import 'package:flutter/material.dart';
import 'package:neetiflow/domain/entities/timeline_event.dart';
import 'package:intl/intl.dart';

class TimelineWidget extends StatelessWidget {
  final List<TimelineEvent> events;

  const TimelineWidget({
    Key? key,
    required this.events,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.timeline_outlined,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No timeline events yet',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
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
        final isFirst = index == 0;
        final isLast = index == events.length - 1;
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 72,
                child: Column(
                  children: [
                    Text(
                      DateFormat('MMM dd').format(event.timestamp),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      DateFormat('HH:mm').format(event.timestamp),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Container(
                    width: 2,
                    height: 24,
                    color: isFirst ? Colors.transparent : Theme.of(context).primaryColor,
                  ),
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: 2,
                      color: isLast ? Colors.transparent : Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, bottom: 24.0),
                  child: _buildTimelineEvent(event, context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTimelineEvent(TimelineEvent event, BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _getCategoryIcon(event.category),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    event.title,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            if (event.description.isNotEmpty) ...[
              const SizedBox(height: 8.0),
              Text(
                event.description,
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey[700],
                ),
              ),
            ],
            const SizedBox(height: 8.0),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                event.category,
                style: TextStyle(
                  fontSize: 12.0,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getCategoryIcon(String category) {
    IconData iconData;
    switch (category.toLowerCase()) {
      case 'status':
        iconData = Icons.flag_outlined;
        break;
      case 'note':
        iconData = Icons.note_outlined;
        break;
      case 'email':
        iconData = Icons.email_outlined;
        break;
      case 'call':
        iconData = Icons.phone_outlined;
        break;
      case 'meeting':
        iconData = Icons.calendar_today_outlined;
        break;
      default:
        iconData = Icons.event_outlined;
    }
    return Icon(iconData, size: 20, color: Colors.grey[600]);
  }
}
