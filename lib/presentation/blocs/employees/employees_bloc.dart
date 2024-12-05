import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:neetiflow/domain/entities/employee.dart';
import 'package:neetiflow/domain/entities/role.dart';
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

class UpdateEmployeeRole extends EmployeesEvent {
  final Employee employee;
  final Role newRole;
  final String changedBy;
  final String? newDepartmentId;
  final String? newDepartmentName;
  const UpdateEmployeeRole(this.employee, this.newRole, this.changedBy, {this.newDepartmentId, this.newDepartmentName});

  @override
  List<Object?> get props => [employee, newRole, changedBy, newDepartmentId, newDepartmentName];
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
  
  const EmployeesLoading({required this.employees});
  
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

  const EmailAvailabilityChecked(
    this.email,
    this.isAvailable,
    {required this.employees}
  );

  @override
  List<Object?> get props => [email, isAvailable, employees];
}

class EmployeesEmailAvailable extends EmployeesState {
  final List<Employee> employees;
  
  const EmployeesEmailAvailable({required this.employees});
  
  @override
  List<Object?> get props => [employees];
}

class EmployeesEmailError extends EmployeesState {
  final String message;
  final List<Employee> employees;

  const EmployeesEmailError(this.message, {required this.employees});

  @override
  List<Object?> get props => [message, employees];
}

class EmployeeRoleUpdated extends EmployeesState {
  final Employee employee;
  const EmployeeRoleUpdated(this.employee);

  @override
  List<Object?> get props => [employee];
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
    on<UpdateEmployeeRole>(_onUpdateEmployeeRole);
  }

  @override
  Future<void> close() {
    _employeesSubscription?.cancel();
    return super.close();
  }

  void _onLoadEmployees(LoadEmployees event, Emitter<EmployeesState> emit) async {
    try {
      final currentState = state is EmployeesLoaded 
        ? (state as EmployeesLoaded).employees 
        : <Employee>[];

      // Emit loading state to show progress
      emit(EmployeesLoading(employees: currentState));

      // Load employees
      final employees = await _employeesRepository.getEmployees(event.companyId);
      emit(EmployeesLoaded(employees));
    } catch (e) {
      emit(const EmployeesError('Failed to load employees', []));
    }
  }

  void _onUpdateEmployeesList(
    UpdateEmployeesList event,
    Emitter<EmployeesState> emit,
  ) async {
    final sortedEmployees = List<Employee>.from(event.employees)
      ..sort((a, b) => '${a.firstName} ${a.lastName}'.compareTo('${b.firstName} ${b.lastName}'));
    emit(EmployeesLoaded(sortedEmployees));
  }

  void _onAddEmployee(
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

  void _onUpdateEmployee(UpdateEmployee event, Emitter<EmployeesState> emit) async {
    try {
      final currentState = state is EmployeesLoaded 
        ? (state as EmployeesLoaded).employees 
        : <Employee>[];

      emit(EmployeesLoading(employees: currentState));

      await _employeesRepository.updateEmployee(event.employee);
      final updatedEmployees = await _employeesRepository.getEmployees(event.employee.companyId ?? '');
      
      emit(EmployeesLoaded(updatedEmployees));
      emit(const EmployeeOperationSuccess('Employee updated successfully'));
    } catch (e) {
      emit(const EmployeesError('Failed to update employee', []));
    }
  }

  void _onDeleteEmployee(
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

  void _onCheckEmailAvailability(
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

  void _onUpdateEmployeeRole(UpdateEmployeeRole event, Emitter<EmployeesState> emit) async {
    try {
      // Get current employees list
      final currentEmployees = state is EmployeesLoaded 
        ? (state as EmployeesLoaded).employees 
        : <Employee>[];

      // Create updated employee with new role
      final updatedEmployee = event.employee.copyWith(
        role: event.newRole,
        roleHistory: [...(event.employee.roleHistory ?? []), RoleChangeRecord(
          roleId: event.newRole.id ?? '',
          changedAt: DateTime.now(),
          changedBy: event.changedBy,
          previousRoleId: event.employee.role?.id,
          departmentId: event.newDepartmentId,
          departmentName: event.newDepartmentName,
        )],
        departmentId: event.newDepartmentId,
        departmentName: event.newDepartmentName,
      );

      // Update in repository
      await _employeesRepository.updateEmployee(updatedEmployee);
      
      // Get fresh list of employees
      final updatedEmployees = await _employeesRepository.getEmployees(updatedEmployee.companyId ?? '');

      // Emit updated states
      emit(EmployeesLoaded(updatedEmployees));
      emit(EmployeeRoleUpdated(updatedEmployee));
    } catch (e) {
      emit(EmployeesError('Failed to update employee role: ${e.toString()}', const []));
    }
  }
}
