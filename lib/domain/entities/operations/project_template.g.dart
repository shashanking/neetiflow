// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TemplateFieldImpl _$$TemplateFieldImplFromJson(Map<String, dynamic> json) =>
    _$TemplateFieldImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      description: json['description'] as String? ?? '',
      isRequired: json['isRequired'] as bool? ?? false,
      options: (json['options'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
      value: json['value'] as String? ?? '',
    );

Map<String, dynamic> _$$TemplateFieldImplToJson(_$TemplateFieldImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'description': instance.description,
      'isRequired': instance.isRequired,
      'options': instance.options,
      'metadata': instance.metadata,
      'value': instance.value,
    };

_$TemplatePhaseImpl _$$TemplatePhaseImplFromJson(Map<String, dynamic> json) =>
    _$TemplatePhaseImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      defaultDuration: json['defaultDuration'] == null
          ? null
          : Duration(microseconds: (json['defaultDuration'] as num).toInt()),
      fields: (json['fields'] as List<dynamic>?)
              ?.map((e) => TemplateField.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      taskIds: (json['taskIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isCompleted: json['isCompleted'] as bool? ?? false,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      order: (json['order'] as num?)?.toInt() ?? 0,
      estimatedDuration: json['estimatedDuration'] == null
          ? null
          : Duration(microseconds: (json['estimatedDuration'] as num).toInt()),
      defaultTasks: (json['defaultTasks'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$TemplatePhaseImplToJson(_$TemplatePhaseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'defaultDuration': instance.defaultDuration?.inMicroseconds,
      'fields': instance.fields,
      'metadata': instance.metadata,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'taskIds': instance.taskIds,
      'isCompleted': instance.isCompleted,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'order': instance.order,
      'estimatedDuration': instance.estimatedDuration?.inMicroseconds,
      'defaultTasks': instance.defaultTasks,
    };

_$TemplateMilestoneImpl _$$TemplateMilestoneImplFromJson(
        Map<String, dynamic> json) =>
    _$TemplateMilestoneImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      dueDate: json['dueDate'] == null
          ? null
          : DateTime.parse(json['dueDate'] as String),
      isCompleted: json['isCompleted'] as bool? ?? false,
      tasks:
          (json['tasks'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
    );

Map<String, dynamic> _$$TemplateMilestoneImplToJson(
        _$TemplateMilestoneImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'dueDate': instance.dueDate?.toIso8601String(),
      'isCompleted': instance.isCompleted,
      'tasks': instance.tasks,
    };
