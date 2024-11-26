import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:neetiflow/domain/entities/employee.dart';
import 'package:neetiflow/domain/repositories/employees_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

class UpdateEmployeesList extends EmployeesEvent {
  final List<Employee> employees;
  const UpdateEmployeesList(this.employees);

  @override
  List<Object?> get props => [employees];
}

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
  final List<Employee> employees;

  const EmployeesError(this.message, this.employees);

  @override
  List<Object?> get props => [message, employees];
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
  StreamSubscription<List<Employee>>? _employeesSubscription;

  EmployeesBloc({
    required EmployeesRepository employeesRepository,
  })  : _employeesRepository = employeesRepository,
        super(EmployeesInitial()) {
    on<LoadEmployees>(_onLoadEmployees);
    on<AddEmployee>(_onAddEmployee);
    on<UpdateEmployee>(_onUpdateEmployee);
    on<DeleteEmployee>(_onDeleteEmployee);
    on<CheckEmailAvailability>(_onCheckEmailAvailability);
    on<ResetEmployeesState>(_onResetState);
    on<UpdateEmployeesList>(_onUpdateEmployeesList);
  }

  @override
  Future<void> close() {
    _employeesSubscription?.cancel();
    return super.close();
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
      // Cancel any existing subscription
      await _employeesSubscription?.cancel();
      
      // Subscribe to real-time updates
      _employeesSubscription = _employeesRepository
          .employeesStream(event.companyId)
          .listen(
            (employees) => add(UpdateEmployeesList(employees)),
          );
    } catch (e) {
      emit(EmployeesError(
        'Failed to load employees: ${e.toString()}',
        currentEmployees,
      ));
    }
  }

  Future<void> _onUpdateEmployeesList(
    UpdateEmployeesList event,
    Emitter<EmployeesState> emit,
  ) async {
    final sortedEmployees = List<Employee>.from(event.employees)
      ..sort((a, b) => '${a.firstName} ${a.lastName}'.compareTo('${b.firstName} ${b.lastName}'));
    emit(EmployeesLoaded(sortedEmployees));
  }

  Future<void> _onAddEmployee(
    AddEmployee event,
    Emitter<EmployeesState> emit,
  ) async {
    try {
      if (event.employee.companyId == null) {
        throw Exception('Company ID is required');
      }
      
      final employee = await _employeesRepository.addEmployee(
        event.employee,
        event.password,
      );

      emit(EmployeeOperationSuccess('Employee ${employee.firstName} ${employee.lastName} added successfully'));
      final employees = await _employeesRepository.getEmployees(event.employee.companyId!);
      final sortedEmployees = List<Employee>.from(employees)
        ..sort((a, b) => '${a.firstName} ${a.lastName}'.compareTo('${b.firstName} ${b.lastName}'));
      emit(EmployeesLoaded(sortedEmployees));
    } catch (e) {
      String errorMessage = 'Failed to add employee';
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'email-already-in-use':
            errorMessage = 'Email is already registered';
            break;
          case 'invalid-email':
            errorMessage = 'Invalid email format';
            break;
          case 'weak-password':
            errorMessage = 'Password is too weak';
            break;
          default:
            errorMessage = 'Authentication error: ${e.message}';
        }
      }
      emit(EmployeesError(errorMessage, const []));
    }
  }

  Future<void> _onUpdateEmployee(
    UpdateEmployee event,
    Emitter<EmployeesState> emit,
  ) async {
    try {
      if (event.employee.companyId == null) {
        throw Exception('Company ID is required');
      }

      await _employeesRepository.updateEmployee(event.employee);
      emit(EmployeeOperationSuccess('Employee ${event.employee.firstName} ${event.employee.lastName} updated successfully'));
      final employees = await _employeesRepository.getEmployees(event.employee.companyId!);
      final sortedEmployees = List<Employee>.from(employees)
        ..sort((a, b) => '${a.firstName} ${a.lastName}'.compareTo('${b.firstName} ${b.lastName}'));
      emit(EmployeesLoaded(sortedEmployees));
    } catch (e) {
      emit(EmployeesError('Failed to update employee: ${e.toString()}', const []));
    }
  }

  Future<void> _onDeleteEmployee(
    DeleteEmployee event,
    Emitter<EmployeesState> emit,
  ) async {
    try {
      await _employeesRepository.deleteEmployee(event.companyId, event.employeeId);
      emit(const EmployeeOperationSuccess('Employee deleted successfully'));
    } catch (e) {
      emit(EmployeesError(
        'Failed to delete employee: ${e.toString()}',
        const [],
      ));
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
}
