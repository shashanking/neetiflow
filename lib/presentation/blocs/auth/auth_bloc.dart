import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:neetiflow/domain/entities/employee.dart';
import 'package:neetiflow/domain/entities/organization.dart';
import 'package:neetiflow/domain/repositories/auth_repository.dart';

// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class SignInWithEmailRequested extends AuthEvent {
  final String email;
  final String password;

  const SignInWithEmailRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class CreateOrganizationRequested extends AuthEvent {
  final Organization organization;
  final Employee admin;
  final String password;

  const CreateOrganizationRequested({
    required this.organization,
    required this.admin,
    required this.password,
  });

  @override
  List<Object?> get props => [organization, admin, password];
}

class SignOutRequested extends AuthEvent {}

// States
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final Employee employee;
  final Organization? organization;

  const Authenticated({
    required this.employee,
    this.organization,
  });

  @override
  List<Object?> get props => [employee, organization];
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthInitial()) {
    on<SignInWithEmailRequested>(_onSignInWithEmailRequested);
    on<CreateOrganizationRequested>(_onCreateOrganizationRequested);
    on<SignOutRequested>(_onSignOutRequested);
  }

  Future<void> _onSignInWithEmailRequested(
    SignInWithEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final result = await _authRepository.signInWithEmail(
        email: event.email,
        password: event.password,
      );
      
      emit(Authenticated(
        employee: result['employee'] as Employee,
      ));
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? 'Authentication failed. Please try again.'));
    } catch (e) {
      emit(const AuthError('An unexpected error occurred. Please try again.'));
    }
  }

  Future<void> _onCreateOrganizationRequested(
    CreateOrganizationRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final result = await _authRepository.registerOrganization(
        organization: event.organization,
        admin: event.admin,
        password: event.password,
      );

      emit(Authenticated(
        employee: result['employee'] as Employee,
        organization: result['organization'] as Organization,
      ));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authRepository.signOut();
      emit(AuthInitial());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
