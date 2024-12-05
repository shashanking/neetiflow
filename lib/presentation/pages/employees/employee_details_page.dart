import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neetiflow/presentation/widgets/employees/employee_timeline_container.dart';
import 'package:intl/intl.dart';
import 'package:neetiflow/domain/entities/employee.dart';
import 'package:neetiflow/domain/entities/permission.dart';
import 'package:neetiflow/presentation/blocs/departments/departments_bloc.dart';
import 'package:neetiflow/presentation/blocs/password_reset/password_reset_bloc.dart';
import 'package:neetiflow/presentation/blocs/auth/auth_bloc.dart';

import '../../../domain/entities/department.dart';
import '../../../domain/repositories/employees_repository.dart';
import '../../blocs/employees/employees_bloc.dart';
import '../../widgets/persistent_shell.dart';
import 'employees_page.dart';

class EmployeeDetailsPage extends StatefulWidget {
  final Employee employee;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const EmployeeDetailsPage({
    super.key,
    required this.employee,
    this.onEdit,
    this.onDelete,
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
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _subscribeToEmployeeUpdates();
    
    // Load departments once
    if (widget.employee.companyId != null) {
      context.read<DepartmentsBloc>().add(LoadDepartments(widget.employee.companyId!));
    }
  }

  @override
  void dispose() {
    _employeeSubscription?.cancel();
    super.dispose();
  }

  void _subscribeToEmployeeUpdates() {
    try {
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
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error loading employee details: $error'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            );
      }
    } catch (e) {
      debugPrint('Error setting up employee stream: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading employee details: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _updateDepartmentRole(DepartmentHierarchy newRole) {
    context.read<DepartmentsBloc>().add(
      UpdateEmployeeDepartmentRole(
        widget.employee.departmentId!, 
        widget.employee.id!, 
        newRole
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final employee = _currentEmployee ?? widget.employee;

    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  final state = PersistentShell.of(context);
                  if (state != null) {
                    // Explicitly navigate to Employees page
                    state.setCustomPage(
                      BlocProvider(
                        create: (context) => EmployeesBloc(
                          employeesRepository: context.read<EmployeesRepository>(),
                        )..add(LoadEmployees(widget.employee.companyId!)),
                        child: const EmployeesPage(),
                      ),
                    );
                  }
                },
                tooltip: 'Back to Employees',
              ),
              title: Text('${employee.firstName} ${employee.lastName}'),
              actions: [
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, authState) {
                    if (authState is Authenticated) {
                      final isCurrentUser = authState.employee.id == employee.id;
                      final isAdmin = authState.employee.role?.id == 'admin_role_id';
 
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
                              onPressed: widget.onEdit,
                              tooltip: 'Edit Employee',
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.delete_outline),
                              onPressed: widget.onDelete,
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
              ],
              bottom: const TabBar(
                tabs: [
                  Tab(text: 'Details'),
                  Tab(text: 'Timeline'),
                ],
              ),
            ),
          ],
          body: TabBarView(
            children: [
              // Details Tab
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: _buildDetails(context),
              ),
              // Timeline Tab
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: employee.id != null && employee.companyId != null
                    ? EmployeeTimelineContainer(
                        employeeId: employee.id!,
                        companyId: employee.companyId!,
                      )
                    : const Center(
                        child: Text('Employee ID or Company ID not available'),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetails(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final authBloc = context.read<AuthBloc>();
    
    // Safely access the current user from the auth state
    final currentUser = authBloc.state is Authenticated 
      ? (authBloc.state as Authenticated).employee 
      : null;

    // Check if the current user is an admin and not editing their own profile
    final canManageEmployee = currentUser?.role?.permissions.contains(Permission.manageEmployees) ?? false;
    final isOwnProfile = currentUser?.id == widget.employee.id;
    final canToggleStatus = canManageEmployee && !isOwnProfile;

    return Stack(
      children: [
        // Background with gradient
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  theme.colorScheme.surfaceVariant.withOpacity(0.5),
                  theme.colorScheme.surface,
                ],
              ),
            ),
          ),
        ),
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hero Section
              Container(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 48),
                child: Column(
                  children: [
                    Hero(
                      tag: 'employee-avatar-${widget.employee.id}',
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.primary.withOpacity(0.2),
                              blurRadius: 16,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 56,
                          backgroundColor: theme.colorScheme.primary,
                          child: Text(
                            widget.employee.firstName[0].toUpperCase(),
                            style: theme.textTheme.displaySmall?.copyWith(
                              color: theme.colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      '${widget.employee.firstName} ${widget.employee.lastName}',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    // Status Chips
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: [
                        _buildStatusChip(
                          context: context,
                          icon: widget.employee.role?.id == 'admin_role_id'
                              ? Icons.admin_panel_settings
                              : widget.employee.role?.id == 'manager_role_id'
                                  ? Icons.manage_accounts
                                  : Icons.person,
                          label: widget.employee.role?.name ?? 'No Role',
                          backgroundColor: theme.colorScheme.primaryContainer,
                          foregroundColor: theme.colorScheme.primary,
                        ),
                        if (widget.employee.departmentId != null)
                          BlocBuilder<DepartmentsBloc, DepartmentsState>(
                            builder: (context, state) {
                              if (state is DepartmentsLoaded) {
                                final department = state.departments.firstWhere(
                                  (d) => d.id == widget.employee.departmentId,
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
                                
                                final role = department.employeeRoles[widget.employee.id] ?? DepartmentHierarchy.member;
                                
                                return _buildStatusChip(
                                  context: context,
                                  icon: role == DepartmentHierarchy.head
                                      ? Icons.supervised_user_circle
                                      : role == DepartmentHierarchy.manager
                                          ? Icons.manage_accounts
                                          : Icons.group,
                                  label: '${department.name} (${role.toString().split('.').last})',
                                  backgroundColor: theme.colorScheme.tertiaryContainer,
                                  foregroundColor: theme.colorScheme.tertiary,
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        _buildStatusChip(
                          context: context,
                          icon: widget.employee.isActive
                              ? Icons.check_circle_outline
                              : Icons.cancel_outlined,
                          label: widget.employee.isActive ? 'ACTIVE' : 'INACTIVE',
                          backgroundColor: widget.employee.isActive
                              ? theme.colorScheme.secondaryContainer
                              : theme.colorScheme.errorContainer,
                          foregroundColor: widget.employee.isActive
                              ? theme.colorScheme.secondary
                              : theme.colorScheme.error,
                        ),
                        _buildStatusChip(
                          context: context,
                          icon: widget.employee.isOnline
                              ? Icons.circle
                              : Icons.circle_outlined,
                          label: widget.employee.isOnline ? 'ONLINE' : 'OFFLINE',
                          backgroundColor: widget.employee.isOnline
                              ? theme.colorScheme.primaryContainer
                              : theme.colorScheme.surfaceVariant,
                          foregroundColor: widget.employee.isOnline
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Information Cards
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildInfoCard(
                      context: context,
                      title: 'Contact Information',
                      children: [
                        _DetailItem(
                          icon: Icons.email_outlined,
                          title: 'Email',
                          value: widget.employee.email,
                          onTap: () {
                            // Handle email tap
                          },
                        ),
                        if (widget.employee.phone != null && widget.employee.phone!.isNotEmpty)
                          _DetailItem(
                            icon: Icons.phone_outlined,
                            title: 'Phone',
                            value: widget.employee.phone!,
                            onTap: () {
                              // Handle phone tap
                            },
                          ),
                        if (widget.employee.address != null && widget.employee.address!.isNotEmpty)
                          _DetailItem(
                            icon: Icons.location_on_outlined,
                            title: 'Address',
                            value: widget.employee.address!,
                            onTap: () {
                              // Handle address tap
                            },
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildInfoCard(
                      context: context,
                      title: 'Employment Information',
                      children: [
                        if (widget.employee.companyName != null && widget.employee.companyName!.isNotEmpty)
                          _DetailItem(
                            icon: Icons.business_outlined,
                            title: 'Company',
                            value: widget.employee.companyName!,
                          )
                        else
                          const _DetailItem(
                            icon: Icons.business_outlined,
                            title: 'Company',
                            value: 'Not Assigned',
                          ),
                        if (widget.employee.joiningDate != null)
                          _DetailItem(
                            icon: Icons.calendar_today_outlined,
                            title: 'Joining Date',
                            value: DateFormat('MMMM d, y').format(widget.employee.joiningDate!),
                          ),
                        if (widget.employee.updatedAt != null)
                          _DetailItem(
                            icon: Icons.update_outlined,
                            title: 'Last Updated',
                            value: DateFormat('MMMM d, y').format(widget.employee.updatedAt!),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              if (canToggleStatus) Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.employee.isActive ? 'Deactivate Employee' : 'Activate Employee',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: widget.employee.isActive 
                            ? colorScheme.error 
                            : colorScheme.primary,
                        ),
                      ),
                    ),
                    Switch.adaptive(
                      value: widget.employee.isActive,
                      onChanged: (bool newStatus) {
                        _showActivationDialog(context);
                      },
                      activeColor: colorScheme.primary,
                      activeTrackColor: colorScheme.primary.withOpacity(0.5),
                      inactiveThumbColor: colorScheme.error,
                      inactiveTrackColor: colorScheme.error.withOpacity(0.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color backgroundColor,
    required Color foregroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: backgroundColor.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: foregroundColor,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: foregroundColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required BuildContext context,
    required String title,
    required List<Widget> children,
  }) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 24,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ...children,
        ],
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
    final colorScheme = theme.colorScheme;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            widget.employee.isActive 
              ? 'Deactivate Employee' 
              : 'Activate Employee',
            style: theme.textTheme.titleMedium?.copyWith(
              color: widget.employee.isActive 
                ? colorScheme.error 
                : colorScheme.primary,
            ),
          ),
          content: Text(
            widget.employee.isActive 
              ? 'Are you sure you want to deactivate this employee? They will lose access to the system.' 
              : 'Are you sure you want to activate this employee? They will regain system access.',
            style: theme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Create a new employee object with updated active status
                final updatedEmployee = widget.employee.copyWith(
                  isActive: !widget.employee.isActive,
                );

                // Toggle employee active status
                context.read<EmployeesBloc>().add(
                  UpdateEmployee(updatedEmployee),
                );
                Navigator.of(dialogContext).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.employee.isActive 
                  ? colorScheme.error 
                  : colorScheme.primary,
              ),
              child: Text(
                widget.employee.isActive ? 'Deactivate' : 'Activate',
                style: TextStyle(color: colorScheme.onPrimary),
              ),
            ),
          ],
        );
      },
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
