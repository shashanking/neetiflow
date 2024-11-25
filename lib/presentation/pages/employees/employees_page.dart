import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neetiflow/domain/entities/employee.dart';
import 'package:neetiflow/presentation/blocs/auth/auth_bloc.dart';
import 'package:neetiflow/presentation/blocs/employees/employees_bloc.dart';
import 'package:neetiflow/presentation/widgets/page_wrapper.dart';
import 'package:intl/intl.dart';
import 'package:neetiflow/presentation/pages/employees/employee_details_page.dart';
import 'package:neetiflow/infrastructure/repositories/firebase_employees_repository.dart';

class EmployeesPage extends StatefulWidget {
  const EmployeesPage({super.key});

  @override
  State<EmployeesPage> createState() => _EmployeesPageState();
}

class _EmployeesPageState extends State<EmployeesPage> {
  final _searchController = TextEditingController();
  EmployeeRole? _selectedRole;
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Employee> _filterEmployees(List<Employee> employees) {
    return employees.where((employee) {
      final matchesSearch = _searchQuery.isEmpty ||
          employee.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          employee.email.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (employee.phone?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);

      final matchesRole = _selectedRole == null || employee.role == _selectedRole;

      return matchesSearch && matchesRole;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    if (authState is! Authenticated) {
      return const Center(child: Text('Not authenticated'));
    }

    return BlocProvider(
      create: (context) => EmployeesBloc(
        employeesRepository: FirebaseEmployeesRepository(),
      )..add(LoadEmployees(authState.employee.companyId!)),
      child: BlocBuilder<EmployeesBloc, EmployeesState>(
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

          return BlocListener<EmployeesBloc, EmployeesState>(
            listener: (context, state) {
              if (state is EmployeeOperationSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              } else if (state is EmployeesError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              }
            },
            child: Builder(
              builder: (context) {
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
                              LoadEmployees(authState.employee.companyId!),
                            );
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (employeesList.isEmpty) {
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

                final filteredEmployees = _filterEmployees(employeesList);
                final roleStats = _getRoleStats(employeesList);

                return Scaffold(
                  appBar: AppBar(
                    title: const Text('Employees'),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: FilledButton.icon(
                          onPressed: () => _showAddEmployeeDialog(context, authState.employee),
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
                  body: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              // Search and Filter
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                                  borderRadius: BorderRadius.circular(12),
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
                                          PopupMenuButton<EmployeeRole?>(
                                            tooltip: 'Filter by role',
                                            icon: Icon(
                                              Icons.filter_list,
                                              color: _selectedRole != null
                                                  ? Theme.of(context).colorScheme.primary
                                                  : null,
                                            ),
                                            itemBuilder: (context) => [
                                              const PopupMenuItem(
                                                value: null,
                                                child: Text('All Roles'),
                                              ),
                                              ...EmployeeRole.values.map((role) {
                                                return PopupMenuItem(
                                                  value: role,
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        role == EmployeeRole.admin
                                                            ? Icons.admin_panel_settings
                                                            : role == EmployeeRole.manager
                                                                ? Icons.manage_accounts
                                                                : Icons.person,
                                                        size: 20,
                                                        color: _selectedRole == role
                                                            ? Theme.of(context).colorScheme.primary
                                                            : null,
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Text(
                                                        role.toString().split('.').last,
                                                        style: TextStyle(
                                                          color: _selectedRole == role
                                                              ? Theme.of(context).colorScheme.primary
                                                              : null,
                                                          fontWeight: _selectedRole == role
                                                              ? FontWeight.bold
                                                              : null,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }),
                                            ],
                                            onSelected: (role) {
                                              setState(() {
                                                _selectedRole = role;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                      if (_searchQuery.isNotEmpty || _selectedRole != null) ...[
                                        const SizedBox(height: 16),
                                        Wrap(
                                          spacing: 8,
                                          children: [
                                            if (_searchQuery.isNotEmpty)
                                              Chip(
                                                label: Text('Search: $_searchQuery'),
                                                onDeleted: () {
                                                  setState(() {
                                                    _searchQuery = '';
                                                    _searchController.clear();
                                                  });
                                                },
                                              ),
                                            if (_selectedRole != null)
                                              Chip(
                                                label: Text('Role: ${_selectedRole.toString().split('.').last}'),
                                                onDeleted: () {
                                                  setState(() {
                                                    _selectedRole = null;
                                                  });
                                                },
                                              ),
                                          ],
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Stats Cards
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Employee Statistics',
                                        style: Theme.of(context).textTheme.titleLarge,
                                      ),
                                      const SizedBox(height: 16),
                                      LayoutBuilder(
                                        builder: (context, constraints) {
                                          final isSmallScreen = constraints.maxWidth < 600;
                                          final stats = [
                                            _StatCard(
                                              icon: Icons.people,
                                              title: 'Total',
                                              value: roleStats['total'].toString(),
                                            ),
                                            _StatCard(
                                              icon: Icons.admin_panel_settings,
                                              title: 'Admins',
                                              value: roleStats['admin'].toString(),
                                            ),
                                            _StatCard(
                                              icon: Icons.manage_accounts,
                                              title: 'Managers',
                                              value: roleStats['manager'].toString(),
                                            ),
                                            _StatCard(
                                              icon: Icons.work,
                                              title: 'Employees',
                                              value: roleStats['employee'].toString(),
                                            ),
                                          ];

                                          return isSmallScreen
                                              ? Column(
                                                  children: stats
                                                      .map((stat) => Padding(
                                                            padding: const EdgeInsets.only(bottom: 16),
                                                            child: stat,
                                                          ))
                                                      .toList(),
                                                )
                                              : Row(
                                                  children: stats
                                                      .map((stat) => Expanded(child: Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 8),
                                                            child: stat,
                                                          )))
                                                      .toList(),
                                                );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Employee Grid
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        sliver: SliverLayoutBuilder(
                          builder: (context, constraints) {
                            final width = constraints.crossAxisExtent;
                            final crossAxisCount = width < 600
                                ? 1
                                : width < 900
                                    ? 2
                                    : width < 1200
                                        ? 3
                                        : 4;

                            if (filteredEmployees.isEmpty) {
                              return SliverToBoxAdapter(
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(32),
                                    child: Column(
                                      children: [
                                        const Icon(
                                          Icons.search_off,
                                          size: 48,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          'No employees found matching your search',
                                          style: Theme.of(context).textTheme.titleMedium,
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }

                            return SliverGrid(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                                mainAxisExtent: 220,
                              ),
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final employee = filteredEmployees[index];
                                  return EmployeeCard(
                                    employee: employee,
                                    onTap: () async {
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EmployeeDetailsPage(
                                            employee: employee,
                                          ),
                                        ),
                                      );

                                      if (result == 'edit') {
                                        _showEditEmployeeDialog(
                                          context,
                                          employee,
                                          authState.employee,
                                        );
                                      } else if (result == 'delete') {
                                        _showDeleteConfirmationDialog(
                                          context,
                                          employee,
                                        );
                                      }
                                    },
                                    onEdit: () => _showEditEmployeeDialog(
                                      context,
                                      employee,
                                      authState.employee,
                                    ),
                                    onDelete: () => _showDeleteConfirmationDialog(
                                      context,
                                      employee,
                                    ),
                                  );
                                },
                                childCount: filteredEmployees.length,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Map<String, int> _getRoleStats(List<Employee> employees) {
    final stats = {
      'total': employees.length,
      'admin': 0,
      'manager': 0,
      'employee': 0,
    };

    for (final employee in employees) {
      switch (employee.role) {
        case EmployeeRole.admin:
          stats['admin'] = (stats['admin'] ?? 0) + 1;
          break;
        case EmployeeRole.manager:
          stats['manager'] = (stats['manager'] ?? 0) + 1;
          break;
        case EmployeeRole.employee:
          stats['employee'] = (stats['employee'] ?? 0) + 1;
          break;
      }
    }

    return stats;
  }

  void _showAddEmployeeDialog(BuildContext context, Employee currentEmployee) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<EmployeesBloc>(),
        child: EmployeeFormDialog(
          companyId: currentEmployee.companyId!,
          companyName: currentEmployee.companyName!,
        ),
      ),
    ).then((result) {
      if (result != null) {
        final Map<String, dynamic> data = result as Map<String, dynamic>;
        context.read<EmployeesBloc>().add(
          AddEmployee(data['employee'] as Employee, data['password'] as String),
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
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<EmployeesBloc>(),
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
        content: Text('Are you sure you want to delete ${employee.name}?'),
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

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.primaryContainer,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 32,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class EmployeeCard extends StatelessWidget {
  final Employee employee;
  final VoidCallback? onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const EmployeeCard({
    super.key,
    required this.employee,
    this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Hero(
                        tag: 'employee_avatar_${employee.id}',
                        child: CircleAvatar(
                          radius: 24,
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          child: Text(
                            employee.name[0].toUpperCase(),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Hero(
                              tag: 'employee_name_${employee.id}',
                              child: Text(
                                employee.name,
                                style: Theme.of(context).textTheme.titleLarge,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                employee.role.toString().split('.').last.toUpperCase(),
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  _InfoRow(
                    icon: Icons.email_outlined,
                    text: employee.email,
                  ),
                  if (employee.phone != null && employee.phone!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    _InfoRow(
                      icon: Icons.phone_outlined,
                      text: employee.phone!,
                    ),
                  ],
                  const SizedBox(height: 8),
                  _InfoRow(
                    icon: Icons.calendar_today_outlined,
                    text: employee.joiningDate != null
                        ? 'Joined: ${DateFormat('MMM d, y').format(employee.joiningDate!)}'
                        : 'No joining date',
                  ),
                ],
              ),
            ),
            if (employee.role != EmployeeRole.admin)
              Positioned(
                top: 8,
                right: 8,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton.filled(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit_outlined, size: 20),
                      tooltip: 'Edit Employee',
                      style: IconButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        minimumSize: const Size(36, 36),
                        padding: const EdgeInsets.all(8),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filled(
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete_outline, size: 20),
                      tooltip: 'Delete Employee',
                      style: IconButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.error.withOpacity(0.1),
                        foregroundColor: Theme.of(context).colorScheme.error,
                        minimumSize: const Size(36, 36),
                        padding: const EdgeInsets.all(8),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
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
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();
  DateTime? _joiningDate;
  EmployeeRole _selectedRole = EmployeeRole.employee;
  bool _isActive = true;
  bool _isPasswordVisible = false;
  Timer? _emailDebounce;

  @override
  void initState() {
    super.initState();
    if (widget.employee != null) {
      _nameController.text = widget.employee!.name;
      _emailController.text = widget.employee!.email;
      _phoneController.text = widget.employee!.phone ?? '';
      _addressController.text = widget.employee!.address ?? '';
      _selectedRole = widget.employee!.role;
      _joiningDate = widget.employee!.joiningDate;
      _isActive = widget.employee!.isActive;
    }

    _emailController.addListener(_onEmailChanged);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    _emailDebounce?.cancel();
    super.dispose();
  }

  void _onEmailChanged() {
    if (_emailDebounce?.isActive ?? false) _emailDebounce!.cancel();
    
    final email = _emailController.text.trim();
    print('Email changed to: $email'); // Debug log
    
    if (email.isEmpty) {
      print('Email is empty, clearing validation state'); // Debug log
      if (mounted) {
        setState(() {});
      }
      return;
    }
    
    _emailDebounce = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      if (email.contains('@')) {
        print('Debounce complete, checking email: $email'); // Debug log
        context.read<EmployeesBloc>().add(CheckEmailAvailability(email));
      } else {
        print('Invalid email format: $email'); // Debug log
      }
    });
  }

  String? _getEmailErrorText(String email, EmployeesState state) {
    print('Getting error text for email: $email, state: $state');
    if (state is EmployeesEmailError) {
      return state.message;
    } else if (state is EmailAvailabilityChecked) {
      return !state.isAvailable ? 'Email is already in use' : null;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditing = widget.employee != null;

    return BlocListener<EmployeesBloc, EmployeesState>(
      listener: (context, state) {
        if (state is EmployeeOperationSuccess) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is EmployeesError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: theme.colorScheme.error,
            ),
          );
        }
      },
      child: Dialog(
        child: PopScope(
          onPopInvoked: (didPop) {
            if (didPop) {
              context.read<EmployeesBloc>().add(LoadEmployees(widget.companyId));
            }
          },
          child: Container(
            width: 500,
            constraints: const BoxConstraints(maxHeight: 700),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(28),
                      topRight: Radius.circular(28),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isEditing ? 'Edit Employee' : 'Add Employee',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isEditing ? 'Update employee information' : 'Enter employee details',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Basic Information',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'Full Name',
                              hintText: 'Enter employee name',
                              prefixIcon: const Icon(Icons.person_outline),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter employee name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          BlocBuilder<EmployeesBloc, EmployeesState>(
                            builder: (context, state) {
                              final email = _emailController.text.trim();
                              final errorText = _getEmailErrorText(email, state);
                              final isChecking = state is EmployeesLoading;
                              final isChecked = state is EmailAvailabilityChecked && 
                                  state.email == email;
                              final isAvailable = isChecked && state.isAvailable;
                              
                              return TextFormField(
                                controller: _emailController,
                                enabled: !isChecking,
                                onChanged: (_) => _onEmailChanged(),
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  hintText: 'Enter employee email',
                                  prefixIcon: const Icon(Icons.email_outlined),
                                  suffixIcon: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (email.isNotEmpty)
                                        IconButton(
                                          icon: const Icon(Icons.clear),
                                          onPressed: () {
                                            _emailController.clear();
                                            _onEmailChanged();
                                          },
                                          tooltip: 'Clear email',
                                        ),
                                      if (isChecking)
                                        const Padding(
                                          padding: EdgeInsets.all(12.0),
                                          child: SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          ),
                                        )
                                      else if (isChecked)
                                        Padding(
                                          padding: const EdgeInsets.only(right: 12.0),
                                          child: Icon(
                                            isAvailable
                                                ? Icons.check_circle_outline
                                                : Icons.error_outline,
                                            color: isAvailable
                                                ? theme.colorScheme.primary
                                                : theme.colorScheme.error,
                                          ),
                                        ),
                                    ],
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  errorText: errorText,
                                  helperText: isChecking 
                                      ? 'Checking email availability...'
                                      : isAvailable
                                          ? 'Email is available'
                                          : null,
                                  helperStyle: TextStyle(
                                    color: isAvailable
                                        ? theme.colorScheme.primary
                                        : null,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter employee email';
                                  }
                                  if (!value.contains('@')) {
                                    return 'Please enter a valid email';
                                  }
                                  if (errorText != null) {
                                    return errorText;
                                  }
                                  if (!isChecked || !isAvailable) {
                                    return 'Please wait for email availability check';
                                  }
                                  return null;
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _phoneController,
                            decoration: InputDecoration(
                              labelText: 'Phone',
                              hintText: 'Enter employee phone',
                              prefixIcon: const Icon(Icons.phone_outlined),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter employee phone number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _addressController,
                            maxLines: 2,
                            decoration: InputDecoration(
                              labelText: 'Address (Optional)',
                              hintText: 'Enter employee address',
                              prefixIcon: const Icon(Icons.location_on_outlined),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              alignLabelWithHint: true,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Additional Information',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (!isEditing) ...[
                            TextFormField(
                              controller: _passwordController,
                              obscureText: !_isPasswordVisible,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                hintText: 'Enter employee password',
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPasswordVisible
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                          ],
                          // Employment Details
                          Text(
                            'Employment Details',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          InkWell(
                            onTap: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: _joiningDate ?? DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime.now(),
                              );
                              if (date != null) {
                                setState(() {
                                  _joiningDate = date;
                                });
                              }
                            },
                            child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: 'Joining Date',
                                prefixIcon: const Icon(Icons.calendar_today_outlined),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                _joiningDate != null
                                    ? DateFormat('MMMM d, y').format(_joiningDate!)
                                    : 'Select date',
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'Role',
                              prefixIcon: Icon(
                                _selectedRole == EmployeeRole.admin
                                    ? Icons.admin_panel_settings
                                    : _selectedRole == EmployeeRole.manager
                                        ? Icons.manage_accounts
                                        : Icons.work,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: DropdownButton<EmployeeRole>(
                              value: _selectedRole,
                              isExpanded: true,
                              underline: const SizedBox.shrink(),
                              items: EmployeeRole.values.map((role) {
                                return DropdownMenuItem(
                                  value: role,
                                  child: Text(role.toString().split('.').last),
                                );
                              }).toList(),
                              onChanged: (role) {
                                if (role != null) {
                                  setState(() {
                                    _selectedRole = role;
                                  });
                                }
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                          SwitchListTile(
                            title: const Text('Active Status'),
                            subtitle: Text(_isActive ? 'Employee is active' : 'Employee is inactive'),
                            value: _isActive,
                            onChanged: (value) {
                              setState(() {
                                _isActive = value;
                              });
                            },
                            secondary: Icon(
                              _isActive ? Icons.check_circle_outline : Icons.cancel_outlined,
                              color: _isActive ? theme.colorScheme.primary : theme.colorScheme.error,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 16),
                      FilledButton.icon(
                        onPressed: _submit,
                        icon: Icon(isEditing ? Icons.save : Icons.add),
                        label: Text(isEditing ? 'Save Changes' : 'Add Employee'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final employee = Employee(
        id: widget.employee?.id,
        companyId: widget.companyId,
        companyName: widget.companyName,
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
        role: _selectedRole,
        joiningDate: _joiningDate,
        isActive: _isActive,
      );

      if (widget.employee != null) {
        Navigator.pop(context, {'employee': employee});
      } else {
        Navigator.pop(context, {
          'employee': employee,
          'password': _passwordController.text,
        });
      }
    }
  }
}
