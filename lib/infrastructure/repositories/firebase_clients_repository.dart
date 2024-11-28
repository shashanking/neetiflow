import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:neetiflow/domain/entities/client.dart';
import 'package:neetiflow/domain/entities/lead.dart';
import 'package:neetiflow/domain/repositories/clients_repository.dart';

class FirebaseClientsException implements Exception {
  final String message;
  FirebaseClientsException(this.message);
  
  @override
  String toString() => message;
}

class FirebaseClientsRepository implements ClientsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 50,
      colors: true,
      printEmojis: true,
    ),
  );

  ClientType _parseClientType(String? type) {
    switch (type?.toLowerCase()) {
      case 'individual':
        return ClientType.individual;
      case 'company':
        return ClientType.company;
      default:
        return ClientType.individual;
    }
  }

  ClientStatus _parseClientStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'active':
        return ClientStatus.active;
      case 'inactive':
        return ClientStatus.inactive;
      case 'suspended':
        return ClientStatus.suspended;
      default:
        return ClientStatus.active;
    }
  }

  @override
  Future<List<Client>> getClients(String organizationId) async {
    try {
      _logger.d('🔍 Getting clients for organization: $organizationId');
      final snapshot = await _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('clients')
          .orderBy('createdAt', descending: true)
          .get();

      _logger.d('📦 Retrieved ${snapshot.docs.length} clients');
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Client.fromJson(data);
      }).toList();
    } catch (e, stackTrace) {
      _logger.e('❌ Failed to get clients', error: e, stackTrace: stackTrace);
      throw Exception('Failed to get clients: $e');
    }
  }

  @override
  Future<Client> getClient(String organizationId, String clientId) async {
    try {
      final doc = await _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('clients')
          .doc(clientId)
          .get();

      if (!doc.exists) {
        throw Exception('Client not found');
      }

      final data = doc.data()!;
      data['id'] = doc.id;
      return Client.fromJson(data);
    } catch (e) {
      throw Exception('Failed to get client: $e');
    }
  }

  @override
  Future<Client> createClient(String organizationId, Client client) async {
    try {
      _logger.d('➕ Creating client in organization: $organizationId');
      
      // Create document reference first
      final docRef = _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('clients')
          .doc();

      // Prepare client data
      final clientData = client.toJson()
        ..remove('id') // Remove any existing ID
        ..addAll({
          'id': docRef.id,
          'createdAt': FieldValue.serverTimestamp(),
          'lastInteractionDate': FieldValue.serverTimestamp(),
        });

      _logger.d('📝 Setting client data with ID: ${docRef.id}');
      
      // Set the data in a single operation
      await docRef.set(clientData);
      
      _logger.d('✅ Client created successfully');
      
      // Convert timestamps to DateTime for the return value
      clientData['createdAt'] = DateTime.now();
      clientData['lastInteractionDate'] = DateTime.now();
      
      return Client.fromJson(clientData);
    } catch (e, stackTrace) {
      _logger.e('❌ Failed to create client', error: e, stackTrace: stackTrace);
      throw Exception('Failed to create client: $e');
    }
  }

  @override
  Future<void> updateClient(String organizationId, Client client) async {
    try {
      _logger.i('📝 Updating client in Firestore: ${client.id}');
      
      final clientRef = _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('clients')
          .doc(client.id);

      // Convert client to JSON and prepare update data
      Map<String, dynamic> updateData = client.toJson();
      
      // Remove id from update data as it shouldn't be updated
      updateData.remove('id');
      
      // Set server timestamp for updatedAt
      updateData['updatedAt'] = FieldValue.serverTimestamp();
      
      // Convert DateTime to Timestamp for Firestore
      if (client.lastInteractionDate != null) {
        updateData['lastInteractionDate'] = Timestamp.fromDate(client.lastInteractionDate!);
      }
      updateData['createdAt'] = Timestamp.fromDate(client.createdAt);

      // Update the document
      await clientRef.update(updateData);
      _logger.d('✅ Client updated successfully in Firestore');
    } catch (e, stackTrace) {
      _logger.e('❌ Error updating client in Firestore',
          error: e, stackTrace: stackTrace);
      throw FirebaseClientsException(
          'Failed to update client: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteClient(String organizationId, String clientId) async {
    try {
      _logger.d('🗑️ Deleting client: $clientId from organization: $organizationId');
      
      // Delete in a single operation without fetching first
      await _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('clients')
          .doc(clientId)
          .delete();
          
      _logger.d('✅ Client deleted successfully');
    } catch (e, stackTrace) {
      _logger.e('❌ Failed to delete client', error: e, stackTrace: stackTrace);
      throw Exception('Failed to delete client: $e');
    }
  }

  @override
  Future<Client> convertLeadToClient(
    String organizationId,
    Lead lead,
    Client client,
  ) async {
    try {
      // Start a batch operation
      final batch = _firestore.batch();

      // Create new client document
      final clientRef = _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('clients')
          .doc();

      // Update the client with the reference to the lead
      final clientData = client.copyWith(
        id: clientRef.id,
        leadId: lead.id,
      ).toJson();

      batch.set(clientRef, clientData);

      // Update lead's process status to completed
      final leadRef = _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('leads')
          .doc(lead.id);

      batch.update(leadRef, {
        'processStatus': ProcessStatus.completed.toString().split('.').last,
      });

      // Commit the batch
      await batch.commit();

      return client.copyWith(id: clientRef.id);
    } catch (e) {
      throw Exception('Failed to convert lead to client: $e');
    }
  }

  @override
  Future<List<Client>> searchClients(String organizationId, String query) async {
    try {
      // Convert query to lowercase for case-insensitive search
      final lowercaseQuery = query.toLowerCase();

      // Get all clients (in a real application, you might want to implement pagination)
      final snapshot = await _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('clients')
          .get();

      // Filter clients based on the search query
      return snapshot.docs.where((doc) {
        final data = doc.data();
        final searchableFields = [
          data['name']?.toString().toLowerCase(),
          data['email']?.toString().toLowerCase(),
          data['phone']?.toString().toLowerCase(),
          data['address']?.toString().toLowerCase(),
        ];

        return searchableFields.any((field) =>
            field != null && field.contains(lowercaseQuery));
      }).map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Client.fromJson(data);
      }).toList();
    } catch (e) {
      throw Exception('Failed to search clients: $e');
    }
  }

  @override
  Future<void> updateClientStatus(
    String organizationId,
    String clientId,
    ClientStatus status,
  ) async {
    try {
      await _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('clients')
          .doc(clientId)
          .update({
        'status': status.toString().split('.').last,
        'lastInteractionDate': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update client status: $e');
    }
  }

  @override
  Future<void> assignClientToEmployee(
    String organizationId,
    String clientId,
    String employeeId,
  ) async {
    try {
      await _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('clients')
          .doc(clientId)
          .update({
        'assignedEmployeeId': employeeId,
        'lastInteractionDate': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to assign client to employee: $e');
    }
  }

  @override
  Future<void> updateClientValue(
    String organizationId,
    String clientId,
    double value,
  ) async {
    try {
      await _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('clients')
          .doc(clientId)
          .update({
        'lifetimeValue': value,
        'lastInteractionDate': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update client value: $e');
    }
  }

  @override
  Stream<List<Client>> clientsStream(String organizationId) {
    _logger.d('🔄 Setting up clients stream for: $organizationId');
    return _firestore
        .collection('organizations')
        .doc(organizationId)
        .collection('clients')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          _logger.d('📥 Stream update with ${snapshot.docs.length} clients');
          return snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return Client.fromJson(data);
          }).toList();
        });
  }

  @override
  Stream<List<Client>> watchClients(String organizationId) {
    try {
      _logger.i('👀 Starting clients watch stream');
      
      return _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('clients')
          .orderBy('lastInteractionDate', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          final lastInteractionDate = (data['lastInteractionDate'] as Timestamp?)?.toDate();
          final createdAt = (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now();
          
          return Client(
            id: doc.id,
            name: data['name'] ?? '',
            email: data['email'] ?? '',
            phone: data['phone'] ?? '',
            address: data['address'] ?? '',
            type: _parseClientType(data['type']),
            status: _parseClientStatus(data['status']),
            website: data['website'],
            gstin: data['gstin'],
            pan: data['pan'],
            leadId: data['leadId'],
            createdAt: createdAt,
            lastInteractionDate: lastInteractionDate,
            metadata: Map<String, dynamic>.from(data['metadata'] ?? {}),
            tags: List<String>.from(data['tags'] ?? []),
            assignedEmployeeId: data['assignedEmployeeId'],
            lifetimeValue: (data['lifetimeValue'] ?? 0.0).toDouble(),
          );
        }).toList();
      });
    } catch (e, stackTrace) {
      _logger.e('❌ Error setting up clients watch stream',
          error: e, stackTrace: stackTrace);
      throw FirebaseClientsException(
          'Failed to watch clients: ${e.toString()}');
    }
  }
}
