import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
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
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 50,
      colors: true,
      printEmojis: true,
    ),
  );

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
    _logger.i('Processing sign in request');
    try {
      emit(AuthLoading());
      final result = await _authRepository.signInWithEmail(
        email: event.email,
        password: event.password,
      );
      
      _logger.i('Sign in successful');
      emit(Authenticated(
        employee: result['employee'] as Employee,
      ));
    } on FirebaseAuthException catch (e) {
      _logger.e('Sign in failed', error: e);
      emit(AuthError(e.message ?? 'Authentication failed. Please try again.'));
    } catch (e) {
      _logger.e('Sign in failed', error: e);
      emit(const AuthError('An unexpected error occurred. Please try again.'));
    }
  }

  Future<void> _onCreateOrganizationRequested(
    CreateOrganizationRequested event,
    Emitter<AuthState> emit,
  ) async {
    _logger.i('Processing create organization request');
    try {
      emit(AuthLoading());
      final result = await _authRepository.registerOrganization(
        organization: event.organization,
        admin: event.admin,
        password: event.password,
      );

      _logger.i('Create organization successful');
      emit(Authenticated(
        employee: result['employee'] as Employee,
        organization: result['organization'] as Organization,
      ));
    } catch (e) {
      _logger.e('Create organization failed', error: e);
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    _logger.i('Processing sign out request');
    try {
      emit(AuthLoading());
      await _authRepository.signOut();
      
      _logger.i('Sign out successful');
      emit(AuthInitial());
    } catch (e) {
      _logger.e('Sign out failed', error: e);
      emit(AuthError(e.toString()));
    }
  }
}
