import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:neetiflow/domain/entities/lead.dart';
import 'package:neetiflow/domain/entities/custom_field_value.dart';
import 'package:neetiflow/domain/entities/timeline_event.dart';

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
  Future<void> addTimelineEvent(String organizationId, TimelineEvent event);
  Stream<List<TimelineEvent>> getTimelineEvents(String organizationId, String leadId);
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
  Future<List<Lead>> importLeadsFromCSV(Uint8List fileBytes) async {
    final csvString = utf8.decode(fileBytes);
    final csvTable = const CsvToListConverter().convert(csvString);
    
    if (csvTable.isEmpty) {
      throw Exception('CSV file is empty');
    }

    // Convert headers to strings explicitly
    final headers = Map<String, int>.fromIterables(
      (csvTable.first).map((e) => e.toString().toLowerCase().replaceAll(' ', '')),
      List.generate((csvTable.first).length, (i) => i),
    );

    final leads = <Lead>[];
    for (var i = 1; i < csvTable.length; i++) {
      final row = csvTable[i];
      if (row.length != headers.length) continue;

      // Extract custom fields from CSV
      final customFields = <String, CustomFieldValue>{};
      headers.forEach((key, index) {
        if (key.startsWith('cf_') && row[index] != null && row[index].toString().isNotEmpty) {
          final fieldId = key.substring(3); // Remove 'cf_' prefix
          customFields[fieldId] = CustomFieldValue(
            fieldId: fieldId,
            value: row[index],
            updatedAt: DateTime.now(),
          );
        }
      });

      // Convert row to List<String> for fromCSV method
      final stringRow = row.map((e) => e?.toString() ?? '').toList();

      try {
        leads.add(Lead.fromCSV(stringRow, headers: headers)
            .copyWith(customFields: customFields));
      } catch (e) {
        print('Error importing row $i: $e');
        continue;
      }
    }

    return leads;
  }

  @override
  Future<Uint8List> exportLeadsToCSV(List<Lead> leads) async {
    if (leads.isEmpty) {
      return Uint8List.fromList(utf8.encode(''));
    }

    // Get all unique custom field IDs
    final customFieldIds = <String>{};
    for (final lead in leads) {
      customFieldIds.addAll(lead.customFields.keys);
    }

    // Prepare headers
    final headers = [
      'ID',
      'First Name',
      'Last Name',
      'Email',
      'Phone',
      'Subject',
      'Message',
      'Status',
      'Process Status',
      'Created At',
      'Updated At',
      'Score',
      ...customFieldIds.map((id) => 'CF_$id'),
    ];

    // Prepare rows
    final rows = leads.map((lead) {
      final row = [
        lead.id,
        lead.firstName,
        lead.lastName,
        lead.email,
        lead.phone,
        lead.subject,
        lead.message,
        lead.status.toString().split('.').last,
        lead.processStatus.toString().split('.').last,
        lead.createdAt.toIso8601String(),
        lead.updatedAt?.toIso8601String() ?? '',
        lead.score.toString(),
      ];

      // Add custom field values
      for (final fieldId in customFieldIds) {
        final value = lead.customFields[fieldId]?.value ?? '';
        row.add(value.toString());
      }

      return row;
    }).toList();

    // Convert to CSV
    rows.insert(0, headers);
    final csv = const ListToCsvConverter().convert(rows);
    return Uint8List.fromList(utf8.encode(csv));
  }

  @override
  Future<void> addTimelineEvent(String organizationId, TimelineEvent event) async {
    await _firestore
        .collection('organizations')
        .doc(organizationId)
        .collection('leads')
        .doc(event.leadId)
        .collection('timeline')
        .doc(event.id)
        .set(event.toJson());
  }

  @override
  Stream<List<TimelineEvent>> getTimelineEvents(String organizationId, String leadId) {
    return _firestore
        .collection('organizations')
        .doc(organizationId)
        .collection('leads')
        .doc(leadId)
        .collection('timeline')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TimelineEvent.fromJson({...doc.data(), 'id': doc.id}))
            .toList());
  }
}
