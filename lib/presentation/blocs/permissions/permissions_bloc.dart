import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:neetiflow/domain/entities/employee.dart';
import 'package:neetiflow/domain/entities/role.dart';
import 'package:neetiflow/domain/services/permission_service.dart';

part 'permissions_event.dart';
part 'permissions_state.dart';

class PermissionsBloc extends Bloc<PermissionsEvent, PermissionsState> {
  final PermissionService _permissionService;

  PermissionsBloc({PermissionService? permissionService})
      : _permissionService = permissionService ?? PermissionService(),
        super(PermissionsInitial()) {
    on<CheckPermissionEvent>(_onCheckPermission);
    on<LoadHierarchyPermissionsEvent>(_onLoadHierarchyPermissions);
  }

  void _onCheckPermission(
    CheckPermissionEvent event, 
    Emitter<PermissionsState> emit
  ) {
    try {
      final hasPermission = _permissionService.checkContextualPermission(
        currentUser: event.currentUser,
        permission: event.permission,
        targetDepartmentId: event.targetDepartmentId,
        targetEmployeeId: event.targetEmployeeId,
      );

      emit(PermissionCheckResult(
        hasPermission: hasPermission,
        permission: event.permission,
      ));
    } catch (e) {
      emit(PermissionsError(message: e.toString()));
    }
  }

  void _onLoadHierarchyPermissions(
    LoadHierarchyPermissionsEvent event, 
    Emitter<PermissionsState> emit
  ) {
    try {
      final permissions = _permissionService.getHierarchyPermissions(event.hierarchy);
      emit(HierarchyPermissionsLoaded(
        hierarchy: event.hierarchy,
        permissions: permissions,
      ));
    } catch (e) {
      emit(PermissionsError(message: e.toString()));
    }
  }
}
