import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:neetiflow/domain/entities/employee.dart';
import 'package:neetiflow/domain/repositories/employees_repository.dart';
import 'package:logger/logger.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/employee_timeline_event.dart';

@LazySingleton(as: EmployeesRepository)
@Environment(Environment.prod)
class FirebaseEmployeesRepository implements EmployeesRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 50,
      colors: true,
      printEmojis: true,
    ),
  );

  FirebaseEmployeesRepository(
    @Named('firestore') this._firestore,
    @Named('firebaseAuth') this._auth,
  );

  @override
  Future<List<Employee>> getEmployees(String companyId) async {
    try {
      _logger.i('Getting employees for company: $companyId');
      final snapshot = await _firestore
          .collection('organizations')
          .doc(companyId)
          .collection('employees')
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Employee.fromJson(data);
      }).toList();
    } catch (e, stackTrace) {
      _logger.e('Error getting employees', error: e, stackTrace: stackTrace);
      throw Exception('Failed to get employees: $e');
    }
  }

  @override
  Stream<List<Employee>> employeesStream(String companyId) {
    return _firestore
        .collection('organizations')
        .doc(companyId)
        .collection('employees')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Employee.fromJson(data);
      }).toList();
    });
  }

  @override
  Stream<Employee> employeeStream(String companyId, String employeeId) {
    return _firestore
        .collection('organizations')
        .doc(companyId)
        .collection('employees')
        .doc(employeeId)
        .snapshots()
        .map((doc) {
      if (!doc.exists) {
        throw Exception('Employee not found');
      }
      final data = doc.data()!;
      data['id'] = doc.id;
      return Employee.fromJson(data);
    });
  }

  @override
  Future<Employee> addEmployee(Employee employee, String password) async {
    try {
      if (employee.companyId == null) {
        throw Exception('Company ID is required');
      }

      _logger.i('Creating new employee account');
      // Create Firebase Auth user
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: employee.email,
        password: password,
      );

      if (userCredential.user == null) {
        throw Exception('Failed to create user account');
      }

      final employeeId = userCredential.user!.uid;
      _logger.i('Created auth account for employee: $employeeId');

      // Save employee to Firestore
      await _firestore
          .collection('organizations')
          .doc(employee.companyId)
          .collection('employees')
          .doc(employeeId)
          .set({
        ...employee.toJson(),
        'id': employeeId,
        'authUid': employeeId,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Create user mapping
      await _firestore.collection('user_mappings').doc(employee.email).set({
        'companyId': employee.companyId,
        'employeeId': employeeId,
        'role': employee.role.toString().split('.').last,
      });

      // Update organization employee count
      await _updateOrganizationEmployeeCount(employee.companyId!, 1);

      // Create employee timeline event for the new employee
      final now = DateTime.now();
      final employeeTimelineEvent = EmployeeTimelineEvent(
        id: const Uuid().v4(),
        employeeId: employeeId,
        title: 'Account Created',
        description: 'Employee account was created',
        timestamp: now,
        category: 'account_creation',
        metadata: {
          'role': employee.role.toString().split('.').last,
          if (employee.departmentId != null) 'departmentId': employee.departmentId,
          'joiningDate': employee.joiningDate?.toIso8601String(),
          'createdAt': now.toIso8601String(),
        },
      );

      // Add the timeline event
      await _firestore
          .collection('organizations')
          .doc(employee.companyId)
          .collection('employees')
          .doc(employeeId)
          .collection('timeline')
          .doc(employeeTimelineEvent.id)
          .set(employeeTimelineEvent.toJson());

      _logger.i('Employee created successfully');
      return employee.copyWith(id: employeeId);
    } catch (e, stackTrace) {
      _logger.e('Error creating employee', error: e, stackTrace: stackTrace);
      throw Exception('Failed to create employee: $e');
    }
  }

  @override
  Future<void> updateEmployee(Employee employee) async {
    try {
      _logger.i('Updating employee: ${employee.id}');
      await _firestore
          .collection('organizations')
          .doc(employee.companyId)
          .collection('employees')
          .doc(employee.id)
          .update({
        ...employee.toJson(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Update user mapping if email changed
      final userMappingDoc = await _firestore
          .collection('user_mappings')
          .where('employeeId', isEqualTo: employee.id)
          .get();

      if (userMappingDoc.docs.isNotEmpty) {
        final oldEmail = userMappingDoc.docs.first.id;
        if (oldEmail != employee.email) {
          // Delete old mapping
          await _firestore.collection('user_mappings').doc(oldEmail).delete();
          // Create new mapping
          await _firestore.collection('user_mappings').doc(employee.email).set({
            'companyId': employee.companyId,
            'employeeId': employee.id,
            'role': employee.role.toString().split('.').last,
          });
        }
      }

      _logger.i('Employee updated successfully');
    } catch (e, stackTrace) {
      _logger.e('Error updating employee', error: e, stackTrace: stackTrace);
      throw Exception('Failed to update employee: $e');
    }
  }

  @override
  Future<void> updateEmployeeStatus(String employeeId, String companyId, bool isActive) async {
    try {
      // Update Firestore status
      await _firestore
          .collection('organizations')
          .doc(companyId)
          .collection('employees')
          .doc(employeeId)
          .update({'isActive': isActive});

      _logger.i('Employee status updated in Firestore successfully');
    } catch (e) {
      _logger.e('Failed to update employee status', error: e);
      throw Exception('Failed to update employee status: $e');
    }
  }

  @override
  Future<void> deleteEmployee(String companyId, String employeeId) async {
    try {
      _logger.i('Deleting employee: $employeeId');
      // Get employee data first
      final employeeDoc = await _firestore
          .collection('organizations')
          .doc(companyId)
          .collection('employees')
          .doc(employeeId)
          .get();

      if (!employeeDoc.exists) {
        throw Exception('Employee not found');
      }

      final employeeData = employeeDoc.data()!;
      final email = employeeData['email'] as String;

      // Delete employee document
      await _firestore
          .collection('organizations')
          .doc(companyId)
          .collection('employees')
          .doc(employeeId)
          .delete();

      // Delete user mapping
      await _firestore.collection('user_mappings').doc(email).delete();

      // Update organization employee count
      await _updateOrganizationEmployeeCount(companyId, -1);

      if (_auth != null) {
        // Delete Firebase Auth user
        final methods = await _auth.fetchSignInMethodsForEmail(email);
        if (methods.isNotEmpty) {
          try {
            // Sign in with custom token or admin SDK to get user
            final user = (await _auth.signInWithEmailAndPassword(
              email: email,
              // Use a temporary password or implement proper admin SDK
              password: 'temporary_password',
            )).user;
            
            if (user != null) {
              await user.delete();
            }
          } catch (e) {
            _logger.w('Could not delete auth user: $e');
          }
        }
      }

      _logger.i('Employee deleted successfully');
    } catch (e, stackTrace) {
      _logger.e('Error deleting employee', error: e, stackTrace: stackTrace);
      throw Exception('Failed to delete employee: $e');
    }
  }

  @override
  Future<Employee?> getEmployeeByUid(String uid) async {
    try {
      _logger.i('Getting employee by UID: $uid');
      
      // First check user_mappings collection using the current user's email
      final currentUser = _auth.currentUser;
      if (currentUser == null || currentUser.email == null) {
        _logger.e('No authenticated user or email found');
        return null;
      }

      final userMapping = await _firestore
          .collection('user_mappings')
          .doc(currentUser.email)
          .get();

      if (!userMapping.exists) {
        _logger.e('No user mapping found for email: ${currentUser.email}');
        return null;
      }

      final data = userMapping.data()!;
      final companyId = data['companyId'] as String;
      final employeeId = data['employeeId'] as String;

      // Get employee data
      final employeeDoc = await _firestore
          .collection('organizations')
          .doc(companyId)
          .collection('employees')
          .doc(employeeId)
          .get();

      if (!employeeDoc.exists) {
        _logger.e('No employee document found for ID: $employeeId');
        return null;
      }

      final employeeData = employeeDoc.data()!;
      employeeData['id'] = employeeDoc.id;
      _logger.i('Successfully retrieved employee data');
      return Employee.fromJson(employeeData);
    } catch (e, stackTrace) {
      _logger.e('Error getting employee by UID', error: e, stackTrace: stackTrace);
      return null;
    }
  }

  @override
  Future<Employee?> getEmployeeByEmail(String email) async {
    try {
      _logger.i('Getting employee by email: $email');
      // First check user_mappings collection
      final userMapping = await _firestore
          .collection('user_mappings')
          .doc(email)
          .get();

      if (!userMapping.exists) {
        _logger.e('No user mapping found for email: $email');
        return null;
      }

      final data = userMapping.data()!;
      final companyId = data['companyId'] as String;
      final employeeId = data['employeeId'] as String;

      // Get employee data
      final employeeDoc = await _firestore
          .collection('organizations')
          .doc(companyId)
          .collection('employees')
          .doc(employeeId)
          .get();

      if (!employeeDoc.exists) {
        _logger.e('No employee document found for ID: $employeeId');
        return null;
      }

      final employeeData = employeeDoc.data()!;
      employeeData['id'] = employeeDoc.id;
      _logger.i('Successfully retrieved employee data');
      return Employee.fromJson(employeeData);
    } catch (e, stackTrace) {
      _logger.e('Error getting employee by email', error: e, stackTrace: stackTrace);
      return null;
    }
  }

  @override
  Future<List<Employee>> searchEmployees(String query, {int limit = 10}) async {
    try {
      _logger.i('Searching employees with query: $query');
      
      // Create a list of keywords from the query
      final keywords = query.toLowerCase().split(' ');
      
      // Search by first name, last name, and email
      final querySnapshot = await _firestore
          .collection('organizations')
          .doc(_auth.currentUser?.uid)
          .collection('employees')
          .where('searchTerms', arrayContainsAny: keywords)
          .limit(limit)
          .get();

      final employees = querySnapshot.docs
          .map((doc) => Employee.fromJson(doc.data()))
          .toList();

      _logger.i('Found ${employees.length} employees matching query: $query');
      return employees;
    } catch (e, stackTrace) {
      _logger.e('Failed to search employees', error: e, stackTrace: stackTrace);
      throw Exception('Failed to search employees: $e');
    }
  }

  @override
  Future<List<Employee>> getEmployeesByIds(List<String> employeeIds) async {
    try {
      _logger.i('Fetching employees by IDs: $employeeIds');
      
      if (employeeIds.isEmpty) {
        return [];
      }

      final querySnapshot = await _firestore
          .collection('organizations')
          .doc(_auth.currentUser?.uid)
          .collection('employees')
          .where(FieldPath.documentId, whereIn: employeeIds)
          .get();

      final employees = querySnapshot.docs
          .map((doc) => Employee.fromJson(doc.data()))
          .toList();

      _logger.i('Found ${employees.length} employees by IDs');
      return employees;
    } catch (e, stackTrace) {
      _logger.e('Failed to get employees by IDs', error: e, stackTrace: stackTrace);
      throw Exception('Failed to get employees by IDs: $e');
    }
  }

  Future<void> _updateOrganizationEmployeeCount(String companyId, int change) async {
    try {
      await _firestore.runTransaction((transaction) async {
        final orgDoc = await transaction.get(
          _firestore.collection('organizations').doc(companyId)
        );
        
        if (!orgDoc.exists) {
          throw Exception('Organization not found');
        }

        final currentCount = orgDoc.data()?['employeeCount'] as int? ?? 0;
        final newCount = currentCount + change;
        
        transaction.update(
          _firestore.collection('organizations').doc(companyId),
          {'employeeCount': newCount}
        );
      });
      
      _logger.i('Updated organization employee count');
    } catch (e, stackTrace) {
      _logger.e('Error updating organization employee count', error: e, stackTrace: stackTrace);
      throw Exception('Failed to update organization employee count: $e');
    }
  }

  @override
  Future<List<Employee>> getActiveEmployees({int limit = 20}) async {
    try {
      _logger.i('Getting active employees with limit: $limit');
      
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('No authenticated user found');
      }

      final userMapping = await _firestore
          .collection('user_mappings')
          .doc(currentUser.email)
          .get();

      if (!userMapping.exists) {
        throw Exception('No organization mapping found for current user');
      }

      final companyId = userMapping.data()!['companyId'] as String;
      
      final querySnapshot = await _firestore
          .collection('organizations')
          .doc(companyId)
          .collection('employees')
          .where('isActive', isEqualTo: true)
          .limit(limit)
          .get();

      final employees = querySnapshot.docs
          .map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return Employee.fromJson(data);
          })
          .toList();

      _logger.i('Found ${employees.length} active employees');
      return employees;
    } catch (e, stackTrace) {
      _logger.e('Failed to get active employees', error: e, stackTrace: stackTrace);
      throw Exception('Failed to get active employees: $e');
    }
  }

  @override
  Future<Employee?> getEmployee(String employeeId) async {
    try {
      _logger.i('Getting employee with ID: $employeeId');
      
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('No authenticated user found');
      }

      final userMapping = await _firestore
          .collection('user_mappings')
          .doc(currentUser.email)
          .get();

      if (!userMapping.exists) {
        throw Exception('No organization mapping found for current user');
      }

      final companyId = userMapping.data()!['companyId'] as String;
      
      final employeeDoc = await _firestore
          .collection('organizations')
          .doc(companyId)
          .collection('employees')
          .doc(employeeId)
          .get();

      if (!employeeDoc.exists) {
        _logger.w('No employee found with ID: $employeeId');
        return null;
      }

      final data = employeeDoc.data()!;
      data['id'] = employeeDoc.id;
      
      _logger.i('Successfully retrieved employee');
      return Employee.fromJson(data);
    } catch (e, stackTrace) {
      _logger.e('Failed to get employee', error: e, stackTrace: stackTrace);
      throw Exception('Failed to get employee: $e');
    }
  }

  @override
  Future<bool> isEmailAvailable(String email) async {
    try {
      _logger.i('Starting email availability check for: ${email.split('@')[0]}***');
      
      // Check user_mappings collection first
      _logger.d('Checking user_mappings collection...');
      final userMappingRef = _firestore.collection('user_mappings').doc(email);
      _logger.d('User mapping reference path: ${userMappingRef.path}');
      
      final userMapping = await userMappingRef.get();
      _logger.d('User mapping exists: ${userMapping.exists}');
      
      if (userMapping.exists) {
        _logger.i('Email found in user_mappings, not available');
        return false;
      }

      // Then check Firebase Auth
      _logger.d('Checking Firebase Auth...');
      try {
        _logger.d('Fetching sign-in methods for email...');
        final methods = await _auth.fetchSignInMethodsForEmail(email);
        _logger.d('Available sign-in methods: $methods');
        
        final isAvailable = methods.isEmpty;
        _logger.i('Email availability result: $isAvailable');
        return isAvailable;
      } on FirebaseAuthException catch (e) {
        _logger.e('Firebase Auth error', error: e, stackTrace: StackTrace.current);
        _logger.d('Error code: ${e.code}');
        _logger.d('Error message: ${e.message}');
        
        if (e.code == 'invalid-email') {
          _logger.w('Invalid email format detected');
          throw Exception('Invalid email format');
        }
        rethrow;
      }
    } catch (e, stackTrace) {
      _logger.e('Error in isEmailAvailable', error: e, stackTrace: stackTrace);
      if (e is FirebaseAuthException) {
        throw Exception('Authentication error: ${e.message}');
      }
      throw Exception('Failed to check email availability: ${e.toString()}');
    }
  }

  @override
  Future<List<Employee>> getEmployeesByDepartment(String departmentId) async {
    try {
      _logger.i('Getting employees for department: $departmentId');
      
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('No authenticated user found');
      }

      final userMapping = await _firestore
          .collection('user_mappings')
          .doc(currentUser.email)
          .get();

      if (!userMapping.exists) {
        throw Exception('No organization mapping found for current user');
      }

      final companyId = userMapping.data()!['companyId'] as String;
      
      final querySnapshot = await _firestore
          .collection('organizations')
          .doc(companyId)
          .collection('employees')
          .where('departmentId', isEqualTo: departmentId)
          .get();

      final employees = querySnapshot.docs
          .map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return Employee.fromJson(data);
          })
          .toList();

      _logger.i('Found ${employees.length} employees in department: $departmentId');
      return employees;
    } catch (e, stackTrace) {
      _logger.e('Failed to get employees by department', error: e, stackTrace: stackTrace);
      throw Exception('Failed to get employees by department: $e');
    }
  }
}
