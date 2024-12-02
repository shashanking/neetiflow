import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neetiflow/domain/repositories/operations/project_repository.dart';
import 'package:neetiflow/domain/repositories/operations_repository.dart';
import 'package:neetiflow/injection.dart';
import 'package:neetiflow/presentation/blocs/project/project_bloc.dart';
import 'package:neetiflow/presentation/blocs/project/project_event.dart';
import 'package:neetiflow/presentation/blocs/project/project_state.dart';
import 'package:neetiflow/presentation/widgets/projects/project_form.dart';

import '../../../domain/entities/client.dart';
import '../../../domain/entities/operations/project_failure.dart';
import '../../../domain/entities/operations/project_template.dart';

class ProjectCreateScreen extends StatelessWidget {
  const ProjectCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProjectBloc(
        getIt<OperationsRepository>(),
        getIt<ProjectRepository>(),
      )..add(const ProjectEvent.started()),
      child: BlocConsumer<ProjectBloc, ProjectState>(
        listener: (context, state) {
          state.maybeWhen(
            error: (message) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message)),
              );
            },
            deleted: () {
              Navigator.of(context).pop();
            },
            orElse: () {},
          );
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Create Project'),
            ),
            body: state.when(
              initial: () => const Center(child: CircularProgressIndicator()),
              loading: () => const Center(child: CircularProgressIndicator()),
              loaded: (projects, templates, clients, currentProject) {
                return ProjectForm(
                  onSubmit: (project) {
                    context.read<ProjectBloc>().add(
                          ProjectEvent.createProject(
                            name: project.name,
                            description: project.description ?? '',
                            type: project.type,
                            client: project.client,
                            startDate: project.startDate ?? DateTime.now(),
                            endDate: project.endDate ??
                                DateTime.now().add(const Duration(days: 30)),
                          ),
                        );
                  },
                  availableTemplates: templates,
                );
              },
              error: (message) => Center(child: Text('Error: $message')),
              deleted: () => const Center(child: Text('Project deleted')),
              form: (String name,
                  Client? client,
                  ProjectTemplate? template,
                  DateTime? startDate,
                  DateTime? expectedEndDate,
                  String? description,
                  bool showErrorMessages,
                  bool isSaving,
                  Option<Either<ProjectFailure, Unit>>
                      saveFailureOrSuccessOption) {
                return null;
              },
            ),
          );
        },
      ),
    );
  }
}
