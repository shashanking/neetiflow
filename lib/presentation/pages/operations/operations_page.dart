import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neetiflow/domain/entities/client.dart' as domain_client;
import 'package:neetiflow/domain/entities/operations/project_template.dart';
import 'package:neetiflow/injection.dart';
import 'package:neetiflow/presentation/blocs/project/project_bloc.dart';
import 'package:neetiflow/presentation/widgets/projects/project_template_list.dart';

import '../../blocs/project/project_event.dart';
import '../../blocs/project/project_state.dart';
import '../../dialogs/project_create_dialog.dart';
import '../../widgets/projects/project_list.dart';
import 'project_details_page.dart';

class OperationsPage extends StatefulWidget {
  const OperationsPage({super.key});

  void _showOperationDialog(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Operation creation coming soon')),
    );
  }

  @override
  State<OperationsPage> createState() => _OperationsPageState();
}

class _OperationsPageState extends State<OperationsPage> {
  OperationsTab _selectedTab = OperationsTab.projects;
  late final ProjectBloc _projectBloc;

  @override
  void initState() {
    super.initState();
    _projectBloc = getIt<ProjectBloc>()..add(const ProjectEvent.started());
  }

  @override
  void dispose() {
    _projectBloc.close();
    super.dispose();
  }

  void _showCreateProjectDialog(BuildContext context, List<domain_client.Client> clients,
      List<ProjectTemplate> templates) {
    showDialog(
      context: context,
      builder: (_) => BlocProvider(
        create: (context) => getIt<ProjectBloc>(),
        child: ProjectCreateDialog(
          clients: clients,
          templates: templates,
          onSubmit: (name, description, template, client, startDate, endDate) {
            context.read<ProjectBloc>().add(
                  ProjectEvent.createProject(
                    name: name,
                    description: description,
                    type: template.type,
                    client: client,
                    startDate: startDate,
                    endDate: endDate,
                  ),
                );
            Navigator.of(context).pop();
          },
          emptyName: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please enter a project name')),
            );
          },
          noClient: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please select a client')),
            );
          },
          noTemplate: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please select a template')),
            );
          },
          noStartDate: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please select a start date')),
            );
          },
          noEndDate: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please select an end date')),
            );
          },
          invalidDates: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('End date must be after start date')),
            );
          },
          insufficientPermissions: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Insufficient permissions')),
            );
          },
          unableToUpdate: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Unable to update project')),
            );
          },
          unableToDelete: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Unable to delete project')),
            );
          },
          unexpected: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('An unexpected error occurred')),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border(
                  bottom: BorderSide(
                    color: theme.colorScheme.outline.withOpacity(0.1),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Operations Management',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _getTabDescription(),
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                  _buildTabSelector(context),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<ProjectBloc, ProjectState>(
                bloc: _projectBloc,
                builder: (context, state) {
                  return state.map(
                    initial: (_) =>
                        const Center(child: CircularProgressIndicator()),
                    loading: (_) =>
                        const Center(child: CircularProgressIndicator()),
                    loaded: (state) {
                      if (_selectedTab == OperationsTab.projects) {
                        return ProjectList(
                          projects: state.projects,
                          onCreateProject: () => _showCreateProjectDialog(
                            context,
                            state.clients,
                            state.templates,
                          ),
                          onProjectTap: (project) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProjectDetailsPage(project: project),
                              ),
                            );
                          },
                        );
                      } else if (_selectedTab == OperationsTab.templates) {
                        return const ProjectTemplateList();
                      } else {
                        return _buildComingSoonContent(context);
                      }
                    },
                    error: (state) => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 48,
                            color: theme.colorScheme.error,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Error: ${state.message}',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.error,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          FilledButton.icon(
                            onPressed: () => _projectBloc.add(
                              const ProjectEvent.started(),
                            ),
                            icon: const Icon(Icons.refresh),
                            label: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                    deleted: (_) => const Center(
                        child: Text('Project deleted successfully')),
                    form: (form) => const Text('form')
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabSelector(BuildContext context) {
    return SegmentedButton<OperationsTab>(
      segments: const [
        ButtonSegment(
          value: OperationsTab.projects,
          label: Text('Projects'),
          icon: Icon(Icons.work_outline),
        ),
        ButtonSegment(
          value: OperationsTab.templates,
          label: Text('Templates'),
          icon: Icon(Icons.article_outlined),
        ),
        ButtonSegment(
          value: OperationsTab.reports,
          label: Text('Reports'),
          icon: Icon(Icons.analytics_outlined),
        ),
      ],
      selected: {_selectedTab},
      onSelectionChanged: (tabs) {
        setState(() {
          _selectedTab = tabs.first;
        });
      },
    );
  }

  Widget _buildComingSoonContent(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.upcoming_outlined,
            size: 64,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'Coming Soon',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This feature is under development',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  String _getTabDescription() {
    switch (_selectedTab) {
      case OperationsTab.projects:
        return 'Manage and track your projects';
      case OperationsTab.templates:
        return 'Create and manage project templates';
      case OperationsTab.reports:
        return 'View project analytics and reports';
    }
  }
}

enum OperationsTab {
  projects,
  templates,
  reports,
}
