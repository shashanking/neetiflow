import 'package:flutter/material.dart';
import 'package:neetiflow/domain/entities/role.dart';
import 'package:neetiflow/domain/services/permission_service.dart';

class RolePermissionsWidget extends StatelessWidget {
  final DepartmentHierarchy hierarchy;
  final bool expanded;

  const RolePermissionsWidget({
    Key? key, 
    required this.hierarchy,
    this.expanded = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final permissionService = PermissionService();
    final permissions = permissionService.getHierarchyPermissions(hierarchy);

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ExpansionTile(
        initiallyExpanded: expanded,
        title: Text(
          _getHierarchyTitle(hierarchy),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: _getHierarchyColor(hierarchy),
          ),
        ),
        subtitle: Text(
          'Permissions for ${_getHierarchyTitle(hierarchy)} Role',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        children: [
          _buildPermissionsList(context, permissions),
        ],
      ),
    );
  }

  Widget _buildPermissionsList(BuildContext context, List<String> permissions) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Granted Permissions:',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          ...permissions.map((permission) => _buildPermissionItem(context, permission)),
        ],
      ),
    );
  }

  Widget _buildPermissionItem(BuildContext context, String permission) {
    return ListTile(
      dense: true,
      leading: Icon(
        Icons.check_circle_outline,
        color: _getHierarchyColor(hierarchy).withOpacity(0.7),
      ),
      title: Text(
        _formatPermissionName(permission),
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  String _formatPermissionName(String permission) {
    return permission
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  String _getHierarchyTitle(DepartmentHierarchy hierarchy) {
    switch (hierarchy) {
      case DepartmentHierarchy.admin:
        return 'System Administrator';
      case DepartmentHierarchy.manager:
        return 'Department Manager';
      case DepartmentHierarchy.member:
        return 'Standard Employee';
      default:
        return 'Unknown Role';
    }
  }

  Color _getHierarchyColor(DepartmentHierarchy hierarchy) {
    switch (hierarchy) {
      case DepartmentHierarchy.admin:
        return Colors.red;
      case DepartmentHierarchy.manager:
        return Colors.blue;
      case DepartmentHierarchy.member:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  // Static method to show a full permissions dialog
  static void showPermissionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Role Permissions Overview'),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RolePermissionsWidget(hierarchy: DepartmentHierarchy.admin),
              RolePermissionsWidget(hierarchy: DepartmentHierarchy.manager),
              RolePermissionsWidget(hierarchy: DepartmentHierarchy.member),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
