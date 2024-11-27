import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:neetiflow/domain/entities/department.dart';
import 'package:neetiflow/domain/repositories/departments_repository.dart';

// Events
abstract class DepartmentsEvent extends Equatable {
  const DepartmentsEvent();

  @override
  List<Object?> get props => [];
}

class LoadDepartments extends DepartmentsEvent {
  final String organizationId;
  const LoadDepartments(this.organizationId);

  @override
  List<Object?> get props => [organizationId];
}

class AddDepartment extends DepartmentsEvent {
  final Department department;
  const AddDepartment(this.department);

  @override
  List<Object?> get props => [department];
}

class UpdateDepartment extends DepartmentsEvent {
  final Department department;
  const UpdateDepartment(this.department);

  @override
  List<Object?> get props => [department];
}

class DeleteDepartment extends DepartmentsEvent {
  final String organizationId;
  final String departmentId;
  const DeleteDepartment(this.organizationId, this.departmentId);

  @override
  List<Object?> get props => [organizationId, departmentId];
}

class UpdateEmployeeDepartmentRole extends DepartmentsEvent {
  final String departmentId;
  final String employeeId;
  final DepartmentRole role;
  const UpdateEmployeeDepartmentRole(this.departmentId, this.employeeId, this.role);

  @override
  List<Object?> get props => [departmentId, employeeId, role];
}

class RemoveEmployeeFromDepartment extends DepartmentsEvent {
  final String departmentId;
  final String employeeId;
  const RemoveEmployeeFromDepartment(this.departmentId, this.employeeId);

  @override
  List<Object?> get props => [departmentId, employeeId];
}

// States
abstract class DepartmentsState extends Equatable {
  const DepartmentsState();

  @override
  List<Object?> get props => [];
}

class DepartmentsInitial extends DepartmentsState {}

class DepartmentsLoading extends DepartmentsState {
  final List<Department> departments;
  const DepartmentsLoading(this.departments);

  @override
  List<Object?> get props => [departments];
}

class DepartmentsLoaded extends DepartmentsState {
  final List<Department> departments;
  const DepartmentsLoaded(this.departments);

  @override
  List<Object?> get props => [departments];
}

class DepartmentOperationSuccess extends DepartmentsState {
  final String message;
  final List<Department> departments;
  const DepartmentOperationSuccess(this.message, this.departments);

  @override
  List<Object?> get props => [message, departments];
}

class DepartmentsError extends DepartmentsState {
  final String message;
  final List<Department> departments;
  const DepartmentsError(this.message, this.departments);

  @override
  List<Object?> get props => [message, departments];
}

// Bloc
class DepartmentsBloc extends Bloc<DepartmentsEvent, DepartmentsState> {
  final DepartmentsRepository _departmentsRepository;

  DepartmentsBloc({
    required DepartmentsRepository departmentsRepository,
  })  : _departmentsRepository = departmentsRepository,
        super(DepartmentsInitial()) {
    on<LoadDepartments>(_onLoadDepartments);
    on<AddDepartment>(_onAddDepartment);
    on<UpdateDepartment>(_onUpdateDepartment);
    on<DeleteDepartment>(_onDeleteDepartment);
    on<UpdateEmployeeDepartmentRole>(_onUpdateEmployeeRole);
    on<RemoveEmployeeFromDepartment>(_onRemoveEmployeeFromDepartment);
  }

  Future<void> _onLoadDepartments(
    LoadDepartments event,
    Emitter<DepartmentsState> emit,
  ) async {
    try {
      emit(DepartmentsLoading(
        state is DepartmentsLoaded ? (state as DepartmentsLoaded).departments : [],
      ));

      final departments = await _departmentsRepository.getDepartments(
        event.organizationId,
      );

      emit(DepartmentsLoaded(List<Department>.from(departments)));
    } catch (e) {
      emit(DepartmentsError(
        e.toString(),
        state is DepartmentsLoaded ? (state as DepartmentsLoaded).departments : [],
      ));
    }
  }

  Future<void> _onAddDepartment(
    AddDepartment event,
    Emitter<DepartmentsState> emit,
  ) async {
    try {
      emit(DepartmentsLoading(
        state is DepartmentsLoaded ? (state as DepartmentsLoaded).departments : [],
      ));

      final department = await _departmentsRepository.addDepartment(
        event.department,
      );

      final currentDepartments = state is DepartmentsLoaded
          ? (state as DepartmentsLoaded).departments
          : <Department>[];

      emit(DepartmentOperationSuccess(
        'Department created successfully',
        List<Department>.from([...currentDepartments, department]),
      ));
    } catch (e) {
      emit(DepartmentsError(
        e.toString(),
        state is DepartmentsLoaded ? (state as DepartmentsLoaded).departments : [],
      ));
    }
  }

  Future<void> _onUpdateDepartment(
    UpdateDepartment event,
    Emitter<DepartmentsState> emit,
  ) async {
    try {
      emit(DepartmentsLoading(
        state is DepartmentsLoaded ? (state as DepartmentsLoaded).departments : [],
      ));

      await _departmentsRepository.updateDepartment(event.department);

      final departments = state is DepartmentsLoaded
          ? List<Department>.from(
              (state as DepartmentsLoaded).departments.map(
                (d) => d.id == event.department.id ? event.department : d,
              ),
            )
          : <Department>[];

      emit(DepartmentOperationSuccess(
        'Department updated successfully',
        departments,
      ));
    } catch (e) {
      emit(DepartmentsError(
        e.toString(),
        state is DepartmentsLoaded ? (state as DepartmentsLoaded).departments : [],
      ));
    }
  }

  Future<void> _onDeleteDepartment(
    DeleteDepartment event,
    Emitter<DepartmentsState> emit,
  ) async {
    try {
      emit(DepartmentsLoading(
        state is DepartmentsLoaded ? (state as DepartmentsLoaded).departments : [],
      ));

      await _departmentsRepository.deleteDepartment(
        event.organizationId,
        event.departmentId,
      );

      final departments = state is DepartmentsLoaded
          ? List<Department>.from(
              (state as DepartmentsLoaded)
                  .departments
                  .where((d) => d.id != event.departmentId),
            )
          : <Department>[];

      emit(DepartmentOperationSuccess(
        'Department deleted successfully',
        departments,
      ));
    } catch (e) {
      emit(DepartmentsError(
        e.toString(),
        state is DepartmentsLoaded ? (state as DepartmentsLoaded).departments : [],
      ));
    }
  }

  Future<void> _onUpdateEmployeeRole(
    UpdateEmployeeDepartmentRole event,
    Emitter<DepartmentsState> emit,
  ) async {
    try {
      emit(DepartmentsLoading(
        state is DepartmentsLoaded ? (state as DepartmentsLoaded).departments : [],
      ));

      await _departmentsRepository.updateEmployeeRole(
        event.departmentId,
        event.employeeId,
        event.role,
      );

      final departments = state is DepartmentsLoaded
          ? List<Department>.from(
              (state as DepartmentsLoaded).departments.map((d) {
                if (d.id == event.departmentId) {
                  final updatedRoles = Map<String, DepartmentRole>.from(d.employeeRoles);
                  updatedRoles[event.employeeId] = event.role;
                  return d.copyWith(employeeRoles: updatedRoles);
                }
                return d;
              }),
            )
          : <Department>[];

      emit(DepartmentOperationSuccess(
        'Employee role updated successfully',
        departments,
      ));
    } catch (e) {
      emit(DepartmentsError(
        e.toString(),
        state is DepartmentsLoaded ? (state as DepartmentsLoaded).departments : [],
      ));
    }
  }

  Future<void> _onRemoveEmployeeFromDepartment(
    RemoveEmployeeFromDepartment event,
    Emitter<DepartmentsState> emit,
  ) async {
    try {
      emit(DepartmentsLoading(
        state is DepartmentsLoaded ? (state as DepartmentsLoaded).departments : [],
      ));

      await _departmentsRepository.removeEmployeeFromDepartment(
        event.departmentId,
        event.employeeId,
      );

      final departments = state is DepartmentsLoaded
          ? List<Department>.from(
              (state as DepartmentsLoaded).departments.map((d) {
                if (d.id == event.departmentId) {
                  final updatedRoles = Map<String, DepartmentRole>.from(d.employeeRoles);
                  updatedRoles.remove(event.employeeId);
                  return d.copyWith(employeeRoles: updatedRoles);
                }
                return d;
              }),
            )
          : <Department>[];

      emit(DepartmentOperationSuccess(
        'Employee removed from department successfully',
        departments,
      ));
    } catch (e) {
      emit(DepartmentsError(
        e.toString(),
        state is DepartmentsLoaded ? (state as DepartmentsLoaded).departments : [],
      ));
    }
  }
}
