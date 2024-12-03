import 'package:freezed_annotation/freezed_annotation.dart';

part 'project_notification.freezed.dart';
part 'project_notification.g.dart';

enum NotificationType {
  memberJoined,
  memberLeft,
  accessChanged,
  phaseCompleted,
  taskAssigned,
  taskCompleted,
  commentAdded,
  deadlineApproaching,
}

@freezed
class ProjectNotification with _$ProjectNotification {
  const factory ProjectNotification({
    required String id,
    required String recipientId,
    required String projectId,
    required String title,
    required String message,
    required NotificationType type,
    required Map<String, dynamic> data,
    required bool isRead,
    required DateTime createdAt,
  }) = _ProjectNotification;

  factory ProjectNotification.fromJson(Map<String, dynamic> json) =>
      _$ProjectNotificationFromJson(json);
}
