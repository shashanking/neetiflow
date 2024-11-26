import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  const PasswordResetEmailSent({required this.email});

  @override
  List<Object?> get props => [email];
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

  PasswordResetBloc({FirebaseAuth? auth})
      : _auth = auth ?? FirebaseAuth.instance,
        super(PasswordResetInitial()) {
    on<SendPasswordResetEmail>(_onSendPasswordResetEmail);
  }

  Future<void> _onSendPasswordResetEmail(
    SendPasswordResetEmail event,
    Emitter<PasswordResetState> emit,
  ) async {
    try {
      emit(PasswordResetLoading());
      
      // Send password reset email
      await _auth.sendPasswordResetEmail(email: event.email);
      
      emit(PasswordResetEmailSent(email: event.email));
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        case 'user-not-found':
          errorMessage = 'No user found with this email address.';
          break;
        default:
          errorMessage = 'An error occurred. Please try again later.';
      }
      emit(PasswordResetError(message: errorMessage));
    } catch (e) {
      emit(const PasswordResetError(
        message: 'An unexpected error occurred. Please try again.',
      ));
    }
  }
}
