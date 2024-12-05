// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProjectActivityImpl _$$ProjectActivityImplFromJson(
        Map<String, dynamic> json) =>
    _$ProjectActivityImpl(
      id: json['id'] as String,
      projectId: json['projectId'] as String,
      employeeId: json['employeeId'] as String,
      employeeName: json['employeeName'] as String,
      action: json['action'] as String,
      details: json['details'] as Map<String, dynamic>,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$$ProjectActivityImplToJson(
        _$ProjectActivityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'projectId': instance.projectId,
      'employeeId': instance.employeeId,
      'employeeName': instance.employeeName,
      'action': instance.action,
      'details': instance.details,
      'timestamp': instance.timestamp.toIso8601String(),
    };
