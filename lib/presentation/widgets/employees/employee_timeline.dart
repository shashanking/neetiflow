import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:neetiflow/domain/entities/employee_timeline_event.dart';

class EmployeeTimeline extends StatelessWidget {
  final List<EmployeeTimelineEvent> events;
  final bool isLoading;
  final double? height;

  const EmployeeTimeline({
    super.key,
    required this.events,
    this.isLoading = false,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (events.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.timeline_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No timeline events yet',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 18,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return _TimelineItem(
          event: event,
          isFirst: index == 0,
          isLast: index == events.length - 1,
        );
      },
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final EmployeeTimelineEvent event;
  final bool isFirst;
  final bool isLast;

  const _TimelineItem({
    required this.event,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline indicator column
          Column(
            children: [
              if (!isFirst)
                Expanded(
                  child: Container(
                    width: 2,
                    color: theme.colorScheme.primary.withOpacity(0.5),
                  ),
                ),
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: theme.colorScheme.primary.withOpacity(0.5),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          // Event details column
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    event.description ?? '',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('MMM dd, yyyy HH:mm').format(event.timestamp),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  if (event.metadata?.isNotEmpty ?? false) ...[
                    const SizedBox(height: 8),
                    _buildMetadata(context, event.metadata!),
                  ],
                  const SizedBox(height: 8),
                  Chip(
                    label: Text(
                      event.category.toUpperCase(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                    backgroundColor: _getCategoryColor(event.category),
                    padding: EdgeInsets.zero,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildMetadata(BuildContext context, Map<String, dynamic> metadata) {
  return Wrap(
    spacing: 8,
    runSpacing: 4,
    children: metadata.entries.map((entry) {
      if (entry.key == 'type' || entry.key.contains('Id')) {
        return const SizedBox.shrink();
      }
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          '${entry.key}: ${entry.value}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      );
    }).toList(),
  );
}

Color _getCategoryColor(String category) {
  switch (category.toLowerCase()) {
    case 'role_change':
      return Colors.purple[600]!;
    case 'department_change':
      return Colors.blue[600]!;
    case 'status_change':
      return Colors.orange[600]!;
    case 'project_assignment':
      return Colors.green[600]!;
    case 'leave':
      return Colors.red[600]!;
    case 'training':
      return Colors.teal[600]!;
    case 'achievement':
      return Colors.amber[600]!;
    default:
      return Colors.grey[600]!;
  }
}
