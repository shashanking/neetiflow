import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:neetiflow/domain/entities/employee.dart';
import 'package:neetiflow/domain/entities/organization.dart';
import 'package:neetiflow/domain/repositories/auth_repository.dart';
import 'package:neetiflow/infrastructure/services/secure_storage_service.dart';
import 'package:uuid/uuid.dart';

class FirebaseAuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final _uuid = const Uuid();
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 50,
      colors: true,
      printEmojis: true,
    ),
  );

  FirebaseAuthRepositoryImpl({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<User?> getCurrentUser() async {
    try {
      _logger.i('Getting current user');
      return _firebaseAuth.currentUser;
    } catch (e, stackTrace) {
      _logger.e('Error getting current user', error: e, stackTrace: stackTrace);
      throw Exception('Failed to get current user: $e');
    }
  }

  @override
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      _logger.i('Attempting login with email: ${email.split('@')[0]}***');
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _logger.i('Login successful for user: ${userCredential.user?.uid}');
      return userCredential.user;
    } on FirebaseAuthException catch (e, stackTrace) {
      _logger.e('Firebase Auth Error: ${e.code}', error: e, stackTrace: stackTrace);
      throw Exception('Failed to sign in: ${e.message}');
    } catch (e, stackTrace) {
      _logger.e('Unexpected Error during login', error: e, stackTrace: stackTrace);
      throw Exception('Failed to sign in: $e');
    }
  }

  @override
  Future<User?> signUpWithEmailAndPassword(String email, String password) async {
    try {
      _logger.i('Attempting sign up with email: ${email.split('@')[0]}***');
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _logger.i('Sign up successful for user: ${userCredential.user?.uid}');
      return userCredential.user;
    } on FirebaseAuthException catch (e, stackTrace) {
      _logger.e('Firebase Auth Error: ${e.code}', error: e, stackTrace: stackTrace);
      throw Exception('Failed to sign up: ${e.message}');
    } catch (e, stackTrace) {
      _logger.e('Unexpected Error during sign up', error: e, stackTrace: stackTrace);
      throw Exception('Failed to sign up: $e');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      _logger.i('Signing out user');
      
      // Get current user's email before signing out
      final currentUser = await getCurrentUser();
      if (currentUser?.email != null) {
        // Get user mapping to find company and employee IDs
        final userMapping = await _firestore
            .collection('user_mappings')
            .doc(currentUser!.email)
            .get();

        if (userMapping.exists) {
          final data = userMapping.data()!;
          final companyId = data['companyId'] as String;
          final employeeId = data['employeeId'] as String;

          // Update employee active status to false
          await _firestore
              .collection('organizations')
              .doc(companyId)
              .collection('employees')
              .doc(employeeId)
              .update({
            'isActive': false,
            'isOnline': false,
            'updatedAt': FieldValue.serverTimestamp(),
          });
        }
      }

      await _firebaseAuth.signOut();
      await SecureStorageService.clearCredentials();
      _logger.i('Sign out successful');
    } catch (e, stackTrace) {
      _logger.e('Error signing out', error: e, stackTrace: stackTrace);
      throw Exception('Failed to sign out: $e');
    }
  }

  @override
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  @override
  Future<Employee> getEmployeeData(String uid) async {
    try {
      _logger.i('Getting employee data for uid: $uid');
      
      // Get the current user's email
      final currentUser = await getCurrentUser();
      if (currentUser == null || currentUser.email == null) {
        throw Exception('User not authenticated or email not available');
      }
      
      // Get company ID from user_mappings
      final userMappingDoc = await _firestore
          .collection('user_mappings')
          .doc(currentUser.email)
          .get();
          
      if (!userMappingDoc.exists) {
        throw Exception('User mapping not found');
      }
      
      final mappingData = userMappingDoc.data()!;
      final companyId = mappingData['companyId'] as String;
      final employeeId = mappingData['employeeId'] as String;
      
      // Get employee data directly using company ID and employee ID
      final employeeDoc = await _firestore
          .collection('organizations')
          .doc(companyId)
          .collection('employees')
          .doc(employeeId)
          .get();

      if (!employeeDoc.exists) {
        throw Exception('Employee not found');
      }

      // Get organization data to ensure we have the company name
      final organizationDoc = await _firestore
          .collection('organizations')
          .doc(companyId)
          .get();
          
      if (!organizationDoc.exists) {
        throw Exception('Organization not found');
      }
      
      final organizationData = organizationDoc.data()!;
      final companyName = organizationData['name'] as String;

      final data = employeeDoc.data()!;
      data['id'] = employeeDoc.id;
      data['companyId'] = companyId;
      data['companyName'] = companyName;  // Set the company name from organization data

      _logger.i('Employee data retrieved successfully');
      return Employee.fromJson(data);
    } catch (e) {
      _logger.e('Error getting employee data', error: e);
      throw Exception('Failed to get employee data: $e');
    }
  }

  Future<Map<String, dynamic>> signInWithCompanyAndEmployeeId({
    required String companyId,
    required String employeeId,
    required String password,
  }) async {
    try {
      _logger.i('Attempting login with company ID: $companyId and employee ID: $employeeId');
      // Get employee document
      final employeeDoc = await _firestore
          .collection('organizations')
          .doc(companyId)
          .collection('employees')
          .doc(employeeId)
          .get();

      if (!employeeDoc.exists) {
        _logger.e('Employee not found');
        throw Exception('Employee not found');
      }

      final employee = Employee.fromJson(employeeDoc.data()!);
      
      // Sign in with Firebase Auth
      final userCredential = await signInWithEmailAndPassword(
        employee.email,
        password,
      );

      if (userCredential == null) {
        throw Exception('Authentication failed');
      }

      _logger.i('Login successful for user: ${userCredential.uid}');
      return {
        'user': userCredential,
        'employee': employee,
      };
    } catch (e, stackTrace) {
      _logger.e('Error signing in with company and employee ID', error: e, stackTrace: stackTrace);
      throw Exception('Failed to sign in: $e');
    }
  }

  @override
  Future<Organization?> getOrganization(String organizationId) async {
    try {
      _logger.i('Getting organization data for ID: $organizationId');
      final organizationDoc = await _firestore
          .collection('organizations')
          .doc(organizationId)
          .get();

      if (!organizationDoc.exists) {
        _logger.w('Organization not found');
        return null;
      }

      final data = organizationDoc.data()!;
      data['id'] = organizationDoc.id;

      _logger.i('Organization data retrieved successfully');
      return Organization.fromJson(data);
    } catch (e, stackTrace) {
      _logger.e('Error getting organization data', error: e, stackTrace: stackTrace);
      throw Exception('Failed to get organization data: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> registerOrganization({
    required Organization organization,
    required Employee admin,
    required String password,
  }) async {
    try {
      _logger.i('Attempting to register organization: ${organization.name}');
      // Create user with Firebase Auth
      final userCredential = await signUpWithEmailAndPassword(
        admin.email,
        password,
      );

      if (userCredential == null) {
        throw Exception('Failed to create user account');
      }

      final companyId = _uuid.v4();
      final employeeId = _uuid.v4();

      // Save organization to Firestore
      await _firestore.collection('organizations').doc(companyId).set({
        ...organization.toJson(),
        'id': companyId,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Save admin employee to Firestore
      await _firestore
          .collection('organizations')
          .doc(companyId)
          .collection('employees')
          .doc(employeeId)
          .set({
        ...admin.toJson(),
        'id': employeeId,
        'companyId': companyId,
        'companyName': organization.name,
        'role': 'admin',
        'isActive': true,
        'joiningDate': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Create a user-to-company mapping for easy lookup
      await _firestore
          .collection('user_mappings')
          .doc(admin.email)
          .set({
        'companyId': companyId,
        'employeeId': employeeId,
        'role': 'admin',
      });

      _logger.i('Organization registered successfully');
      return {
        'user': userCredential,
        'organization': organization.copyWith(id: companyId),
        'employee': admin.copyWith(
          id: employeeId,
          companyId: companyId,
          companyName: organization.name,  // Add the company name here
        ),
      };
    } catch (e, stackTrace) {
      _logger.e('Error registering organization', error: e, stackTrace: stackTrace);
      throw Exception('Failed to register organization: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      _logger.i('Attempting login with email: ${email.split('@')[0]}***');
      
      // Get the employee data
      final organizationsSnapshot = await _firestore
          .collection('organizations')
          .get();

      Employee? foundEmployee;

      for (var org in organizationsSnapshot.docs) {
        final employeeSnapshot = await _firestore
            .collection('organizations')
            .doc(org.id)
            .collection('employees')
            .where('email', isEqualTo: email)
            .limit(1)
            .get();

        if (employeeSnapshot.docs.isNotEmpty) {
          foundEmployee = Employee.fromJson({
            'id': employeeSnapshot.docs.first.id,
            ...employeeSnapshot.docs.first.data(),
          });
          break;
        }
      }

      if (foundEmployee == null) {
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'No employee found with this email',
        );
      }

      final employee = foundEmployee;

      // Check if employee is active (skip check for admins)
      if (!employee.isActive && employee.role != EmployeeRole.admin) {
        throw FirebaseAuthException(
          code: 'user-disabled',
          message: 'This account has been deactivated. Please contact your administrator.',
        );
      }

      // Sign in with Firebase Auth
      final userCredential = await signInWithEmailAndPassword(
        email,
        password,
      );

      // Update online status in Firestore
      await _firestore
          .collection('organizations')
          .doc(employee.companyId)
          .collection('employees')
          .doc(employee.id)
          .update({
        'isOnline': true,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Get the updated employee data
      final updatedEmployee = employee.copyWith(
        isOnline: true,
        isActive: employee.role == EmployeeRole.admin ? employee.isActive : true
      );

      _logger.i('Login successful for employee: ${updatedEmployee.firstName} ${updatedEmployee.lastName}');
      return {
        'user': userCredential,
        'employee': updatedEmployee,
      };
    } on FirebaseAuthException catch (e, stackTrace) {
      _logger.e('Firebase Auth Error: ${e.code}', error: e, stackTrace: stackTrace);
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'No user found with this email address.';
          break;
        case 'wrong-password':
          message = 'Invalid password.';
          break;
        case 'invalid-email':
          message = 'Invalid email format.';
          break;
        case 'user-disabled':
          message = 'This account has been disabled.';
          break;
        case 'too-many-requests':
          message = 'Too many login attempts. Please try again later.';
          break;
        case 'account-disabled':
          message = 'Your account is currently inactive. Please contact your administrator.';
          break;
        default:
          message = e.message ?? 'Authentication failed';
      }
      throw FirebaseAuthException(
        code: e.code,
        message: message,
      );
    } catch (e, stackTrace) {
      _logger.e('Unexpected Error during login', error: e, stackTrace: stackTrace);
      throw FirebaseAuthException(
        code: 'unknown',
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }
}
