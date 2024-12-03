import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:neetiflow/domain/entities/operations/project.dart';
import 'package:neetiflow/presentation/blocs/project/project_bloc.dart';
import 'package:neetiflow/presentation/blocs/project/project_event.dart';
import 'package:neetiflow/presentation/widgets/projects/project_timeline.dart';
import 'package:neetiflow/presentation/widgets/projects/project_member_selector.dart';
import 'package:neetiflow/presentation/widgets/projects/project_file_uploader.dart';
import 'package:neetiflow/presentation/widgets/projects/project_activity_feed.dart';
import 'package:neetiflow/presentation/widgets/projects/dialogs/task_editor_dialog.dart';
import 'package:neetiflow/presentation/widgets/projects/dialogs/milestone_editor_dialog.dart';

import '../../../domain/entities/operations/task.dart';
import '../../../injection.dart';
import '../../blocs/project/project_state.dart';

class ProjectDetailsScreen extends StatelessWidget {
  final Project project;

  const ProjectDetailsScreen({
    Key? key,
    required this.project,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProjectBloc>()
        ..add(ProjectEvent.projectSelected(project)),
      child: BlocBuilder<ProjectBloc, ProjectState>(
        builder: (context, state) {
          return DefaultTabController(
            length: 5,
            child: Scaffold(
              appBar: AppBar(
                title: Text(project.name),
                bottom: const TabBar(
                  isScrollable: true,
                  tabs: [
                    Tab(text: 'Overview'),
                    Tab(text: 'Timeline'),
                    Tab(text: 'Tasks'),
                    Tab(text: 'Team'),
                    Tab(text: 'Files'),
                  ],
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      // TODO: Navigate to edit screen
                    },
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      switch (value) {
                        case 'delete':
                          _showDeleteConfirmation(context);
                          break;
                        case 'export':
                          // TODO: Implement export
                          break;
                        case 'share':
                          // TODO: Implement share
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'export',
                        child: ListTile(
                          leading: Icon(Icons.download),
                          title: Text('Export'),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'share',
                        child: ListTile(
                          leading: Icon(Icons.share),
                          title: Text('Share'),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: ListTile(
                          leading: Icon(Icons.delete, color: Colors.red),
                          title: Text('Delete', style: TextStyle(color: Colors.red)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              body: TabBarView(
                children: [
                  _buildOverviewTab(context, state),
                  _buildTimelineTab(context, state),
                  _buildTasksTab(context, state),
                  _buildTeamTab(context, state),
                  _buildFilesTab(context, state),
                ],
              ),
              floatingActionButton: _buildFloatingActionButton(context),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOverviewTab(BuildContext context, ProjectState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatusCard(context),
          const SizedBox(height: 16),
          _buildDescriptionCard(context),
          const SizedBox(height: 16),
          _buildProgressCard(context),
          const SizedBox(height: 16),
          _buildRecentActivities(context),
        ],
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text(project.status.name),
                  backgroundColor: _getStatusColor(project.status),
                ),
                Text(
                  DateFormat('MMM dd, yyyy').format(project.startDate ?? DateTime.now()),
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Description',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(project.description?? ''),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard(BuildContext context) {
    // TODO: Calculate actual progress
    const progress = 0.6;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Progress',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text('${(progress * 100).toInt()}% Complete'),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivities(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Activities',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            BlocBuilder<ProjectBloc, ProjectState>(
              builder: (context, state) {
                return state.maybeMap(
                  loaded: (state) => ProjectActivityFeed(
                    activities: state.currentProject?.metadata['activities'] ?? [],
                  ),
                  orElse: () => const Center(child: CircularProgressIndicator()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineTab(BuildContext context, ProjectState state) {
    return ProjectTimeline(project: project);
  }

  Widget _buildTasksTab(BuildContext context, ProjectState state) {
    return ListView.builder(
      itemCount: project.phases.length,
      itemBuilder: (context, index) {
        final phase = project.phases[index];
        return ExpansionTile(
          title: Text(phase.name),
          subtitle: Text('${phase.defaultTasks.length} tasks'),
          children: phase.defaultTasks.map((task) {
            return ListTile(
              leading: Checkbox(
                value: task.status == TaskStatus.done,
                onChanged: (value) {
                  final task = Task(
                    id: '123',
                    name: 'Sample Task',
                    description: '',
                    status: TaskStatus.todo,
                    assigneeId: '456',
                    dueDate: DateTime.now(),
                    priority: Priority.medium,
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now(),
                  );
                  // TODO: Update task status
                },
              ),
              title: Text(task.name),
              subtitle: Text(task.description),
              trailing: Text(
                DateFormat('MMM dd').format(task.dueDate),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildTeamTab(BuildContext context, ProjectState state) {
    return Column(
      children: [
        ListTile(
          title: const Text('Team Members'),
          trailing: IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => Dialog(
                  child: ProjectMemberSelector(
                    onMembersSelected: (members) {
                      for (final member in members) {
                        context.read<ProjectBloc>().add(
                          ProjectEvent.addTeamMember(
                            projectId: project.id, 
                            member: member,
                          ),
                        );
                      }
                      Navigator.of(context).pop();
                    },
                    initialMembers: project.members,
                  ),
                ),
              );
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: project.members.length,
            itemBuilder: (context, index) {
              final member = project.members[index];
              return ListTile(
                leading: CircleAvatar(
                  child: Text(member.employeeName[0]),
                ),
                title: Text(member.employeeName),
                subtitle: Text(member.role),
                trailing: PopupMenuButton<String>(
                  onSelected: (value) {
                    // TODO: Handle member actions
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'change_role',
                      child: Text('Change Role'),
                    ),
                    const PopupMenuItem(
                      value: 'remove',
                      child: Text('Remove', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilesTab(BuildContext context, ProjectState state) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ProjectFileUploader(
        projectId: state.maybeMap(
          loaded: (loadedState) => loadedState.currentProject?.id ?? project.id,
          orElse: () => project.id,
        ),
      ),
    );
  }

  Widget? _buildFloatingActionButton(BuildContext context) {
    final tabController = DefaultTabController.of(context);
    if (tabController == null) return null;

    return AnimatedBuilder(
      animation: tabController,
      builder: (context, child) {
        final icons = [
          Icons.edit,
          Icons.timeline,
          Icons.add_task,
          Icons.person_add,
          Icons.upload_file,
        ];
        final labels = [
          'Edit Details',
          'Add Milestone',
          'Add Task',
          'Add Member',
          'Upload File',
        ];
        final currentTab = tabController.index;

        return FloatingActionButton.extended(
          onPressed: () {
            switch (currentTab) {
              case 0:
                // TODO: Edit project details
                break;
              case 1:
                showDialog(
                  context: context,
                  builder: (context) => MilestoneEditorDialog(
                    onSave: (milestone) {
                      // TODO: Add milestone to project
                      Navigator.of(context).pop();
                    },
                  ),
                );
                break;
              case 2:
                showDialog(
                  context: context,
                  builder: (context) => TaskEditorDialog(
                    onSave: (task) {
                      // TODO: Add task to project
                      Navigator.of(context).pop();
                    },
                  ),
                );
                break;
              case 3:
                showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    child: ProjectMemberSelector(
                      onMembersSelected: (members) {
                        for (final member in members) {
                          context.read<ProjectBloc>().add(
                            ProjectEvent.addTeamMember(
                              projectId: project.id, 
                              member: member,
                            ),
                          );
                        }
                        Navigator.of(context).pop();
                      },
                      initialMembers: project.members,
                    ),
                  ),
                );
                break;
              case 4:
                // TODO: Implement file upload
                break;
            }
          },
          icon: Icon(icons[currentTab]),
          label: Text(labels[currentTab]),
        );
      },
    );
  }

  Future<void> _showDeleteConfirmation(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Project'),
        content: const Text('Are you sure you want to delete this project? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<ProjectBloc>().add(ProjectEvent.deleteProject(project.id));
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(ProjectStatus status) {
    switch (status) {
      case ProjectStatus.planning:
        return Colors.blue;
      case ProjectStatus.active:
        return Colors.green;
      case ProjectStatus.inProgress:
        return Colors.orange;
      case ProjectStatus.onHold:
        return Colors.amber;
      case ProjectStatus.completed:
        return Colors.teal;
      case ProjectStatus.cancelled:
        return Colors.red;
    }
  }
}
