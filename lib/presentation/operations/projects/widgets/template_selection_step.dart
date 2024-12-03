import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neetiflow/domain/entities/operations/project_template.dart';
import 'package:neetiflow/presentation/blocs/project/project_bloc.dart';
import 'package:neetiflow/presentation/blocs/project/project_event.dart';
import 'package:neetiflow/presentation/blocs/project/project_state.dart';

class TemplateSelectionStep extends StatelessWidget {
  final ProjectTemplate? selectedTemplate;
  final Function(ProjectTemplate) onTemplateSelected;

  const TemplateSelectionStep({
    super.key,
    this.selectedTemplate,
    required this.onTemplateSelected, required bool showErrorMessages, required void Function(dynamic template) onTemplateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectBloc, ProjectState>(
      builder: (context, state) {
        return state.maybeMap(
          loading: (_) => const Center(child: CircularProgressIndicator()),
          loaded: (state) => ListView.builder(
            itemCount: state.templates.length,
            itemBuilder: (context, index) {
              final template = state.templates[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  selected: selectedTemplate?.id == template.id,
                  title: Text(template.name),
                  subtitle: Text(template.description ?? ''),
                  trailing: Chip(
                    label: Text(template.type.toString().split('.').last),
                    backgroundColor: selectedTemplate?.id == template.id
                        ? Theme.of(context).colorScheme.primaryContainer
                        : Theme.of(context).colorScheme.surfaceVariant,
                  ),
                  onTap: () {
                    onTemplateSelected(template);
                    context.read<ProjectBloc>().add(
                          ProjectEvent.templateChanged(template),
                        );
                  },
                ),
              );
            },
          ),
          error: (state) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error loading templates: ${state.message}',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<ProjectBloc>().add(
                          const ProjectEvent.started(),
                        );
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
          orElse: () => const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
