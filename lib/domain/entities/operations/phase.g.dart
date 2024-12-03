// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'phase.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PhaseImpl _$$PhaseImplFromJson(Map<String, dynamic> json) => _$PhaseImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      taskIds:
          (json['taskIds'] as List<dynamic>).map((e) => e as String).toList(),
      isCompleted: json['isCompleted'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      order: (json['order'] as num).toInt(),
      estimatedDuration:
          Duration(microseconds: (json['estimatedDuration'] as num).toInt()),
      defaultTasks: (json['defaultTasks'] as List<dynamic>?)
              ?.map((e) => Task.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$PhaseImplToJson(_$PhaseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'taskIds': instance.taskIds,
      'isCompleted': instance.isCompleted,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'order': instance.order,
      'estimatedDuration': instance.estimatedDuration.inMicroseconds,
      'defaultTasks': instance.defaultTasks,
    };
