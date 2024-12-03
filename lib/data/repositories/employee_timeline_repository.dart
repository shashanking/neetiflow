import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:neetiflow/domain/entities/employee_timeline_event.dart';

abstract class EmployeeTimelineRepository {
  Stream<List<EmployeeTimelineEvent>> getTimelineEvents(String organizationId, String employeeId);
  Future<void> addTimelineEvent(String organizationId, EmployeeTimelineEvent event);
  Future<void> deleteTimelineEvent(String organizationId, String employeeId, String eventId);
}

class EmployeeTimelineRepositoryImpl implements EmployeeTimelineRepository {
  final FirebaseFirestore _firestore;

  EmployeeTimelineRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<EmployeeTimelineEvent>> getTimelineEvents(
    String organizationId,
    String employeeId,
  ) {
    return _firestore
        .collection('organizations')
        .doc(organizationId)
        .collection('employees')
        .doc(employeeId)
        .collection('timeline')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                EmployeeTimelineEvent.fromJson({...doc.data(), 'id': doc.id}))
            .toList());
  }

  @override
  Future<void> addTimelineEvent(
    String organizationId,
    EmployeeTimelineEvent event,
  ) async {
    await _firestore
        .collection('organizations')
        .doc(organizationId)
        .collection('employees')
        .doc(event.employeeId)
        .collection('timeline')
        .doc(event.id)
        .set(event.toJson());
  }

  @override
  Future<void> deleteTimelineEvent(
    String organizationId,
    String employeeId,
    String eventId,
  ) async {
    await _firestore
        .collection('organizations')
        .doc(organizationId)
        .collection('employees')
        .doc(employeeId)
        .collection('timeline')
        .doc(eventId)
        .delete();
  }
}
