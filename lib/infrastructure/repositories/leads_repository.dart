import 'dart:convert';
import 'dart:html' if (dart.library.html) 'dart:html' as html;
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

  // Create a new lead
  Future<void> createLead(String companyId, Lead lead) async {
    final leadData = {
      'uid': '', // Will be set by rules
      'firstName': lead.firstName,
      'lastName': lead.lastName,
      'phone': lead.phone,
      'email': lead.email,
      'subject': lead.subject,
      'message': lead.message,
      'status': lead.status.toString().split('.').last,
      'processStatus': lead.processStatus.toString().split('.').last,
      'createdAt': FieldValue.serverTimestamp(),
      'metadata': lead.metadata ?? {},
      'segments': lead.segments ?? [],
    };

    await _firestore
        .collection('organizations')
        .doc(companyId)
        .collection('leads')
        .add(leadData);
  }

  // Import leads from CSV
  Future<List<Lead>> importLeadsFromCSV(Uint8List bytes) async {
    try {
      final csvString = utf8.decode(bytes);
      final List<List<dynamic>> rows = const CsvToListConverter().convert(csvString);

      if (rows.isEmpty) {
        throw Exception('CSV file is empty');
      }

      // Skip header row and convert to leads
      final leads = rows.skip(1).map((row) {
        if (row.length < 6) {
          throw Exception('Invalid CSV format: each row must have at least 6 columns');
        }

        return Lead(
          id: '', // Will be set by Firestore
          uid: '', // Will be set by rules
          firstName: row[0].toString(),
          lastName: row[1].toString(),
          phone: row[2].toString(),
          email: row[3].toString(),
          subject: row[4].toString(),
          message: row[5].toString(),
          status: LeadStatus.cold,
          processStatus: ProcessStatus.fresh,
          createdAt: DateTime.now(),
          metadata: {},
          segments: ['csv-import'],
        );
      }).toList();

      return leads;
    } catch (e) {
      throw Exception('Failed to parse CSV file: ${e.toString()}');
    }
  }

  // Save imported leads
  Future<void> saveImportedLeads(String companyId, List<Lead> leads) async {
    final batch = _firestore.batch();
    final collectionRef = _firestore
        .collection('organizations')
        .doc(companyId)
        .collection('leads');

    for (final lead in leads) {
      final docRef = collectionRef.doc();
      final leadData = {
        'uid': '', // Will be set by rules
        'firstName': lead.firstName,
        'lastName': lead.lastName,
        'phone': lead.phone,
        'email': lead.email,
        'subject': lead.subject,
        'message': lead.message,
        'status': lead.status.toString().split('.').last,
        'processStatus': lead.processStatus.toString().split('.').last,
        'createdAt': FieldValue.serverTimestamp(),
        'metadata': lead.metadata ?? {},
        'segments': lead.segments ?? ['csv-import'],
      };
      batch.set(docRef, leadData);
    }

    await batch.commit();
  }

  // Export leads to CSV and handle download
  Future<void> exportLeadsToCSV(String companyId) async {
    try {
      final leads = await getLeads(companyId);
      
      final csvData = [
        ['First Name', 'Last Name', 'Phone', 'Email', 'Subject', 'Message', 'Status', 'Process Status', 'Created At'],
        ...leads.map((lead) => [
              lead.firstName,
              lead.lastName,
              lead.phone,
              lead.email,
              lead.subject,
              lead.message,
              lead.status.toString().split('.').last,
              lead.processStatus.toString().split('.').last,
              lead.createdAt.toIso8601String(),
            ]),
      ];

      final csvString = const ListToCsvConverter().convert(csvData);
      final bytes = utf8.encode(csvString);

      if (kIsWeb) {
        // For web, create a download link
        final blob = html.Blob([bytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final link = html.AnchorElement()
          ..href = url
          ..download = 'leads_${DateTime.now().toIso8601String()}.csv';
        link.click();
        html.Url.revokeObjectUrl(url);
      } else {
        // TODO: Implement native platform file saving
        throw UnimplementedError('File saving not yet implemented for native platforms');
      }
    } catch (e) {
      throw Exception('Failed to export leads: ${e.toString()}');
    }
  }
}
