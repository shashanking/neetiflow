import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:neetiflow/domain/entities/employee.dart';
import 'package:neetiflow/presentation/blocs/departments/departments_bloc.dart';
import 'package:neetiflow/presentation/blocs/password_reset/password_reset_bloc.dart';
import 'package:neetiflow/presentation/blocs/auth/auth_bloc.dart';
import 'package:neetiflow/presentation/blocs/employee_status/employee_status_bloc.dart';

import '../../../domain/entities/department.dart';
import '../../../domain/repositories/employees_repository.dart';

class EmployeeDetailsPage extends StatefulWidget {
  final Employee employee;

  const EmployeeDetailsPage({
    super.key,
    required this.employee,
  });

  @override
  State<EmployeeDetailsPage> createState() => _EmployeeDetailsPageState();
}

class _EmployeeDetailsPageState extends State<EmployeeDetailsPage> {
  StreamSubscription<Employee>? _employeeSubscription;
  Employee? _currentEmployee;

  @override
  void initState() {
    super.initState();
    _subscribeToEmployeeUpdates();
    
    // Load departments once in initState
    if (widget.employee.companyId != null) {
      Future.microtask(() {
        if (mounted) {
          context.read<DepartmentsBloc>().add(LoadDepartments(widget.employee.companyId!));
        }
      });
    }
  }

  @override
  void dispose() {
    _employeeSubscription?.cancel();
    super.dispose();
  }

  void _subscribeToEmployeeUpdates() {
    if (widget.employee.id != null && widget.employee.companyId != null) {
      final employeesRepository = context.read<EmployeesRepository>();
      _employeeSubscription?.cancel(); // Cancel any existing subscription
      _employeeSubscription = employeesRepository
          .employeeStream(widget.employee.companyId!, widget.employee.id!)
          .listen(
            (employee) {
              if (mounted) {
                setState(() => _currentEmployee = employee);
              }
            },
            onError: (error) {
              debugPrint('Error in employee stream: $error');
            },
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final employee = _currentEmployee ?? widget.employee;

    return Scaffold(
      appBar: AppBar(
        title: Text('${employee.firstName ?? ''} ${employee.lastName ?? ''}'),
        actions: [
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, authState) {
              if (authState is Authenticated) {
                final isCurrentUser = authState.employee.id == employee.id;
                final isAdmin = authState.employee.role == EmployeeRole.admin;
                
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isCurrentUser) ...[
                      IconButton(
                        icon: const Icon(Icons.key),
                        onPressed: () {
                          _showResetPasswordDialog(context);
                        },
                        tooltip: 'Reset Password',
                      ),
                      const SizedBox(width: 8),
                    ],
                    if (isAdmin && !isCurrentUser) ...[
                      IconButton(
                        icon: Icon(
                          employee.isActive
                              ? Icons.toggle_on_outlined
                              : Icons.toggle_off_outlined,
                        ),
                        onPressed: () {
                          _showActivationDialog(context);
                        },
                        tooltip: employee.isActive
                            ? 'Deactivate Employee'
                            : 'Activate Employee',
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () {
                          Navigator.pop(context, 'edit');
                        },
                        tooltip: 'Edit Employee',
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () {
                          Navigator.pop(context, 'delete');
                        },
                        tooltip: 'Delete Employee',
                        style: IconButton.styleFrom(
                          foregroundColor: Theme.of(context).colorScheme.error,
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
          if (employee.role != EmployeeRole.admin) ...[
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () {
                Navigator.pop(context, 'edit');
              },
              tooltip: 'Edit Employee',
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                Navigator.pop(context, 'delete');
              },
              tooltip: 'Delete Employee',
              style: IconButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
            ),
            const SizedBox(width: 16),
          ],
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildDetails(context),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetails(BuildContext context) {
    final theme = Theme.of(context);
    final employee = widget.employee;

    return SingleChildScrollView(
      child: Padding(
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
                      mainAxisSize: MainAxisSize.min,
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
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: employee.isOnline
                                ? theme.colorScheme.primaryContainer
                                : theme.colorScheme.surfaceVariant,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                employee.isOnline
                                    ? Icons.circle
                                    : Icons.circle_outlined,
                                size: 16,
                                color: employee.isOnline
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                employee.isOnline ? 'ONLINE' : 'OFFLINE',
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: employee.isOnline
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.onSurfaceVariant,
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
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Contact Information',
                      style: theme.textTheme.titleLarge,
                    ),
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
            const SizedBox(height: 16),
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: theme.colorScheme.primary,
                    child: Text(
                      employee.firstName[0].toUpperCase(),
                      style: theme.textTheme.headlineLarge?.copyWith(
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${employee.firstName} ${employee.lastName}',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showResetPasswordDialog(BuildContext context) {
    final theme = Theme.of(context);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to reset the password for:',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              '${widget.employee.firstName} ${widget.employee.lastName}',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              widget.employee.email,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'A password reset link will be sent to their email address.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              context.read<PasswordResetBloc>().add(
                    SendPasswordResetEmail(email: widget.employee.email),
                  );
            },
            child: BlocBuilder<PasswordResetBloc, PasswordResetState>(
              builder: (context, state) {
                if (state is PasswordResetLoading) {
                  return const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  );
                }
                return const Text('Send Reset Link');
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showActivationDialog(BuildContext context) {
    final theme = Theme.of(context);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          widget.employee.isActive ? 'Deactivate Employee' : 'Activate Employee'
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.employee.isActive
                  ? 'Are you sure you want to deactivate this employee?'
                  : 'Are you sure you want to activate this employee?',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              '${widget.employee.firstName} ${widget.employee.lastName}',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              widget.employee.email,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.employee.isActive
                  ? 'They will not be able to log in until reactivated.'
                  : 'They will be able to log in after activation.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (widget.employee.id != null && widget.employee.companyId != null) {
                context.read<EmployeeStatusBloc>().add(
                  UpdateEmployeeStatus(
                    employeeId: widget.employee.id!,
                    companyId: widget.employee.companyId!,
                    isActive: !widget.employee.isActive,
                  ),
                );
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Cannot update status: Invalid employee data'),
                    backgroundColor: Theme.of(context).colorScheme.error,
                  ),
                );
              }
            },
            child: BlocBuilder<EmployeeStatusBloc, EmployeeStatusState>(
              builder: (context, state) {
                if (state is EmployeeStatusUpdating) {
                  return const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  );
                }
                return Text(
                  widget.employee.isActive ? 'Deactivate' : 'Activate'
                );
              },
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
          crossAxisAlignment: CrossAxisAlignment.center,
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
            // Using Flexible instead of Expanded for better behavior
            Flexible(
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
            if (onTap != null) ...[
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
