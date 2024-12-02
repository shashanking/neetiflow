import 'package:flutter/material.dart';
import 'package:neetiflow/domain/entities/operations/project.dart';
import 'package:timeline_tile/timeline_tile.dart';

class ProjectTimeline extends StatelessWidget {
  final Project project;

  const ProjectTimeline({
    super.key,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final events = _buildTimelineEvents();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Project Timeline',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return TimelineTile(
                alignment: TimelineAlign.manual,
                lineXY: 0.2,
                isFirst: index == 0,
                isLast: index == events.length - 1,
                indicatorStyle: IndicatorStyle(
                  width: 24,
                  height: 24,
                  indicator: _buildIndicator(event.type, theme),
                  drawGap: true,
                ),
                beforeLineStyle: LineStyle(
                  color: theme.colorScheme.primary.withOpacity(0.2),
                ),
                endChild: _buildEventCard(event, theme),
                startChild: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    _formatDate(event.date),
                    style: theme.textTheme.bodySmall,
                    textAlign: TextAlign.right,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(TimelineEventType type, ThemeData theme) {
    IconData getIcon() {
      switch (type) {
        case TimelineEventType.start:
          return Icons.play_arrow;
        case TimelineEventType.milestone:
          return Icons.flag;
        case TimelineEventType.phase:
          return Icons.layers;
        case TimelineEventType.end:
          return Icons.stop;
      }
    }

    Color getColor() {
      switch (type) {
        case TimelineEventType.start:
          return Colors.green;
        case TimelineEventType.milestone:
          return Colors.orange;
        case TimelineEventType.phase:
          return theme.colorScheme.primary;
        case TimelineEventType.end:
          return Colors.red;
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: getColor(),
        shape: BoxShape.circle,
      ),
      child: Icon(
        getIcon(),
        size: 16,
        color: Colors.white,
      ),
    );
  }

  Widget _buildEventCard(TimelineEvent event, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (event.description != null) ...[
                const SizedBox(height: 8),
                Text(
                  event.description!,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  List<TimelineEvent> _buildTimelineEvents() {
    final events = <TimelineEvent>[
      TimelineEvent(
        type: TimelineEventType.start,
        date: project.startDate ?? DateTime.now(),
        title: 'Project Started',
        description: 'Project kicked off with initial planning phase',
      ),
    ];

    // Add phases
    for (final phase in project.phases) {
      events.add(
        TimelineEvent(
          type: TimelineEventType.phase,
          date: phase.startDate ?? DateTime.now(),
          title: phase.name,
          description: phase.description,
        ),
      );
    }

    // Add milestones
    for (final milestone in project.milestones) {
      events.add(
        TimelineEvent(
          type: TimelineEventType.milestone,
          date: milestone.dueDate ?? DateTime.now(),
          title: milestone.name,
          description: milestone.description,
        ),
      );
    }

    // Add end date
    events.add(
      TimelineEvent(
        type: TimelineEventType.end,
        date: project.expectedEndDate ?? DateTime.now().add(const Duration(days: 30)),
        title: 'Expected Completion',
      ),
    );

    // Sort events by date
    events.sort((a, b) => a.date.compareTo(b.date));

    return events;
  }
}

enum TimelineEventType {
  start,
  milestone,
  phase,
  end,
}

class TimelineEvent {
  final TimelineEventType type;
  final DateTime date;
  final String title;
  final String? description;

  TimelineEvent({
    required this.type,
    required this.date,
    required this.title,
    this.description,
  });
}
