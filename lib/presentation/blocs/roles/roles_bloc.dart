import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:neetiflow/domain/entities/role.dart';
import 'package:neetiflow/domain/repositories/roles_repository.dart';

// Events
abstract class RolesEvent extends Equatable {
  const RolesEvent();

  @override
  List<Object?> get props => [];
}

class LoadRoles extends RolesEvent {
  final String organizationId;
  const LoadRoles(this.organizationId);

  @override
  List<Object?> get props => [organizationId];
}

class AddRole extends RolesEvent {
  final Role role;
  const AddRole(this.role);

  @override
  List<Object?> get props => [role];
}

class UpdateRole extends RolesEvent {
  final Role role;
  const UpdateRole(this.role);

  @override
  List<Object?> get props => [role];
}

class DeleteRole extends RolesEvent {
  final String organizationId;
  final String roleId;
  const DeleteRole(this.organizationId, this.roleId);

  @override
  List<Object?> get props => [organizationId, roleId];
}

class AssignRoleToEmployee extends RolesEvent {
  final String organizationId;
  final String roleId;
  final String employeeId;
  final String? departmentId;

  const AssignRoleToEmployee({
    required this.organizationId,
    required this.roleId,
    required this.employeeId,
    this.departmentId,
  });

  @override
  List<Object?> get props => [organizationId, roleId, employeeId, departmentId];
}

class RemoveRoleFromEmployee extends RolesEvent {
  final String organizationId;
  final String roleId;
  final String employeeId;
  final String? departmentId;

  const RemoveRoleFromEmployee({
    required this.organizationId,
    required this.roleId,
    required this.employeeId,
    this.departmentId,
  });

  @override
  List<Object?> get props => [organizationId, roleId, employeeId, departmentId];
}

class WatchRoles extends RolesEvent {
  final String organizationId;
  const WatchRoles(this.organizationId);

  @override
  List<Object> get props => [organizationId];
}

// States
abstract class RolesState extends Equatable {
  const RolesState();

  @override
  List<Object?> get props => [];
}

class RolesInitial extends RolesState {}

class RolesLoading extends RolesState {}

class RolesLoaded extends RolesState {
  final List<Role> roles;
  const RolesLoaded(this.roles);

  @override
  List<Object?> get props => [roles];
}

class RolesError extends RolesState {
  final String message;
  final List<Role>? roles;
  const RolesError(this.message, [this.roles]);

  @override
  List<Object?> get props => [message, roles];
}

// Bloc
class RolesBloc extends Bloc<RolesEvent, RolesState> {
  final RolesRepository _rolesRepository;
  StreamSubscription? _rolesSubscription;

  RolesBloc({required RolesRepository rolesRepository})
      : _rolesRepository = rolesRepository,
        super(RolesInitial()) {
    on<LoadRoles>(_onLoadRoles);
    on<AddRole>(_onAddRole);
    on<UpdateRole>(_onUpdateRole);
    on<DeleteRole>(_onDeleteRole);
    on<AssignRoleToEmployee>(_onAssignRoleToEmployee);
    on<RemoveRoleFromEmployee>(_onRemoveRoleFromEmployee);
    on<WatchRoles>(_onWatchRoles);
  }

  Future<void> _onLoadRoles(LoadRoles event, Emitter<RolesState> emit) async {
    try {
      emit(RolesLoading());
      final roles = await _rolesRepository.getRoles(event.organizationId);
      emit(RolesLoaded(roles));
    } catch (e) {
      emit(RolesError(e.toString()));
    }
  }

  Future<void> _onAddRole(AddRole event, Emitter<RolesState> emit) async {
    try {
      if (state is RolesLoaded) {
        final currentRoles = (state as RolesLoaded).roles;
        await _rolesRepository.addRole(event.role);
        final updatedRoles = await _rolesRepository.getRoles(event.role.organizationId);
        emit(RolesLoaded(updatedRoles));
      }
    } catch (e) {
      emit(RolesError(e.toString()));
    }
  }

  Future<void> _onUpdateRole(UpdateRole event, Emitter<RolesState> emit) async {
    try {
      if (state is RolesLoaded) {
        await _rolesRepository.updateRole(event.role);
        final updatedRoles = await _rolesRepository.getRoles(event.role.organizationId);
        emit(RolesLoaded(updatedRoles));
      }
    } catch (e) {
      emit(RolesError(e.toString()));
    }
  }

  Future<void> _onDeleteRole(DeleteRole event, Emitter<RolesState> emit) async {
    try {
      if (state is RolesLoaded) {
        await _rolesRepository.deleteRole(event.organizationId, event.roleId);
        final updatedRoles = await _rolesRepository.getRoles(event.organizationId);
        emit(RolesLoaded(updatedRoles));
      }
    } catch (e) {
      emit(RolesError(e.toString()));
    }
  }

  Future<void> _onAssignRoleToEmployee(
    AssignRoleToEmployee event,
    Emitter<RolesState> emit,
  ) async {
    try {
      await _rolesRepository.assignRoleToEmployee(
        event.organizationId,
        event.roleId,
        event.employeeId,
        departmentId: event.departmentId,
      );
      // Optionally reload roles if needed
    } catch (e) {
      emit(RolesError(e.toString()));
    }
  }

  Future<void> _onRemoveRoleFromEmployee(
    RemoveRoleFromEmployee event,
    Emitter<RolesState> emit,
  ) async {
    try {
      await _rolesRepository.removeRoleFromEmployee(
        event.organizationId,
        event.roleId,
        event.employeeId,
        departmentId: event.departmentId,
      );
      // Optionally reload roles if needed
    } catch (e) {
      emit(RolesError(e.toString()));
    }
  }

  void _onWatchRoles(
    WatchRoles event, 
    Emitter<RolesState> emit
  ) async {
    // Cancel any existing subscription
    await _rolesSubscription?.cancel();

    try {
      _rolesSubscription = _rolesRepository
          .watchRoles(event.organizationId)
          .listen(
        (roles) {
          add(LoadRoles(event.organizationId));
        },
        onError: (error) {
          emit(RolesError(
            error.toString(), 
            state is RolesLoaded ? (state as RolesLoaded).roles : []
          ));
        },
      );
    } catch (e) {
      emit(RolesError(
        e.toString(), 
        state is RolesLoaded ? (state as RolesLoaded).roles : []
      ));
    }
  }

  @override
  Future<void> close() {
    _rolesSubscription?.cancel();
    return super.close();
  }
}
