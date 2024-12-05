import 'package:flutter/material.dart';
import 'package:neetiflow/presentation/core/widgets/dynamic_form_field.dart';
import 'package:neetiflow/domain/entities/operations/project_template.dart';

class TemplateConfigStep extends StatelessWidget {
  final ProjectTemplateConfig? templateConfig;
  final bool showErrorMessages;
  final Function(ProjectTemplateConfig) onConfigChanged;
  final Function(String, dynamic) onFieldChanged;

  const TemplateConfigStep({
    super.key,
    this.templateConfig,
    required this.showErrorMessages,
    required this.onConfigChanged,
    required this.onFieldChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (templateConfig == null) {
      return const Center(
        child: Text('Please select a project template first'),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Project Configuration'),
          const SizedBox(height: 16),
          _buildCustomFields(),
          const SizedBox(height: 24),
          _buildSectionTitle('Default Phases'),
          const SizedBox(height: 16),
          _buildPhasesList(),
          const SizedBox(height: 24),
          _buildSectionTitle('Required Roles'),
          const SizedBox(height: 16),
          _buildRolesList(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildCustomFields() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final field in templateConfig!.customFields)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: DynamicFormField(
                  field: field,
                  onChanged: (value) => onFieldChanged(field.id, value),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhasesList() {
    return Card(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: templateConfig!.defaultPhases.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final phase = templateConfig!.defaultPhases[index];
          return ExpansionTile(
            title: Text(phase.name),
            subtitle: Text(
              'Duration: ${phase.defaultDuration?.inDays ?? phase.estimatedDuration?.inDays ?? 0} days',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Description:',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(phase.description),
                    const SizedBox(height: 16),
                    Text(
                      'Tasks:',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        for (final task in phase.defaultTasks)
                          Chip(label: Text(task['name'] ?? 'Unnamed Task')),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Custom Fields:',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    Column(
                      children: [
                        for (final field in phase.fields)
                          ListTile(
                            leading: const Icon(Icons.check_circle_outline),
                            title: Text(field.name),
                            subtitle: Text(field.description),
                            dense: true,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRolesList() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRoleSection('Core Team', templateConfig!.requiredRoles['core'] ?? []),
            const SizedBox(height: 16),
            _buildRoleSection('Optional Roles', templateConfig!.requiredRoles['optional'] ?? []),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleSection(String title, List<String> roles) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final role in roles)
              Chip(
                label: Text(role),
                avatar: const Icon(Icons.person_outline, size: 18),
              ),
          ],
        ),
      ],
    );
  }
}
