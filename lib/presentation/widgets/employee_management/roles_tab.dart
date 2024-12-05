import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neetiflow/domain/entities/role.dart';
import 'package:neetiflow/presentation/blocs/auth/auth_bloc.dart';
import 'package:neetiflow/presentation/blocs/roles/roles_bloc.dart';
import 'package:neetiflow/presentation/widgets/employee_management/role_form_dialog.dart';

class RolesTab extends StatelessWidget {
  const RolesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = context.read<AuthBloc>().state;
    
    if (authState is! Authenticated) {
      return const Center(child: Text('Not authenticated'));
    }

    return BlocBuilder<RolesBloc, RolesState>(
      builder: (context, state) {
        if (state is RolesLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is RolesError) {
          return Center(
            child: Text(
              'Error: ${state.message}',
              style: TextStyle(color: theme.colorScheme.error),
            ),
          );
        }

        if (state is RolesLoaded) {
          final systemRoles = state.roles
              .where((role) => role.type == RoleType.system)
              .toList();
          final departmentRoles = state.roles
              .where((role) => role.type == RoleType.department)
              .toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Text(
                      'Role Management',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    FilledButton.icon(
                      onPressed: () => _showRoleFormDialog(context),
                      icon: const Icon(Icons.add),
                      label: const Text('Add Role'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildRoleSection(
                        context,
                        'System Roles',
                        systemRoles,
                        Icons.admin_panel_settings,
                      ),
                      const SizedBox(height: 32),
                      _buildRoleSection(
                        context,
                        'Department Roles',
                        departmentRoles,
                        Icons.groups,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  void _showRoleFormDialog(BuildContext context, {Role? role}) {
    final authState = context.read<AuthBloc>().state;
    if (authState is! Authenticated) return;

    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<RolesBloc>(),
        child: RoleFormDialog(
          organizationId: authState.employee.companyId!,
          role: role,
        ),
      ),
    );
  }

  Widget _buildRoleSection(
    BuildContext context,
    String title,
    List<Role> roles,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon),
            const SizedBox(width: 8),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (roles.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'No roles found',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: roles.length,
            itemBuilder: (context, index) {
              final role = roles[index];
              return Card(
                child: ListTile(
                  title: Text(role.name),
                  subtitle: Text(role.description),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showRoleFormDialog(context, role: role),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (dialogContext) => BlocProvider.value(
                              value: context.read<RolesBloc>(),
                              child: AlertDialog(
                                title: const Text('Delete Role'),
                                content: Text(
                                  'Are you sure you want to delete the role "${role.name}"?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(dialogContext).pop();
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  FilledButton(
                                    onPressed: () {
                                      dialogContext.read<RolesBloc>().add(
                                            DeleteRole(
                                              role.organizationId,
                                              role.id!,
                                            ),
                                          );
                                      Navigator.of(dialogContext).pop();
                                    },
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
