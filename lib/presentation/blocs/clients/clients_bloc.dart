import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neetiflow/domain/entities/client.dart';
import 'package:neetiflow/domain/repositories/auth_repository.dart';
import 'package:neetiflow/domain/repositories/employees_repository.dart';
import 'package:neetiflow/infrastructure/repositories/firebase_clients_repository.dart';
import 'package:logger/logger.dart';

// Client sort options
enum ClientSortOption {
  nameAsc,
  nameDesc,
  dateAsc,
  dateDesc,
  ratingAsc,
  ratingDesc,
}

// Events
abstract class ClientsEvent {}

class LoadClients extends ClientsEvent {}

class SearchClients extends ClientsEvent {
  final String query;
  SearchClients(this.query);
}

class FilterClientsByStatus extends ClientsEvent {
  final ClientStatus status;
  FilterClientsByStatus(this.status);
}

class AddClient extends ClientsEvent {
  final Client client;
  AddClient(this.client);
}

class UpdateClient extends ClientsEvent {
  final Client client;
  UpdateClient(this.client);
}

class DeleteClient extends ClientsEvent {
  final String clientId;
  DeleteClient(this.clientId);
}

class UpdateClientStatus extends ClientsEvent {
  final String clientId;
  final ClientStatus status;
  UpdateClientStatus(this.clientId, this.status);
}

// States
abstract class ClientsState {}

class ClientsInitial extends ClientsState {}

class ClientsLoading extends ClientsState {}

class ClientsLoaded extends ClientsState {
  final List<Client> clients;
  final List<Client> filteredClients;
  final ClientStatus? filterStatus;
  final String searchQuery;

  ClientsLoaded({
    required this.clients,
    List<Client>? filteredClients,
    this.filterStatus,
    this.searchQuery = '',
  }) : filteredClients = filteredClients ?? clients;

  ClientsLoaded copyWith({
    List<Client>? clients,
    List<Client>? filteredClients,
    ClientStatus? filterStatus,
    String? searchQuery,
  }) {
    return ClientsLoaded(
      clients: clients ?? this.clients,
      filteredClients: filteredClients ?? this.filteredClients,
      filterStatus: filterStatus ?? this.filterStatus,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class ClientsError extends ClientsState {
  final String message;
  ClientsError(this.message);
}

// Bloc
class ClientsBloc extends Bloc<ClientsEvent, ClientsState> {
  final _clientsRepository = FirebaseClientsRepository();
  final AuthRepository _authRepository;
  final EmployeesRepository _employeesRepository;
  final _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 50,
      colors: true,
      printEmojis: true,
    ),
  );

  String? _organizationId;
  StreamSubscription<List<Client>>? _clientsSubscription;

  ClientsBloc({
    required AuthRepository authRepository,
    required EmployeesRepository employeesRepository,
  })  : _authRepository = authRepository,
        _employeesRepository = employeesRepository,
        super(ClientsInitial()) {
    on<LoadClients>(_onLoadClients);
    on<SearchClients>(_onSearchClients);
    on<FilterClientsByStatus>(_onFilterClientsByStatus);
    on<AddClient>(_onAddClient);
    on<UpdateClient>(_onUpdateClient);
    on<DeleteClient>(_onDeleteClient);
    on<UpdateClientStatus>(_onUpdateClientStatus);
  }

  Future<String?> _getOrganizationId({bool forceRefresh = false}) async {
    try {
      if (!forceRefresh && _organizationId != null) {
        _logger.d('🔄 Using cached organization ID: $_organizationId');
        return _organizationId;
      }

      _logger.d('1️⃣ Getting current user...');
      final currentUser = await _authRepository.getCurrentUser();
      if (currentUser == null) {
        _logger.e('❌ No authenticated user found');
        return null;
      }
      _logger.d('✅ Got current user: ${currentUser.uid}');

      _logger.d('2️⃣ Getting employee data...');
      final employee = await _employeesRepository.getEmployeeByUid(currentUser.uid);
      if (employee == null) {
        _logger.e('❌ No employee found for UID: ${currentUser.uid}');
        return null;
      }
      _logger.d('✅ Got employee data');

      if (employee.companyId == null || employee.companyId!.isEmpty) {
        _logger.e('❌ Employee has no associated company ID');
        return null;
      }
      _logger.d('✅ Found company ID: ${employee.companyId}');

      _organizationId = employee.companyId;
      return _organizationId;
    } catch (e, stackTrace) {
      _logger.e('❌ Error getting organization ID', error: e, stackTrace: stackTrace);
      return null;
    }
  }

  Future<void> _onLoadClients(
    LoadClients event,
    Emitter<ClientsState> emit,
  ) async {
    if (emit.isDone) return;

    try {
      emit(ClientsLoading());
      _logger.i('🔄 Loading clients...');

      // Force refresh organization ID on initial load
      final orgId = await _getOrganizationId(forceRefresh: true);
      if (orgId == null) {
        _logger.e('❌ Failed to get organization ID');
        if (!emit.isDone) emit(ClientsError('Failed to get organization ID'));
        return;
      }

      // Cancel any existing subscription
      await _clientsSubscription?.cancel();

      // Subscribe to real-time updates
      _clientsSubscription = _clientsRepository
          .watchClients(orgId)
          .listen(
            (clients) {
              if (state is ClientsLoaded) {
                final currentState = state as ClientsLoaded;
                add(SearchClients(currentState.searchQuery));
              } else {
                add(SearchClients(''));
              }
            },
            onError: (error) {
              _logger.e('❌ Error in clients stream', error: error);
              add(LoadClients());
            },
          );

    } catch (e, stackTrace) {
      _logger.e('❌ Error loading clients', error: e, stackTrace: stackTrace);
      if (!emit.isDone) {
        emit(ClientsError('Failed to load clients: ${e.toString()}'));
      }
    }
  }

  void _onSearchClients(
    SearchClients event,
    Emitter<ClientsState> emit,
  ) async {
    if (emit.isDone) return;

    try {
      _logger.d('🔍 Searching clients with query: ${event.query}');
      
      final orgId = await _getOrganizationId();
      if (orgId == null) {
        _logger.e('❌ Failed to get organization ID while searching');
        return;
      }

      final clients = await _clientsRepository.getClients(orgId);
      
      if (!emit.isDone) {
        final filteredClients = _filterAndSearchClients(
          clients,
          searchQuery: event.query,
          status: state is ClientsLoaded
              ? (state as ClientsLoaded).filterStatus
              : null,
        );

        emit(ClientsLoaded(
          clients: clients,
          filteredClients: filteredClients,
          searchQuery: event.query,
          filterStatus:
              state is ClientsLoaded ? (state as ClientsLoaded).filterStatus : null,
        ));
      }
    } catch (e, stackTrace) {
      _logger.e('❌ Error searching clients', error: e, stackTrace: stackTrace);
    }
  }

  Future<void> _onFilterClientsByStatus(
    FilterClientsByStatus event,
    Emitter<ClientsState> emit,
  ) async {
    if (state is ClientsLoaded && !emit.isDone) {
      final currentState = state as ClientsLoaded;
      try {
        final newState = _applyFiltersAndSearch(
          currentState.copyWith(filterStatus: event.status),
        );
        emit(newState);
      } catch (e, stackTrace) {
        _logger.e('Error in filter', error: e, stackTrace: stackTrace);
      }
    }
  }

  ClientsLoaded _applyFiltersAndSearch(ClientsLoaded state) {
    var filteredClients = List<Client>.from(state.clients);

    try {
      // Apply status filter
      if (state.filterStatus != null) {
        filteredClients = filteredClients
            .where((client) => client.status == state.filterStatus)
            .toList();
      }

      // Apply search
      if (state.searchQuery.isNotEmpty) {
        final query = state.searchQuery.toLowerCase();
        filteredClients = filteredClients.where((client) {
          return client.fullName.toLowerCase().contains(query) ||
              client.email.toLowerCase().contains(query) ||
              client.phone.toLowerCase().contains(query) ||
              (client.organizationName?.toLowerCase().contains(query) ?? false);
        }).toList();
      }

      return state.copyWith(filteredClients: filteredClients);
    } catch (e, stackTrace) {
      _logger.e('Error applying filters', error: e, stackTrace: stackTrace);
      return state.copyWith(filteredClients: state.clients);
    }
  }

  List<Client> _filterAndSearchClients(
    List<Client> clients, {
    required String searchQuery,
    ClientStatus? status,
  }) {
    var filteredClients = List<Client>.from(clients);

    // Apply status filter if specified
    if (status != null) {
      filteredClients = filteredClients
          .where((client) => client.status == status)
          .toList();
    }

    // Apply search filter if query is not empty
    if (searchQuery.isNotEmpty) {
      final lowercaseQuery = searchQuery.toLowerCase();
      filteredClients = filteredClients.where((client) {
        final searchableFields = [
          client.fullName.toLowerCase(),
          client.email.toLowerCase(),
          client.phone.toLowerCase(),
          client.organizationName?.toLowerCase() ?? '',
          client.domain.name.toLowerCase(),
        ];

        return searchableFields.any((field) => field.contains(lowercaseQuery));
      }).toList();
    }

    return filteredClients;
  }


  Future<void> _onUpdateClient(
    UpdateClient event,
    Emitter<ClientsState> emit,
  ) async {
    try {
      if (state is! ClientsLoaded) {
        throw Exception('Invalid state for updating client');
      }

      final currentState = state as ClientsLoaded;
      
      // Update local state first for immediate UI feedback
      final updatedClients = List<Client>.from(currentState.clients);
      final index = updatedClients.indexWhere((c) => c.id == event.client.id);
      if (index != -1) {
        updatedClients[index] = event.client;
      }

      emit(ClientsLoaded(
        clients: updatedClients,
        searchQuery: currentState.searchQuery,
        filterStatus: currentState.filterStatus,
      ));

      // Then update Firestore in the background
      final orgId = await _getOrganizationId();
      if (orgId == null) {
        throw Exception('Organization ID not found');
      }

      await _clientsRepository.updateClient(orgId, event.client);
      _logger.d('✅ Client updated successfully');

    } catch (e, stackTrace) {
      _logger.e('❌ Failed to update client', error: e, stackTrace: stackTrace);
      if (!emit.isDone) {
        emit(ClientsError('Failed to update client: $e'));
      }
    }
  }

  Future<void> _onAddClient(
    AddClient event,
    Emitter<ClientsState> emit,
  ) async {
    try {
      // Update local state first for immediate UI feedback
      if (state is ClientsLoaded) {
        final currentState = state as ClientsLoaded;
        final updatedClients = List<Client>.from(currentState.clients)
          ..add(event.client);

        emit(ClientsLoaded(
          clients: updatedClients,
          searchQuery: currentState.searchQuery,
          filterStatus: currentState.filterStatus,
        ));
      }

      // Then update Firestore in the background
      final orgId = await _getOrganizationId();
      if (orgId == null) {
        throw Exception('Organization ID not found');
      }

      await _clientsRepository.createClient(orgId, event.client);
      _logger.d('✅ Client created successfully');

    } catch (e, stackTrace) {
      _logger.e('❌ Failed to create client', error: e, stackTrace: stackTrace);
      if (!emit.isDone) {
        emit(ClientsError('Failed to create client: $e'));
      }
    }
  }

  Future<void> _onDeleteClient(
    DeleteClient event,
    Emitter<ClientsState> emit,
  ) async {
    try {
      _logger.i('🗑️ Deleting client: ${event.clientId}');

      // Get current state data
      if (state is! ClientsLoaded) {
        throw Exception('Invalid state for client deletion');
      }
      final currentState = state as ClientsLoaded;

      // Update local state immediately for better UX
      final updatedClients = currentState.clients
          .where((client) => client.id != event.clientId)
          .toList();

      emit(ClientsLoaded(
        clients: updatedClients,
        searchQuery: currentState.searchQuery,
        filterStatus: currentState.filterStatus,
      ));

      // Delete from Firestore in the background
      final orgId = await _getOrganizationId();
      if (orgId == null) {
        throw Exception('Organization ID not found');
      }

      await _clientsRepository.deleteClient(orgId, event.clientId);
      _logger.d('✅ Client deleted successfully');
      
    } catch (e, stackTrace) {
      _logger.e('❌ Failed to delete client', error: e, stackTrace: stackTrace);
      if (!emit.isDone) {
        emit(ClientsError('Failed to delete client: $e'));
      }
    }
  }

  Future<void> _onUpdateClientStatus(
    UpdateClientStatus event,
    Emitter<ClientsState> emit,
  ) async {
    if (state is ClientsLoaded) {
      final currentState = state as ClientsLoaded;
      _logger.i('Updating client status: ${event.clientId} to ${event.status}');
      
      final clientToUpdate = currentState.clients
          .firstWhere((client) => client.id == event.clientId);
      final updatedClient = clientToUpdate.copyWith(status: event.status);
      
      _logger.d('Dispatching update client event');
      add(UpdateClient(updatedClient));
    }
  }

  @override
  Future<void> close() async {
    await _clientsSubscription?.cancel();
    return super.close();
  }
}
