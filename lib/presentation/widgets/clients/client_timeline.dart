import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:neetiflow/domain/entities/client_timeline_event.dart';
import 'package:timelines/timelines.dart';

class ClientTimeline extends StatelessWidget {
  final List<ClientTimelineEvent> events;
  final bool isLoading;

  const ClientTimeline({
    super.key,
    required this.events,
    this.isLoading = false,
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
                const SizedBox(height: 8),
                Chip(
                  label: Text(
                    event.category.toUpperCase(),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  padding: EdgeInsets.zero,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ],
            ),
          );
        },
        indicatorBuilder: (_, index) {
          return DotIndicator(
            color: Theme.of(context).colorScheme.primary,
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

  IconData _getIconForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'status':
        return Icons.info_outline;
      case 'note':
        return Icons.note_outlined;
      case 'conversion':
        return Icons.transform_outlined;
      case 'project':
        return Icons.work_outline;
      case 'payment':
        return Icons.payment_outlined;
      case 'meeting':
        return Icons.event_outlined;
      case 'email':
        return Icons.email_outlined;
      case 'call':
        return Icons.phone_outlined;
      default:
        return Icons.circle_outlined;
    }
  }
}
