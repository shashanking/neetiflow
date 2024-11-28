import 'package:neetiflow/domain/entities/client.dart';
import 'package:neetiflow/domain/entities/lead.dart';

abstract class ClientsRepository {
  Future<List<Client>> getClients(String organizationId);
  Stream<List<Client>> clientsStream(String organizationId);
  Future<Client> getClient(String organizationId, String clientId);
  Future<Client> createClient(String organizationId, Client client);
  Future<void> updateClient(String organizationId, Client client);
  Future<void> deleteClient(String organizationId, String clientId);
  Future<Client> convertLeadToClient(String organizationId, Lead lead, Client client);
  Future<List<Client>> searchClients(String organizationId, String query);
  Future<void> updateClientStatus(String organizationId, String clientId, ClientStatus status);
  Future<void> assignClientToEmployee(String organizationId, String clientId, String employeeId);
  Future<void> updateClientValue(String organizationId, String clientId, double value);
}
