// ignore_for_file: invalid_use_of_visible_for_testing_member

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

  void _onClientsUpdated(List<Client> clients) {
    _logger.d('📡 Clients stream updated: ${clients.length} clients');
    
    if (state is ClientsLoaded) {
      final currentState = state as ClientsLoaded;
      emit(currentState.copyWith(
        clients: clients,
        filteredClients: _filterAndSearchClients(
          clients,
          searchQuery: currentState.searchQuery,
          status: currentState.filterStatus,
        ),
      ));
    } else {
      emit(ClientsLoaded(
        clients: clients,
        filteredClients: clients,
        searchQuery: '',
        filterStatus: null,
      ));
    }
  }

  Future<void> _initializeClientsStream() async {
    try {
      _logger.d('🌊 Initializing clients stream...');
      
      final orgId = await _getOrganizationId();
      if (orgId == null) {
        throw Exception('Organization ID not found');
      }

      _logger.d('🌊 Starting clients watch stream for organization: $orgId');

      // Cancel any existing subscription
      await _clientsSubscription?.cancel();

      // Start watching clients stream
      _clientsSubscription = _clientsRepository
          .watchClients(orgId)
          .listen(
            _onClientsUpdated,
            onError: (error) {
              _logger.e('❌ Error in clients stream', error: error);
              emit(ClientsError('Failed to watch clients: $error'));
            },
            cancelOnError: false,
          );

      _logger.d('🌊 Clients stream initialized successfully');
    } catch (e, stackTrace) {
      _logger.e('❌ Failed to initialize clients stream', error: e, stackTrace: stackTrace);
      emit(ClientsError('Failed to initialize clients stream: $e'));
    }
  }

  Future<void> _onLoadClients(
    LoadClients event,
    Emitter<ClientsState> emit,
  ) async {
    try {
      // Immediately emit loading state
      emit(ClientsLoading());

      // Get organization ID
      final orgId = await _getOrganizationId();
      if (orgId == null) {
        throw Exception('Organization ID not found');
      }

      // Initialize stream if not already done
      if (_clientsSubscription == null) {
        await _initializeClientsStream();
      }

      // If we're not in a loaded state after stream initialization, fetch initial data
      if (state is! ClientsLoaded) {
        final clients = await _clientsRepository.getClients(orgId);
        _logger.d('📦 Loaded ${clients.length} clients');
        
        emit(ClientsLoaded(
          clients: clients,
          filteredClients: clients,
          searchQuery: '',
          filterStatus: null,
        ));
      }
    } catch (e, stackTrace) {
      _logger.e('❌ Failed to load clients', error: e, stackTrace: stackTrace);
      emit(ClientsError('Failed to load clients: $e'));
    }
  }

  Future<void> _onSearchClients(
    SearchClients event,
    Emitter<ClientsState> emit,
  ) async {
    try {
      // Ensure we have a valid loaded state
      if (state is! ClientsLoaded) {
        _logger.w('⚠️ Invalid state for searching clients');
        return;
      }

      final currentState = state as ClientsLoaded;
      
      // Use empty string if query is null
      final searchQuery = event.query;

      // Filter clients based on search query and current filter status
      final filteredClients = _filterAndSearchClients(
        currentState.clients, 
        searchQuery: searchQuery, 
        status: currentState.filterStatus
      );

      // Emit updated state
      emit(ClientsLoaded(
        clients: currentState.clients,
        filteredClients: filteredClients,
        searchQuery: searchQuery,
        filterStatus: currentState.filterStatus,
      ));
    } catch (e, stackTrace) {
      _logger.e('❌ Failed to search clients', error: e, stackTrace: stackTrace);
      emit(ClientsError('Failed to search clients: $e'));
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
    // Normalize search query
    final lowercaseQuery = (searchQuery).toLowerCase().trim();

    // Filter by status first if specified
    var filteredClients = status != null
        ? clients.where((client) => client.status == status).toList()
        : List<Client>.from(clients);

    // If no search query, return filtered clients
    if (lowercaseQuery.isEmpty) {
      return filteredClients;
    }

    // Perform search across multiple fields
    return filteredClients.where((client) {
      // Create list of searchable fields
      final searchableFields = [
        client.firstName.toLowerCase(),
        client.lastName.toLowerCase(),
        client.email.toLowerCase(),
        client.phone.toLowerCase(),
        if (client.organizationName != null) 
          client.organizationName!.toLowerCase(),
        client.status.toString().toLowerCase(),
        client.type.toString().toLowerCase(),
        client.domain.toString().toLowerCase(),
      ];

      // Check if any field contains the search query
      return searchableFields.any((field) => field.contains(lowercaseQuery));
    }).toList();
  }

  Future<void> _onAddClient(
    AddClient event,
    Emitter<ClientsState> emit,
  ) async {
    try {
      _logger.i('📝 Adding new client');

      // Ensure we have a valid loaded state
      if (state is! ClientsLoaded) {
        _logger.w('⚠️ Invalid state for adding client');
        return;
      }

      final currentState = state as ClientsLoaded;

      // Get organization ID
      final orgId = await _getOrganizationId();
      if (orgId == null) {
        throw Exception('Organization ID not found');
      }

      // Create the client in Firestore
      final newClient = await _clientsRepository.createClient(orgId, event.client);
      _logger.d('✅ Client created with ID: ${newClient.id}');

      // Update local state with the new client
      final updatedClients = [...currentState.clients, newClient];

      // Emit updated state
      emit(ClientsLoaded(
        clients: updatedClients,
        filteredClients: _filterAndSearchClients(
          updatedClients,
          searchQuery: currentState.searchQuery,
          status: currentState.filterStatus,
        ),
        searchQuery: currentState.searchQuery,
        filterStatus: currentState.filterStatus,
      ));

      _logger.d('✅ Client added successfully');

    } catch (e, stackTrace) {
      _logger.e('❌ Failed to add client', error: e, stackTrace: stackTrace);
      
      // Re-emit the previous state to maintain UI consistency
      if (state is ClientsLoaded) {
        emit(state);
      }
      
      emit(ClientsError('Failed to add client: $e'));
    }
  }

  Future<void> _onUpdateClient(
    UpdateClient event,
    Emitter<ClientsState> emit,
  ) async {
    try {
      _logger.i('📝 Updating client: ${event.client.id}');

      // Ensure we have a valid loaded state
      if (state is! ClientsLoaded) {
        _logger.w('⚠️ Invalid state for updating client');
        return;
      }

      final currentState = state as ClientsLoaded;
      final orgId = await _getOrganizationId();
      if (orgId == null) {
        throw Exception('Organization ID not found');
      }

      // Update client in repository first
      await _clientsRepository.updateClient(orgId, event.client);

      // Update local state after successful repository update
      final updatedClients = currentState.clients.map((client) {
        return client.id == event.client.id ? event.client : client;
      }).toList();

      final updatedState = ClientsLoaded(
        clients: updatedClients,
        filteredClients: _filterAndSearchClients(
          updatedClients,
          searchQuery: currentState.searchQuery,
          status: currentState.filterStatus,
        ),
        searchQuery: currentState.searchQuery,
        filterStatus: currentState.filterStatus,
      );

      emit(updatedState);
      _logger.d('✅ Client update successful');
    } catch (e, stackTrace) {
      _logger.e('❌ Failed to update client', error: e, stackTrace: stackTrace);
      emit(ClientsError('Failed to update client: $e'));
      // Re-emit the previous state to maintain UI consistency
      if (state is ClientsLoaded) {
        emit(state);
      }
    }
  }

  Future<void> _onDeleteClient(
    DeleteClient event,
    Emitter<ClientsState> emit,
  ) async {
    try {
      _logger.i('🗑️ Deleting client: ${event.clientId}');

      // Ensure we have a valid loaded state
      if (state is! ClientsLoaded) {
        _logger.w('⚠️ Invalid state for deleting client');
        return;
      }

      final currentState = state as ClientsLoaded;
      
      // Check if client exists in current state
      final clientToDelete = currentState.clients.firstWhere(
        (c) => c.id == event.clientId,
        orElse: () => throw Exception('Client not found in current state'),
      );

      final orgId = await _getOrganizationId();
      if (orgId == null) {
        throw Exception('Organization ID not found');
      }

      // Remove client from local state first
      final updatedClients = currentState.clients
          .where((client) => client.id != event.clientId)
          .toList();

      // Emit updated state
      emit(ClientsLoaded(
        clients: updatedClients,
        filteredClients: _filterAndSearchClients(
          updatedClients,
          searchQuery: currentState.searchQuery,
          status: currentState.filterStatus,
        ),
        searchQuery: currentState.searchQuery,
        filterStatus: currentState.filterStatus,
      ));

      // Then delete from Firestore
      await _clientsRepository.deleteClient(orgId, event.clientId);
      _logger.d('✅ Client deleted successfully');

    } catch (e, stackTrace) {
      _logger.e('❌ Failed to delete client', error: e, stackTrace: stackTrace);
      
      // Re-emit the previous state to maintain UI consistency
      if (state is ClientsLoaded) {
        emit(state);
      }
      
      emit(ClientsError('Failed to delete client: $e'));
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
