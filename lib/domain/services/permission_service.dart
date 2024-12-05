import 'package:neetiflow/domain/entities/role.dart';
import 'package:neetiflow/domain/entities/employee.dart';

class PermissionService {
  // Singleton pattern
  static final PermissionService _instance = PermissionService._internal();
  factory PermissionService() => _instance;
  PermissionService._internal();

  // Predefined permission hierarchies
  static final Map<DepartmentHierarchy, List<String>> _hierarchyPermissions = {
    DepartmentHierarchy.admin: [
      'read_all', 'write_all', 'delete_all', 
      'manage_users', 'manage_roles', 'manage_departments',
      'view_reports', 'configure_system'
    ],
    DepartmentHierarchy.manager: [
      'read_department', 'write_department', 
      'manage_department_employees', 
      'view_department_reports', 
      'assign_roles_in_department'
    ],
    DepartmentHierarchy.member: [
      'read_own_profile', 'update_own_profile', 
      'view_department_info', 
      'log_work_hours', 'submit_requests'
    ],
  };

  // Check if a user has a specific permission
  bool hasPermission(Employee employee, String permission) {
    if (employee.role == null) return false;

    // Check direct role permissions
    if (employee.role!.permissions.contains(permission)) {
      return true;
    }

    // Check hierarchical permissions
    return _checkHierarchicalPermissions(employee.role!.hierarchy, permission);
  }

  // Check permissions based on hierarchy
  bool _checkHierarchicalPermissions(DepartmentHierarchy hierarchy, String permission) {
    // Higher hierarchies inherit permissions from lower hierarchies
    for (var h in DepartmentHierarchy.values) {
      if (h.index <= hierarchy.index) {
        if (_hierarchyPermissions[h]?.contains(permission) ?? false) {
          return true;
        }
      }
    }
    return false;
  }

  // Get all permissions for a given hierarchy
  List<String> getHierarchyPermissions(DepartmentHierarchy hierarchy) {
    return _hierarchyPermissions[hierarchy] ?? [];
  }

  // Check if user can perform an action
  bool canPerformAction(Employee employee, String action) {
    return hasPermission(employee, action);
  }

  // Advanced permission checking with context
  bool checkContextualPermission({
    required Employee currentUser,
    required String permission,
    String? targetDepartmentId,
    String? targetEmployeeId,
  }) {
    // Basic permission check
    if (!hasPermission(currentUser, permission)) {
      return false;
    }

    // Additional contextual checks can be added here
    // For example, checking if the user is in the same department
    if (targetDepartmentId != null) {
      if (currentUser.departmentId != targetDepartmentId) {
        // Only managers and admins can cross-department actions
        return currentUser.role?.hierarchy == DepartmentHierarchy.manager ||
               currentUser.role?.hierarchy == DepartmentHierarchy.admin;
      }
    }

    return true;
  }
}
