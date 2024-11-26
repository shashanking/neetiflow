import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:neetiflow/domain/entities/employee.dart';
import 'package:neetiflow/domain/entities/department.dart';
import 'package:neetiflow/presentation/blocs/departments/departments_bloc.dart';

class EmployeeDetailsPage extends StatelessWidget {
  final Employee employee;

  const EmployeeDetailsPage({
    super.key,
    required this.employee,
  });

  @override
  Widget build(BuildContext context) {
    // Load departments when page opens
    if (employee.companyId != null) {
      context.read<DepartmentsBloc>().add(LoadDepartments(employee.companyId!));
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            expandedHeight: 200,
            pinned: true,
            actions: [
              if (employee.role != EmployeeRole.admin) ...[
                IconButton.outlined(
                  onPressed: () {
                    Navigator.pop(context, 'edit');
                  },
                  icon: const Icon(Icons.edit_outlined),
                  tooltip: 'Edit Employee',
                ),
                const SizedBox(width: 8),
                IconButton.outlined(
                  onPressed: () {
                    Navigator.pop(context, 'delete');
                  },
                  icon: const Icon(Icons.delete_outline),
                  tooltip: 'Delete Employee',
                  style: IconButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                  ),
                ),
                const SizedBox(width: 16),
              ],
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Theme.of(context).colorScheme.primaryContainer,
                      Theme.of(context).colorScheme.surface,
                    ],
                  ),
                ),
              ),
              title: Row(
                children: [
                  Hero(
                    tag: 'employee_avatar_${employee.id}',
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Text(
                        employee.name[0].toUpperCase(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Hero(
                      tag: 'employee_name_${employee.id}',
                      child: Text(
                        employee.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _buildDetails(context),
          ),
        ],
      ),
    );
  }

  Widget _buildDetails(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              employee.role == EmployeeRole.admin
                                  ? Icons.admin_panel_settings
                                  : employee.role == EmployeeRole.manager
                                      ? Icons.manage_accounts
                                      : Icons.person,
                              size: 16,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              employee.role.toString().split('.').last.toUpperCase(),
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (employee.departmentId != null) ...[
                        const SizedBox(width: 12),
                        BlocBuilder<DepartmentsBloc, DepartmentsState>(
                          builder: (context, state) {
                            if (state is DepartmentsLoaded) {
                              final department = state.departments.firstWhere(
                                (d) => d.id == employee.departmentId,
                                orElse: () => Department(
                                  id: '',
                                  name: 'Unknown Department',
                                  description: '',
                                  organizationId: '',
                                  employeeRoles: const {},
                                  createdAt: DateTime.now(),
                                  updatedAt: DateTime.now(),
                                ),
                              );
                              
                              final role = department.employeeRoles[employee.id] ?? DepartmentRole.member;
                              
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.tertiaryContainer,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      role == DepartmentRole.head
                                          ? Icons.supervised_user_circle
                                          : role == DepartmentRole.manager
                                              ? Icons.manage_accounts
                                              : Icons.group,
                                      size: 16,
                                      color: theme.colorScheme.tertiary,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${department.name} (${role.toString().split('.').last})',
                                      style: theme.textTheme.labelLarge?.copyWith(
                                        color: theme.colorScheme.tertiary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ],
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: employee.isActive
                              ? theme.colorScheme.secondaryContainer
                              : theme.colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              employee.isActive
                                  ? Icons.check_circle_outline
                                  : Icons.cancel_outlined,
                              size: 16,
                              color: employee.isActive
                                  ? theme.colorScheme.secondary
                                  : theme.colorScheme.error,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              employee.isActive ? 'ACTIVE' : 'INACTIVE',
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: employee.isActive
                                    ? theme.colorScheme.secondary
                                    : theme.colorScheme.error,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Contact Information',
                    style: theme.textTheme.titleLarge,
                  ),
                  const Divider(height: 1),
                  _DetailItem(
                    icon: Icons.email_outlined,
                    title: 'Email',
                    value: employee.email,
                    onTap: () {
                      // Handle email tap
                    },
                  ),
                  if (employee.phone != null && employee.phone!.isNotEmpty)
                    _DetailItem(
                      icon: Icons.phone_outlined,
                      title: 'Phone',
                      value: employee.phone!,
                      onTap: () {
                        // Handle phone tap
                      },
                    ),
                  if (employee.address != null && employee.address!.isNotEmpty)
                    _DetailItem(
                      icon: Icons.location_on_outlined,
                      title: 'Address',
                      value: employee.address!,
                      onTap: () {
                        // Handle address tap
                      },
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Department Management',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<DepartmentsBloc, DepartmentsState>(
                    builder: (context, state) {
                      if (state is DepartmentsLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      
                      if (state is DepartmentsError) {
                        return Center(
                          child: Text(
                            'Error loading departments: ${state.message}',
                            style: TextStyle(color: Theme.of(context).colorScheme.error),
                          ),
                        );
                      }

                      if (state is DepartmentsLoaded) {
                        final currentDepartment = state.departments.firstWhere(
                          (d) => d.id == employee.departmentId,
                          orElse: () => Department(
                            id: '',
                            name: 'Not Assigned',
                            description: '',
                            organizationId: '',
                            employeeRoles: const {},
                            createdAt: DateTime.now(),
                            updatedAt: DateTime.now(),
                          ),
                        );

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DropdownButtonFormField<String>(
                              value: employee.departmentId,
                              decoration: const InputDecoration(
                                labelText: 'Department',
                                border: OutlineInputBorder(),
                              ),
                              items: [
                                const DropdownMenuItem(
                                  value: null,
                                  child: Text('No Department'),
                                ),
                                ...state.departments.map((department) {
                                  return DropdownMenuItem(
                                    value: department.id,
                                    child: Text(department.name),
                                  );
                                }),
                              ],
                              onChanged: (String? newValue) {
                                // Handle department change
                                if (newValue != employee.departmentId) {
                                  if (employee.departmentId != null && employee.id != null) {
                                    context.read<DepartmentsBloc>().add(
                                          RemoveEmployeeFromDepartment(
                                            employee.departmentId!,
                                            employee.id!,
                                          ),
                                        );
                                  }
                                  if (newValue != null && employee.id != null) {
                                    context.read<DepartmentsBloc>().add(
                                          UpdateEmployeeDepartmentRole(
                                            newValue,
                                            employee.id!,
                                            DepartmentRole.member,
                                          ),
                                        );
                                  }
                                }
                              },
                            ),
                            if (employee.departmentId != null) ...[
                              const SizedBox(height: 16),
                              DropdownButtonFormField<DepartmentRole>(
                                value: currentDepartment.employeeRoles[employee.id] ?? DepartmentRole.member,
                                decoration: const InputDecoration(
                                  labelText: 'Department Role',
                                  border: OutlineInputBorder(),
                                ),
                                items: DepartmentRole.values.map((role) {
                                  return DropdownMenuItem(
                                    value: role,
                                    child: Text(role.toString().split('.').last),
                                  );
                                }).toList(),
                                onChanged: (DepartmentRole? newRole) {
                                  if (newRole != null && employee.departmentId != null && employee.id != null) {
                                    context.read<DepartmentsBloc>().add(
                                          UpdateEmployeeDepartmentRole(
                                            employee.departmentId!,
                                            employee.id!,
                                            newRole,
                                          ),
                                        );
                                  }
                                },
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Department Details',
                                style: theme.textTheme.titleSmall,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                currentDepartment.description,
                                style: theme.textTheme.bodyMedium,
                              ),
                            ],
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Employment Information',
                    style: theme.textTheme.titleLarge,
                  ),
                ),
                const Divider(height: 1),
                if (employee.companyName != null && employee.companyName!.isNotEmpty)
                  _DetailItem(
                    icon: Icons.business_outlined,
                    title: 'Company',
                    value: employee.companyName!,
                  )
                else
                  const _DetailItem(
                    icon: Icons.business_outlined,
                    title: 'Company',
                    value: 'Not Assigned',
                  ),
                if (employee.joiningDate != null)
                  _DetailItem(
                    icon: Icons.calendar_today_outlined,
                    title: 'Joining Date',
                    value: DateFormat('MMMM d, y').format(employee.joiningDate!),
                  ),
                if (employee.updatedAt != null)
                  _DetailItem(
                    icon: Icons.update_outlined,
                    title: 'Last Updated',
                    value: DateFormat('MMMM d, y').format(employee.updatedAt!),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final VoidCallback? onTap;

  const _DetailItem({
    required this.icon,
    required this.title,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 20,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: theme.textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onSurfaceVariant,
              ),
          ],
        ),
      ),
    );
  }
}
