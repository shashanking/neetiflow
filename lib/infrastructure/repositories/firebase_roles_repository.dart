import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:neetiflow/domain/entities/role.dart';
import 'package:neetiflow/domain/repositories/roles_repository.dart';

class RoleRepositoryException implements Exception {
  final String message;
  final Object? originalException;

  const RoleRepositoryException(
    this.message, {
    this.originalException,
  });

  @override
  String toString() => message;
}

class FirebaseRolesRepository implements RolesRepository {
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

  FirebaseRolesRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<Role>> getRoles(String organizationId) async {
    try {
      _logger.i('Getting roles for organization: $organizationId');
      final snapshot = await _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('roles')
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Role.fromJson(data);
      }).toList();
    } catch (e, stackTrace) {
      _logger.e('Error getting roles', error: e, stackTrace: stackTrace);
      throw Exception('Failed to get roles: $e');
    }
  }

  @override
  Stream<List<Role>> rolesStream(String organizationId) {
    return _firestore
        .collection('organizations')
        .doc(organizationId)
        .collection('roles')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Role.fromJson(data);
      }).toList();
    });
  }

  @override
  Future<Role> addRole(Role role) async {
    try {
      _logger.i('Creating new role: ${role.name}');
      final docRef = await _firestore
          .collection('organizations')
          .doc(role.organizationId)
          .collection('roles')
          .add({
        ...role.toJson(),
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      final docSnapshot = await docRef.get();
      final data = docSnapshot.data()!;
      data['id'] = docRef.id;

      _logger.i('Role created successfully');
      return Role.fromJson(data);
    } catch (e, stackTrace) {
      _logger.e('Error creating role', error: e, stackTrace: stackTrace);
      throw Exception('Failed to create role: $e');
    }
  }

  @override
  Future<void> updateRole(Role role) async {
    try {
      _logger.i('Updating role: ${role.id}');
      await _firestore
          .collection('organizations')
          .doc(role.organizationId)
          .collection('roles')
          .doc(role.id)
          .update({
        ...role.toJson(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      _logger.i('Role updated successfully');
    } catch (e, stackTrace) {
      _logger.e('Error updating role', error: e, stackTrace: stackTrace);
      throw Exception('Failed to update role: $e');
    }
  }

  @override
  Future<void> deleteRole(String organizationId, String roleId) async {
    try {
      _logger.i('Deleting role: $roleId');
      await _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('roles')
          .doc(roleId)
          .delete();

      _logger.i('Role deleted successfully');
    } catch (e, stackTrace) {
      _logger.e('Error deleting role', error: e, stackTrace: stackTrace);
      throw Exception('Failed to delete role: $e');
    }
  }

  @override
  Future<Role?> getRoleById(String organizationId, String roleId) async {
    try {
      _logger.i('Getting role by ID: $roleId');
      final doc = await _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('roles')
          .doc(roleId)
          .get();

      if (!doc.exists) {
        return null;
      }

      final data = doc.data()!;
      data['id'] = doc.id;

      return Role.fromJson(data);
    } catch (e, stackTrace) {
      _logger.e('Error getting role by ID', error: e, stackTrace: stackTrace);
      throw Exception('Failed to get role: $e');
    }
  }

  @override
  Future<List<Role>> getRolesByType(String organizationId, RoleType type) async {
    try {
      _logger.i('Getting roles by type: ${type.toString()}');
      final snapshot = await _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('roles')
          .where('type', isEqualTo: type.toString().split('.').last)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Role.fromJson(data);
      }).toList();
    } catch (e, stackTrace) {
      _logger.e('Error getting roles by type', error: e, stackTrace: stackTrace);
      throw Exception('Failed to get roles by type: $e');
    }
  }

  @override
  Future<void> assignRoleToEmployee(
    String organizationId,
    String roleId,
    String employeeId, {
    String? departmentId,
  }) async {
    try {
      _logger.i('Assigning role $roleId to employee $employeeId');
      
      final role = await getRoleById(organizationId, roleId);
      if (role == null) {
        throw Exception('Role not found');
      }

      final batch = _firestore.batch();

      // Update employee document
      final employeeRef = _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('employees')
          .doc(employeeId);

      if (role.type == RoleType.system) {
        batch.update(employeeRef, {
          'systemRoles': FieldValue.arrayUnion([roleId]),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } else if (departmentId != null) {
        batch.update(employeeRef, {
          'departmentRoles.$departmentId': roleId,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } else {
        throw Exception('Department ID is required for department roles');
      }

      await batch.commit();
      _logger.i('Role assigned successfully');
    } catch (e, stackTrace) {
      _logger.e('Error assigning role', error: e, stackTrace: stackTrace);
      throw Exception('Failed to assign role: $e');
    }
  }

  @override
  Future<void> removeRoleFromEmployee(
    String organizationId,
    String roleId,
    String employeeId, {
    String? departmentId,
  }) async {
    try {
      _logger.i('Removing role $roleId from employee $employeeId');
      
      final role = await getRoleById(organizationId, roleId);
      if (role == null) {
        throw Exception('Role not found');
      }

      final batch = _firestore.batch();

      // Update employee document
      final employeeRef = _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('employees')
          .doc(employeeId);

      if (role.type == RoleType.system) {
        batch.update(employeeRef, {
          'systemRoles': FieldValue.arrayRemove([roleId]),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } else if (departmentId != null) {
        batch.update(employeeRef, {
          'departmentRoles.$departmentId': FieldValue.delete(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } else {
        throw Exception('Department ID is required for department roles');
      }

      await batch.commit();
      _logger.i('Role removed successfully');
    } catch (e, stackTrace) {
      _logger.e('Error removing role', error: e, stackTrace: stackTrace);
      throw Exception('Failed to remove role: $e');
    }
  }

  @override
  Stream<List<Role>> watchRoles(String organizationId) {
    try {
      _logger.i('Watching roles for organization: $organizationId');
      return _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('roles')
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          return Role.fromJson(data);
        }).toList();
      });
    } catch (e, stackTrace) {
      _logger.e('Error watching roles', error: e, stackTrace: stackTrace);
      return Stream.error(RoleRepositoryException(
        'Failed to watch roles: ${e.toString()}',
        originalException: e,
      ));
    }
  }

  // Method to seed initial roles for a new organization
  Future<void> seedInitialRoles(String organizationId) async {
    try {
      final rolesCollection = _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('roles');

      // Check if roles already exist
      final existingRoles = await rolesCollection.get();
      if (existingRoles.docs.isNotEmpty) return;

      // Define default roles with unique identifiers and comprehensive permissions
      final defaultRoles = [
        Role(
          id: 'admin_role', // Explicitly set unique ID
          name: 'Admin',
          description: 'Full system access and control',
          type: RoleType.system,
          permissions: const [
            // System-wide permissions
            'read_all',
            'write_all',
            'delete_all',
            'manage_users',
            'manage_roles',
            'manage_departments',
            'view_reports',
            'configure_system',
          ],
          hierarchy: DepartmentHierarchy.admin, // Highest level of access
          organizationId: organizationId,
        ),
        Role(
          id: 'manager_role', // Explicitly set unique ID
          name: 'Manager',
          description: 'Department-level management',
          type: RoleType.department,
          permissions: const [
            // Department-level permissions
            'read_department',
            'write_department',
            'manage_department_employees',
            'view_department_reports',
            'assign_roles_in_department',
          ],
          hierarchy: DepartmentHierarchy.manager,
          organizationId: organizationId,
        ),
        Role(
          id: 'employee_role', // Explicitly set unique ID
          name: 'Employee',
          description: 'Standard employee role',
          type: RoleType.department,
          permissions: const [
            // Basic employee permissions
            'read_own_profile',
            'update_own_profile',
            'view_department_info',
            'log_work_hours',
            'submit_requests',
          ],
          hierarchy: DepartmentHierarchy.member,
          organizationId: organizationId,
        ),
      ];

      // Add default roles with predefined IDs
      for (var role in defaultRoles) {
        await rolesCollection.doc(role.id).set(role.toJson());
      }

      _logger.i('Seeded initial roles for organization: $organizationId');
    } catch (e, stackTrace) {
      _logger.e('Error seeding initial roles', error: e, stackTrace: stackTrace);
      throw RoleRepositoryException(
        'Failed to seed initial roles: ${e.toString()}',
        originalException: e,
      );
    }
  }
}
