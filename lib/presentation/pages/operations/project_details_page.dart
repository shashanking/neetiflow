import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neetiflow/domain/entities/operations/project.dart';
import 'package:neetiflow/presentation/blocs/project/project_bloc.dart';
import 'package:neetiflow/presentation/widgets/projects/project_timeline.dart';

import '../../../domain/entities/operations/project_template.dart';
import '../../blocs/project/project_event.dart';
import 'package:neetiflow/presentation/pages/projects/project_create_screen.dart';

class ProjectDetailsPage extends StatefulWidget {
  final Project project;

  const ProjectDetailsPage({
    super.key,
    required this.project,
  });

  @override
  State<ProjectDetailsPage> createState() => _ProjectDetailsPageState();
}

class _ProjectDetailsPageState extends State<ProjectDetailsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.project.name,
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.onPrimary,
          ),
        ),
        backgroundColor: theme.colorScheme.primary,
        actions: [
          IconButton(
            onPressed: () {
              // Navigate to project edit form with current project
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ProjectCreateScreen(),
                ),
              ).then((updatedProject) {
                if (updatedProject != null) {
                  context.read<ProjectBloc>().add(
                    ProjectEvent.createProject(
                      name: updatedProject.name,
                      description: updatedProject.description ?? '',
                      type: updatedProject.type,
                      client: updatedProject.client,
                      startDate: updatedProject.startDate ?? DateTime.now(),
                      endDate: updatedProject.endDate ?? DateTime.now().add(const Duration(days: 30)),
                    ),
                  );
                }
              });
            },
            icon: Icon(
              Icons.edit_outlined,
              color: theme.colorScheme.onPrimary,
            ),
            tooltip: 'Edit Project',
          ),
          PopupMenuButton<String>(
            onSelected: _handleMenuAction,
            icon: Icon(
              Icons.more_vert,
              color: theme.colorScheme.onPrimary,
            ),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'archive',
                child: Text('Archive Project'),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Text('Delete Project'),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: theme.colorScheme.onPrimary,
          unselectedLabelColor: theme.colorScheme.onPrimary.withOpacity(0.6),
          indicatorColor: theme.colorScheme.secondary,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Timeline'),
            Tab(text: 'Tasks'),
            Tab(text: 'Files'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildTimelineTab(),
          _buildTasksTab(),
          _buildFilesTab(),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    final theme = Theme.of(context);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProjectHeader(),
          SizedBox(
            height: 32, 
            child: Divider(
              color: theme.dividerColor,
              thickness: 1,
            ),
          ),
          _buildProjectStats(),
          SizedBox(
            height: 32, 
            child: Divider(
              color: theme.dividerColor,
              thickness: 1,
            ),
          ),
          _buildProjectDescription(),
          SizedBox(
            height: 32, 
            child: Divider(
              color: theme.dividerColor,
              thickness: 1,
            ),
          ),
          _buildProjectTeam(),
        ],
      ),
    );
  }

  Widget _buildProjectHeader() {
    final theme = Theme.of(context);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.project.name,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Client: ${widget.project.client.name}',
                        style: theme.textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(widget.project.status),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildInfoItem(
                  icon: Icons.calendar_today_outlined,
                  label: 'Start Date',
                  value: _formatDate(widget.project.startDate ?? DateTime.now()),
                ),
                const SizedBox(width: 32),
                _buildInfoItem(
                  icon: Icons.event_outlined,
                  label: 'End Date',
                  value: _formatDate(widget.project.expectedEndDate ?? DateTime.now()),
                ),
                const SizedBox(width: 32),
                _buildInfoItem(
                  icon: _getProjectTypeIcon(widget.project.type),
                  label: 'Type',
                  value: _getProjectTypeName(widget.project.type),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectStats() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.task_alt,
            label: 'Tasks',
            value: '${widget.project.phases.expand((p) => p.defaultTasks).length}',
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            icon: Icons.people_outline,
            label: 'Team Members',
            value: '${widget.project.members.length}',
            color: Colors.green,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            icon: Icons.flag_outlined,
            label: 'Milestones',
            value: '${widget.project.milestones.length}',
            color: Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    final theme = Theme.of(context);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: color,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectDescription() {
    final theme = Theme.of(context);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Description',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.project.description ?? '',
              style: theme.textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectTeam() {
    final theme = Theme.of(context);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Team Members',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Show dialog to add team member
                    showDialog(
                      context: context,
                      builder: (context) => _buildAddTeamMemberDialog(context),
                    );
                  },
                  icon: const Icon(Icons.person_add_outlined),
                  tooltip: 'Add Team Member',
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.project.members.length,
              itemBuilder: (context, index) {
                final member = widget.project.members[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(member.employeeName[0]),
                  ),
                  title: Text(member.employeeName),
                  subtitle: Text(member.role),
                  trailing: IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {
                      // TODO: Implement member actions
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineTab() {
    return ProjectTimeline(project: widget.project);
  }

  Widget _buildTasksTab() {
    return const Center(
      child: Text('Tasks tab coming soon'),
    );
  }

  Widget _buildFilesTab() {
    return const Center(
      child: Text('Files tab coming soon'),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 20,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.bodySmall,
            ),
            Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusChip(ProjectStatus status) {
    final theme = Theme.of(context);
    
    Color getStatusColor() {
      switch (status) {
        case ProjectStatus.planning:
          return Colors.orange;
        case ProjectStatus.active:
          return Colors.green;
        case ProjectStatus.inProgress:
          return Colors.blue;
        case ProjectStatus.onHold:
          return Colors.amber;
        case ProjectStatus.completed:
          return Colors.teal;
        case ProjectStatus.cancelled:
          return Colors.red;
      }
    }

    return Chip(
      label: Text(
        _getStatusName(status),
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onPrimary,
        ),
      ),
      backgroundColor: getStatusColor(),
    );
  }

  String _getProjectTypeName(ProjectType type) {
    switch (type) {
      case ProjectType.custom:
        return 'Custom';
      case ProjectType.socialMedia:
        return 'Social Media';
      case ProjectType.software:
        return 'Software';
      case ProjectType.ecommerce:
        return 'E-commerce';
      case ProjectType.appDevelopment:
        return 'App Development';
      case ProjectType.uiuxDesign:
        return 'UI/UX Design';
      case ProjectType.webDevelopment:
        return 'Web Development';
      case ProjectType.marketing:
        return 'Marketing';
      case ProjectType.event:
        return 'Event';
      case ProjectType.research:
        return 'Research';
      case ProjectType.construction:
        return 'Construction';
      case ProjectType.education:
        return 'Education';
      case ProjectType.other:
        return 'Other';
    }
  }

  IconData _getProjectTypeIcon(ProjectType type) {
    switch (type) {
      case ProjectType.custom:
        return Icons.build;
      case ProjectType.socialMedia:
        return Icons.public;
      case ProjectType.software:
        return Icons.computer;
      case ProjectType.ecommerce:
        return Icons.shopping_cart;
      case ProjectType.appDevelopment:
        return Icons.phone_android;
      case ProjectType.uiuxDesign:
        return Icons.design_services;
      case ProjectType.webDevelopment:
        return Icons.web;
      case ProjectType.marketing:
        return Icons.campaign;
      case ProjectType.event:
        return Icons.event;
      case ProjectType.research:
        return Icons.science;
      case ProjectType.construction:
        return Icons.construction;
      case ProjectType.education:
        return Icons.school;
      case ProjectType.other:
        return Icons.category;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _getStatusName(ProjectStatus status) {
    switch (status) {
      case ProjectStatus.planning:
        return 'Planning';
      case ProjectStatus.active:
        return 'Active';
      case ProjectStatus.inProgress:
        return 'In Progress';
      case ProjectStatus.onHold:
        return 'On Hold';
      case ProjectStatus.completed:
        return 'Completed';
      case ProjectStatus.cancelled:
        return 'Cancelled';
    }
  }

  void _handleMenuAction(String value) {
    switch (value) {
      case 'archive':
        // TODO: Implement archive
        break;
      case 'delete':
        _showDeleteConfirmation();
        break;
    }
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Project'),
        content: Text(
          'Are you sure you want to delete "${widget.project.name}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              context.read<ProjectBloc>().add(
                    ProjectEvent.deleteProject(widget.project.id),
                  );
              Navigator.of(context).pop();
              Navigator.of(context).pop();
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

  Widget _buildAddTeamMemberDialog(BuildContext context) {
    Theme.of(context);
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    String selectedRole = 'Member';
    final List<String> roles = ['Member', 'Manager', 'Viewer'];

    return StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: const Text('Add Team Member'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Employee Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Employee Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedRole,
                decoration: const InputDecoration(
                  labelText: 'Role',
                  border: OutlineInputBorder(),
                ),
                items: roles.map((role) => 
                  DropdownMenuItem(
                    value: role, 
                    child: Text(role)
                  )
                ).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedRole = value!;
                  });
                },
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
            onPressed: () {
              // Validate inputs
              if (nameController.text.isEmpty || emailController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please fill in all fields'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              // Create new project member
              final newMember = ProjectMember(
                employeeId: DateTime.now().millisecondsSinceEpoch.toString(), // Temporary ID
                employeeName: nameController.text,
                role: selectedRole,
                access: selectedRole == 'Manager' 
                  ? ProjectAccess.edit 
                  : (selectedRole == 'Viewer' 
                    ? ProjectAccess.view 
                    : ProjectAccess.view),
                joinedAt: DateTime.now(),
              );

              // TODO: Implement actual backend call to add team member
              context.read<ProjectBloc>().add(
                ProjectEvent.addTeamMember(
                  projectId: widget.project.id,
                  member: newMember,
                ),
              );

              Navigator.of(context).pop();
            },
            child: const Text('Add Member'),
          ),
        ],
      ),
    );
  }
}
