import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:neetiflow/domain/entities/employee.dart';
import 'package:neetiflow/domain/entities/organization.dart';
import 'package:neetiflow/domain/repositories/auth_repository.dart';
import 'package:uuid/uuid.dart';

class FirebaseAuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final _uuid = const Uuid();

  FirebaseAuthRepositoryImpl({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<User?> getCurrentUser() async {
    return _firebaseAuth.currentUser;
  }

  @override
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }

  @override
  Future<User?> signUpWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      throw Exception('Failed to sign up: $e');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
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
      // Get employee document
      final employeeDoc = await _firestore
          .collection('organizations')
          .doc(companyId)
          .collection('employees')
          .doc(employeeId)
          .get();

      if (!employeeDoc.exists) {
        throw Exception('Employee not found');
      }

      final employee = Employee.fromJson(employeeDoc.data()!);
      
      // Sign in with Firebase Auth
      final userCredential = await signInWithEmailAndPassword(
        employee.email,
        password,
      );

      return {
        'user': userCredential,
        'employee': employee,
      };
    } catch (e) {
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
      // Create user with Firebase Auth
      final userCredential = await signUpWithEmailAndPassword(
        admin.email,
        password,
      );

      // Generate IDs
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

      return {
        'user': userCredential,
        'organization': organization.copyWith(id: companyId),
        'employee': admin.copyWith(
          id: employeeId,
          companyId: companyId,
        ),
      };
    } catch (e) {
      throw Exception('Failed to register organization: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      // Sign in with Firebase Auth first
      final userCredential = await signInWithEmailAndPassword(
        email,
        password,
      );

      // Get user mapping
      final userMapping = await _firestore
          .collection('user_mappings')
          .doc(email)
          .get();

      if (!userMapping.exists) {
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'No user mapping found for this email. Please contact your administrator.',
        );
      }

      final mappingData = userMapping.data()!;
      final companyId = mappingData['companyId'] as String;
      final employeeId = mappingData['employeeId'] as String;

      // Get employee document
      final employeeDoc = await _firestore
          .collection('organizations')
          .doc(companyId)
          .collection('employees')
          .doc(employeeId)
          .get();

      if (!employeeDoc.exists) {
        throw FirebaseAuthException(
          code: 'employee-not-found',
          message: 'Employee record not found. Please contact your administrator.',
        );
      }

      final employee = Employee.fromJson(employeeDoc.data()!);

      return {
        'user': userCredential,
        'employee': employee,
      };
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'No user found with this email address.';
          break;
        case 'wrong-password':
          message = 'Invalid password. Please try again.';
          break;
        case 'invalid-email':
          message = 'Invalid email format.';
          break;
        case 'user-disabled':
          message = 'This account has been disabled. Please contact support.';
          break;
        case 'too-many-requests':
          message = 'Too many login attempts. Please try again later.';
          break;
        case 'employee-not-found':
          message = e.message ?? 'Employee record not found.';
          break;
        default:
          message = e.message ?? 'An error occurred during sign in.';
      }
      throw FirebaseAuthException(
        code: e.code,
        message: message,
      );
    } catch (e) {
      throw FirebaseAuthException(
        code: 'unknown',
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }
}
