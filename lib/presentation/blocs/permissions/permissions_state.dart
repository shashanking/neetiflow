part of 'permissions_bloc.dart';

abstract class PermissionsState extends Equatable {
  const PermissionsState();
  
  @override
  List<Object?> get props => [];
}

class PermissionsInitial extends PermissionsState {}

class PermissionCheckResult extends PermissionsState {
  final bool hasPermission;
  final String permission;

  const PermissionCheckResult({
    required this.hasPermission,
    required this.permission,
  });

  @override
  List<Object?> get props => [hasPermission, permission];
}

class HierarchyPermissionsLoaded extends PermissionsState {
  final DepartmentHierarchy hierarchy;
  final List<String> permissions;

  const HierarchyPermissionsLoaded({
    required this.hierarchy,
    required this.permissions,
  });

  @override
  List<Object?> get props => [hierarchy, permissions];
}

class PermissionsError extends PermissionsState {
  final String message;

  const PermissionsError({required this.message});

  @override
  List<Object?> get props => [message];
}
