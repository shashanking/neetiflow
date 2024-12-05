part of 'permissions_bloc.dart';

abstract class PermissionsEvent extends Equatable {
  const PermissionsEvent();

  @override
  List<Object?> get props => [];
}

class CheckPermissionEvent extends PermissionsEvent {
  final Employee currentUser;
  final String permission;
  final String? targetDepartmentId;
  final String? targetEmployeeId;

  const CheckPermissionEvent({
    required this.currentUser,
    required this.permission,
    this.targetDepartmentId,
    this.targetEmployeeId,
  });

  @override
  List<Object?> get props => [
    currentUser, 
    permission, 
    targetDepartmentId, 
    targetEmployeeId
  ];
}

class LoadHierarchyPermissionsEvent extends PermissionsEvent {
  final DepartmentHierarchy hierarchy;

  const LoadHierarchyPermissionsEvent({required this.hierarchy});

  @override
  List<Object> get props => [hierarchy];
}
