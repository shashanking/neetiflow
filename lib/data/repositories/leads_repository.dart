import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:neetiflow/domain/entities/lead.dart';
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
  Stream<List<TimelineEvent>> getEmployeeTimelineEvents(String organizationId, String employeeId);
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
    final leadJson = lead.toJson()..remove('id');
    await _firestore
        .collection('organizations')
        .doc(organizationId)
        .collection('leads')
        .doc(lead.id)
        .set(leadJson);

    // Add timeline events if any
    if (lead.timelineEvents.isNotEmpty) {
      final batch = _firestore.batch();
      for (final event in lead.timelineEvents) {
        final eventRef = _firestore
            .collection('organizations')
            .doc(organizationId)
            .collection('leads')
            .doc(lead.id)
            .collection('timeline')
            .doc(event.id);
        batch.set(eventRef, event.toJson()..remove('id'));
      }
      await batch.commit();
    }
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
    print('Starting CSV parsing...');
    
    // Convert bytes to string and split by newlines
    final csvString = utf8.decode(fileBytes);
    final lines = csvString.split('\n');
    print('Number of lines: ${lines.length}');
    
    if (lines.isEmpty) {
      throw Exception('CSV file is empty');
    }

    // Parse header line
    final headerLine = lines[0];
    final headers = Map<String, int>.fromIterables(
      headerLine.split(',').map((e) => e.trim().toLowerCase()),
      List.generate(headerLine.split(',').length, (i) => i),
    );
    print('Headers: $headers');

    final leads = <Lead>[];
    // Start from index 1 to skip header
    for (var i = 1; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.isEmpty) continue;
      
      print('\nProcessing line $i: $line');
      final values = line.split(',').map((e) => e.trim()).toList();
      
      if (values.length != headers.length) {
        print('Line $i has incorrect number of values: ${values.length} (expected: ${headers.length})');
        continue;
      }

      try {
        final lead = Lead.fromCSV(values, headers: headers);
        print('Successfully created lead: ${lead.firstName} ${lead.lastName}');
        leads.add(lead);
      } catch (e, stackTrace) {
        print('Error importing line $i: $e');
        print('Stack trace: $stackTrace');
        continue;
      }
    }

    print('Successfully parsed ${leads.length} leads');
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

  @override
  Stream<List<TimelineEvent>> getEmployeeTimelineEvents(String organizationId, String employeeId) {
    return _firestore
        .collection('organizations')
        .doc(organizationId)
        .collection('leads')
        .snapshots()
        .asyncMap((leadsSnapshot) async {
          final allEvents = <TimelineEvent>[];
          final processedLeadIds = <String>{};  // To track processed leads
          
          for (final leadDoc in leadsSnapshot.docs) {
            final leadData = leadDoc.data();
            final assignedTo = leadData['metadata']?['assignedEmployeeId'];
            
            // If this lead is assigned to the current employee, add it as a task
            if (assignedTo == employeeId && !processedLeadIds.contains(leadDoc.id)) {
              processedLeadIds.add(leadDoc.id);
              
              // Add a lead assignment event if not already processed
              allEvents.add(TimelineEvent(
                id: 'assignment_${leadDoc.id}',
                leadId: leadDoc.id,
                title: 'New Lead Assigned',
                description: 'Lead "${leadData['firstName'] ?? ''} ${leadData['lastName'] ?? ''}" has been assigned to you',
                timestamp: ((leadData['assignedAt'] as Timestamp?) ?? 
                          (leadData['createdAt'] as Timestamp?) ?? 
                          Timestamp.now()).toDate(),
                category: 'lead_assigned',
                metadata: {
                  'assignedTo': employeeId,
                  'status': leadData['status'] ?? 'pending',
                  'leadName': '${leadData['firstName'] ?? ''} ${leadData['lastName'] ?? ''}',
                  'leadPhone': leadData['phone'],
                  'leadEmail': leadData['email'],
                },
              ));
            }

            // Get timeline events for this lead
            final timelineSnapshot = await _firestore
                .collection('organizations')
                .doc(organizationId)
                .collection('leads')
                .doc(leadDoc.id)
                .collection('timeline')
                .orderBy('timestamp', descending: true)
                .get();

            final events = timelineSnapshot.docs.map((doc) {
              final data = doc.data();
              // Only include events that are specifically assigned to this employee
              // and are not lead assignments (since we handle those separately)
              final isAssigned = data['metadata'] != null &&
                  data['metadata']['assignedTo'] == employeeId &&
                  data['category'] != 'lead_assigned';
              
              if (!isAssigned) return null;

              return TimelineEvent(
                id: doc.id,
                leadId: leadDoc.id,
                title: data['title'] ?? '',
                description: data['description'] ?? '',
                timestamp: (data['timestamp'] as Timestamp).toDate(),
                category: data['category'] ?? '',
                metadata: {
                  ...?data['metadata'] as Map<String, dynamic>?,
                  'leadName': '${leadData['firstName'] ?? ''} ${leadData['lastName'] ?? ''}',
                  'status': leadData['status'] ?? 'pending',
                },
              );
            }).whereType<TimelineEvent>().toList();

            allEvents.addAll(events);
          }

          // Sort all events by timestamp
          allEvents.sort((a, b) => b.timestamp.compareTo(a.timestamp));
          return allEvents;
        });
  }
}
