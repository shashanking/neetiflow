import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:neetiflow/domain/entities/lead.dart';

abstract class LeadsRepository {
  Stream<List<Lead>> getLeads(String organizationId);
  Future<void> createLead(String organizationId, Lead lead);
  Future<void> updateLead(String organizationId, Lead lead);
  Future<void> deleteLead(String organizationId, String leadId);
  Future<void> bulkDeleteLeads({
    required String organizationId,
    required Set<String> leadIds,
  });
  Future<void> bulkUpdateLeadsStatus({
    required String organizationId,
    required Set<String> leadIds,
    required String status,
  });
  Future<void> bulkUpdateLeadsProcessStatus({
    required String organizationId,
    required Set<String> leadIds,
    required String status,
  });
  Future<List<Lead>> importLeadsFromCSV(Uint8List fileBytes);
  Future<Uint8List> exportLeadsToCSV(List<Lead> leads);
}

class LeadsRepositoryImpl implements LeadsRepository {
  final FirebaseFirestore _firestore;

  LeadsRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<void> bulkDeleteLeads({
    required String organizationId,
    required Set<String> leadIds,
  }) async {
    final batch = _firestore.batch();
    
    for (final leadId in leadIds) {
      final docRef = _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('leads')
          .doc(leadId);
      batch.delete(docRef);
    }

    await batch.commit();
  }

  @override
  Future<void> bulkUpdateLeadsStatus({
    required String organizationId,
    required Set<String> leadIds,
    required String status,
  }) async {
    final batch = _firestore.batch();
    
    for (final leadId in leadIds) {
      final docRef = _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('leads')
          .doc(leadId);
      batch.update(docRef, {'status': status});
    }

    await batch.commit();
  }

  @override
  Future<void> bulkUpdateLeadsProcessStatus({
    required String organizationId,
    required Set<String> leadIds,
    required String status,
  }) async {
    final batch = _firestore.batch();
    
    for (final leadId in leadIds) {
      final docRef = _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('leads')
          .doc(leadId);
      batch.update(docRef, {'processStatus': status});
    }

    await batch.commit();
  }

  @override
  Stream<List<Lead>> getLeads(String organizationId) {
    return _firestore
        .collection('organizations')
        .doc(organizationId)
        .collection('leads')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Lead.fromJson({...doc.data(), 'id': doc.id}))
            .toList());
  }

  @override
  Future<void> createLead(String organizationId, Lead lead) async {
    await _firestore
        .collection('organizations')
        .doc(organizationId)
        .collection('leads')
        .add(lead.toJson()..remove('id'));
  }

  @override
  Future<void> updateLead(String organizationId, Lead lead) async {
    await _firestore
        .collection('organizations')
        .doc(organizationId)
        .collection('leads')
        .doc(lead.id)
        .update(lead.toJson()..remove('id'));
  }

  @override
  Future<void> deleteLead(String organizationId, String leadId) async {
    await _firestore
        .collection('organizations')
        .doc(organizationId)
        .collection('leads')
        .doc(leadId)
        .delete();
  }

  @override
  Future<List<Lead>> importLeadsFromCSV(Uint8List fileBytes) {
    // TODO: implement importLeadsFromCSV
    throw UnimplementedError();
  }

  @override
  Future<Uint8List> exportLeadsToCSV(List<Lead> leads) {
    // TODO: implement exportLeadsToCSV
    throw UnimplementedError();
  }
}
