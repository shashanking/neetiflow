// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProjectNotificationImpl _$$ProjectNotificationImplFromJson(
        Map<String, dynamic> json) =>
    _$ProjectNotificationImpl(
      id: json['id'] as String,
      recipientId: json['recipientId'] as String,
      projectId: json['projectId'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      type: $enumDecode(_$NotificationTypeEnumMap, json['type']),
      data: json['data'] as Map<String, dynamic>,
      isRead: json['isRead'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$ProjectNotificationImplToJson(
        _$ProjectNotificationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'recipientId': instance.recipientId,
      'projectId': instance.projectId,
      'title': instance.title,
      'message': instance.message,
      'type': _$NotificationTypeEnumMap[instance.type]!,
      'data': instance.data,
      'isRead': instance.isRead,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$NotificationTypeEnumMap = {
  NotificationType.memberJoined: 'memberJoined',
  NotificationType.memberLeft: 'memberLeft',
  NotificationType.accessChanged: 'accessChanged',
  NotificationType.phaseCompleted: 'phaseCompleted',
  NotificationType.taskAssigned: 'taskAssigned',
  NotificationType.taskCompleted: 'taskCompleted',
  NotificationType.commentAdded: 'commentAdded',
  NotificationType.deadlineApproaching: 'deadlineApproaching',
};
