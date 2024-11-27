import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/lead_model.dart';

abstract class LeadsRepository {
  Stream<List<LeadModel>> getLeads(String companyId);
  Future<void> createLead(String companyId, LeadModel lead);
  Future<void> updateLead(String companyId, LeadModel lead);
  Future<void> deleteLead(String companyId, String leadId);
  Future<void> bulkDeleteLeads({
    required String companyId,
    required Set<String> leadIds,
  });
  Future<void> bulkUpdateLeadsStatus({
    required String companyId,
    required Set<String> leadIds,
    required String status,
  });
  Future<void> bulkUpdateLeadsProcessStatus({
    required String companyId,
    required Set<String> leadIds,
    required String status,
  });
  Future<List<LeadModel>> importLeadsFromCSV(Uint8List fileBytes);
  Future<Uint8List> exportLeadsToCSV(List<LeadModel> leads);
}

class LeadsRepositoryImpl implements LeadsRepository {
  final FirebaseFirestore _firestore;

  LeadsRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<void> bulkDeleteLeads({
    required String companyId,
    required Set<String> leadIds,
  }) async {
    final batch = _firestore.batch();
    
    for (final leadId in leadIds) {
      final docRef = _firestore
          .collection('companies')
          .doc(companyId)
          .collection('leads')
          .doc(leadId);
      batch.delete(docRef);
    }

    await batch.commit();
  }

  @override
  Future<void> bulkUpdateLeadsStatus({
    required String companyId,
    required Set<String> leadIds,
    required String status,
  }) async {
    final batch = _firestore.batch();
    
    for (final leadId in leadIds) {
      final docRef = _firestore
          .collection('companies')
          .doc(companyId)
          .collection('leads')
          .doc(leadId);
      batch.update(docRef, {'status': status});
    }

    await batch.commit();
  }

  @override
  Future<void> bulkUpdateLeadsProcessStatus({
    required String companyId,
    required Set<String> leadIds,
    required String status,
  }) async {
    final batch = _firestore.batch();
    
    for (final leadId in leadIds) {
      final docRef = _firestore
          .collection('companies')
          .doc(companyId)
          .collection('leads')
          .doc(leadId);
      batch.update(docRef, {'processStatus': status});
    }

    await batch.commit();
  }

  @override
  Stream<List<LeadModel>> getLeads(String companyId) {
    return _firestore
        .collection('companies')
        .doc(companyId)
        .collection('leads')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => LeadModel.fromJson({...doc.data(), 'id': doc.id}))
            .toList());
  }

  @override
  Future<void> createLead(String companyId, LeadModel lead) async {
    await _firestore
        .collection('companies')
        .doc(companyId)
        .collection('leads')
        .add(lead.toJson()..remove('id'));
  }

  @override
  Future<void> updateLead(String companyId, LeadModel lead) async {
    await _firestore
        .collection('companies')
        .doc(companyId)
        .collection('leads')
        .doc(lead.id)
        .update(lead.toJson()..remove('id'));
  }

  @override
  Future<void> deleteLead(String companyId, String leadId) async {
    await _firestore
        .collection('companies')
        .doc(companyId)
        .collection('leads')
        .doc(leadId)
        .delete();
  }

  @override
  Future<List<LeadModel>> importLeadsFromCSV(Uint8List fileBytes) {
    // TODO: implement importLeadsFromCSV
    throw UnimplementedError();
  }

  @override
  Future<Uint8List> exportLeadsToCSV(List<LeadModel> leads) {
    // TODO: implement exportLeadsToCSV
    throw UnimplementedError();
  }
}
