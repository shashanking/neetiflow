import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neetiflow/domain/repositories/roles_repository.dart';
import 'package:neetiflow/domain/repositories/departments_repository.dart';
import 'package:neetiflow/presentation/blocs/auth/auth_bloc.dart';
import 'package:neetiflow/presentation/blocs/departments/departments_bloc.dart';
import 'package:neetiflow/presentation/blocs/roles/roles_bloc.dart';
import 'package:neetiflow/presentation/widgets/employee_management/roles_tab.dart';
import 'package:neetiflow/presentation/pages/employees/employees_page.dart';
import '../../widgets/persistent_shell.dart';

class EmployeeManagementPage extends StatelessWidget {
  const EmployeeManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = context.read<AuthBloc>().state;
    
    if (authState is! Authenticated) {
      return const Center(child: Text('Not authenticated'));
    }

    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Container(
            color: theme.colorScheme.surface,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          final state = PersistentShell.of(context);
                          if (state != null) {
                            state.clearCustomPage();
                          }
                        },
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Employee Management',
                        style: theme.textTheme.headlineSmall,
                      ),
                    ],
                  ),
                ),
                const TabBar(
                  tabs: [
                    Tab(text: 'Departments'),
                    Tab(text: 'Roles'),
                    Tab(text: 'Functions'),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                BlocProvider(
                  create: (context) => DepartmentsBloc(
                    departmentsRepository: context.read<DepartmentsRepository>(),
                  )..add(LoadDepartments(authState.employee.companyId!)),
                  child: _DepartmentsTab(),
                ),
                BlocProvider(
                  create: (context) => RolesBloc(
                    rolesRepository: context.read<RolesRepository>(),
                  )..add(LoadRoles(authState.employee.companyId!)),
                  child: const RolesTab(),
                ),
                _FunctionsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DepartmentsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DepartmentsBloc, DepartmentsState>(
      builder: (context, state) {
        if (state is DepartmentsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is DepartmentsError) {
          return Center(
            child: Text(
              'Error: ${state.message}',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          );
        }

        if (state is DepartmentsLoaded) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Text(
                      'Departments',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    FilledButton.icon(
                      onPressed: () {
                        final authState = context.read<AuthBloc>().state;
                        if (authState is Authenticated && authState.employee.companyId != null) {
                          showDialog(
                            context: context,
                            builder: (context) => CreateDepartmentDialog(
                              organizationId: authState.employee.companyId!,
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Add Department'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.departments.length,
                  itemBuilder: (context, index) {
                    final department = state.departments[index];
                    return Card(
                      child: ListTile(
                        title: Text(department.name),
                        subtitle: Text(department.description),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                // Show edit department dialog
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                // Show delete confirmation dialog
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _RolesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Roles Management Coming Soon'),
    );
  }
}

class _FunctionsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Functions Management Coming Soon'),
    );
  }
}
