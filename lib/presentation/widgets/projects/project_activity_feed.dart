import 'package:flutter/material.dart';
import 'package:neetiflow/domain/entities/operations/project_activity.dart';

class ProjectActivityFeed extends StatelessWidget {
  final List<ProjectActivity> activities;

  const ProjectActivityFeed({
    Key? key,
    required this.activities,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (activities.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('No recent activities'),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final activity = activities[index];
        return _buildActivityTile(context, activity);
      },
    );
  }

  Widget _buildActivityTile(BuildContext context, ProjectActivity activity) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: _getActivityColor(activity),
        child: Icon(
          _getActivityIcon(activity),
          color: Colors.white,
          size: 20,
        ),
      ),
      title: RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: [
            TextSpan(
              text: activity.employeeName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: ' ${_getActivityDescription(activity)}'),
          ],
        ),
      ),
      subtitle: Text(
        '${activity.employeeName} ${_getActivityDescription(activity)}',
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: _buildActivityDetails(context, activity),
    );
  }

  Widget? _buildActivityDetails(
      BuildContext context, ProjectActivity activity) {
    switch (_getActivityType(activity)) {
      case ActivityType.fileUploaded:
      case ActivityType.fileDeleted:
        return Text(
          activity.details['fileName'] ?? '',
          style: Theme.of(context).textTheme.bodySmall,
        );
      case ActivityType.memberAdded:
      case ActivityType.memberRemoved:
        return CircleAvatar(
          radius: 12,
          child: Text(
            (activity.details['memberName'] as String?)?.substring(0, 1) ?? '',
            style: const TextStyle(fontSize: 12),
          ),
        );
      default:
        return null;
    }
  }

  Color _getActivityColor(ProjectActivity activity) {
    final activityType = _getActivityType(activity);
    switch (activityType) {
      case ActivityType.created:
        return Colors.green;
      case ActivityType.updated:
        return Colors.blue;
      case ActivityType.memberAdded:
        return Colors.teal;
      case ActivityType.memberRemoved:
        return Colors.red;
      case ActivityType.fileUploaded:
        return Colors.purple;
      case ActivityType.fileDeleted:
        return Colors.orange;
      case ActivityType.taskCreated:
        return Colors.indigo;
      case ActivityType.taskCompleted:
        return Colors.green;
      case ActivityType.milestoneReached:
        return Colors.amber;
      case ActivityType.statusChanged:
        return Colors.deepOrange;
      }
  }

  IconData _getActivityIcon(ProjectActivity activity) {
    final activityType = _getActivityType(activity);
    switch (activityType) {
      case ActivityType.created:
        return Icons.add_circle;
      case ActivityType.updated:
        return Icons.edit;
      case ActivityType.memberAdded:
        return Icons.person_add;
      case ActivityType.memberRemoved:
        return Icons.person_remove;
      case ActivityType.fileUploaded:
        return Icons.file_upload;
      case ActivityType.fileDeleted:
        return Icons.delete;
      case ActivityType.taskCreated:
        return Icons.add_task;
      case ActivityType.taskCompleted:
        return Icons.check_circle;
      case ActivityType.milestoneReached:
        return Icons.flag;
      case ActivityType.statusChanged:
        return Icons.change_circle;
      }
  }

  String _getActivityDescription(ProjectActivity activity) {
    final activityType = _getActivityType(activity);
    switch (activityType) {
      case ActivityType.created:
        return 'created the project';
      case ActivityType.updated:
        return 'updated project details';
      case ActivityType.memberAdded:
        return 'added ${activity.details['memberName']} to the project';
      case ActivityType.memberRemoved:
        return 'removed ${activity.details['memberName']} from the project';
      case ActivityType.fileUploaded:
        return 'uploaded ${activity.details['fileName']}';
      case ActivityType.fileDeleted:
        return 'deleted ${activity.details['fileName']}';
      case ActivityType.taskCreated:
        return 'created a new task: ${activity.details['taskName']}';
      case ActivityType.taskCompleted:
        return 'completed task: ${activity.details['taskName']}';
      case ActivityType.milestoneReached:
        return 'reached milestone: ${activity.details['milestoneName']}';
      case ActivityType.statusChanged:
        return 'changed project status to ${activity.details['newStatus']}';
      }
  }

  ActivityType _getActivityType(ProjectActivity activity) {
    return ActivityType.values.firstWhere(
      (type) => type.toString().split('.').last == activity.action,
      orElse: () => ActivityType.updated,
    );
  }
}
