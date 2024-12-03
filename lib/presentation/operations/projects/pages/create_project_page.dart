import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neetiflow/domain/entities/operations/project.dart';
import 'package:neetiflow/injection.dart';
import 'package:neetiflow/presentation/operations/projects/widgets/project_form_stepper.dart';
import 'package:uuid/uuid.dart';

import '../../../../domain/entities/operations/project_template.dart';
import '../../../blocs/project/project_bloc.dart';

class CreateProjectPage extends StatelessWidget {
  final Project? initialProject;
  final void Function(Project)? onSave;
  final bool unableToDelete;

  const CreateProjectPage({
    super.key,
    this.initialProject,
    this.onSave,
    this.unableToDelete = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProjectBloc>(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Create Project'),
            ),
            body: ProjectFormStepper(
              initialProject: initialProject,
              onSave: () {
                final formState = context.read<ProjectBloc>().state.maybeMap(
                      form: (state) => state,
                      orElse: () => throw StateError('Cannot create project from current state'),
                    );
                    
                if (formState.client == null) {
                  throw StateError('Client is required');
                }

                onSave?.call(Project(
                  id: const Uuid().v4(),
                  name: formState.name,
                  description: formState.description ?? '',
                  type: formState.template?.type ?? ProjectType.software,
                  clientId: formState.client!.id,
                  status: ProjectStatus.planning,
                  phases: const [],
                  milestones: const [],
                  members: const [],
                  workflows: const [],
                  startDate: formState.startDate ?? DateTime.now(),
                  expectedEndDate: formState.expectedEndDate ?? DateTime.now().add(const Duration(days: 30)), organizationId: '',
                ));
              },
              unableToDelete: unableToDelete,
            ),
          );
        },
      ),
    );
  }
}
