import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:neetiflow/domain/entities/timeline_event.dart';


enum ChangeType {
  increase,
  decrease,
  modified,
  neutral,
}

class TimelineWidget extends StatefulWidget {
  final List<TimelineEvent> events;
  final bool isOverview;
  final double? height;
  final double? width;

  const TimelineWidget({
    super.key,
    required this.events,
    this.isOverview = false,
    this.height,
    this.width,
  });

  @override
  State<TimelineWidget> createState() => _TimelineWidgetState();
}

class _TimelineWidgetState extends State<TimelineWidget>
    with SingleTickerProviderStateMixin {
  late final ScrollController _scrollController;
  late final AnimationController _animationController;
  bool _showFloatingTimeline = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scrollController.addListener(() {
      final showTimeline = _scrollController.offset > 100;
      if (showTimeline != _showFloatingTimeline) {
        setState(() => _showFloatingTimeline = showTimeline);
        if (showTimeline) {
          _animationController.forward();
        } else {
          _animationController.reverse();
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.events.isEmpty) {
      return _buildEmptyState();
    }

    final events = widget.events
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: const Icon(Icons.help_outline),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const Dialog(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(16),
                      child: ColorIndexWidget(),
                    ),
                  ),
                );
              },
              tooltip: 'Show Color Index',
            ),
          ],
        ),
        Expanded(
          child: Stack(
            children: [
              _buildMainTimeline(events),
              if (_showFloatingTimeline) _buildFloatingTimeline(events),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMainTimeline(List<TimelineEvent> events) {
    final height = widget.height ?? MediaQuery.of(context).size.height * 0.4;
    return SizedBox(
      height: height,
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        child: Stack(
          children: [
            // Horizontal Timeline Line
            Positioned(
              left: 0,
              right: 0,
              top: height / 2,
              child: Container(
                height: 2,
                color: Colors.grey[300],
              ),
            ),
            // Events
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 16),
                ...List.generate(events.length, (index) {
                  final isUp = index.isEven;
                  final isLastEvent = index == events.length - 1;
                  return Padding(
                    padding: const EdgeInsets.only(right: 24),
                    child: SizedBox(
                      height: height,
                      child: Column(
                        mainAxisAlignment: isUp ? MainAxisAlignment.start : MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!isUp) ...[
                            _buildDateLabel(events[index].timestamp),
                            const SizedBox(height: 8),
                            _TimelineEventCard(
                              event: events[index],
                              isOverview: widget.isOverview,
                              isUp: isUp,
                            ),
                            _buildConnector(),
                          ] else ...[
                            _buildConnector(),
                            _TimelineEventCard(
                              event: events[index],
                              isOverview: widget.isOverview,
                              isUp: isUp,
                            ),
                            const SizedBox(height: 8),
                            _buildDateLabel(events[index].timestamp),
                          ],
                          if (isLastEvent) ...[
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.blue[900],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'Created',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                          if (!isLastEvent) _buildTimeDifferenceIndicator(events[index].timestamp, events[index + 1].timestamp),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(width: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeDifferenceIndicator(DateTime current, DateTime next) {
    final difference = current.difference(next).abs();
    String timeDiffText;

    if (difference.inDays >= 30) {
      final months = (difference.inDays / 30).floor();
      timeDiffText = '$months ${months == 1 ? 'month' : 'months'}';
    } else if (difference.inDays >= 7) {
      final weeks = (difference.inDays / 7).floor();
      timeDiffText = '$weeks ${weeks == 1 ? 'week' : 'weeks'}';
    } else if (difference.inDays >= 1) {
      timeDiffText =
          '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'}';
    } else if (difference.inHours >= 1) {
      final hours = difference.inHours;
      timeDiffText = '$hours ${hours == 1 ? 'hour' : 'hours'}';
    } else {
      final minutes = difference.inMinutes;
      timeDiffText = '$minutes ${minutes == 1 ? 'minute' : 'minutes'}';
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      width: 200, // Match the timeline card width
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              height: 1,
              color: Colors.grey[300],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Text(
              timeDiffText,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              height: 1,
              color: Colors.grey[300],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingTimeline(List<TimelineEvent> events) {
    return Positioned(
      bottom: 16,
      left: 16,
      right: 16,
      child: FadeTransition(
        opacity: _animationController,
        child: Container(
          height: 4,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(2),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final scrollExtent = _scrollController.position.maxScrollExtent;
              final offset = _scrollController.offset;
              final progress = offset / scrollExtent;
              return Align(
                alignment:
                    Alignment(math.min(1, math.max(-1, progress * 2 - 1)), 0),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.timeline_outlined,
              size: 48,
              color: Theme.of(context).primaryColor.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No timeline events yet',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Events will appear here as they occur',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateLabel(DateTime date) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _formatDate(date),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget _buildConnector() {
    return Container(
      width: 2,
      height: 40,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).primaryColor.withOpacity(0.2),
            Theme.of(context).primaryColor.withOpacity(0.6),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateToCheck = DateTime(date.year, date.month, date.day);

    if (dateToCheck == today) {
      return 'Today ${DateFormat('HH:mm').format(date)}';
    } else if (dateToCheck == yesterday) {
      return 'Yesterday ${DateFormat('HH:mm').format(date)}';
    } else if (now.difference(date).inDays < 7) {
      return DateFormat('EEE HH:mm').format(date);
    } else {
      return DateFormat('MMM d, HH:mm').format(date);
    }
  }
}

class _TimelineEventCard extends StatefulWidget {
  final TimelineEvent event;
  final bool isOverview;
  final bool isUp;

  const _TimelineEventCard({
    required this.event,
    required this.isOverview,
    required this.isUp,
  });

  @override
  State<_TimelineEventCard> createState() => _TimelineEventCardState();
}

class _TimelineEventCardState extends State<_TimelineEventCard> {
  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isCompact = screenWidth < 600;
    
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: isCompact ? 250 : 300,
        maxHeight: isCompact ? 120 : 150,
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: widget.event.category == 'system'
                ? Colors.blue[900]!
                : Colors.grey[200]!,
            width: widget.event.category == 'system' ? 2 : 1,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(),
                const SizedBox(height: 8),
                _buildMetadata(),
                if (widget.isOverview) ...[
                  const SizedBox(height: 8),
                  _buildLeadBadge(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetadata() {
    final metadata = widget.event.metadata;
    if (metadata == null || metadata.isEmpty) return const SizedBox.shrink();

    return DefaultTextStyle(
      style: TextStyle(
        fontSize: 12,
        color: Colors.grey[600],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (metadata['leadName'] != null) ...[
            Text(
              'Lead: ${metadata['leadName']}',
              style: const TextStyle(fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
          ],
          if (metadata['status'] != null) ...[
            const SizedBox(height: 4),
            Text(
              'Status: ${metadata['status']}',
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final color = _getEventColor();
    final isEmployeeEvent = widget.event.metadata?['source'] == 'employee_timeline';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategoryIcon(color),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.event.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ),
                    if (isEmployeeEvent)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Employee',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  widget.event.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDate(widget.event.timestamp),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeadBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        'Lead Name',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }



  Color _getEventColor() {
    if (widget.event.category == 'system') {
      return Colors.blue[900]!;
    }

    if (widget.event.metadata != null) {
      if (widget.event.metadata!.containsKey('new_status')) {
        final newStatus =
            widget.event.metadata!['new_status'].toString().toLowerCase();
        switch (newStatus) {
          case 'new':
            return Colors.blue[400]!;
          case 'in_progress':
            return Colors.amber[600]!;
          case 'pending':
            return Colors.orange[600]!;
          case 'completed':
            return Colors.green[600]!;
          case 'closed':
            return Colors.grey[600]!;
          case 'hot':
            return Colors.red[600]!;
          case 'warm':
            return Colors.orange[600]!;
          case 'cold':
            return Colors.blueGrey[600]!;
        }
      } else if (widget.event.metadata!.containsKey('new_value')) {
        final newValue =
            widget.event.metadata!['new_value'].toString().toLowerCase();
        switch (newValue) {
          case 'new':
            return Colors.blue[400]!;
          case 'in_progress':
            return Colors.amber[600]!;
          case 'pending':
            return Colors.orange[600]!;
          case 'completed':
            return Colors.green[600]!;
          case 'closed':
            return Colors.grey[600]!;
          case 'hot':
            return Colors.red[600]!;
          case 'warm':
            return Colors.orange[600]!;
          case 'cold':
            return Colors.blueGrey[600]!;
        }
      }
    }

    switch (widget.event.category.toLowerCase()) {
      case 'status_change':
        return Colors.purple[600]!;
      case 'email':
        return Colors.blue[600]!;
      case 'call':
        return Colors.green[600]!;
      case 'meeting':
        return Colors.purple[600]!;
      case 'task':
        return Colors.orange[600]!;
      case 'note':
        return Colors.teal[600]!;
      default:
        return Colors.grey[600]!;
    }
  }

  Widget _buildCategoryIcon(Color color) {
    IconData iconData;
    final isSystemEvent = widget.event.category == 'system';

    if (isSystemEvent) {
      iconData = Icons.fiber_new;
    } else {
      switch (widget.event.category.toLowerCase()) {
        case 'email':
          iconData = Icons.email_outlined;
          break;
        case 'call':
          iconData = Icons.phone_outlined;
          break;
        case 'meeting':
          iconData = Icons.calendar_today_outlined;
          break;
        case 'task':
          iconData = Icons.check_circle_outline;
          break;
        case 'note':
          iconData = Icons.note_outlined;
          break;
        default:
          iconData = Icons.event_outlined;
      }
    }
    return Icon(iconData, size: 14, color: color);
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateToCheck = DateTime(date.year, date.month, date.day);

    if (dateToCheck == today) {
      return 'Today ${DateFormat('HH:mm').format(date)}';
    } else if (dateToCheck == yesterday) {
      return 'Yesterday ${DateFormat('HH:mm').format(date)}';
    } else if (now.difference(date).inDays < 7) {
      return DateFormat('EEE HH:mm').format(date);
    } else {
      return DateFormat('MMM d, HH:mm').format(date);
    }
  }
}

class ColorIndexWidget extends StatelessWidget {
  const ColorIndexWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      _ColorIndexItem('Email', Colors.blue[600]!),
      _ColorIndexItem('Call', Colors.green[600]!),
      _ColorIndexItem('Meeting', Colors.purple[600]!),
      _ColorIndexItem('Task', Colors.orange[600]!),
      _ColorIndexItem('Note', Colors.teal[600]!),
    ];

    final statuses = [
      _ColorIndexItem('New', Colors.blue[400]!),
      _ColorIndexItem('In Progress', Colors.amber[600]!),
      _ColorIndexItem('Pending', Colors.orange[600]!),
      _ColorIndexItem('Completed', Colors.green[600]!),
      _ColorIndexItem('Closed', Colors.grey[600]!),
    ];

    final leadTypes = [
      _ColorIndexItem('Hot Lead', Colors.red[600]!),
      _ColorIndexItem('Warm Lead', Colors.orange[600]!),
      _ColorIndexItem('Cold Lead', Colors.blueGrey[600]!),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Color Index',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildSection('Event Categories', categories),
          const SizedBox(height: 16),
          _buildSection('Status Colors', statuses),
          const SizedBox(height: 16),
          _buildSection('Lead Types', leadTypes),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<_ColorIndexItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: items.map((item) => _buildColorItem(item)).toList(),
        ),
      ],
    );
  }

  Widget _buildColorItem(_ColorIndexItem item) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: item.color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          item.label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}

class _ColorIndexItem {
  final String label;
  final Color color;

  _ColorIndexItem(this.label, this.color);
}
