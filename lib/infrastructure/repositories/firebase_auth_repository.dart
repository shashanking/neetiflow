import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:neetiflow/domain/entities/employee.dart';
import 'package:neetiflow/domain/entities/organization.dart';
import 'package:neetiflow/domain/repositories/auth_repository.dart';
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
      _logger.i('Attempting sign out');
      await _firebaseAuth.signOut();
      _logger.i('Sign out successful');
    } catch (e, stackTrace) {
      _logger.e('Error signing out', error: e, stackTrace: stackTrace);
      throw Exception('Failed to sign out: $e');
    }
  }

  @override
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

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
        'role': 'admin',
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
      
      // Sign in with Firebase Auth first
      final userCredential = await signInWithEmailAndPassword(
        email,
        password,
      );

      if (userCredential == null) {
        _logger.e('Authentication failed - null user credential');
        throw FirebaseAuthException(
          code: 'auth/invalid-credential',
          message: 'Invalid login credentials',
        );
      }

      // Get user mapping
      _logger.i('Getting user mapping for email: ${email.split('@')[0]}***');
      final userMapping = await _firestore
          .collection('user_mappings')
          .doc(email)
          .get();

      if (!userMapping.exists) {
        _logger.e('User mapping not found for email: ${email.split('@')[0]}***');
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'No user mapping found for this email. Please contact your administrator.',
        );
      }

      final data = userMapping.data()!;
      final companyId = data['companyId'] as String;
      final employeeId = data['employeeId'] as String;

      // Get employee document
      _logger.i('Fetching employee record: $employeeId');
      final employeeDoc = await _firestore
          .collection('organizations')
          .doc(companyId)
          .collection('employees')
          .doc(employeeId)
          .get();

      if (!employeeDoc.exists) {
        _logger.e('Employee record not found for ID: $employeeId');
        throw FirebaseAuthException(
          code: 'employee-not-found',
          message: 'Employee record not found. Please contact your administrator.',
        );
      }

      final employee = Employee.fromJson(employeeDoc.data()!);

      // Check if employee is active
      if (!employee.isActive) {
        _logger.e('Employee account is inactive: $employeeId');
        throw FirebaseAuthException(
          code: 'account-disabled',
          message: 'Your account is currently inactive. Please contact your administrator.',
        );
      }

      _logger.i('Login successful for employee: ${employee.name}');
      return {
        'user': userCredential,
        'employee': employee,
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
