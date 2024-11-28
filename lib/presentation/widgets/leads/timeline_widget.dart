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
                  builder: (context) => Dialog(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: const ColorIndexWidget(),
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
    return SizedBox(
      height: widget.height ?? 300,
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        child: Stack(
          children: [
            // Horizontal Timeline Line
            Positioned(
              left: 0,
              right: 0,
              top: (widget.height ?? 300) / 2,
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
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!isUp) ...[
                          const Spacer(),
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
                          const Spacer(),
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

  bool _shouldShowTimeDiff(DateTime current, DateTime next) {
    final difference = current.difference(next).abs();
    return difference.inMinutes >= 1; // Show for gaps of 1 minute or more
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
      timeDiffText = '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'}';
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
    super.key,
    required this.event,
    required this.isOverview,
    required this.isUp,
  });

  @override
  State<_TimelineEventCard> createState() => _TimelineEventCardState();
}

class _TimelineEventCardState extends State<_TimelineEventCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final isSystemEvent = widget.event.category == 'system';
    final color = _getEventColor();

    return InkWell(
      onTap: () => setState(() => _isExpanded = !_isExpanded),
      child: Container(
        width: 200,
        constraints: const BoxConstraints(maxWidth: 200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSystemEvent ? color : Colors.grey[200]!,
            width: isSystemEvent ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            if (_isExpanded) _buildMetadata(),
            if (widget.isOverview) _buildLeadBadge(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final color = _getEventColor();
    final isSystemEvent = widget.event.category == 'system';
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(isSystemEvent ? 0.15 : 0.1),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
      ),
      child: Row(
        children: [
          _buildCategoryIcon(color),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.event.title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSystemEvent ? FontWeight.w700 : FontWeight.w600,
                    color: isSystemEvent ? color : null,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  _formatDate(widget.event.timestamp),
                  style: TextStyle(
                    fontSize: 10,
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

  Widget _buildMetadata() {
    final isSystemEvent = widget.event.category == 'system';
    final color = _getEventColor();

    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.event.description != null && widget.event.description!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                widget.event.description!,
                style: TextStyle(
                  fontSize: 12,
                  color: isSystemEvent ? color : Colors.grey[600],
                ),
              ),
            ),
          ...widget.event.metadata!.entries.map((entry) {
            if (entry.key == 'event_type') return const SizedBox.shrink();

            final hasChange = entry.value is Map &&
                entry.value.containsKey('old') &&
                entry.value.containsKey('new') ||
                (entry.key.contains('old_') &&
                    widget.event.metadata!.containsKey(entry.key.replaceAll('old_', 'new_')));

            if (hasChange && !isSystemEvent) {
              final oldValue = entry.value is Map
                  ? entry.value['old'].toString()
                  : entry.value.toString();
              final newValue = entry.value is Map
                  ? entry.value['new'].toString()
                  : widget.event.metadata![entry.key.replaceAll('old_', 'new_')].toString();
              final changeType = _getChangeType(oldValue, newValue);

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.key.replaceAll('old_', '').replaceAll('_', ' ').toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.arrow_forward,
                          size: 12,
                          color: _getChangeColor(changeType).withOpacity(0.6),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(fontSize: 10),
                              children: [
                                TextSpan(
                                  text: oldValue,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                TextSpan(
                                  text: ' → ',
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                  ),
                                ),
                                TextSpan(
                                  text: newValue,
                                  style: TextStyle(
                                    color: _getChangeColor(changeType),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            } else if (!entry.key.startsWith('new_')) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${entry.key.replaceAll('_', ' ').toUpperCase()}: ',
                      style: TextStyle(
                        fontSize: 10,
                        color: isSystemEvent ? color : Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        entry.value.toString(),
                        style: TextStyle(
                          fontSize: 10,
                          color: isSystemEvent ? color : null,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          }).toList(),
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

  ChangeType _getChangeType(String oldValue, String newValue) {
    try {
      final oldNum = double.parse(oldValue);
      final newNum = double.parse(newValue);
      if (newNum > oldNum) return ChangeType.increase;
      if (newNum < oldNum) return ChangeType.decrease;
      return ChangeType.neutral;
    } catch (_) {
      final statusPriority = {
        'new': 0,
        'open': 1,
        'in_progress': 2,
        'pending': 3,
        'completed': 4,
        'closed': 5,
      };

      final oldStatus = statusPriority[oldValue.toLowerCase()] ?? -1;
      final newStatus = statusPriority[newValue.toLowerCase()] ?? -1;

      if (oldStatus != -1 && newStatus != -1) {
        if (newStatus > oldStatus) return ChangeType.increase;
        if (newStatus < oldStatus) return ChangeType.decrease;
        return ChangeType.neutral;
      }

      if (oldValue == newValue) return ChangeType.neutral;
      return ChangeType.modified;
    }
  }

  Color _getChangeColor(ChangeType type) {
    switch (type) {
      case ChangeType.increase:
        return Colors.green[700]!;
      case ChangeType.decrease:
        return Colors.red[700]!;
      case ChangeType.modified:
        return Colors.blue[700]!;
      case ChangeType.neutral:
        return Colors.grey[700]!;
    }
  }

  Color _getEventColor() {
    if (widget.event.category == 'system') {
      return Colors.blue[900]!;
    }

    if (widget.event.metadata != null) {
      if (widget.event.metadata!.containsKey('new_status')) {
        final newStatus = widget.event.metadata!['new_status'].toString().toLowerCase();
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
        final newValue = widget.event.metadata!['new_value'].toString().toLowerCase();
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
