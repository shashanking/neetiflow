import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:neetiflow/domain/entities/department.dart' hide DepartmentHierarchy;
import 'package:neetiflow/domain/entities/role.dart';
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
  final dynamic role;
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

class WatchDepartments extends DepartmentsEvent {
  final String organizationId;
  const WatchDepartments(this.organizationId);

  @override
  List<Object> get props => [organizationId];
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

class DepartmentOperationFailure extends DepartmentsState {
  final String message;
  final List<Department> departments;
  const DepartmentOperationFailure(this.message, this.departments);

  @override
  List<Object?> get props => [message, departments];
}

// Bloc
class DepartmentsBloc extends Bloc<DepartmentsEvent, DepartmentsState> {
  final DepartmentsRepository _departmentsRepository;
  StreamSubscription? _departmentsSubscription;

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
    on<WatchDepartments>(_onWatchDepartments);
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
      // Validate department input
      if (event.department.name.trim().isEmpty) {
        emit(DepartmentOperationFailure(
          'Department name cannot be empty', 
          state is DepartmentsLoaded ? (state as DepartmentsLoaded).departments : []
        ));
        return;
      }

      // Attempt to add the department
      final addedDepartment = await _departmentsRepository.addDepartment(event.department);

      // Update the current state by adding the new department
      final updatedDepartments = List<Department>.from(state is DepartmentsLoaded ? (state as DepartmentsLoaded).departments : [])
        ..add(addedDepartment);

      // Emit success state
      emit(DepartmentOperationSuccess(
        'Department "${addedDepartment.name}" created successfully', 
        updatedDepartments
      ));
    } catch (e) {
      // Handle any errors during department creation
      emit(DepartmentOperationFailure(
        'Failed to create department: ${e.toString()}', 
        state is DepartmentsLoaded ? (state as DepartmentsLoaded).departments : []
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

  FutureOr<void> _onUpdateEmployeeRole(
    UpdateEmployeeDepartmentRole event, 
    Emitter<DepartmentsState> emit,
  ) async {
    if (state is DepartmentsLoaded) {
      try {
        await _departmentsRepository.updateEmployeeRole(
          event.departmentId, 
          event.employeeId, 
          event.role,
        );

        final updatedDepartments = List<Department>.from(
          (state as DepartmentsLoaded).departments.map((d) {
            if (d.id == event.departmentId) {
              // Convert role to Role if it's a DepartmentHierarchy
              final roleToUpdate = event.role is DepartmentHierarchy
                  ? Role(
                      name: event.role.toString().split('.').last,
                      description: 'Department Role',
                      type: RoleType.department,
                      organizationId: d.organizationId,
                      hierarchy: event.role,
                    )
                  : event.role;

              final updatedRoles = Map<String, Role>.from(d.employeeRoles);
              updatedRoles[event.employeeId] = roleToUpdate;
              return d.copyWith(employeeRoles: updatedRoles);
            }
            return d;
          }),
        );

        emit(DepartmentsLoaded(updatedDepartments));
      } catch (e) {
        // Handle error
        emit(DepartmentOperationFailure(e.toString(), 
          (state as DepartmentsLoaded).departments
        ));
      }
    }
  }

  Future<void> _onRemoveEmployeeFromDepartment(
    RemoveEmployeeFromDepartment event,
    Emitter<DepartmentsState> emit,
  ) async {
    if (state is DepartmentsLoaded) {
      final departments = List<Department>.from(
        (state as DepartmentsLoaded).departments.map((d) {
          if (d.id == event.departmentId) {
            final updatedRoles = Map<String, Role>.from(d.employeeRoles);
            updatedRoles.remove(event.employeeId);
            return d.copyWith(employeeRoles: updatedRoles);
          }
          return d;
        }),
      );

      try {
        await _departmentsRepository.removeEmployeeFromDepartment(
          event.departmentId,
          event.employeeId,
        );

        emit(DepartmentsLoaded(departments));
      } catch (e) {
        emit(DepartmentOperationFailure(
          e.toString(), 
          (state as DepartmentsLoaded).departments
        ));
      }
    }
  }

  void _onWatchDepartments(
    WatchDepartments event, 
    Emitter<DepartmentsState> emit
  ) async {
    // Cancel any existing subscription
    await _departmentsSubscription?.cancel();

    try {
      _departmentsSubscription = _departmentsRepository
          .watchDepartments(event.organizationId)
          .listen(
        (departments) {
          add(LoadDepartments(event.organizationId));
        },
        onError: (error) {
          emit(DepartmentsError(
            error.toString(), 
            state is DepartmentsLoaded ? (state as DepartmentsLoaded).departments : []
          ));
        },
      );
    } catch (e) {
      emit(DepartmentsError(
        e.toString(), 
        state is DepartmentsLoaded ? (state as DepartmentsLoaded).departments : []
      ));
    }
  }

  @override
  Future<void> close() {
    _departmentsSubscription?.cancel();
    return super.close();
  }
}
