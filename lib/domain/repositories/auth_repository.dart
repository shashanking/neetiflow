import 'package:firebase_auth/firebase_auth.dart';
import 'package:neetiflow/domain/entities/employee.dart';
import 'package:neetiflow/domain/entities/organization.dart';

abstract class AuthRepository {
  Future<User?> getCurrentUser();
  Future<User?> signInWithEmailAndPassword(String email, String password);
  Future<User?> signUpWithEmailAndPassword(String email, String password);
  Future<void> signOut();
  Stream<User?> get authStateChanges;

  // App-specific methods
  Future<Map<String, dynamic>> signInWithEmail({
    required String email,
    required String password,
  });

  Future<Map<String, dynamic>> registerOrganization({
    required Organization organization,
    required Employee admin,
    required String password,
  });
}
