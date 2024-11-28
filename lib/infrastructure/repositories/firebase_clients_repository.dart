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



  Future<Client> _createClientFromDocument(
      DocumentSnapshot<Map<String, dynamic>> doc) async {
    final data = doc.data()!;
    return Client(
      id: doc.id,
      firstName: data['firstName'] as String? ?? '',
      lastName: data['lastName'] as String? ?? '',
      email: data['email'] as String? ?? '',
      phone: data['phone'] as String? ?? '',
      address: data['address'] as String? ?? '',
      type: ClientType.values.firstWhere(
        (e) => e.toString().split('.').last == data['type'],
        orElse: () => ClientType.individual,
      ),
      status: ClientStatus.values.firstWhere(
        (e) => e.toString().split('.').last == data['status'],
        orElse: () => ClientStatus.active,
      ),
      domain: ClientDomain.values.firstWhere(
        (e) => e.toString().split('.').last == data['domain'],
        orElse: () => ClientDomain.other,
      ),
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      organizationName: data['organizationName'] as String?,
      governmentType: data['governmentType'] as String?,
      website: data['website'] as String?,
      gstin: data['gstin'] as String?,
      pan: data['pan'] as String?,
      leadId: data['leadId'] as String?,
      joiningDate: data['joiningDate'] != null
          ? (data['joiningDate'] as Timestamp).toDate()
          : DateTime.now(),
      lastInteractionDate: data['lastInteractionDate'] != null
          ? (data['lastInteractionDate'] as Timestamp).toDate()
          : null,
      metadata: data['metadata'] as Map<String, dynamic>?,
      tags: (data['tags'] as List<dynamic>?)?.cast<String>(),
      assignedEmployeeId: data['assignedEmployeeId'] as String?,
      projects: (data['projects'] as List<dynamic>?)
              ?.map((e) => Project.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      lifetimeValue: (data['lifetimeValue'] as num?)?.toDouble() ?? 0.0,
    );
  }

  @override
  Future<List<Client>> getClients(String organizationId) async {
    try {
      _logger.d('🔍 Getting clients for organization: $organizationId');
      
      // Get the organization document first to verify it exists
      final orgDoc = await _firestore
          .collection('organizations')
          .doc(organizationId)
          .get();
          
      if (!orgDoc.exists) {
        _logger.w('⚠️ Organization document not found');
        return [];
      }
      
      _logger.d('✅ Organization document found');
      
      // Get clients collection
      final clientsRef = _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('clients');
          
      _logger.d('📂 Querying clients collection at path: ${clientsRef.path}');
      
      final snapshot = await clientsRef
          .orderBy('lastInteractionDate', descending: true)
          .get();

      _logger.d('📦 Retrieved ${snapshot.docs.length} clients');
      
      if (snapshot.docs.isEmpty) {
        _logger.w('⚠️ No client documents found in collection');
        return [];
      }
      
      // Log the first document's data to verify structure
      if (snapshot.docs.isNotEmpty) {
        final firstDoc = snapshot.docs.first.data();
        _logger.d('📄 Sample client document structure: ${firstDoc.keys.join(', ')}');
      }

      // Wait for all futures to complete
      final futures = snapshot.docs.map((doc) async {
        try {
          return await _createClientFromDocument(doc);
        } catch (e) {
          _logger.e('❌ Error parsing client document ${doc.id}', error: e);
          rethrow;
        }
      });
      
      return await Future.wait(futures);
    } catch (e, stackTrace) {
      _logger.e('❌ Failed to get clients', error: e, stackTrace: stackTrace);
      throw FirebaseClientsException('Failed to get clients: $e');
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

      return _createClientFromDocument(doc);
    } catch (e) {
      throw Exception('Failed to get client: $e');
    }
  }

  @override
  Future<Client> createClient(String organizationId, Client client) async {
    try {
      _logger.d('➕ Creating client in organization: $organizationId');
      
      // Verify organization exists
      final orgDoc = await _firestore
          .collection('organizations')
          .doc(organizationId)
          .get();
          
      if (!orgDoc.exists) {
        _logger.w('⚠️ Organization not found');
        throw FirebaseClientsException('Organization not found');
      }
      
      // Create document reference
      final docRef = _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('clients')
          .doc();

      // Validate required fields
      if (client.firstName.isEmpty && client.lastName.isEmpty && client.organizationName == null) {
        throw FirebaseClientsException('Client must have a name or organization name');
      }

      // Prepare client data with validation
      final clientData = {
        'firstName': client.firstName.trim(),
        'lastName': client.lastName.trim(),
        'email': client.email.trim(),
        'phone': client.phone.trim(),
        'address': client.address.trim(),
        'type': client.type.toString().split('.').last,
        'status': client.status.toString().split('.').last,
        'domain': client.domain.toString().split('.').last,
        'rating': client.rating.clamp(0.0, 5.0),  // Ensure rating is between 0-5
        'organizationName': client.organizationName?.trim(),
        'governmentType': client.governmentType?.trim(),
        'website': client.website?.trim(),
        'gstin': client.gstin?.trim(),
        'pan': client.pan?.trim(),
        'leadId': client.leadId,
        'joiningDate': Timestamp.fromDate(client.joiningDate),
        'lastInteractionDate': Timestamp.fromDate(DateTime.now()),
        'metadata': client.metadata ?? {},
        'tags': client.tags ?? [],
        'assignedEmployeeId': client.assignedEmployeeId,
        'projects': client.projects.map((p) => p.toJson()).toList(),
        'lifetimeValue': client.lifetimeValue.clamp(0.0, double.infinity),
      };

      _logger.d('📝 Creating client with ID: ${docRef.id}');
      
      // Create the document in a transaction for atomicity
      await _firestore.runTransaction((transaction) async {
        transaction.set(docRef, clientData);
      });
      
      _logger.d('✅ Client created successfully');
      
      // Return the created client
      return _createClientFromDocument(await docRef.get());
    } catch (e, stackTrace) {
      _logger.e('❌ Failed to create client', error: e, stackTrace: stackTrace);
      if (e is FirebaseClientsException) {
        rethrow;
      }
      throw FirebaseClientsException('Failed to create client: $e');
    }
  }

  @override
  Future<void> updateClient(String organizationId, Client client) async {
    try {
      _logger.i('📝 Updating client: ${client.id}');
      
      // Get client reference
      final clientRef = _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('clients')
          .doc(client.id);

      // Validate required fields
      if (client.firstName.isEmpty && client.lastName.isEmpty && client.organizationName == null) {
        throw FirebaseClientsException('Client must have a name or organization name');
      }

      // Prepare update data with validation
      final updateData = {
        'firstName': client.firstName.trim(),
        'lastName': client.lastName.trim(),
        'email': client.email.trim(),
        'phone': client.phone.trim(),
        'address': client.address.trim(),
        'type': client.type.toString().split('.').last,
        'status': client.status.toString().split('.').last,
        'domain': client.domain.toString().split('.').last,
        'rating': client.rating.clamp(0.0, 5.0),
        'organizationName': client.organizationName?.trim(),
        'governmentType': client.governmentType?.trim(),
        'website': client.website?.trim(),
        'gstin': client.gstin?.trim(),
        'pan': client.pan?.trim(),
        'leadId': client.leadId,
        'joiningDate': Timestamp.fromDate(client.joiningDate),
        'lastInteractionDate': Timestamp.fromDate(DateTime.now()),
        'metadata': client.metadata ?? {},
        'tags': client.tags ?? [],
        'assignedEmployeeId': client.assignedEmployeeId,
        'projects': client.projects.map((p) => p.toJson()).toList(),
        'lifetimeValue': client.lifetimeValue.clamp(0.0, double.infinity),
      };

      // Update directly without transaction for better performance
      await clientRef.update(updateData);
      
      _logger.d('✅ Client updated successfully');
    } catch (e, stackTrace) {
      _logger.e('❌ Failed to update client', error: e, stackTrace: stackTrace);
      if (e is FirebaseClientsException) {
        rethrow;
      }
      throw FirebaseClientsException('Failed to update client: $e');
    }
  }

  @override
  Future<void> deleteClient(String organizationId, String clientId) async {
    try {
      _logger.d('🗑️ Deleting client: $clientId from organization: $organizationId');
      
      // Get the client document reference
      final clientRef = _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('clients')
          .doc(clientId);
      
      // Verify the document exists before attempting deletion
      final docSnapshot = await clientRef.get();
      if (!docSnapshot.exists) {
        _logger.w('⚠️ Client document not found');
        throw FirebaseClientsException('Client not found');
      }
      
      // Delete the client document
      await clientRef.delete();
      _logger.d('✅ Client deleted successfully');
      
    } catch (e, stackTrace) {
      _logger.e('❌ Failed to delete client', error: e, stackTrace: stackTrace);
      if (e is FirebaseClientsException) {
        rethrow;
      }
      throw FirebaseClientsException('Failed to delete client: $e');
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
      final clientData = {
        'firstName': client.firstName,
        'lastName': client.lastName,
        'email': client.email,
        'phone': client.phone,
        'address': client.address,
        'type': client.type.toString().split('.').last,
        'status': client.status.toString().split('.').last,
        'domain': client.domain.toString().split('.').last,
        'rating': client.rating,
        'organizationName': client.organizationName,
        'governmentType': client.governmentType,
        'website': client.website,
        'gstin': client.gstin,
        'pan': client.pan,
        'leadId': lead.id,
        'joiningDate': Timestamp.fromDate(client.joiningDate),
        'lastInteractionDate': client.lastInteractionDate != null
            ? Timestamp.fromDate(client.lastInteractionDate!)
            : null,
        'metadata': client.metadata,
        'tags': client.tags,
        'assignedEmployeeId': client.assignedEmployeeId,
        'projects': client.projects.map((p) => p.toJson()).toList(),
        'lifetimeValue': client.lifetimeValue,
      };

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

      return _createClientFromDocument(await clientRef.get());
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
      final filteredDocs = snapshot.docs.where((doc) {
        final data = doc.data();
        final searchableFields = [
          data['firstName']?.toString().toLowerCase(),
          data['lastName']?.toString().toLowerCase(),
          data['email']?.toString().toLowerCase(),
          data['phone']?.toString().toLowerCase(),
          data['address']?.toString().toLowerCase(),
        ];

        return searchableFields.any((field) =>
            field != null && field.contains(lowercaseQuery));
      });

      // Wait for all futures to complete
      final futures = filteredDocs.map((doc) => _createClientFromDocument(doc));
      return await Future.wait(futures);
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
        .asyncMap((snapshot) async {
          final futures = snapshot.docs.map((doc) => _createClientFromDocument(doc));
          return await Future.wait(futures);
        });
  }

  Stream<List<Client>> watchClients(String organizationId) {
    try {
      _logger.i('👀 Starting clients watch stream');
      
      return _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('clients')
          .orderBy('lastInteractionDate', descending: true)
          .snapshots()
          .asyncMap((snapshot) async {
            final futures = snapshot.docs.map((doc) => _createClientFromDocument(doc));
            return await Future.wait(futures);
          });
    } catch (e, stackTrace) {
      _logger.e('❌ Error setting up clients watch stream',
          error: e, stackTrace: stackTrace);
      throw FirebaseClientsException(
          'Failed to watch clients: ${e.toString()}');
    }
  }
}
