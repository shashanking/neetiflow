import 'package:injectable/injectable.dart';
import 'package:neetiflow/domain/repositories/clients_repository.dart';
import 'package:neetiflow/domain/entities/client.dart';
import 'package:neetiflow/utils/logger.dart';

@injectable
class ClientService {
  final ClientsRepository _clientRepository;
  final String _organizationId;

  ClientService(
    @Named('organizationId') this._organizationId,
    this._clientRepository,
  );

  Future<List<Client>> searchClients({
    String? query,
    ClientType? type,
    ClientStatus? status,
    String? assignedEmployeeId,
    int limit = 20,
  }) async {
    try {
      logger.i('Searching clients: query=$query, type=$type');

      if (query == null && type == null && status == null && assignedEmployeeId == null) {
        // Get all clients and filter active ones in the service layer
        final clients = await _clientRepository.getClients(_organizationId);
        return clients
            .where((c) => c.status == ClientStatus.active)
            .take(limit)
            .toList();
      }

      // Perform initial search
      final clients = await _clientRepository.searchClients(_organizationId, query ?? '');

      // Additional filtering
      final filteredClients = clients.where((client) {
        if (type != null && client.type != type) return false;
        if (status != null && client.status != status) return false;
        if (assignedEmployeeId != null && client.assignedEmployeeId != assignedEmployeeId) return false;
        return true;
      }).take(limit).toList();

      logger.i('Found ${filteredClients.length} clients');
      return filteredClients;
    } catch (e, stackTrace) {
      logger.e('Failed to search clients', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<Client?> getClientDetails(String clientId) async {
    try {
      logger.i('Fetching client details: $clientId');
      
      final client = await _clientRepository.getClient(_organizationId ,clientId);
      
      if (client == null) {
        logger.w('Client not found: $clientId');
        return null;
      }

      logger.i('Client details fetched: ${client.name}');
      return client;
    } catch (e, stackTrace) {
      logger.e('Failed to fetch client details', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<List<Client>> getClientsByType(ClientType type, {int limit = 50}) async {
    try {
      logger.i('Fetching clients of type: $type');
      
      final allClients = await _clientRepository.getClients(_organizationId);
      final filteredClients = allClients
          .where((client) => client.type == type)
          .take(limit)
          .toList();
      
      logger.i('Found ${filteredClients.length} clients of type $type');
      return filteredClients;
    } catch (e, stackTrace) {
      logger.e('Failed to fetch clients by type', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}
