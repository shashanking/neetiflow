import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:neetiflow/domain/entities/operations/project_template.dart';

class ProjectTemplateDetails extends StatelessWidget {
  final ProjectTemplate template;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onClone;

  const ProjectTemplateDetails({
    Key? key,
    required this.template,
    required this.onEdit,
    required this.onDelete,
    required this.onClone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with actions
          ListTile(
            title: Text(
              template.name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            subtitle: Text(
              template.type.toString().split('.').last,
              style: TextStyle(color: Colors.grey[600]),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: onClone,
                  tooltip: 'Clone Template',
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: onEdit,
                  tooltip: 'Edit Template',
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: onDelete,
                  tooltip: 'Delete Template',
                ),
              ],
            ),
          ),
          const Divider(),
          // Template details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (template.description != null) ...[
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(template.description!),
                  const SizedBox(height: 16),
                ],
                // Version info
                Row(
                  children: [
                    _buildInfoChip(
                      context,
                      'Version ${template.version}',
                      Icons.numbers,
                    ),
                    const SizedBox(width: 8),
                    if (template.parentTemplateId != null)
                      _buildInfoChip(
                        context,
                        'Derived Template',
                        Icons.account_tree,
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                // Timeline
                Text(
                  'Timeline',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildTimelineInfo(
                      context,
                      'Created',
                      template.createdAt ?? DateTime.now(),
                    ),
                    const SizedBox(width: 24),
                    _buildTimelineInfo(
                      context,
                      'Last Updated',
                      template.updatedAt ?? DateTime.now(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Phases overview
                Text(
                  'Phases',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: template.phases.length,
                    itemBuilder: (context, index) {
                      final phase = template.phases[index];
                      return Card(
                        margin: const EdgeInsets.only(right: 8),
                        child: Container(
                          width: 200,
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                phase.name,
                                style: Theme.of(context).textTheme.titleSmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${phase.defaultTasks.length} tasks',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              Text(
                                'Estimated Duration: ${phase.defaultDuration?.inDays ?? phase.estimatedDuration?.inDays ?? 7} days',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineInfo(BuildContext context, String label, DateTime date) {
    final dateFormat = DateFormat('MMM d, y');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
        ),
        const SizedBox(height: 4),
        Text(
          dateFormat.format(date),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
