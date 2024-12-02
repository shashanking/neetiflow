import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:neetiflow/domain/entities/client.dart';
import 'package:neetiflow/domain/entities/lead.dart';
import 'package:neetiflow/domain/repositories/clients_repository.dart';

import '../../domain/entities/operations/project.dart';

class FirebaseClientsException implements Exception {
  final String message;
  FirebaseClientsException(this.message);
  
  @override
  String toString() => message;
}

@injectable
@LazySingleton(as: ClientsRepository)
@Environment(Environment.prod)
class FirebaseClientsRepository implements ClientsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final Logger _logger;

  FirebaseClientsRepository() {
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 0,
        errorMethodCount: 5,
        lineLength: 50,
        colors: true,
        printEmojis: true,
      ),
    );
  }

  Future<Client> _createClientFromDocument(
      DocumentSnapshot<Map<String, dynamic>> doc) async {
    try {
      final data = doc.data();
      if (data == null) {
        throw FirebaseClientsException('Document data is null');
      }

      return Client(
        id: doc.id,
        firstName: data['firstName']?.toString() ?? '',
        lastName: data['lastName']?.toString() ?? '',
        email: data['email']?.toString() ?? '',
        phone: data['phone']?.toString() ?? '',
        address: data['address']?.toString() ?? '',
        organizationName: data['organizationName']?.toString(),
        governmentType: data['governmentType']?.toString(),
        website: data['website']?.toString(),
        gstin: data['gstin']?.toString(),
        pan: data['pan']?.toString(),
        leadId: data['leadId']?.toString(),
        assignedEmployeeId: data['assignedEmployeeId']?.toString(),
        rating: (data['rating'] is num) ? (data['rating'] as num).toDouble() : 0.0,
        lifetimeValue: (data['lifetimeValue'] is num) ? (data['lifetimeValue'] as num).toDouble() : 0.0,
        joiningDate: _parseTimestamp(data['joiningDate']) ?? DateTime.now(),
        lastInteractionDate: _parseTimestamp(data['lastInteractionDate']) ?? DateTime.now(),
        type: _parseEnum(data['type']?.toString(), ClientType.values, ClientType.individual),
        status: _parseEnum(data['status']?.toString(), ClientStatus.values, ClientStatus.active),
        domain: _parseEnum(data['domain']?.toString(), ClientDomain.values, ClientDomain.other),
        projects: _parseProjects(data['projects']),
        tags: (data['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
        metadata: (data['metadata'] as Map<String, dynamic>?) ?? {},
      );
    } catch (e, stackTrace) {
      _logger.e('❌ Failed to create client from document', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  // Helper method to parse enums safely
  T _parseEnum<T>(dynamic value, List<T> values, T defaultValue) {
    if (value == null) return defaultValue;
    
    // Convert value to string and normalize it
    final stringValue = value.toString().toLowerCase().trim();
    
    // Try to find a matching enum value
    try {
      return values.firstWhere(
        (v) => v.toString().split('.').last.toLowerCase() == stringValue,
        orElse: () => defaultValue,
      );
    } catch (e) {
      _logger.w('⚠️ Failed to parse enum value: $value', error: e);
      return defaultValue;
    }
  }

  // Helper method to parse timestamps safely
  DateTime? _parseTimestamp(dynamic timestamp) {
    try {
      return timestamp != null 
        ? (timestamp as Timestamp).toDate() 
        : null;
    } catch (e) {
      _logger.w('⚠️ Failed to parse timestamp', error: e);
      return null;
    }
  }

  // Helper method to parse projects safely
  List<Project> _parseProjects(dynamic projectsData) {
    try {
      return projectsData != null
        ? (projectsData as List<dynamic>)
            .map((e) => Project.fromJson(e as Map<String, dynamic>))
            .toList()
        : [];
    } catch (e) {
      _logger.w('⚠️ Failed to parse projects, returning empty list');
      return [];
    }
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
      _logger.i('📝 Creating new client');
      
      // Check if organization exists
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

      // Prepare client data with validation and null checks
      final Map<String, dynamic> clientData = {
        'firstName': client.firstName.trim(),
        'lastName': client.lastName.trim(),
        'email': client.email.trim(),
        'phone': client.phone.trim(),
        'address': client.address.trim(),
        'type': client.type.toString().split('.').last,
        'status': client.status.toString().split('.').last,
        'domain': client.domain.toString().split('.').last,
        'rating': client.rating.clamp(0.0, 5.0),
        'lifetimeValue': client.lifetimeValue.clamp(0.0, double.infinity),
        'joiningDate': Timestamp.fromDate(client.joiningDate),
        'lastInteractionDate': Timestamp.fromDate(DateTime.now()),
        'projects': [], // Initialize as empty array
        'tags': [], // Initialize as empty array
        'metadata': {}, // Initialize as empty map
      };

      // Add optional fields only if they have values
      void addIfNotEmpty(String key, String? value) {
        if (value != null && value.trim().isNotEmpty) {
          clientData[key] = value.trim();
        }
      }

      addIfNotEmpty('organizationName', client.organizationName);
      addIfNotEmpty('governmentType', client.governmentType);
      addIfNotEmpty('website', client.website);
      addIfNotEmpty('gstin', client.gstin);
      addIfNotEmpty('pan', client.pan);
      addIfNotEmpty('leadId', client.leadId);
      addIfNotEmpty('assignedEmployeeId', client.assignedEmployeeId);

      // Add non-string optional fields if they have values
      if (client.metadata != null && client.metadata!.isNotEmpty) {
        clientData['metadata'] = Map<String, dynamic>.from(client.metadata!);
      }
      if (client.tags != null && client.tags!.isNotEmpty) {
        clientData['tags'] = List<String>.from(client.tags!);
      }
      if (client.projects.isNotEmpty) {
        clientData['projects'] = client.projects.map((p) => p.toJson()).toList();
      }

      // Create the document in Firestore
      await docRef.set(clientData);
      _logger.d('✅ Client document created successfully');

      // Create and return the client object with the new ID
      return client.copyWith(id: docRef.id);
      
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

      // Prepare update data with validation and null checks
      final Map<String, dynamic> updateData = {
        'firstName': client.firstName.trim(),
        'lastName': client.lastName.trim(),
        'email': client.email.trim(),
        'phone': client.phone.trim(),
        'address': client.address.trim(),
        'type': client.type.toString().split('.').last,
        'status': client.status.toString().split('.').last,
        'domain': client.domain.toString().split('.').last,
        'rating': client.rating.clamp(0.0, 5.0),
        'lifetimeValue': client.lifetimeValue.clamp(0.0, double.infinity),
        'lastInteractionDate': Timestamp.fromDate(DateTime.now()),
        'joiningDate': Timestamp.fromDate(client.joiningDate),
      };

      // Add optional fields only if they have values
      void addIfNotEmpty(String key, String? value) {
        if (value != null && value.trim().isNotEmpty) {
          updateData[key] = value.trim();
        }
      }

      addIfNotEmpty('organizationName', client.organizationName);
      addIfNotEmpty('governmentType', client.governmentType);
      addIfNotEmpty('website', client.website);
      addIfNotEmpty('gstin', client.gstin);
      addIfNotEmpty('pan', client.pan);
      addIfNotEmpty('leadId', client.leadId);
      addIfNotEmpty('assignedEmployeeId', client.assignedEmployeeId);

      // Add non-string optional fields
      if (client.metadata != null && client.metadata!.isNotEmpty) {
        updateData['metadata'] = client.metadata;
      }
      if (client.tags != null && client.tags!.isNotEmpty) {
        updateData['tags'] = client.tags;
      }
      if (client.projects.isNotEmpty) {
        updateData['projects'] = client.projects.map((p) => p.toJson()).toList();
      }

      // Update in Firestore with merge option to prevent field deletion
      await clientRef.set(updateData, SetOptions(merge: true));
      
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
      _logger.i('🗑️ Deleting client: $clientId');
      
      // First check if organization exists
      final orgDoc = await _firestore
          .collection('organizations')
          .doc(organizationId)
          .get();
          
      if (!orgDoc.exists) {
        _logger.w('⚠️ Organization not found');
        throw FirebaseClientsException('Organization not found');
      }
      
      // Get reference to the client document
      final clientRef = _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('clients')
          .doc(clientId);
      
      // Check if client exists before deleting
      final clientDoc = await clientRef.get();
      if (!clientDoc.exists) {
        _logger.w('⚠️ Client not found');
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
      _logger.d('🌊 Starting clients watch stream for organization: $organizationId');
      
      return _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('clients')
          .orderBy('lastInteractionDate', descending: true)
          .snapshots()
          .asyncMap((snapshot) async {
            final List<Client> clients = [];
            
            for (var doc in snapshot.docs) {
              try {
                // Safely create client, skipping documents that can't be parsed
                final client = await _createClientFromDocument(doc);
                clients.add(client);
              } catch (e) {
                _logger.e('❌ Failed to parse client document: ${doc.id}', error: e);
                // Optionally log the problematic document data
                _logger.d('Problematic document data: ${doc.data()}');
                // Continue processing other documents
                continue;
              }
            }
            
            _logger.d('📦 Successfully processed ${clients.length} clients from stream');
            return clients;
          });
    } catch (e, stackTrace) {
      _logger.e('❌ Error setting up clients watch stream',
          error: e, stackTrace: stackTrace);
      
      // Return a stream that immediately emits an error
      return Stream.error(
        FirebaseClientsException('Failed to watch clients: ${e.toString()}')
      );
    }
  }
}
