import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timelines/timelines.dart';
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

    return Timeline.tileBuilder(
      theme: TimelineThemeData(
        nodePosition: 0,
        color: Theme.of(context).colorScheme.primary,
        connectorTheme: ConnectorThemeData(
          thickness: 2.0,
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        ),
      ),
      builder: TimelineTileBuilder.connected(
        connectionDirection: ConnectionDirection.before,
        itemCount: events.length,
        contentsBuilder: (_, index) {
          final event = events[index];
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      event.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    Text(
                      DateFormat('MMM d, y h:mm a').format(event.timestamp),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  event.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                if (event.metadata?.isNotEmpty ?? false) ...[
                  const SizedBox(height: 8),
                  _buildMetadata(context, event.metadata!),
                ],
                const SizedBox(height: 8),
                Chip(
                  label: Text(
                    event.category.toUpperCase(),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                  ),
                  backgroundColor: _getCategoryColor(event.category),
                  padding: EdgeInsets.zero,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ],
            ),
          );
        },
        indicatorBuilder: (_, index) {
          return DotIndicator(
            color: _getCategoryColor(events[index].category),
            child: Icon(
              _getIconForCategory(events[index].category),
              color: Theme.of(context).colorScheme.onPrimary,
              size: 16,
            ),
          );
        },
        connectorBuilder: (_, index, connectorType) {
          return SolidLineConnector(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
          );
        },
      ),
    );
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

  IconData _getIconForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'role_change':
        return Icons.change_circle;
      case 'department_change':
        return Icons.transfer_within_a_station;
      case 'status_change':
        return Icons.update;
      case 'project_assignment':
        return Icons.assignment;
      case 'leave':
        return Icons.event_busy;
      case 'training':
        return Icons.school;
      case 'achievement':
        return Icons.emoji_events;
      default:
        return Icons.event_note;
    }
  }
}
