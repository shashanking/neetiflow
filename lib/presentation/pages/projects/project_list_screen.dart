import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neetiflow/domain/entities/operations/project.dart';
import 'package:neetiflow/presentation/blocs/project/project_bloc.dart';
import 'package:neetiflow/presentation/blocs/project/project_event.dart';
import 'package:neetiflow/presentation/forms/project_list_form.dart';
import 'package:neetiflow/presentation/pages/projects/project_create_screen.dart';

class ProjectListScreen extends StatelessWidget {
  final List<Project> projects;
  final void Function(Project) onProjectSelected;
  final ProjectListForm form;
  final VoidCallback? onCreateProject;

  const ProjectListScreen({
    Key? key,
    required this.projects,
    required this.onProjectSelected,
    required this.form,
    this.onCreateProject,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: onCreateProject ?? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProjectCreateScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: form.searchController,
              decoration: const InputDecoration(
                labelText: 'Search Projects',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                context.read<ProjectBloc>().add(
                      ProjectEvent.filtered(query: value),
                    );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: projects.length,
              itemBuilder: (context, index) {
                final project = projects[index];
                return ListTile(
                  title: Text(project.name),
                  subtitle: Text(project.description ?? ''),
                  trailing: Chip(
                    label: Text(project.status.name),
                    backgroundColor: _getStatusColor(project.status),
                  ),
                  onTap: () => onProjectSelected(project),
                );
              },
            ),
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

class ProjectDetailsScreen extends StatelessWidget {
  final Project project;
  final bool deleted;

  const ProjectDetailsScreen(
      {super.key, required this.project, required this.deleted});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Project Details'),
      ),
      body: const Center(
        child: Text('Details of the selected project will be shown here.'),
      ),
    );
  }
}
