import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neetiflow/domain/entities/role.dart';
import 'package:neetiflow/presentation/blocs/roles/roles_bloc.dart';

class RoleFormDialog extends StatefulWidget {
  final String organizationId;
  final Role? role;

  const RoleFormDialog({
    super.key,
    required this.organizationId,
    this.role,
  });

  @override
  State<RoleFormDialog> createState() => _RoleFormDialogState();
}

class _RoleFormDialogState extends State<RoleFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late RoleType _selectedType;
  final List<String> _permissions = [];
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.role?.name);
    _descriptionController = TextEditingController(text: widget.role?.description);
    _selectedType = widget.role?.type ?? RoleType.system;
    _isActive = widget.role?.isActive ?? true;
    if (widget.role != null) {
      _permissions.addAll(widget.role!.permissions);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditing = widget.role != null;

    return Dialog(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEditing ? 'Edit Role' : 'Create Role',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Role Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a role name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<RoleType>(
                  value: _selectedType,
                  decoration: const InputDecoration(
                    labelText: 'Role Type',
                    border: OutlineInputBorder(),
                  ),
                  items: RoleType.values.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type.toString().split('.').last),
                    );
                  }).toList(),
                  onChanged: (RoleType? value) {
                    if (value != null) {
                      setState(() {
                        _selectedType = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Role Active'),
                  subtitle: const Text('Toggle to activate or deactivate this role'),
                  value: _isActive,
                  onChanged: (bool value) {
                    setState(() {
                      _isActive = value;
                    });
                  },
                ),
                const SizedBox(height: 24),
                Text(
                  'Permissions',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    _buildPermissionChip('View Dashboard'),
                    _buildPermissionChip('Manage Employees'),
                    _buildPermissionChip('Manage Roles'),
                    _buildPermissionChip('Manage Departments'),
                    _buildPermissionChip('View Reports'),
                    _buildPermissionChip('Manage Settings'),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: _saveRole,
                      child: Text(isEditing ? 'Update' : 'Create'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionChip(String permission) {
    final isSelected = _permissions.contains(permission);
    return FilterChip(
      label: Text(permission),
      selected: isSelected,
      onSelected: (bool selected) {
        setState(() {
          if (selected) {
            _permissions.add(permission);
          } else {
            _permissions.remove(permission);
          }
        });
      },
    );
  }

  void _saveRole() {
    if (_formKey.currentState!.validate()) {
      final role = Role(
        id: widget.role?.id,
        name: _nameController.text,
        description: _descriptionController.text,
        type: _selectedType,
        organizationId: widget.organizationId,
        permissions: _permissions,
        isActive: _isActive,
      );

      if (widget.role != null) {
        context.read<RolesBloc>().add(UpdateRole(role));
      } else {
        context.read<RolesBloc>().add(AddRole(role));
      }

      Navigator.of(context).pop();
    }
  }
}
