import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:neetiflow/domain/entities/department.dart' hide DepartmentHierarchy;
import 'package:neetiflow/domain/entities/role.dart';
import 'package:neetiflow/domain/repositories/departments_repository.dart';

class DepartmentRepositoryException implements Exception {
  final String message;
  final Object? originalException;

  const DepartmentRepositoryException(
    this.message, {
    this.originalException,
  });

  @override
  String toString() => message;
}

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
      throw DepartmentRepositoryException(
        'Failed to get departments: $e', 
        originalException: e
      );
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
        'name': department.name,
        'description': department.description,
        'organizationId': department.organizationId,
        'employeeRoles': department.employeeRoles.map(
          (key, value) => MapEntry(key, {
            'id': value.id,
            'name': value.name,
            'type': value.type.toString().split('.').last,
            'hierarchy': value.hierarchy.toString().split('.').last,
            'permissions': value.permissions,
          }),
        ),
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      _logger.i('Department created successfully');
      
      // Wait for the document to be available and get the server timestamps
      final docSnapshot = await docRef.get();
      final data = docSnapshot.data()!;
      data['id'] = docRef.id;
      
      return Department.fromJson(data);
    } catch (e, stackTrace) {
      _logger.e('Error creating department', error: e, stackTrace: stackTrace);
      throw DepartmentRepositoryException(
        'Failed to create department: $e', 
        originalException: e
      );
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
        'name': department.name,
        'description': department.description,
        'organizationId': department.organizationId,
        'employeeRoles': department.employeeRoles.map(
          (key, value) => MapEntry(key, {
            'id': value.id,
            'name': value.name,
            'type': value.type.toString().split('.').last,
            'hierarchy': value.hierarchy.toString().split('.').last,
            'permissions': value.permissions,
          }),
        ),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      _logger.i('Department updated successfully');
    } catch (e, stackTrace) {
      _logger.e('Error updating department', error: e, stackTrace: stackTrace);
      throw DepartmentRepositoryException(
        'Failed to update department: $e', 
        originalException: e
      );
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
      throw DepartmentRepositoryException(
        'Failed to delete department: $e', 
        originalException: e
      );
    }
  }

  @override
  Future<void> updateEmployeeRole(
    String departmentId, 
    String employeeId, 
    Role role
  ) async {
    try {
      // Validate role input
      if (role == null) {
        throw ArgumentError('Role cannot be null');
      }

      _logger.i('Updating employee role: $employeeId in department: $departmentId');
      
      // Get the organization ID from the role
      final organizationId = role.organizationId;

      await _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('departments')
          .doc(departmentId)
          .update({
        'employeeRoles.$employeeId': {
          'id': role.id,
          'name': role.name,
          'type': role.type.toString().split('.').last,
          'hierarchy': role.hierarchy.toString().split('.').last,
          'permissions': role.permissions,
        },
        'updatedAt': FieldValue.serverTimestamp(),
      });

      _logger.i('Employee role updated successfully');
    } catch (e, stackTrace) {
      _logger.e(
        'Error updating employee role', 
        error: e, 
        stackTrace: stackTrace
      );
      throw DepartmentRepositoryException(
        'Failed to update employee role: ${e.toString()}', 
        originalException: e
      );
    }
  }

  @override
  Future<void> removeEmployeeFromDepartment(
    String departmentId, 
    String employeeId
  ) async {
    try {
      _logger.i('Removing employee: $employeeId from department: $departmentId');
      
      // Find the organization ID
      final departmentSnapshot = await _firestore
          .collection('organizations')
          .doc(departmentId)
          .collection('departments')
          .doc(departmentId)
          .get();
      
      final organizationId = departmentSnapshot.data()?['organizationId'];
      
      if (organizationId == null) {
        throw ArgumentError('Department not found');
      }

      // Remove employee role from department
      await _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('departments')
          .doc(departmentId)
          .update({
        'employeeRoles.$employeeId': FieldValue.delete(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      _logger.i('Employee removed from department successfully');
    } catch (e, stackTrace) {
      _logger.e(
        'Error removing employee from department', 
        error: e, 
        stackTrace: stackTrace
      );
      throw DepartmentRepositoryException(
        'Failed to remove employee from department: ${e.toString()}', 
        originalException: e
      );
    }
  }

  // Method to seed initial departments for a new organization
  Future<void> seedInitialDepartments(String organizationId) async {
    try {
      final departmentsCollection = _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('departments');

      // Check if departments already exist
      final existingDepartments = await departmentsCollection.get();
      if (existingDepartments.docs.isNotEmpty) return;

      // Define default departments with unique identifiers
      final defaultDepartments = [
        Department(
          id: 'hr_department', // Explicitly set unique ID
          name: 'Human Resources',
          description: 'Manages employee relations, recruitment, and benefits',
          organizationId: organizationId,
        ),
        Department(
          id: 'it_department', // Explicitly set unique ID
          name: 'Information Technology',
          description: 'Manages technology infrastructure and support',
          organizationId: organizationId,
        ),
        Department(
          id: 'finance_department', // Explicitly set unique ID
          name: 'Finance',
          description: 'Handles financial planning, accounting, and budgeting',
          organizationId: organizationId,
        ),
        Department(
          id: 'sales_department', // Explicitly set unique ID
          name: 'Sales',
          description: 'Responsible for revenue generation and customer acquisition',
          organizationId: organizationId,
        ),
        Department(
          id: 'marketing_department', // Explicitly set unique ID
          name: 'Marketing',
          description: 'Manages brand strategy and promotional activities',
          organizationId: organizationId,
        ),
      ];

      // Add default departments with predefined IDs
      for (var department in defaultDepartments) {
        await departmentsCollection.doc(department.id).set(department.toJson());
      }

      _logger.i('Seeded initial departments for organization: $organizationId');
    } catch (e, stackTrace) {
      _logger.e('Error seeding initial departments', error: e, stackTrace: stackTrace);
      throw DepartmentRepositoryException(
        'Failed to seed initial departments: ${e.toString()}',
        originalException: e,
      );
    }
  }

  @override
  Stream<List<Department>> watchDepartments(String organizationId) {
    try {
      _logger.i('Watching departments for organization: $organizationId');
      return _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('departments')
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          return Department.fromJson(data);
        }).toList();
      });
    } catch (e, stackTrace) {
      _logger.e('Error watching departments', error: e, stackTrace: stackTrace);
      return Stream.error(DepartmentRepositoryException(
        'Failed to watch departments: ${e.toString()}',
        originalException: e,
      ));
    }
  }
}
