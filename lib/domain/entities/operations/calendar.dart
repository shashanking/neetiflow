import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'calendar.freezed.dart';
part 'calendar.g.dart';

enum EventType {
  deadline,
  meeting,
  review,
  publication,
  milestone,
  task,
  custom
}

enum EventStatus {
  scheduled,
  inProgress,
  completed,
  cancelled,
  delayed
}

enum RecurrenceType {
  none,
  daily,
  weekly,
  monthly,
  yearly,
  custom
}

@freezed
class CalendarEvent with _$CalendarEvent {
  const factory CalendarEvent({
    required String id,
    required String title,
    required EventType type,
    required DateTime startTime,
    required DateTime endTime,
    required EventStatus status,
    String? projectId,
    String? clientId,
    String? description,
    List<String>? attendees,
    String? location,
    String? color,
    required RecurrenceRule? recurrence,
    @Default({}) Map<String, dynamic> metadata,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _CalendarEvent;

  factory CalendarEvent.fromJson(Map<String, dynamic> json) =>
      _$CalendarEventFromJson(json);
}

@freezed
class RecurrenceRule with _$RecurrenceRule {
  const factory RecurrenceRule({
    required RecurrenceType type,
    required int frequency,
    DateTime? until,
    int? count,
    List<int>? byWeekDay,
    List<int>? byMonthDay,
    List<int>? byMonth,
    @Default({}) Map<String, dynamic> metadata,
  }) = _RecurrenceRule;

  factory RecurrenceRule.fromJson(Map<String, dynamic> json) =>
      _$RecurrenceRuleFromJson(json);
}

@freezed
class CalendarView with _$CalendarView {
  const factory CalendarView({
    required String id,
    required String name,
    required String userId,
    required ViewType type,
    List<String>? filteredProjects,
    List<String>? filteredClients,
    List<String>? filteredEventTypes,
    @Default({}) Map<String, bool> visibilitySettings,
    @Default({}) Map<String, dynamic> metadata,
  }) = _CalendarView;

  factory CalendarView.fromJson(Map<String, dynamic> json) =>
      _$CalendarViewFromJson(json);
}

enum ViewType {
  month,
  week,
  day,
  timeline,
  resource
}
