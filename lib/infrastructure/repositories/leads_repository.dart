import 'dart:convert';
import 'dart:typed_data';
import 'dart:html' if (dart.library.html) 'dart:html' as html;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:neetiflow/domain/entities/lead.dart';
import 'package:csv/csv.dart';

class LeadsRepository {
  final FirebaseFirestore _firestore;

  LeadsRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // Get all leads
  Future<List<Lead>> getLeads(String companyId) async {
    final snapshot = await _firestore
        .collection('organizations')
        .doc(companyId)
        .collection('leads')
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return Lead.fromJson(data);
    }).toList();
  }

  // Update lead status
  Future<void> updateLeadStatus({
    required String companyId,
    required String leadId,
    LeadStatus? status,
    ProcessStatus? processStatus,
  }) async {
    try {
      final docRef = _firestore
          .collection('organizations')
          .doc(companyId)
          .collection('leads')
          .doc(leadId);
      final updates = <String, dynamic>{};
      
      if (status != null) {
        updates['status'] = status.toString().split('.').last;
      }
      if (processStatus != null) {
        updates['processStatus'] = processStatus.toString().split('.').last;
      }
      
      await docRef.update(updates);
    } catch (e) {
      throw Exception('Failed to update lead status: $e');
    }
  }

  // Create lead
  Future<void> createLead(String companyId, Lead lead) async {
    try {
      await _firestore
          .collection('organizations')
          .doc(companyId)
          .collection('leads')
          .add(lead.toJson());
    } catch (e) {
      throw Exception('Failed to create lead: $e');
    }
  }

  // Update lead
  Future<void> updateLead(String companyId, Lead lead) async {
    try {
      await _firestore
          .collection('organizations')
          .doc(companyId)
          .collection('leads')
          .doc(lead.id)
          .update(lead.toJson());
    } catch (e) {
      throw Exception('Failed to update lead: $e');
    }
  }

  // Delete lead
  Future<void> deleteLead(String companyId, String leadId) async {
    try {
      await _firestore
          .collection('organizations')
          .doc(companyId)
          .collection('leads')
          .doc(leadId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete lead: $e');
    }
  }

  // Import leads from CSV
  Future<List<Lead>> importLeadsFromCSV(Uint8List fileBytes) async {
    try {
      final csvString = String.fromCharCodes(fileBytes);
      final List<List<dynamic>> csvTable = const CsvToListConverter().convert(csvString);
      
      if (csvTable.isEmpty) {
        throw Exception('CSV file is empty');
      }

      final headers = csvTable[0].map((e) => e.toString().toLowerCase()).toList();
      final leads = <Lead>[];

      for (var i = 1; i < csvTable.length; i++) {
        final row = csvTable[i];
        if (row.length != headers.length) continue;

        final Map<String, dynamic> leadData = {};
        for (var j = 0; j < headers.length; j++) {
          leadData[headers[j]] = row[j].toString();
        }

        leads.add(Lead.fromJson(leadData));
      }

      return leads;
    } catch (e) {
      throw Exception('Failed to parse CSV file: $e');
    }
  }

  // Save imported leads
  Future<void> saveImportedLeads(String companyId, List<Lead> leads) async {
    try {
      final batch = _firestore.batch();
      final collectionRef = _firestore
          .collection('organizations')
          .doc(companyId)
          .collection('leads');

      for (final lead in leads) {
        final docRef = collectionRef.doc();
        batch.set(docRef, lead.toJson());
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to save imported leads: $e');
    }
  }

  // Export leads to CSV
  Future<Uint8List> exportLeadsToCSV(List<Lead> leads) async {
    try {
      print('Repository: Starting CSV export for ${leads.length} leads');
      final headers = [
        'First Name',
        'Last Name',
        'Email',
        'Phone',
        'Subject',
        'Message',
        'Status',
        'Process Status',
        'Segments',
        'Created At',
      ];
      print('Repository: Headers prepared: ${headers.join(", ")}');

      final List<List<dynamic>> rows = [];
      for (var lead in leads) {
        try {
          final row = [
            lead.firstName,
            lead.lastName,
            lead.email,
            lead.phone,
            lead.subject,
            lead.message,
            lead.status.toString().split('.').last,
            lead.processStatus.toString().split('.').last,
            lead.segments?.join(', ') ?? '',
            lead.createdAt.toIso8601String(),
          ];
          rows.add(row);
        } catch (e, stackTrace) {
          print('Error processing lead ${lead.id}: $e');
          print(stackTrace);
        }
      }

      final csvString = const ListToCsvConverter().convert([headers, ...rows]);
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
        return Uint8List(0); // Return empty bytes for web
      } else {
        return Uint8List.fromList(bytes);
      }
    } catch (e, stackTrace) {
      print('Repository: CSV export failed');
      print('Repository: Error: $e');
      print('Repository: Stack trace: $stackTrace');
      throw Exception('Failed to export leads to CSV: $e');
    }
  }
}
