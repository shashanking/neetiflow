import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

// Events
abstract class PasswordResetEvent extends Equatable {
  const PasswordResetEvent();

  @override
  List<Object?> get props => [];
}

class SendPasswordResetEmail extends PasswordResetEvent {
  final String email;

  const SendPasswordResetEmail({required this.email});

  @override
  List<Object?> get props => [email];
}

// States
abstract class PasswordResetState extends Equatable {
  const PasswordResetState();

  @override
  List<Object?> get props => [];
}

class PasswordResetInitial extends PasswordResetState {}

class PasswordResetLoading extends PasswordResetState {}

class PasswordResetEmailSent extends PasswordResetState {
  final String email;
  final String organizationName;

  const PasswordResetEmailSent({
    required this.email,
    required this.organizationName,
  });

  @override
  List<Object?> get props => [email, organizationName];
}

class PasswordResetError extends PasswordResetState {
  final String message;

  const PasswordResetError({required this.message});

  @override
  List<Object?> get props => [message];
}

// BLoC
class PasswordResetBloc extends Bloc<PasswordResetEvent, PasswordResetState> {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  PasswordResetBloc({FirebaseAuth? auth, FirebaseFirestore? firestore})
      : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        super(PasswordResetInitial()) {
    on<SendPasswordResetEmail>(_onSendPasswordResetEmail);
  }

  Future<void> _onSendPasswordResetEmail(
    SendPasswordResetEmail event,
    Emitter<PasswordResetState> emit,
  ) async {
    try {
      emit(PasswordResetLoading());

      debugPrint('Attempting to send password reset email to: ${event.email}');

      // Get organization info from user mapping first
      final userMapping = await _firestore
          .collection('user_mappings')
          .doc(event.email)
          .get();

      debugPrint('User mapping exists: ${userMapping.exists}');

      if (!userMapping.exists) {
        debugPrint('No user mapping found for email: ${event.email}');
        emit(const PasswordResetError(
          message: 'No account found with this email address.',
        ));
        return;
      }

      final companyId = userMapping.data()?['companyId'] as String?;
      debugPrint('Company ID: $companyId');

      if (companyId == null) {
        debugPrint('No company ID found in user mapping');
        emit(const PasswordResetError(
          message: 'Unable to find organization information.',
        ));
        return;
      }

      // Get organization details
      final orgDoc = await _firestore
          .collection('organizations')
          .doc(companyId)
          .get();

      debugPrint('Organization exists: ${orgDoc.exists}');

      if (!orgDoc.exists) {
        debugPrint('Organization document not found');
        emit(const PasswordResetError(
          message: 'Organization not found.',
        ));
        return;
      }

      final organizationName = orgDoc.data()?['name'] as String? ?? 'Your Organization';
      debugPrint('Organization name: $organizationName');
      
      try {
        // Send password reset email
        debugPrint('Sending password reset email...');
        await _auth.sendPasswordResetEmail(
          email: event.email,
        );
        
        debugPrint('Password reset email sent successfully');
        
        emit(PasswordResetEmailSent(
          email: event.email,
          organizationName: organizationName,
        ));
      } on FirebaseAuthException catch (e) {
        debugPrint('Firebase Auth Error while sending reset email: ${e.code} - ${e.message}');
        
        // Special handling for user-not-found
        if (e.code == 'user-not-found') {
          debugPrint('User exists in Firestore but not in Firebase Auth. This should not happen.');
          emit(const PasswordResetError(
            message: 'There was an error with your account. Please contact support.',
          ));
          return;
        }
        
        rethrow;
      }
      
    } on FirebaseAuthException catch (e) {
      debugPrint('Firebase Auth Exception: ${e.code} - ${e.message}');
      String errorMessage;
      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        case 'user-not-found':
          errorMessage = 'No account found with this email address.';
          break;
        case 'too-many-requests':
          errorMessage = 'Too many attempts. Please try again later.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Password reset is not enabled for this project.';
          break;
        default:
          errorMessage = e.message ?? 'An error occurred. Please try again later.';
      }
      emit(PasswordResetError(message: errorMessage));
    } catch (e, stackTrace) {
      debugPrint('Unexpected error: $e');
      debugPrint('Stack trace: $stackTrace');
      emit(PasswordResetError(
        message: 'An unexpected error occurred: ${e.toString()}',
      ));
    }
  }
}
