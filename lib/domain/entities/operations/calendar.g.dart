// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CalendarEventImpl _$$CalendarEventImplFromJson(Map<String, dynamic> json) =>
    _$CalendarEventImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      type: $enumDecode(_$EventTypeEnumMap, json['type']),
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      status: $enumDecode(_$EventStatusEnumMap, json['status']),
      projectId: json['projectId'] as String?,
      clientId: json['clientId'] as String?,
      description: json['description'] as String?,
      attendees: (json['attendees'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      location: json['location'] as String?,
      color: json['color'] as String?,
      recurrence: json['recurrence'] == null
          ? null
          : RecurrenceRule.fromJson(json['recurrence'] as Map<String, dynamic>),
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$CalendarEventImplToJson(_$CalendarEventImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'type': _$EventTypeEnumMap[instance.type]!,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'status': _$EventStatusEnumMap[instance.status]!,
      'projectId': instance.projectId,
      'clientId': instance.clientId,
      'description': instance.description,
      'attendees': instance.attendees,
      'location': instance.location,
      'color': instance.color,
      'recurrence': instance.recurrence,
      'metadata': instance.metadata,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$EventTypeEnumMap = {
  EventType.deadline: 'deadline',
  EventType.meeting: 'meeting',
  EventType.review: 'review',
  EventType.publication: 'publication',
  EventType.milestone: 'milestone',
  EventType.task: 'task',
  EventType.custom: 'custom',
};

const _$EventStatusEnumMap = {
  EventStatus.scheduled: 'scheduled',
  EventStatus.inProgress: 'inProgress',
  EventStatus.completed: 'completed',
  EventStatus.cancelled: 'cancelled',
  EventStatus.delayed: 'delayed',
};

_$RecurrenceRuleImpl _$$RecurrenceRuleImplFromJson(Map<String, dynamic> json) =>
    _$RecurrenceRuleImpl(
      type: $enumDecode(_$RecurrenceTypeEnumMap, json['type']),
      frequency: (json['frequency'] as num).toInt(),
      until: json['until'] == null
          ? null
          : DateTime.parse(json['until'] as String),
      count: (json['count'] as num?)?.toInt(),
      byWeekDay: (json['byWeekDay'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      byMonthDay: (json['byMonthDay'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      byMonth: (json['byMonth'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$RecurrenceRuleImplToJson(
        _$RecurrenceRuleImpl instance) =>
    <String, dynamic>{
      'type': _$RecurrenceTypeEnumMap[instance.type]!,
      'frequency': instance.frequency,
      'until': instance.until?.toIso8601String(),
      'count': instance.count,
      'byWeekDay': instance.byWeekDay,
      'byMonthDay': instance.byMonthDay,
      'byMonth': instance.byMonth,
      'metadata': instance.metadata,
    };

const _$RecurrenceTypeEnumMap = {
  RecurrenceType.none: 'none',
  RecurrenceType.daily: 'daily',
  RecurrenceType.weekly: 'weekly',
  RecurrenceType.monthly: 'monthly',
  RecurrenceType.yearly: 'yearly',
  RecurrenceType.custom: 'custom',
};

_$CalendarViewImpl _$$CalendarViewImplFromJson(Map<String, dynamic> json) =>
    _$CalendarViewImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      userId: json['userId'] as String,
      type: $enumDecode(_$ViewTypeEnumMap, json['type']),
      filteredProjects: (json['filteredProjects'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      filteredClients: (json['filteredClients'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      filteredEventTypes: (json['filteredEventTypes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      visibilitySettings:
          (json['visibilitySettings'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(k, e as bool),
              ) ??
              const {},
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$CalendarViewImplToJson(_$CalendarViewImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'userId': instance.userId,
      'type': _$ViewTypeEnumMap[instance.type]!,
      'filteredProjects': instance.filteredProjects,
      'filteredClients': instance.filteredClients,
      'filteredEventTypes': instance.filteredEventTypes,
      'visibilitySettings': instance.visibilitySettings,
      'metadata': instance.metadata,
    };

const _$ViewTypeEnumMap = {
  ViewType.month: 'month',
  ViewType.week: 'week',
  ViewType.day: 'day',
  ViewType.timeline: 'timeline',
  ViewType.resource: 'resource',
};
