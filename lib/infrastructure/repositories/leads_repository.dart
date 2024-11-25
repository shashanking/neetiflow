import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:neetiflow/domain/entities/lead.dart';

class LeadsRepository {
  final FirebaseFirestore _firestore;

  LeadsRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // Get leads for a company
  Future<List<Lead>> getLeads(String companyId) async {
    final snapshot = await _firestore
        .collection('organizations')
        .doc(companyId)
        .collection('leads')
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return Lead.fromJson(data);
    }).toList();
  }

  // Update lead status
  Future<void> updateLeadStatus(
    String companyId,
    String leadId, {
    LeadStatus? status,
    ProcessStatus? processStatus,
  }) async {
    final Map<String, dynamic> data = {};
    if (status != null) {
      data['status'] = status.toString().split('.').last;
    }
    if (processStatus != null) {
      data['processStatus'] = processStatus.toString().split('.').last;
    }

    await _firestore
        .collection('organizations')
        .doc(companyId)
        .collection('leads')
        .doc(leadId)
        .update(data);
  }

  // Import leads from CSV
  Future<List<Lead>> importLeadsFromCSV(Uint8List bytes) async {
    try {
      final csvString = utf8.decode(bytes);
      final List<List<dynamic>> csvTable = const CsvToListConverter().convert(csvString);

      if (csvTable.isEmpty) {
        throw Exception('CSV file is empty');
      }

      // Get headers
      final headers = Map.fromIterables(
        (csvTable[0] )
            .map((e) => e.toString().toLowerCase().replaceAll(' ', '')),
        List.generate(csvTable[0].length, (i) => i),
      );

      // Convert rows to leads
      final leads = csvTable.skip(1).map((row) {
        return Lead.fromCSV(
          row.map((e) => e.toString()).toList(),
          headers: headers,
        );
      }).toList();

      return leads;
    } catch (e) {
      throw Exception('Failed to parse CSV file: ${e.toString()}');
    }
  }

  // Export leads to CSV
  Future<Uint8List> exportLeadsToCSV(List<Lead> leads) async {
    try {
      final headers = [
        'First name',
        'Last name',
        'Phone',
        'Email',
        'Subject',
        'Msg',
        'Status',
        'Process status',
        'Created at',
        'Uid',
        'ID',
        'Metadata'
      ];

      final rows = leads.map((lead) => [
        lead.firstName,
        lead.lastName,
        lead.phone,
        lead.email,
        lead.subject,
        lead.message,
        lead.status.toString().split('.').last,
        lead.processStatus.toString().split('.').last,
        lead.createdAt.toIso8601String(),
        lead.uid,
        lead.id,
        lead.metadata != null ? jsonEncode(lead.metadata) : '',
      ]).toList();

      rows.insert(0, headers);

      final csv = const ListToCsvConverter().convert(rows);
      return Uint8List.fromList(utf8.encode(csv));
    } catch (e) {
      throw Exception('Failed to export leads to CSV: ${e.toString()}');
    }
  }

  // Save imported leads to Firestore
  Future<void> saveImportedLeads(String companyId, List<Lead> leads) async {
    final batch = _firestore.batch();
    final leadsRef = _firestore
        .collection('organizations')
        .doc(companyId)
        .collection('leads');

    for (final lead in leads) {
      final docRef = leadsRef.doc(lead.id);
      batch.set(docRef, lead.toJson());
    }

    await batch.commit();
  }

  // Create lead
  Future<void> createLead(String companyId, Lead lead) async {
    try {
      final docRef = _firestore
          .collection('organizations')
          .doc(companyId)
          .collection('leads')
          .doc();

      await docRef.set({
        'id': docRef.id,
        'uid': lead.uid,
        'firstName': lead.firstName,
        'lastName': lead.lastName,
        'phone': lead.phone,
        'email': lead.email,
        'subject': lead.subject,
        'message': lead.message,
        'status': lead.status.toString().split('.').last,
        'processStatus': lead.processStatus.toString().split('.').last,
        'createdAt': FieldValue.serverTimestamp(),
        'metadata': lead.metadata,
      });
    } catch (e) {
      throw Exception('Failed to create lead: ${e.toString()}');
    }
  }
}
