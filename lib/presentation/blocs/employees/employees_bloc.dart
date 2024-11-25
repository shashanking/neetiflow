import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:neetiflow/domain/entities/employee.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../domain/repositories/employees_repository.dart';

// Events
abstract class EmployeesEvent extends Equatable {
  const EmployeesEvent();

  @override
  List<Object?> get props => [];
}

class LoadEmployees extends EmployeesEvent {
  final String companyId;
  const LoadEmployees(this.companyId);

  @override
  List<Object?> get props => [companyId];
}

class AddEmployee extends EmployeesEvent {
  final Employee employee;
  final String password;
  const AddEmployee(this.employee, this.password);

  @override
  List<Object?> get props => [employee, password];
}

class UpdateEmployee extends EmployeesEvent {
  final Employee employee;
  const UpdateEmployee(this.employee);

  @override
  List<Object?> get props => [employee];
}

class DeleteEmployee extends EmployeesEvent {
  final String companyId;
  final String employeeId;
  const DeleteEmployee(this.companyId, this.employeeId);

  @override
  List<Object?> get props => [companyId, employeeId];
}

class CheckEmailAvailability extends EmployeesEvent {
  final String email;
  const CheckEmailAvailability(this.email);

  @override
  List<Object?> get props => [email];
}

class ResetEmployeesState extends EmployeesEvent {}

// States
abstract class EmployeesState extends Equatable {
  const EmployeesState();

  @override
  List<Object?> get props => [];
}

class EmployeesInitial extends EmployeesState {}

class EmployeesLoading extends EmployeesState {
  final List<Employee> employees;
  
  const EmployeesLoading({this.employees = const []});
  
  @override
  List<Object?> get props => [employees];
}

class EmployeesLoaded extends EmployeesState {
  final List<Employee> employees;
  const EmployeesLoaded(this.employees);

  @override
  List<Object?> get props => [employees];
}

class EmployeeOperationSuccess extends EmployeesState {
  final String message;
  const EmployeeOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class EmployeesError extends EmployeesState {
  final String message;
  const EmployeesError(this.message);

  @override
  List<Object?> get props => [message];
}

class EmailAvailabilityChecked extends EmployeesState {
  final String email;
  final bool isAvailable;
  final List<Employee> employees;

  const EmailAvailabilityChecked(this.email, this.isAvailable, {this.employees = const []});

  @override
  List<Object?> get props => [email, isAvailable, employees];
}

class EmployeesEmailAvailable extends EmployeesState {
  final List<Employee> employees;
  
  const EmployeesEmailAvailable({this.employees = const []});
  
  @override
  List<Object?> get props => [employees];
}

class EmployeesEmailError extends EmployeesState {
  final String message;
  final List<Employee> employees;

  const EmployeesEmailError(this.message, {this.employees = const []});

  @override
  List<Object?> get props => [message, employees];
}

// Bloc
class EmployeesBloc extends Bloc<EmployeesEvent, EmployeesState> {
  final EmployeesRepository _employeesRepository;
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  StreamSubscription<QuerySnapshot>? _employeesSubscription;

  EmployeesBloc({
    required EmployeesRepository employeesRepository,
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _employeesRepository = employeesRepository,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance,
        super(EmployeesInitial()) {
    on<LoadEmployees>(_onLoadEmployees);
    on<AddEmployee>(_onAddEmployee);
    on<UpdateEmployee>(_onUpdateEmployee);
    on<DeleteEmployee>(_onDeleteEmployee);
    on<CheckEmailAvailability>(_onCheckEmailAvailability);
    on<ResetEmployeesState>(_onResetState);
  }

  Future<void> _onLoadEmployees(
    LoadEmployees event,
    Emitter<EmployeesState> emit,
  ) async {
    final currentEmployees = state is EmployeesLoaded 
        ? (state as EmployeesLoaded).employees 
        : const <Employee>[];
    emit(EmployeesLoading(employees: currentEmployees));
    try {
      await _employeesSubscription?.cancel();
      
      // Get initial data
      final snapshot = await _firestore
          .collection('organizations')
          .doc(event.companyId)
          .collection('employees')
          .get();
      
      final employees = snapshot.docs
          .map((doc) => Employee.fromJson({
                ...doc.data(),
                'id': doc.id,
                'companyId': event.companyId,
              }))
          .toList();
      emit(EmployeesLoaded(employees));

      // Setup stream for updates
      _employeesSubscription = _firestore
          .collection('organizations')
          .doc(event.companyId)
          .collection('employees')
          .snapshots()
          .listen(
        (snapshot) {
          if (!emit.isDone) {
            final employees = snapshot.docs
                .map((doc) => Employee.fromJson({
                      ...doc.data(),
                      'id': doc.id,
                      'companyId': event.companyId,
                    }))
                .toList();
            emit(EmployeesLoaded(employees));
          }
        },
        onError: (error) {
          if (!emit.isDone) {
            emit(EmployeesError(error.toString()));
          }
        },
      );
    } catch (e) {
      if (!emit.isDone) {
        emit(EmployeesError(e.toString()));
      }
    }
  }

  Future<void> _onAddEmployee(
    AddEmployee event,
    Emitter<EmployeesState> emit,
  ) async {
    try {
      // Create Firebase Auth user
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: event.employee.email,
        password: event.password,
      );

      final employee = event.employee.copyWith(
        uid: userCredential.user?.uid,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Create employee document in organizations/companyId/employees collection
      final employeeRef = await _firestore
          .collection('organizations')
          .doc(employee.companyId)
          .collection('employees')
          .add(employee.toJson());

      // Create user mapping for authentication
      await _firestore
          .collection('user_mappings')
          .doc(employee.email)
          .set({
        'companyId': employee.companyId,
        'employeeId': employeeRef.id,
        'email': employee.email,
        'role': employee.role.toString(),
      });
      
      // Emit success state
      emit(EmployeeOperationSuccess('Employee ${employee.name} added successfully'));
      
      // Reload employees list
      final snapshot = await _firestore
          .collection('organizations')
          .doc(employee.companyId)
          .collection('employees')
          .get();
      
      final employees = snapshot.docs
          .map((doc) => Employee.fromJson({
                ...doc.data(),
                'id': doc.id,
                'companyId': employee.companyId,
                'companyName': employee.companyName,
              }))
          .toList();
      
      emit(EmployeesLoaded(employees));
    } catch (e) {
      String errorMessage = 'Failed to add employee';
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'email-already-in-use':
            errorMessage = 'An account already exists with this email';
            break;
          case 'invalid-email':
            errorMessage = 'Invalid email address';
            break;
          case 'weak-password':
            errorMessage = 'Password is too weak';
            break;
          default:
            errorMessage = e.message ?? 'Authentication failed';
        }
      }
      emit(EmployeesError(errorMessage));
    }
  }

  Future<void> _onUpdateEmployee(
    UpdateEmployee event,
    Emitter<EmployeesState> emit,
  ) async {
    try {
      await _firestore
          .collection('organizations')
          .doc(event.employee.companyId)
          .collection('employees')
          .doc(event.employee.id)
          .update(event.employee.toJson());
      
      emit(EmployeeOperationSuccess('Employee ${event.employee.name} updated successfully'));
      
      // Reload employees list
      final snapshot = await _firestore
          .collection('organizations')
          .doc(event.employee.companyId)
          .collection('employees')
          .get();
      
      final employees = snapshot.docs
          .map((doc) => Employee.fromJson({
                ...doc.data(),
                'id': doc.id,
                'companyId': event.employee.companyId,
                'companyName': event.employee.companyName,
              }))
          .toList();
      
      emit(EmployeesLoaded(employees));
    } catch (e) {
      emit(EmployeesError('Failed to update employee: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteEmployee(
    DeleteEmployee event,
    Emitter<EmployeesState> emit,
  ) async {
    try {
      // Get employee data first
      final employeeDoc = await _firestore
          .collection('employees')
          .doc(event.employeeId)
          .get();

      if (employeeDoc.exists) {
        final employeeData = employeeDoc.data();
        if (employeeData != null) {
          // Delete user mapping
          await _firestore
              .collection('user_mappings')
              .doc(employeeData['email'] as String)
              .delete();

          // Delete employee document
          await employeeDoc.reference.delete();
        }
      }

      emit(const EmployeeOperationSuccess('Employee deleted successfully'));
    } catch (e) {
      emit(EmployeesError('Failed to delete employee: ${e.toString()}'));
    }
  }

  FutureOr<void> _onCheckEmailAvailability(
    CheckEmailAvailability event,
    Emitter<EmployeesState> emit,
  ) async {
    final currentEmployees = state is EmployeesLoaded 
        ? (state as EmployeesLoaded).employees 
        : const <Employee>[];

    if (event.email.isEmpty) {
      emit(EmployeesEmailAvailable(employees: currentEmployees));
      return;
    }

    // First validate email format
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(event.email)) {
      emit(EmployeesEmailError('Please enter a valid email address', employees: currentEmployees));
      return;
    }

    emit(EmployeesLoading(employees: currentEmployees));
    try {
      print('Checking email availability for: ${event.email}');
      final isAvailable = await _employeesRepository.isEmailAvailable(event.email);
      print('Email availability result: $isAvailable');

      emit(EmailAvailabilityChecked(event.email, isAvailable, employees: currentEmployees));
    } catch (e) {
      print('Error checking email availability: $e');
      emit(EmployeesEmailError('Error checking email availability', employees: currentEmployees));
    }
  }

  void _onResetState(
    ResetEmployeesState event,
    Emitter<EmployeesState> emit,
  ) {
    if (state is EmployeesLoaded) {
      final currentEmployees = (state as EmployeesLoaded).employees;
      emit(EmployeesLoaded(currentEmployees));
    }
  }

  @override
  Future<void> close() {
    _employeesSubscription?.cancel();
    return super.close();
  }
}
