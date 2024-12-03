// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workflow_template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WorkflowStateImpl _$$WorkflowStateImplFromJson(Map<String, dynamic> json) =>
    _$WorkflowStateImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      color: json['color'] as String? ?? '#808080',
      description: json['description'] as String? ?? '',
      isInitial: json['isInitial'] as bool? ?? false,
      isFinal: json['isFinal'] as bool? ?? false,
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$WorkflowStateImplToJson(_$WorkflowStateImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'color': instance.color,
      'description': instance.description,
      'isInitial': instance.isInitial,
      'isFinal': instance.isFinal,
      'metadata': instance.metadata,
    };

_$WorkflowTransitionImpl _$$WorkflowTransitionImplFromJson(
        Map<String, dynamic> json) =>
    _$WorkflowTransitionImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      fromStateId: json['fromStateId'] as String,
      toStateId: json['toStateId'] as String,
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$WorkflowTransitionImplToJson(
        _$WorkflowTransitionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'fromStateId': instance.fromStateId,
      'toStateId': instance.toStateId,
      'metadata': instance.metadata,
    };

_$WorkflowTemplateImpl _$$WorkflowTemplateImplFromJson(
        Map<String, dynamic> json) =>
    _$WorkflowTemplateImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      states: (json['states'] as List<dynamic>)
          .map((e) => WorkflowState.fromJson(e as Map<String, dynamic>))
          .toList(),
      transitions: (json['transitions'] as List<dynamic>)
          .map((e) => WorkflowTransition.fromJson(e as Map<String, dynamic>))
          .toList(),
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$WorkflowTemplateImplToJson(
        _$WorkflowTemplateImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'states': instance.states,
      'transitions': instance.transitions,
      'metadata': instance.metadata,
    };
