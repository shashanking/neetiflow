import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:neetiflow/domain/entities/custom_field.dart';
import 'dart:developer' as developer;

class CustomFieldsRepository {
  final FirebaseFirestore _firestore;
  final String _organizationId;

  CustomFieldsRepository({
    required String organizationId,
    FirebaseFirestore? firestore,
  })  : _organizationId = organizationId,
        _firestore = firestore ?? FirebaseFirestore.instance {
    // Log repository initialization details
    developer.log(
      'CustomFieldsRepository initialized',
      name: 'CustomFieldsRepository',
      level: 800, // INFO level
      error: {
        'organizationId': _organizationId,
        'firestore': _firestore.toString(),
      },
    );
  }

  CollectionReference<Map<String, dynamic>> get _customFieldsCollection =>
      _firestore
          .collection('organizations')
          .doc(_organizationId)
          .collection('custom_fields');

  Future<List<CustomField>> getCustomFields() async {
    try {
      developer.log('Fetching custom fields', 
        name: 'CustomFieldsRepository',
        level: 800, // INFO level
        error: {
          'organizationId': _organizationId,
          'collectionPath': _customFieldsCollection.path,
        },
      );

      // First, check if the organization document exists
      final orgDoc = await _firestore
          .collection('organizations')
          .doc(_organizationId)
          .get();

      if (!orgDoc.exists) {
        developer.log('Organization document does not exist', 
          name: 'CustomFieldsRepository',
          level: 1000, // ERROR level
          error: 'Invalid organization ID: $_organizationId',
        );
        throw Exception('Invalid organization ID');
      }

      final snapshot = await _customFieldsCollection
          .where('isActive', isEqualTo: true)
          .get();

      developer.log('Custom fields query results', 
        name: 'CustomFieldsRepository',
        level: 900, // DEBUG level
        error: {
          'documentCount': snapshot.docs.length,
        },
      );

      final fields = snapshot.docs
          .map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            
            developer.log('Custom field document', 
              name: 'CustomFieldsRepository',
              level: 950, // VERBOSE level
              error: data,
            );

            return CustomField.fromJson(data);
          })
          .toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return fields;
    } catch (e, stackTrace) {
      developer.log('Error in getCustomFields', 
        name: 'CustomFieldsRepository',
        level: 1000, // ERROR level
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<void> addCustomField(CustomField field) async {
    try {
      await _customFieldsCollection.doc(field.id).set(field.toJson());
    } catch (e) {
      throw Exception('Failed to add custom field: $e');
    }
  }

  Future<void> updateCustomField(CustomField field) async {
    try {
      await _customFieldsCollection.doc(field.id).update(field.toJson());
    } catch (e) {
      throw Exception('Failed to update custom field: $e');
    }
  }

  Future<void> deleteCustomField(String fieldId) async {
    try {
      // Soft delete by setting isActive to false
      await _customFieldsCollection.doc(fieldId).update({'isActive': false});
    } catch (e) {
      throw Exception('Failed to delete custom field: $e');
    }
  }

  Stream<List<CustomField>> watchCustomFields() {
    return _customFieldsCollection
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      developer.log('Watching custom fields - snapshot docs count: ${snapshot.docs.length}', 
        name: 'CustomFieldsRepository',
        level: 900, // DEBUG level
      );

      return snapshot.docs
          .map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            
            developer.log('Watched document data: $data', 
              name: 'CustomFieldsRepository',
              level: 950, // VERBOSE level
            );

            return CustomField.fromJson(data);
          })
          .toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    });
  }
}
