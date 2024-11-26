import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:neetiflow/domain/entities/department.dart';
import 'package:neetiflow/domain/repositories/departments_repository.dart';

class FirebaseDepartmentsRepository implements DepartmentsRepository {
  final FirebaseFirestore _firestore;
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 50,
      colors: true,
      printEmojis: true,
    ),
  );

  FirebaseDepartmentsRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<Department>> getDepartments(String organizationId) async {
    try {
      _logger.i('Getting departments for organization: $organizationId');
      final snapshot = await _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('departments')
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Department.fromJson(data);
      }).toList();
    } catch (e, stackTrace) {
      _logger.e('Error getting departments', error: e, stackTrace: stackTrace);
      throw Exception('Failed to get departments: $e');
    }
  }

  @override
  Future<Department> addDepartment(Department department) async {
    try {
      _logger.i('Creating new department: ${department.name}');
      final docRef = await _firestore
          .collection('organizations')
          .doc(department.organizationId)
          .collection('departments')
          .add({
        ...department.toJson(),
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      _logger.i('Department created successfully');
      return department.copyWith(id: docRef.id);
    } catch (e, stackTrace) {
      _logger.e('Error creating department', error: e, stackTrace: stackTrace);
      throw Exception('Failed to create department: $e');
    }
  }

  @override
  Future<void> updateDepartment(Department department) async {
    try {
      _logger.i('Updating department: ${department.id}');
      await _firestore
          .collection('organizations')
          .doc(department.organizationId)
          .collection('departments')
          .doc(department.id)
          .update({
        ...department.toJson(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      _logger.i('Department updated successfully');
    } catch (e, stackTrace) {
      _logger.e('Error updating department', error: e, stackTrace: stackTrace);
      throw Exception('Failed to update department: $e');
    }
  }

  @override
  Future<void> deleteDepartment(String organizationId, String departmentId) async {
    try {
      _logger.i('Deleting department: $departmentId');
      await _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('departments')
          .doc(departmentId)
          .delete();

      _logger.i('Department deleted successfully');
    } catch (e, stackTrace) {
      _logger.e('Error deleting department', error: e, stackTrace: stackTrace);
      throw Exception('Failed to delete department: $e');
    }
  }

  @override
  Future<void> updateEmployeeRole(
    String departmentId,
    String employeeId,
    DepartmentRole role,
  ) async {
    try {
      _logger.i('Updating role for employee: $employeeId in department: $departmentId');
      await _firestore
          .collection('organizations')
          .doc(departmentId)
          .collection('departments')
          .doc(departmentId)
          .update({
        'employeeRoles.$employeeId': role.toString().split('.').last,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      _logger.i('Employee role updated successfully');
    } catch (e, stackTrace) {
      _logger.e('Error updating employee role', error: e, stackTrace: stackTrace);
      throw Exception('Failed to update employee role: $e');
    }
  }

  @override
  Future<void> removeEmployeeFromDepartment(
    String departmentId,
    String employeeId,
  ) async {
    try {
      _logger.i('Removing employee: $employeeId from department: $departmentId');
      await _firestore
          .collection('organizations')
          .doc(departmentId)
          .collection('departments')
          .doc(departmentId)
          .update({
        'employeeRoles.$employeeId': FieldValue.delete(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      _logger.i('Employee removed from department successfully');
    } catch (e, stackTrace) {
      _logger.e('Error removing employee from department',
          error: e, stackTrace: stackTrace);
      throw Exception('Failed to remove employee from department: $e');
    }
  }
}
