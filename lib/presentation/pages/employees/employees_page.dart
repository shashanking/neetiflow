import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:neetiflow/domain/entities/employee.dart';
import 'package:neetiflow/domain/entities/department.dart' as department_entity;
import 'package:neetiflow/domain/entities/role.dart' as role_entity;
import 'package:neetiflow/domain/repositories/employees_repository.dart';
import 'package:neetiflow/domain/repositories/departments_repository.dart';
import 'package:neetiflow/domain/repositories/roles_repository.dart';
import 'package:neetiflow/presentation/blocs/auth/auth_bloc.dart';
import 'package:neetiflow/presentation/blocs/employees/employees_bloc.dart';
import 'package:neetiflow/presentation/blocs/departments/departments_bloc.dart';
import 'package:neetiflow/presentation/blocs/roles/roles_bloc.dart';
import 'package:neetiflow/presentation/pages/employees/employee_details_page.dart';
import 'package:neetiflow/presentation/pages/employee_management/employee_management_page.dart';
import 'package:neetiflow/presentation/widgets/persistent_shell.dart';
import 'package:uuid/uuid.dart';

class EmployeesPage extends StatefulWidget {
  const EmployeesPage({super.key});

  @override
  State<EmployeesPage> createState() => _EmployeesPageState();
}

class _EmployeesPageState extends State<EmployeesPage> {
  final _searchController = TextEditingController();
  String? _selectedRoleId;
  String? _selectedDepartmentId;
  String _searchQuery = '';
  bool _showOnlyActiveEmployees = false;

  List<Employee> _filterEmployees(List<Employee> employees) {
    return employees.where((employee) {
      // Search query filter
      final matchesSearch = 
        employee.firstName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        employee.lastName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        employee.email.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        (employee.phone?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
      
      // Role filter with null safety
      final matchesRole = _selectedRoleId == null || 
        (employee.role?.id == _selectedRoleId || 
         (employee.role?.name.toLowerCase() == _selectedRoleId?.toLowerCase()));
      
      // Department filter
      final matchesDepartment = _selectedDepartmentId == null || 
        employee.departmentId == _selectedDepartmentId;
      
      // Active status filter
      final matchesActiveStatus = _showOnlyActiveEmployees 
        ? employee.isActive 
        : true;

      return matchesSearch && matchesRole && matchesDepartment && matchesActiveStatus;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    
    if (authState is! Authenticated || (authState).organization?.id == null) {
      return const Center(child: Text('Not authenticated or missing organization'));
    }

    final String orgId = (authState).organization!.id!;

    
    final screenWidth = MediaQuery.of(context).size.width;
    final isCompact = screenWidth < 600;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => EmployeesBloc(
            employeesRepository: context.read<EmployeesRepository>(),
          )..add(LoadEmployees(orgId)),
        ),
        BlocProvider(
          create: (context) => DepartmentsBloc(
            departmentsRepository: context.read<DepartmentsRepository>(),
          )..add(LoadDepartments(orgId)),
        ),
        BlocProvider(
          create: (context) => RolesBloc(
            rolesRepository: context.read<RolesRepository>(),
          )..add(LoadRoles(orgId)),
        ),
      ],
      child: BlocListener<DepartmentsBloc, DepartmentsState>(
        listener: (context, state) {
          if (state is DepartmentOperationSuccess) {
            // Show success snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is DepartmentOperationFailure) {
            // Show error snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Employees'),
            automaticallyImplyLeading: !isCompact,
            leading: isCompact
                ? IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      // Use PersistentShell's toggleDrawer method
                      PersistentShell.of(context)?.toggleDrawer();
                    },
                  )
                : null,
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  final state = PersistentShell.of(context);
                  if (state != null) {
                    state.setCustomPage(
                      MultiBlocProvider(
                        providers: [
                          BlocProvider(
                            create: (context) => DepartmentsBloc(
                              departmentsRepository: context.read<DepartmentsRepository>(),
                            ),
                          ),
                        ],
                        child: const EmployeeManagementPage(),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: FilledButton.icon(
                  onPressed: () => _showAddEmployeeDialog(
                    context,
                    authState.employee,
                  ),
                  icon: const Icon(Icons.person_add),
                  label: const Text('Add Employee'),
                  style: FilledButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ),
            ],
          ),
          body: BlocBuilder<RolesBloc, RolesState>(
            builder: (context, rolesState) {
              if (rolesState is! RolesLoaded) {
                return const Center(child: CircularProgressIndicator());
              }

              return BlocBuilder<EmployeesBloc, EmployeesState>(
                builder: (context, state) {
                  List<Employee> employeesList = state is EmployeesLoaded 
                      ? state.employees 
                      : state is EmployeesLoading 
                          ? state.employees
                          : state is EmailAvailabilityChecked
                              ? state.employees
                              : state is EmployeesEmailError
                                  ? state.employees
                              : state is EmployeesEmailAvailable
                                  ? state.employees
                              : [];

                  final filteredEmployees = _filterEmployees(employeesList);

                  if (state is EmployeesLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (state is EmployeesError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 48,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Error: ${state.message}',
                            style: Theme.of(context).textTheme.titleMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          FilledButton.icon(
                            onPressed: () {
                              context.read<EmployeesBloc>().add(
                                LoadEmployees(
                                  (context.read<AuthBloc>().state is Authenticated)
                                      ? (context.read<AuthBloc>().state as Authenticated).organization?.id ?? ''
                                      : '',
                                ),
                              );
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (filteredEmployees.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.people_outline,
                            size: 64,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No employees found',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Add your first employee to get started',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 24),
                          FilledButton.icon(
                            onPressed: () => _showAddEmployeeDialog(
                              context,
                              authState.employee,
                            ),
                            icon: const Icon(Icons.add),
                            label: const Text('Add Employee'),
                          ),
                        ],
                      ),
                    );
                  }

                  return CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _searchController,
                                      decoration: InputDecoration(
                                        hintText: 'Search employees...',
                                        prefixIcon: const Icon(Icons.search),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          _searchQuery = value;
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  DropdownButton<String>(
                                    value: _selectedRoleId,
                                    hint: const Text('Filter by Role'),
                                    items: [
                                      const DropdownMenuItem(
                                        value: null,
                                        child: Text('All Roles'),
                                      ),
                                      ...rolesState.roles.map((role) {
                                        return DropdownMenuItem(
                                          value: role.id,
                                          child: Text(role.name),
                                        );
                                      }),
                                    ],
                                    onChanged: (roleId) {
                                      setState(() {
                                        _selectedRoleId = roleId;
                                      });
                                    },
                                  ),
                                  const SizedBox(width: 16),
                                  BlocBuilder<DepartmentsBloc, DepartmentsState>(
                                    builder: (context, state) {
                                      if (state is DepartmentsLoaded) {
                                        return DropdownButton<String>(
                                          value: _selectedDepartmentId,
                                          hint: const Text('Department'),
                                          items: [
                                            const DropdownMenuItem(
                                              value: null,
                                              child: Text('All Departments'),
                                            ),
                                            ...state.departments.map((department) {
                                              return DropdownMenuItem(
                                                value: department.id,
                                                child: Text(department.name),
                                              );
                                            }),
                                          ],
                                          onChanged: (value) {
                                            setState(() {
                                              _selectedDepartmentId = value;
                                            });
                                          },
                                        );
                                      }
                                      return const SizedBox.shrink();
                                    },
                                  ),
                                  const SizedBox(width: 16),
                                  SizedBox(
                                    width: 250, // Fixed width for the checkbox
                                    child: CheckboxListTile(
                                      dense: true,
                                      title: const Text(
                                        'Show only active employees',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      value: _showOnlyActiveEmployees,
                                      onChanged: (value) {
                                        setState(() {
                                          _showOnlyActiveEmployees = value ?? false;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverGrid(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          mainAxisExtent: 220,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final employee = filteredEmployees[index];
                            return EmployeeCard(
                              employee: employee,
                              onEdit: () => _showEditEmployeeDialog(
                                context,
                                employee,
                                authState.employee,
                              ),
                              onDelete: () => _showDeleteConfirmationDialog(
                                context,
                                employee,
                              ),
                              onView: () {
                                final state = PersistentShell.of(context);
                                if (state != null) {
                                  state.setCustomPage(
                                    MultiBlocProvider(
                                      providers: [
                                        BlocProvider.value(
                                          value: context.read<EmployeesBloc>(),
                                        ),
                                        BlocProvider.value(
                                          value: context.read<DepartmentsBloc>(),
                                        ),
                                        RepositoryProvider.value(
                                          value: context.read<EmployeesRepository>(),
                                        ),
                                      ],
                                      child: EmployeeDetailsPage(
                                        employee: employee,
                                        onEdit: () {
                                          state.clearCustomPage();
                                          _showEditEmployeeDialog(
                                            context,
                                            employee,
                                            authState.employee,
                                          );
                                        },
                                        onDelete: () {
                                          state.clearCustomPage();
                                          _showDeleteConfirmationDialog(
                                            context,
                                            employee,
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                }
                              },
                            );
                          },
                          childCount: filteredEmployees.length,
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showAddEmployeeDialog(BuildContext context, Employee currentEmployee) {
    showDialog(
      context: context,
      builder: (dialogContext) => MultiBlocProvider(
        providers: [
          BlocProvider.value(
            value: context.read<EmployeesBloc>(),
          ),
          BlocProvider.value(
            value: context.read<RolesBloc>(),
          ),
        ],
        child: EmployeeFormDialog(
          companyId: currentEmployee.companyId!,
          companyName: currentEmployee.companyName!,
        ),
      ),
    ).then((result) {
      if (result != null) {
        final Map<String, dynamic> data = result as Map<String, dynamic>;
        context.read<EmployeesBloc>().add(
          AddEmployee(
            data['employee'] as Employee,
            data['password'] as String,
          ),
        );
      }
    });
  }

  void _showEditEmployeeDialog(
    BuildContext context,
    Employee employee,
    Employee currentEmployee,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => MultiBlocProvider(
        providers: [
          BlocProvider.value(
            value: context.read<EmployeesBloc>(),
          ),
          BlocProvider.value(
            value: context.read<RolesBloc>(),
          ),
        ],
        child: EmployeeFormDialog(
          employee: employee,
          companyId: currentEmployee.companyId!,
          companyName: currentEmployee.companyName!,
        ),
      ),
    ).then((result) {
      if (result != null) {
        final employee = result as Employee;
        context.read<EmployeesBloc>().add(UpdateEmployee(employee));
      }
    });
  }

  void _showDeleteConfirmationDialog(BuildContext context, Employee employee) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.warning_amber_rounded, size: 48),
        title: const Text('Delete Employee'),
        content: Text('Are you sure you want to delete ${employee.firstName} ${employee.lastName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              context.read<EmployeesBloc>().add(
                DeleteEmployee(employee.companyId!, employee.id!),
              );
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

}

class EmployeeCard extends StatelessWidget {
  final Employee employee;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onView;

  const EmployeeCard({
    super.key,
    required this.employee,
    this.onEdit,
    this.onDelete,
    this.onView,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Generate a consistent color based on the employee's name
    final employeeColor = _generateColorFromName(employee.firstName);
    final isActive = employee.isActive;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isActive 
            ? employeeColor.withOpacity(0.3) 
            : colorScheme.error.withOpacity(0.3),
          width: 1,
        ),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              employeeColor.withOpacity(0.05),
              employeeColor.withOpacity(0.02),
            ],
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onView,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with Name and Actions
                  Row(
                    children: [
                      // Circular Avatar with Active/Inactive Indicator
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: employeeColor.withOpacity(0.2),
                            child: Text(
                              (employee.firstName[0] + employee.lastName[0]).toUpperCase(),
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: employeeColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isActive 
                                  ? Colors.green 
                                  : colorScheme.error,
                                border: Border.all(
                                  color: Colors.white, 
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      
                      // Name and Department
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${employee.firstName} ${employee.lastName}',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isActive 
                                  ? colorScheme.onSurface 
                                  : colorScheme.onSurface.withOpacity(0.6),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              employee.departmentName ?? 'Unassigned',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: isActive 
                                  ? colorScheme.onSurfaceVariant 
                                  : colorScheme.onSurfaceVariant.withOpacity(0.6),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      
                      // Action Buttons
                      IconButton(
                        icon: Icon(
                          Icons.edit_outlined, 
                          size: 24, 
                          color: isActive 
                            ? colorScheme.primary 
                            : colorScheme.primary.withOpacity(0.4),
                        ),
                        onPressed: isActive ? onEdit : null,
                        tooltip: 'Edit',
                        visualDensity: VisualDensity.compact,
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete_outline, 
                          size: 24, 
                          color: isActive 
                            ? colorScheme.error 
                            : colorScheme.error.withOpacity(0.4),
                        ),
                        onPressed: isActive ? onDelete : null,
                        tooltip: 'Delete',
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                  
                  const Divider(height: 24, thickness: 0.5),
                  
                  // Employee Details
                  Row(
                    children: [
                      Expanded(
                        child: _buildDetailChip(
                          context, 
                          icon: Icons.work_outline, 
                          text: employee.role?.name ?? 'No Role',
                          color: employeeColor,
                          isActive: isActive,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildDetailChip(
                          context, 
                          icon: Icons.email_outlined, 
                          text: employee.email,
                          color: employeeColor,
                          isActive: isActive,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildDetailChip(
                    context, 
                    icon: Icons.phone_outlined, 
                    text: employee.phone ?? 'No Phone',
                    color: employeeColor,
                    fullWidth: true,
                    isActive: isActive,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailChip(
    BuildContext context, {
    required IconData icon,
    required String text,
    required Color color,
    bool fullWidth = false,
    bool isActive = true,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: fullWidth ? double.infinity : null,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(isActive ? 0.1 : 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(isActive ? 0.2 : 0.1),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
        children: [
          Icon(
            icon, 
            size: 18, 
            color: isActive 
              ? color 
              : color.withOpacity(0.4),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodySmall?.copyWith(
                color: isActive 
                  ? colorScheme.onSurfaceVariant 
                  : colorScheme.onSurfaceVariant.withOpacity(0.6),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Color _generateColorFromName(String name) {
    // Generate a consistent color based on the name
    final hash = name.hashCode;
    return Color.fromRGBO(
      (hash & 0xFF0000) >> 16,
      (hash & 0x00FF00) >> 8,
      hash & 0x0000FF,
      0.8,
    );
  }
}

class EmployeeFormDialog extends StatefulWidget {
  final String companyId;
  final String companyName;
  final Employee? employee;

  const EmployeeFormDialog({
    super.key,
    required this.companyId,
    required this.companyName,
    this.employee,
  });

  @override
  State<EmployeeFormDialog> createState() => _EmployeeFormDialogState();
}

class _EmployeeFormDialogState extends State<EmployeeFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  DateTime? _joiningDate;
  String? _selectedDepartmentId;
  String? _selectedRoleId;
  String? _selectedRoleName;
  bool _isSubmitting = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    final employee = widget.employee;
    if (employee != null) {
      _firstNameController.text = employee.firstName;
      _lastNameController.text = employee.lastName;
      _emailController.text = employee.email;
      _phoneController.text = employee.phone ?? '';
      _addressController.text = employee.address ?? '';
      _joiningDate = employee.joiningDate;
      _selectedDepartmentId = employee.departmentId;
      _selectedRoleId = employee.role?.id;
      _selectedRoleName = employee.role?.name;
    }

    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      context.read<RolesBloc>().add(LoadRoles(authState.employee.companyId!));
      context.read<DepartmentsBloc>().add(LoadDepartments(authState.employee.companyId!));
    }
  }

  void _initializeRoleIfNeeded(List<role_entity.Role> roles) {
    if (!_isInitialized) {
      final activeRoles = roles.where((role) => role.isActive).toList();
      
      if (widget.employee != null && _selectedRoleId != null) {
        // For existing employee, ensure their role is in the list
        final currentRole = roles.firstWhere(
          (role) => role.id == _selectedRoleId,
          orElse: () => activeRoles.first,
        );
        _selectedRoleId = currentRole.id;
        _selectedRoleName = currentRole.name;
      } else if (activeRoles.isNotEmpty) {
        // For new employee, select first active role
        _selectedRoleId = activeRoles.first.id;
        _selectedRoleName = activeRoles.first.name;
      }
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = context.read<AuthBloc>().state;
    if (authState is! Authenticated) return const SizedBox.shrink();

    return Dialog(
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  widget.employee == null ? 'Add Employee' : 'Edit Employee',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _firstNameController,
                        decoration: const InputDecoration(
                          labelText: 'First Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter first name';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _lastNameController,
                        decoration: const InputDecoration(
                          labelText: 'Last Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter last name';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Phone',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _addressController,
                        decoration: const InputDecoration(
                          labelText: 'Address',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: BlocBuilder<DepartmentsBloc, DepartmentsState>(
                        builder: (context, state) {
                          if (state is DepartmentsLoading) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (state is DepartmentsLoaded) {
                            final departments = state.departments;
                            if (departments.isEmpty) {
                              return const Text('No departments available');
                            }
                            return DropdownButtonFormField<String>(
                              value: _selectedDepartmentId,
                              decoration: const InputDecoration(
                                labelText: 'Department',
                                border: OutlineInputBorder(),
                              ),
                              items: departments.map((dept) {
                                return DropdownMenuItem(
                                  value: dept.id,
                                  child: Text(dept.name),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedDepartmentId = value;
                                });
                              },
                            );
                          }
                          if (state is DepartmentsError) {
                            return Text('Error: ${state.message}');
                          }
                          return const Text('No departments available');
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: BlocBuilder<RolesBloc, RolesState>(
                        builder: (context, state) {
                          if (state is RolesLoading) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (state is RolesLoaded) {
                            final roles = state.roles;
                            if (roles.isEmpty) {
                              return const Text('No roles available');
                            }

                            final activeRoles = roles.where((role) => role.isActive).toList();
                            
                            // Initialize role selection if needed
                            if (!_isInitialized) {
                              _initializeRoleIfNeeded(roles);
                              return const Center(child: CircularProgressIndicator());
                            }

                            // Ensure selected role exists in dropdown items
                            if (_selectedRoleId != null) {
                              final roleExists = activeRoles.any((role) => role.id == _selectedRoleId);
                              if (!roleExists) {
                                // Add current role to active roles if it exists
                                final currentRole = roles.firstWhere(
                                  (role) => role.id == _selectedRoleId,
                                  orElse: () => activeRoles.first,
                                );
                                if (!activeRoles.contains(currentRole)) {
                                  activeRoles.add(currentRole);
                                }
                              }
                            }

                            return DropdownButtonFormField<String>(
                              value: _selectedRoleId,
                              decoration: const InputDecoration(
                                labelText: 'Role',
                                border: OutlineInputBorder(),
                              ),
                              items: activeRoles.map((role) {
                                return DropdownMenuItem<String>(
                                  value: role.id,
                                  child: Text(role.name),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  final selectedRole = roles.firstWhere(
                                    (role) => role.id == value,
                                  );
                                  setState(() {
                                    _selectedRoleId = value;
                                    _selectedRoleName = selectedRole.name;
                                  });
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a role';
                                }
                                return null;
                              },
                            );
                          }
                          return const Text('Error loading roles');
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: Text(
                    'Joining Date',
                    style: theme.textTheme.titleMedium,
                  ),
                  subtitle: Text(
                    _joiningDate != null
                        ? DateFormat('MMM dd, yyyy').format(_joiningDate!)
                        : 'Not set',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _joiningDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (date != null) {
                        setState(() {
                          _joiningDate = date;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _isSubmitting
                          ? null
                          : () {
                              Navigator.of(context).pop();
                            },
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 16),
                    FilledButton(
                      onPressed: _isSubmitting ? null : _submit,
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              widget.employee == null ? 'Add Employee' : 'Save Changes',
                            ),
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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedRoleId == null) return;

    setState(() {
      _isSubmitting = true;
    });

    final authState = context.read<AuthBloc>().state;
    if (authState is! Authenticated) return;

    final employee = Employee(
      id: widget.employee?.id,
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      address: _addressController.text,
      role: role_entity.Role(
        id: _selectedRoleId ?? '',
        name: _selectedRoleName ?? '',
        description: 'Employee Role', // Add default description
        organizationId: authState.employee.companyId ?? '',
        type: role_entity.RoleType.global, // Use global instead of custom
        hierarchy: role_entity.DepartmentHierarchy.member, // Use member as default
      ),
      departmentId: _selectedDepartmentId,
      companyId: authState.employee.companyId,
      companyName: authState.employee.companyName,
      joiningDate: _joiningDate ?? DateTime.now(),
    );

    if (widget.employee == null) {
      context.read<EmployeesBloc>().add(AddEmployee(employee, _emailController.text));
    } else {
      context.read<EmployeesBloc>().add(UpdateEmployee(employee));
    }

    setState(() {
      _isSubmitting = false;
    });

    if (mounted) {
      Navigator.of(context).pop({'employee': employee, 'password': _emailController.text});
    }
  }
}

class CreateDepartmentDialog extends StatefulWidget {
  final String organizationId;

  const CreateDepartmentDialog({
    Key? key, 
    required this.organizationId
  }) : super(key: key);

  @override
  _CreateDepartmentDialogState createState() => _CreateDepartmentDialogState();
}

class _CreateDepartmentDialogState extends State<CreateDepartmentDialog> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _createDepartment() {
    if (_formKey.currentState?.validate() ?? false) {
      final newDepartment = department_entity.Department(
        id: const Uuid().v4(), // Generate a unique ID
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        organizationId: widget.organizationId,
        createdAt: DateTime.now(),
      );

      // Dispatch add department event
      context.read<DepartmentsBloc>().add(AddDepartment(newDepartment));
      
      // Close the dialog
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create New Department'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Department Name',
                hintText: 'e.g., Engineering, Sales, Marketing',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a department name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Department Description',
                hintText: 'Optional description of the department',
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _createDepartment,
          child: const Text('Create Department'),
        ),
      ],
    );
  }
}

class _ManageEmployeeRoleDialog extends StatefulWidget {
  final Employee employee;

  const _ManageEmployeeRoleDialog({
    required this.employee,
  });

  @override
  State<_ManageEmployeeRoleDialog> createState() => _ManageEmployeeRoleDialogState();
}

class _ManageEmployeeRoleDialogState extends State<_ManageEmployeeRoleDialog> {
  String? _selectedDepartmentId;
  String? _selectedRoleId;
  role_entity.Role? _selectedRole;
  department_entity.Department? _selectedDepartment;

  @override
  void initState() {
    super.initState();
    _selectedDepartmentId = widget.employee.departmentId;
    // Load departments and roles
    context.read<DepartmentsBloc>().add(LoadDepartments(widget.employee.companyId ?? ''));
    context.read<RolesBloc>().add(LoadRoles(widget.employee.companyId ?? ''));
    
    // Defer setting the initial role ID to ensure roles are loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final rolesState = context.read<RolesBloc>().state;
      if (rolesState is RolesLoaded) {
        final roleExists = rolesState.roles.any((r) => r.id == widget.employee.role?.id);
        if (roleExists) {
          setState(() {
            _selectedRoleId = widget.employee.role?.id;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Manage Role & Department'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Department Selection
            BlocBuilder<DepartmentsBloc, DepartmentsState>(
              builder: (context, state) {
                if (state is DepartmentsLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is DepartmentsLoaded) {
                  final departments = state.departments;
                  if (departments.isEmpty) {
                    return const Text('No departments available');
                  }
                  return DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Department',
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedDepartmentId,
                    items: departments.map((dept) {
                      return DropdownMenuItem(
                        value: dept.id,
                        child: Text(dept.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedDepartmentId = value;
                        _selectedDepartment = state.departments
                            .firstWhere((dept) => dept.id == value);
                        // Reset role when department changes
                        _selectedRoleId = null;
                        _selectedRole = null;
                      });
                    },
                  );
                }
                if (state is DepartmentsError) {
                  return Text('Error: ${state.message}');
                }
                return const SizedBox.shrink();
              },
            ),
            const SizedBox(height: 16),
            // Role Selection
            BlocBuilder<RolesBloc, RolesState>(
              builder: (context, state) {
                if (state is RolesLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is RolesLoaded) {
                  final roles = state.roles;
                  if (roles.isEmpty) {
                    return const Text('No roles available');
                  }
                  
                  // Filter roles based on selected department
                  final availableRoles = state.roles.where((role) {
                    if (_selectedDepartmentId == null) return true;
                    return role.departmentId == null || 
                           role.departmentId == _selectedDepartmentId;
                  }).toList();

                  // Validate current selection
                  if (_selectedRoleId != null) {
                    final roleExists = availableRoles.any((r) => r.id == _selectedRoleId);
                    if (!roleExists) {
                      _selectedRoleId = null;
                    }
                  }

                  return DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Role',
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedRoleId,
                    items: availableRoles.map((role) {
                      return DropdownMenuItem(
                        value: role.id,
                        child: Text(role.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedRoleId = value;
                        _selectedRole = state.roles
                            .firstWhere((role) => role.id == value);
                      });
                    },
                  );
                }
                if (state is RolesError) {
                  return Text('Error: ${state.message}');
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _selectedRole == null ? null : () {
            context.read<EmployeesBloc>().add(
              UpdateEmployeeRole(
                widget.employee,
                _selectedRole!,
                context.read<AuthBloc>().state is Authenticated
                    ? (context.read<AuthBloc>().state as Authenticated).employee.id!
                    : 'unknown',
                newDepartmentId: _selectedDepartmentId,
                newDepartmentName: _selectedDepartment?.name,
              ),
            );
            Navigator.pop(context);
          },
          child: const Text('Update'),
        ),
      ],
    );
  }
}
