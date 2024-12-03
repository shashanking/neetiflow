import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:neetiflow/data/repositories/custom_fields_repository.dart';
import 'package:neetiflow/data/repositories/leads_repository.dart';
import 'package:neetiflow/domain/entities/employee.dart';
import 'package:neetiflow/domain/entities/lead.dart';
import 'package:neetiflow/presentation/blocs/auth/auth_bloc.dart';
import 'package:neetiflow/presentation/blocs/employees/employees_bloc.dart';
import 'package:neetiflow/presentation/blocs/leads/leads_bloc.dart';
import 'package:neetiflow/presentation/blocs/clients/clients_bloc.dart';
import 'package:neetiflow/presentation/widgets/persistent_shell.dart';
import 'package:neetiflow/presentation/widgets/leads/timeline_widget.dart';
import '../../../domain/entities/timeline_event.dart';
import '../clients/clients_page.dart';
import '../employees/employees_page.dart';
import '../leads/leads_page.dart';
import '../operations/operations_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    if (authState is! Authenticated) {
      return const Center(child: Text('Please login to view dashboard'));
    }

    final organizationId = authState.employee.companyId!;
    final leadsRepository = LeadsRepositoryImpl();
    final customFieldsRepository = CustomFieldsRepository(
      organizationId: organizationId,
    );
  
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<LeadsRepository>.value(
          value: leadsRepository,
        ),
        RepositoryProvider<CustomFieldsRepository>.value(
          value: customFieldsRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<LeadsBloc>(
            create: (context) => LeadsBloc(
              leadsRepository: leadsRepository,
              organizationId: organizationId,
            )..add(const LoadLeads()),
          ),
          BlocProvider<ClientsBloc>(
            create: (context) => ClientsBloc()..add(LoadClients()),
          ),
          BlocProvider<EmployeesBloc>(
            create: (context) => GetIt.I.get<EmployeesBloc>()..add(LoadEmployees(organizationId)),
          ),
        ],
        child: _HomePageContent(),
      ),
    );
  }
}

class _HomePageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isCompact = screenWidth < 600;
    final isLargeScreen = screenWidth >= 1200;

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is! Authenticated) {
          return const Center(child: Text('Not authenticated'));
        }

        final employee = state.employee;

        return Scaffold(
          appBar: isCompact ? AppBar(
            title: const Text('Dashboard'),
            automaticallyImplyLeading: true,
            leading: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                PersistentShell.of(context)?.toggleDrawer();
              },
            ),
          ) : null,
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isCompact) ...[
                  Text(
                    'Welcome back, ${employee.firstName}!',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Quick Stats Section
                if (employee.role == EmployeeRole.admin || employee.role == EmployeeRole.manager) ...[
                  Row(
                    children: [
                      Expanded(
                        child: BlocBuilder<EmployeesBloc, EmployeesState>(
                          builder: (context, state) {
                            final count = state is EmployeesLoaded ? state.employees.length.toString() : '0';
                            return _StatCard(
                              icon: Icons.people,
                              title: 'Total Employees',
                              value: count,
                              color: theme.colorScheme.primary,
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: BlocBuilder<LeadsBloc, LeadsState>(
                          builder: (context, state) {
                            final count = state.status == LeadsStatus.success ? state.filteredLeads.length.toString() : '0';
                            return _StatCard(
                              icon: Icons.contacts,
                              title: 'Total Leads',
                              value: count,
                              color: Colors.orange,
                            );
                          },
                        ),
                      ),
                      if (isLargeScreen) ...[
                        const SizedBox(width: 16),
                        Expanded(
                          child: BlocBuilder<LeadsBloc, LeadsState>(
                            builder: (context, state) {
                              final count = state.status == LeadsStatus.success
                                ? state.filteredLeads.where((lead) => lead.status == LeadStatus.hot).length.toString()
                                : '0';
                              return _StatCard(
                                icon: Icons.local_fire_department,
                                title: 'Hot Leads',
                                value: count,
                                color: Colors.red,
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: BlocBuilder<ClientsBloc, ClientsState>(
                            builder: (context, state) {
                              final count = state is ClientsLoaded ? state.clients.length.toString() : '0';
                              return _StatCard(
                                icon: Icons.task_alt,
                                title: 'Converted Leads',
                                value: count,
                                color: Colors.green,
                              );
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 24),
                ],

                // Employee's Personal Stats
                if (employee.role == EmployeeRole.employee) ...[
                  Row(
                    children: [
                      Expanded(
                        child: BlocBuilder<LeadsBloc, LeadsState>(
                          builder: (context, state) {
                            final count = state.status == LeadsStatus.success
                              ? state.filteredLeads.where((lead) => lead.metadata?['assignedEmployeeId'] == employee.id).length.toString()
                              : '0';
                            return _StatCard(
                              icon: Icons.contacts,
                              title: 'My Leads',
                              value: count,
                              color: theme.colorScheme.primary,
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: BlocBuilder<LeadsBloc, LeadsState>(
                          builder: (context, state) {
                            final count = state.status == LeadsStatus.success
                              ? state.filteredLeads.where((lead) => 
                                  lead.status == LeadStatus.hot && 
                                  lead.metadata?['assignedEmployeeId'] == employee.id).length.toString()
                              : '0';
                            return _StatCard(
                              icon: Icons.local_fire_department,
                              title: 'Hot Leads',
                              value: count,
                              color: Colors.red,
                            );
                          },
                        ),
                      ),
                      if (isLargeScreen) ...[
                        const SizedBox(width: 16),
                        Expanded(
                          child: BlocBuilder<LeadsBloc, LeadsState>(
                            builder: (context, state) {
                              final count = state.status == LeadsStatus.success
                                ? state.filteredLeads.where((lead) => 
                                    lead.processStatus == ProcessStatus.inProgress && 
                                    lead.metadata?['assignedEmployeeId'] == employee.id).length.toString()
                                : '0';
                              return _StatCard(
                                icon: Icons.pending_actions,
                                title: 'In Progress',
                                value: count,
                                color: Colors.orange,
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: BlocBuilder<LeadsBloc, LeadsState>(
                            builder: (context, state) {
                              final count = state.status == LeadsStatus.success
                                ? state.filteredLeads.where((lead) => 
                                    lead.processStatus == ProcessStatus.completed && 
                                    lead.metadata?['assignedEmployeeId'] == employee.id).length.toString()
                                : '0';
                              return _StatCard(
                                icon: Icons.task_alt,
                                title: 'Completed',
                                value: count,
                                color: Colors.green,
                              );
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 24),
                ],

                // Quick Actions Section
                Text(
                  'Quick Actions',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: isCompact ? 2 : (isLargeScreen ? 4 : 2),
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: isCompact ? 1.5 : 2,
                  children: [
                    _DashboardCard(
                      title: 'Leads',
                      icon: Icons.contacts_outlined,
                      color: theme.colorScheme.primary,
                      onTap: () {
                        PersistentShell.of(context)?.setCustomPage(const LeadsPage());
                      },
                    ),
                    _DashboardCard(
                      title: 'Clients',
                      icon: Icons.people_outline,
                      color: theme.colorScheme.secondary,
                      onTap: () {
                        PersistentShell.of(context)?.setCustomPage(const ClientsPage());
                      },
                    ),
                    _DashboardCard(
                      title: 'Operations',
                      icon: Icons.business_center_outlined,
                      color: Colors.orange,
                      onTap: () {
                        PersistentShell.of(context)?.setCustomPage(const OperationsPage());
                      },
                    ),
                    _DashboardCard(
                      title: 'Employees',
                      icon: Icons.group_outlined,
                      color: Colors.green,
                      onTap: () {
                        PersistentShell.of(context)?.setCustomPage(const EmployeesPage());
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Recent Activity Section
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tasks Section
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'My Tasks',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (employee.companyId != null) ...[
                            StreamBuilder<List<TimelineEvent>>(
                              stream: context.read<LeadsRepository>().getEmployeeTimelineEvents(
                                employee.companyId!,
                                employee.id!,
                              ),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Center(
                                    child: Text(
                                      'Error loading tasks: ${snapshot.error}',
                                      style: TextStyle(color: theme.colorScheme.error),
                                    ),
                                  );
                                }

                                if (!snapshot.hasData) {
                                  return const Center(child: CircularProgressIndicator());
                                }

                                final events = snapshot.data!
                                    .where((event) => 
                                      event.category == 'lead_assigned' || 
                                      event.category == 'lead_status_changed' ||
                                      event.category == 'task_assigned'
                                    )
                                    .toList();

                                if (events.isEmpty) {
                                  return const Card(
                                    child: Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Center(
                                        child: Text('No pending tasks'),
                                      ),
                                    ),
                                  );
                                }

                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: events.length.clamp(0, 5),
                                  itemBuilder: (context, index) {
                                    final event = events[index];
                                    return Card(
                                      child: ListTile(
                                        leading: Icon(
                                          _getTaskIcon(event.category),
                                          color: _getTaskColor(context, event.category),
                                        ),
                                        title: Text(event.title),
                                        subtitle: Text(event.description),
                                        trailing: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              _formatTimeAgo(event.timestamp),
                                              style: theme.textTheme.bodySmall?.copyWith(
                                                color: theme.colorScheme.onSurface.withOpacity(0.6),
                                              ),
                                            ),
                                            if (event.metadata?['status'] != null) ...[
                                              const SizedBox(height: 4),
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 2,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: _getStatusColor(context, event.metadata!['status']).withOpacity(0.1),
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  event.metadata!['status'].toString().toUpperCase(),
                                                  style: theme.textTheme.bodySmall?.copyWith(
                                                    color: _getStatusColor(context, event.metadata!['status']),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                        onTap: () {
                                          if (event.leadId.isNotEmpty) {
                                            // TODO: Navigate to lead details
                                          }
                                        },
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (isLargeScreen) ...[
                      const SizedBox(width: 24),
                      // Recent Activity Timeline
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Recent Activity',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            if (employee.companyId != null) ...[
                              SizedBox(
                                height: 400,
                                child: StreamBuilder<List<TimelineEvent>>(
                                  stream: context.read<LeadsRepository>().getEmployeeTimelineEvents(
                                    employee.companyId!,
                                    employee.id!,
                                  ),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Center(
                                        child: Text(
                                          'Error loading timeline: ${snapshot.error}',
                                          style: TextStyle(color: theme.colorScheme.error),
                                        ),
                                      );
                                    }

                                    if (!snapshot.hasData) {
                                      return const Center(child: CircularProgressIndicator());
                                    }

                                    final events = snapshot.data!;

                                    if (events.isEmpty) {
                                      return const Center(
                                        child: Text('No recent activity'),
                                      );
                                    }

                                    return TimelineWidget(
                                      events: events,
                                      isOverview: true,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  IconData _getTaskIcon(String category) {
    switch (category) {
      case 'lead_assigned':
        return Icons.person_add;
      case 'lead_status_changed':
        return Icons.sync;
      case 'task_assigned':
        return Icons.assignment;
      default:
        return Icons.event;
    }
  }

  Color _getTaskColor(BuildContext context, String category) {
    final theme = Theme.of(context);
    switch (category) {
      case 'lead_assigned':
        return theme.colorScheme.primary;
      case 'lead_status_changed':
        return Colors.orange;
      case 'task_assigned':
        return Colors.blue;
      default:
        return theme.colorScheme.onSurface;
    }
  }

  Color _getStatusColor(BuildContext context, String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'in_progress':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Theme.of(context).colorScheme.onSurface;
    }
  }

  String _formatTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 7) {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isCompact = screenWidth < 600;

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(isCompact ? 12 : 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: color,
                size: isCompact ? 24 : 32,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
