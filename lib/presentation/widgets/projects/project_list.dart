import 'package:flutter/material.dart';
import 'package:neetiflow/domain/entities/operations/project.dart';
import 'package:neetiflow/domain/entities/client.dart';

class ProjectList extends StatelessWidget {
  final List<Project> projects;
  final VoidCallback onCreateProject;
  final void Function(Project project) onProjectTap;

  const ProjectList({
    super.key,
    required this.projects,
    required this.onCreateProject,
    required this.onProjectTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (projects.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.work_outline,
              size: 64,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'No Projects Yet',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Create your first project to get started',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onCreateProject,
              icon: const Icon(Icons.add),
              label: const Text('Create Project'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: projects.length,
      itemBuilder: (context, index) {
        final project = projects[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: InkWell(
            onTap: () => onProjectTap(project),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          project.name,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      _buildStatusChip(context, project.status),
                    ],
                  ),
                  if (project.description != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      project.description!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      if (project.clientId.isNotEmpty) ...[
                        Icon(
                          Icons.business_outlined,
                          size: 16,
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                        const SizedBox(width: 4),
                        FutureBuilder<Client?>(
                          future: _fetchClientName(project.clientId),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Text(
                                'Loading...',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                                ),
                              );
                            }
                            if (snapshot.hasData && snapshot.data != null) {
                              return Text(
                                snapshot.data!.name,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                                ),
                              );
                            }
                            return Text(
                              'Unknown Client',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(0.7),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 16),
                      ],
                      Text('Start Date: ${project.startDate?.toLocal().toString() ?? 'Not set'}'),
                      const SizedBox(width: 16),
                      Text('End Date: ${project.endDate?.toLocal().toString() ?? 'Not set'}'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusChip(BuildContext context, ProjectStatus status) {
    final theme = Theme.of(context);
    Color? chipColor;
    Color? textColor;

    switch (status) {
      case ProjectStatus.planning:
        chipColor = Colors.blue.shade100;
        textColor = Colors.blue.shade800;
        break;
      case ProjectStatus.inProgress:
        chipColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        break;
      case ProjectStatus.completed:
        chipColor = Colors.grey.shade300;
        textColor = Colors.black87;
        break;
      case ProjectStatus.onHold:
        chipColor = Colors.orange.shade100;
        textColor = Colors.orange.shade800;
        break;
      case ProjectStatus.cancelled:
        chipColor = Colors.red.shade100;
        textColor = Colors.red.shade800;
        break;
      default:
        chipColor = Colors.grey.shade200;
        textColor = Colors.black54;
    }

    return Chip(
      label: Text(
        status.toString().split('.').last.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: chipColor,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }

  String _formatDateRange(DateTime start, DateTime? end) {
    final startStr = '${start.month}/${start.day}/${start.year}';
    if (end == null) return 'From $startStr';
    return '$startStr - ${end.month}/${end.day}/${end.year}';
  }

  Future<Client?> _fetchClientName(String clientId) async {
    // implement your logic to fetch client name here
    // for now, just return a dummy client
    return Client(name: 'Dummy Client');
  }
}

class Client {
  final String name;

  Client({required this.name});
}
