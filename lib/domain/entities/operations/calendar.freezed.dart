// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'calendar.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CalendarEvent _$CalendarEventFromJson(Map<String, dynamic> json) {
  return _CalendarEvent.fromJson(json);
}

/// @nodoc
mixin _$CalendarEvent {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  EventType get type => throw _privateConstructorUsedError;
  DateTime get startTime => throw _privateConstructorUsedError;
  DateTime get endTime => throw _privateConstructorUsedError;
  EventStatus get status => throw _privateConstructorUsedError;
  String? get projectId => throw _privateConstructorUsedError;
  String? get clientId => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  List<String>? get attendees => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  String? get color => throw _privateConstructorUsedError;
  RecurrenceRule? get recurrence => throw _privateConstructorUsedError;
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this CalendarEvent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CalendarEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CalendarEventCopyWith<CalendarEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CalendarEventCopyWith<$Res> {
  factory $CalendarEventCopyWith(
          CalendarEvent value, $Res Function(CalendarEvent) then) =
      _$CalendarEventCopyWithImpl<$Res, CalendarEvent>;
  @useResult
  $Res call(
      {String id,
      String title,
      EventType type,
      DateTime startTime,
      DateTime endTime,
      EventStatus status,
      String? projectId,
      String? clientId,
      String? description,
      List<String>? attendees,
      String? location,
      String? color,
      RecurrenceRule? recurrence,
      Map<String, dynamic> metadata,
      DateTime createdAt,
      DateTime updatedAt});

  $RecurrenceRuleCopyWith<$Res>? get recurrence;
}

/// @nodoc
class _$CalendarEventCopyWithImpl<$Res, $Val extends CalendarEvent>
    implements $CalendarEventCopyWith<$Res> {
  _$CalendarEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CalendarEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? type = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? status = null,
    Object? projectId = freezed,
    Object? clientId = freezed,
    Object? description = freezed,
    Object? attendees = freezed,
    Object? location = freezed,
    Object? color = freezed,
    Object? recurrence = freezed,
    Object? metadata = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as EventType,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as EventStatus,
      projectId: freezed == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String?,
      clientId: freezed == clientId
          ? _value.clientId
          : clientId // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      attendees: freezed == attendees
          ? _value.attendees
          : attendees // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      recurrence: freezed == recurrence
          ? _value.recurrence
          : recurrence // ignore: cast_nullable_to_non_nullable
              as RecurrenceRule?,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }

  /// Create a copy of CalendarEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RecurrenceRuleCopyWith<$Res>? get recurrence {
    if (_value.recurrence == null) {
      return null;
    }

    return $RecurrenceRuleCopyWith<$Res>(_value.recurrence!, (value) {
      return _then(_value.copyWith(recurrence: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CalendarEventImplCopyWith<$Res>
    implements $CalendarEventCopyWith<$Res> {
  factory _$$CalendarEventImplCopyWith(
          _$CalendarEventImpl value, $Res Function(_$CalendarEventImpl) then) =
      __$$CalendarEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      EventType type,
      DateTime startTime,
      DateTime endTime,
      EventStatus status,
      String? projectId,
      String? clientId,
      String? description,
      List<String>? attendees,
      String? location,
      String? color,
      RecurrenceRule? recurrence,
      Map<String, dynamic> metadata,
      DateTime createdAt,
      DateTime updatedAt});

  @override
  $RecurrenceRuleCopyWith<$Res>? get recurrence;
}

/// @nodoc
class __$$CalendarEventImplCopyWithImpl<$Res>
    extends _$CalendarEventCopyWithImpl<$Res, _$CalendarEventImpl>
    implements _$$CalendarEventImplCopyWith<$Res> {
  __$$CalendarEventImplCopyWithImpl(
      _$CalendarEventImpl _value, $Res Function(_$CalendarEventImpl) _then)
      : super(_value, _then);

  /// Create a copy of CalendarEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? type = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? status = null,
    Object? projectId = freezed,
    Object? clientId = freezed,
    Object? description = freezed,
    Object? attendees = freezed,
    Object? location = freezed,
    Object? color = freezed,
    Object? recurrence = freezed,
    Object? metadata = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$CalendarEventImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as EventType,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as EventStatus,
      projectId: freezed == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String?,
      clientId: freezed == clientId
          ? _value.clientId
          : clientId // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      attendees: freezed == attendees
          ? _value._attendees
          : attendees // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      recurrence: freezed == recurrence
          ? _value.recurrence
          : recurrence // ignore: cast_nullable_to_non_nullable
              as RecurrenceRule?,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CalendarEventImpl
    with DiagnosticableTreeMixin
    implements _CalendarEvent {
  const _$CalendarEventImpl(
      {required this.id,
      required this.title,
      required this.type,
      required this.startTime,
      required this.endTime,
      required this.status,
      this.projectId,
      this.clientId,
      this.description,
      final List<String>? attendees,
      this.location,
      this.color,
      required this.recurrence,
      final Map<String, dynamic> metadata = const {},
      required this.createdAt,
      required this.updatedAt})
      : _attendees = attendees,
        _metadata = metadata;

  factory _$CalendarEventImpl.fromJson(Map<String, dynamic> json) =>
      _$$CalendarEventImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final EventType type;
  @override
  final DateTime startTime;
  @override
  final DateTime endTime;
  @override
  final EventStatus status;
  @override
  final String? projectId;
  @override
  final String? clientId;
  @override
  final String? description;
  final List<String>? _attendees;
  @override
  List<String>? get attendees {
    final value = _attendees;
    if (value == null) return null;
    if (_attendees is EqualUnmodifiableListView) return _attendees;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? location;
  @override
  final String? color;
  @override
  final RecurrenceRule? recurrence;
  final Map<String, dynamic> _metadata;
  @override
  @JsonKey()
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'CalendarEvent(id: $id, title: $title, type: $type, startTime: $startTime, endTime: $endTime, status: $status, projectId: $projectId, clientId: $clientId, description: $description, attendees: $attendees, location: $location, color: $color, recurrence: $recurrence, metadata: $metadata, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'CalendarEvent'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('title', title))
      ..add(DiagnosticsProperty('type', type))
      ..add(DiagnosticsProperty('startTime', startTime))
      ..add(DiagnosticsProperty('endTime', endTime))
      ..add(DiagnosticsProperty('status', status))
      ..add(DiagnosticsProperty('projectId', projectId))
      ..add(DiagnosticsProperty('clientId', clientId))
      ..add(DiagnosticsProperty('description', description))
      ..add(DiagnosticsProperty('attendees', attendees))
      ..add(DiagnosticsProperty('location', location))
      ..add(DiagnosticsProperty('color', color))
      ..add(DiagnosticsProperty('recurrence', recurrence))
      ..add(DiagnosticsProperty('metadata', metadata))
      ..add(DiagnosticsProperty('createdAt', createdAt))
      ..add(DiagnosticsProperty('updatedAt', updatedAt));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CalendarEventImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.projectId, projectId) ||
                other.projectId == projectId) &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality()
                .equals(other._attendees, _attendees) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.recurrence, recurrence) ||
                other.recurrence == recurrence) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      type,
      startTime,
      endTime,
      status,
      projectId,
      clientId,
      description,
      const DeepCollectionEquality().hash(_attendees),
      location,
      color,
      recurrence,
      const DeepCollectionEquality().hash(_metadata),
      createdAt,
      updatedAt);

  /// Create a copy of CalendarEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CalendarEventImplCopyWith<_$CalendarEventImpl> get copyWith =>
      __$$CalendarEventImplCopyWithImpl<_$CalendarEventImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CalendarEventImplToJson(
      this,
    );
  }
}

abstract class _CalendarEvent implements CalendarEvent {
  const factory _CalendarEvent(
      {required final String id,
      required final String title,
      required final EventType type,
      required final DateTime startTime,
      required final DateTime endTime,
      required final EventStatus status,
      final String? projectId,
      final String? clientId,
      final String? description,
      final List<String>? attendees,
      final String? location,
      final String? color,
      required final RecurrenceRule? recurrence,
      final Map<String, dynamic> metadata,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$CalendarEventImpl;

  factory _CalendarEvent.fromJson(Map<String, dynamic> json) =
      _$CalendarEventImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  EventType get type;
  @override
  DateTime get startTime;
  @override
  DateTime get endTime;
  @override
  EventStatus get status;
  @override
  String? get projectId;
  @override
  String? get clientId;
  @override
  String? get description;
  @override
  List<String>? get attendees;
  @override
  String? get location;
  @override
  String? get color;
  @override
  RecurrenceRule? get recurrence;
  @override
  Map<String, dynamic> get metadata;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of CalendarEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CalendarEventImplCopyWith<_$CalendarEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RecurrenceRule _$RecurrenceRuleFromJson(Map<String, dynamic> json) {
  return _RecurrenceRule.fromJson(json);
}

/// @nodoc
mixin _$RecurrenceRule {
  RecurrenceType get type => throw _privateConstructorUsedError;
  int get frequency => throw _privateConstructorUsedError;
  DateTime? get until => throw _privateConstructorUsedError;
  int? get count => throw _privateConstructorUsedError;
  List<int>? get byWeekDay => throw _privateConstructorUsedError;
  List<int>? get byMonthDay => throw _privateConstructorUsedError;
  List<int>? get byMonth => throw _privateConstructorUsedError;
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;

  /// Serializes this RecurrenceRule to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecurrenceRule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecurrenceRuleCopyWith<RecurrenceRule> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecurrenceRuleCopyWith<$Res> {
  factory $RecurrenceRuleCopyWith(
          RecurrenceRule value, $Res Function(RecurrenceRule) then) =
      _$RecurrenceRuleCopyWithImpl<$Res, RecurrenceRule>;
  @useResult
  $Res call(
      {RecurrenceType type,
      int frequency,
      DateTime? until,
      int? count,
      List<int>? byWeekDay,
      List<int>? byMonthDay,
      List<int>? byMonth,
      Map<String, dynamic> metadata});
}

/// @nodoc
class _$RecurrenceRuleCopyWithImpl<$Res, $Val extends RecurrenceRule>
    implements $RecurrenceRuleCopyWith<$Res> {
  _$RecurrenceRuleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecurrenceRule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? frequency = null,
    Object? until = freezed,
    Object? count = freezed,
    Object? byWeekDay = freezed,
    Object? byMonthDay = freezed,
    Object? byMonth = freezed,
    Object? metadata = null,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as RecurrenceType,
      frequency: null == frequency
          ? _value.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as int,
      until: freezed == until
          ? _value.until
          : until // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      count: freezed == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int?,
      byWeekDay: freezed == byWeekDay
          ? _value.byWeekDay
          : byWeekDay // ignore: cast_nullable_to_non_nullable
              as List<int>?,
      byMonthDay: freezed == byMonthDay
          ? _value.byMonthDay
          : byMonthDay // ignore: cast_nullable_to_non_nullable
              as List<int>?,
      byMonth: freezed == byMonth
          ? _value.byMonth
          : byMonth // ignore: cast_nullable_to_non_nullable
              as List<int>?,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecurrenceRuleImplCopyWith<$Res>
    implements $RecurrenceRuleCopyWith<$Res> {
  factory _$$RecurrenceRuleImplCopyWith(_$RecurrenceRuleImpl value,
          $Res Function(_$RecurrenceRuleImpl) then) =
      __$$RecurrenceRuleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {RecurrenceType type,
      int frequency,
      DateTime? until,
      int? count,
      List<int>? byWeekDay,
      List<int>? byMonthDay,
      List<int>? byMonth,
      Map<String, dynamic> metadata});
}

/// @nodoc
class __$$RecurrenceRuleImplCopyWithImpl<$Res>
    extends _$RecurrenceRuleCopyWithImpl<$Res, _$RecurrenceRuleImpl>
    implements _$$RecurrenceRuleImplCopyWith<$Res> {
  __$$RecurrenceRuleImplCopyWithImpl(
      _$RecurrenceRuleImpl _value, $Res Function(_$RecurrenceRuleImpl) _then)
      : super(_value, _then);

  /// Create a copy of RecurrenceRule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? frequency = null,
    Object? until = freezed,
    Object? count = freezed,
    Object? byWeekDay = freezed,
    Object? byMonthDay = freezed,
    Object? byMonth = freezed,
    Object? metadata = null,
  }) {
    return _then(_$RecurrenceRuleImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as RecurrenceType,
      frequency: null == frequency
          ? _value.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as int,
      until: freezed == until
          ? _value.until
          : until // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      count: freezed == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int?,
      byWeekDay: freezed == byWeekDay
          ? _value._byWeekDay
          : byWeekDay // ignore: cast_nullable_to_non_nullable
              as List<int>?,
      byMonthDay: freezed == byMonthDay
          ? _value._byMonthDay
          : byMonthDay // ignore: cast_nullable_to_non_nullable
              as List<int>?,
      byMonth: freezed == byMonth
          ? _value._byMonth
          : byMonth // ignore: cast_nullable_to_non_nullable
              as List<int>?,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RecurrenceRuleImpl
    with DiagnosticableTreeMixin
    implements _RecurrenceRule {
  const _$RecurrenceRuleImpl(
      {required this.type,
      required this.frequency,
      this.until,
      this.count,
      final List<int>? byWeekDay,
      final List<int>? byMonthDay,
      final List<int>? byMonth,
      final Map<String, dynamic> metadata = const {}})
      : _byWeekDay = byWeekDay,
        _byMonthDay = byMonthDay,
        _byMonth = byMonth,
        _metadata = metadata;

  factory _$RecurrenceRuleImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecurrenceRuleImplFromJson(json);

  @override
  final RecurrenceType type;
  @override
  final int frequency;
  @override
  final DateTime? until;
  @override
  final int? count;
  final List<int>? _byWeekDay;
  @override
  List<int>? get byWeekDay {
    final value = _byWeekDay;
    if (value == null) return null;
    if (_byWeekDay is EqualUnmodifiableListView) return _byWeekDay;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<int>? _byMonthDay;
  @override
  List<int>? get byMonthDay {
    final value = _byMonthDay;
    if (value == null) return null;
    if (_byMonthDay is EqualUnmodifiableListView) return _byMonthDay;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<int>? _byMonth;
  @override
  List<int>? get byMonth {
    final value = _byMonth;
    if (value == null) return null;
    if (_byMonth is EqualUnmodifiableListView) return _byMonth;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final Map<String, dynamic> _metadata;
  @override
  @JsonKey()
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'RecurrenceRule(type: $type, frequency: $frequency, until: $until, count: $count, byWeekDay: $byWeekDay, byMonthDay: $byMonthDay, byMonth: $byMonth, metadata: $metadata)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'RecurrenceRule'))
      ..add(DiagnosticsProperty('type', type))
      ..add(DiagnosticsProperty('frequency', frequency))
      ..add(DiagnosticsProperty('until', until))
      ..add(DiagnosticsProperty('count', count))
      ..add(DiagnosticsProperty('byWeekDay', byWeekDay))
      ..add(DiagnosticsProperty('byMonthDay', byMonthDay))
      ..add(DiagnosticsProperty('byMonth', byMonth))
      ..add(DiagnosticsProperty('metadata', metadata));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecurrenceRuleImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.frequency, frequency) ||
                other.frequency == frequency) &&
            (identical(other.until, until) || other.until == until) &&
            (identical(other.count, count) || other.count == count) &&
            const DeepCollectionEquality()
                .equals(other._byWeekDay, _byWeekDay) &&
            const DeepCollectionEquality()
                .equals(other._byMonthDay, _byMonthDay) &&
            const DeepCollectionEquality().equals(other._byMonth, _byMonth) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      type,
      frequency,
      until,
      count,
      const DeepCollectionEquality().hash(_byWeekDay),
      const DeepCollectionEquality().hash(_byMonthDay),
      const DeepCollectionEquality().hash(_byMonth),
      const DeepCollectionEquality().hash(_metadata));

  /// Create a copy of RecurrenceRule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecurrenceRuleImplCopyWith<_$RecurrenceRuleImpl> get copyWith =>
      __$$RecurrenceRuleImplCopyWithImpl<_$RecurrenceRuleImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecurrenceRuleImplToJson(
      this,
    );
  }
}

abstract class _RecurrenceRule implements RecurrenceRule {
  const factory _RecurrenceRule(
      {required final RecurrenceType type,
      required final int frequency,
      final DateTime? until,
      final int? count,
      final List<int>? byWeekDay,
      final List<int>? byMonthDay,
      final List<int>? byMonth,
      final Map<String, dynamic> metadata}) = _$RecurrenceRuleImpl;

  factory _RecurrenceRule.fromJson(Map<String, dynamic> json) =
      _$RecurrenceRuleImpl.fromJson;

  @override
  RecurrenceType get type;
  @override
  int get frequency;
  @override
  DateTime? get until;
  @override
  int? get count;
  @override
  List<int>? get byWeekDay;
  @override
  List<int>? get byMonthDay;
  @override
  List<int>? get byMonth;
  @override
  Map<String, dynamic> get metadata;

  /// Create a copy of RecurrenceRule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecurrenceRuleImplCopyWith<_$RecurrenceRuleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CalendarView _$CalendarViewFromJson(Map<String, dynamic> json) {
  return _CalendarView.fromJson(json);
}

/// @nodoc
mixin _$CalendarView {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  ViewType get type => throw _privateConstructorUsedError;
  List<String>? get filteredProjects => throw _privateConstructorUsedError;
  List<String>? get filteredClients => throw _privateConstructorUsedError;
  List<String>? get filteredEventTypes => throw _privateConstructorUsedError;
  Map<String, bool> get visibilitySettings =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;

  /// Serializes this CalendarView to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CalendarView
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CalendarViewCopyWith<CalendarView> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CalendarViewCopyWith<$Res> {
  factory $CalendarViewCopyWith(
          CalendarView value, $Res Function(CalendarView) then) =
      _$CalendarViewCopyWithImpl<$Res, CalendarView>;
  @useResult
  $Res call(
      {String id,
      String name,
      String userId,
      ViewType type,
      List<String>? filteredProjects,
      List<String>? filteredClients,
      List<String>? filteredEventTypes,
      Map<String, bool> visibilitySettings,
      Map<String, dynamic> metadata});
}

/// @nodoc
class _$CalendarViewCopyWithImpl<$Res, $Val extends CalendarView>
    implements $CalendarViewCopyWith<$Res> {
  _$CalendarViewCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CalendarView
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? userId = null,
    Object? type = null,
    Object? filteredProjects = freezed,
    Object? filteredClients = freezed,
    Object? filteredEventTypes = freezed,
    Object? visibilitySettings = null,
    Object? metadata = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ViewType,
      filteredProjects: freezed == filteredProjects
          ? _value.filteredProjects
          : filteredProjects // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      filteredClients: freezed == filteredClients
          ? _value.filteredClients
          : filteredClients // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      filteredEventTypes: freezed == filteredEventTypes
          ? _value.filteredEventTypes
          : filteredEventTypes // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      visibilitySettings: null == visibilitySettings
          ? _value.visibilitySettings
          : visibilitySettings // ignore: cast_nullable_to_non_nullable
              as Map<String, bool>,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CalendarViewImplCopyWith<$Res>
    implements $CalendarViewCopyWith<$Res> {
  factory _$$CalendarViewImplCopyWith(
          _$CalendarViewImpl value, $Res Function(_$CalendarViewImpl) then) =
      __$$CalendarViewImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String userId,
      ViewType type,
      List<String>? filteredProjects,
      List<String>? filteredClients,
      List<String>? filteredEventTypes,
      Map<String, bool> visibilitySettings,
      Map<String, dynamic> metadata});
}

/// @nodoc
class __$$CalendarViewImplCopyWithImpl<$Res>
    extends _$CalendarViewCopyWithImpl<$Res, _$CalendarViewImpl>
    implements _$$CalendarViewImplCopyWith<$Res> {
  __$$CalendarViewImplCopyWithImpl(
      _$CalendarViewImpl _value, $Res Function(_$CalendarViewImpl) _then)
      : super(_value, _then);

  /// Create a copy of CalendarView
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? userId = null,
    Object? type = null,
    Object? filteredProjects = freezed,
    Object? filteredClients = freezed,
    Object? filteredEventTypes = freezed,
    Object? visibilitySettings = null,
    Object? metadata = null,
  }) {
    return _then(_$CalendarViewImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ViewType,
      filteredProjects: freezed == filteredProjects
          ? _value._filteredProjects
          : filteredProjects // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      filteredClients: freezed == filteredClients
          ? _value._filteredClients
          : filteredClients // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      filteredEventTypes: freezed == filteredEventTypes
          ? _value._filteredEventTypes
          : filteredEventTypes // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      visibilitySettings: null == visibilitySettings
          ? _value._visibilitySettings
          : visibilitySettings // ignore: cast_nullable_to_non_nullable
              as Map<String, bool>,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CalendarViewImpl with DiagnosticableTreeMixin implements _CalendarView {
  const _$CalendarViewImpl(
      {required this.id,
      required this.name,
      required this.userId,
      required this.type,
      final List<String>? filteredProjects,
      final List<String>? filteredClients,
      final List<String>? filteredEventTypes,
      final Map<String, bool> visibilitySettings = const {},
      final Map<String, dynamic> metadata = const {}})
      : _filteredProjects = filteredProjects,
        _filteredClients = filteredClients,
        _filteredEventTypes = filteredEventTypes,
        _visibilitySettings = visibilitySettings,
        _metadata = metadata;

  factory _$CalendarViewImpl.fromJson(Map<String, dynamic> json) =>
      _$$CalendarViewImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String userId;
  @override
  final ViewType type;
  final List<String>? _filteredProjects;
  @override
  List<String>? get filteredProjects {
    final value = _filteredProjects;
    if (value == null) return null;
    if (_filteredProjects is EqualUnmodifiableListView)
      return _filteredProjects;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _filteredClients;
  @override
  List<String>? get filteredClients {
    final value = _filteredClients;
    if (value == null) return null;
    if (_filteredClients is EqualUnmodifiableListView) return _filteredClients;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _filteredEventTypes;
  @override
  List<String>? get filteredEventTypes {
    final value = _filteredEventTypes;
    if (value == null) return null;
    if (_filteredEventTypes is EqualUnmodifiableListView)
      return _filteredEventTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final Map<String, bool> _visibilitySettings;
  @override
  @JsonKey()
  Map<String, bool> get visibilitySettings {
    if (_visibilitySettings is EqualUnmodifiableMapView)
      return _visibilitySettings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_visibilitySettings);
  }

  final Map<String, dynamic> _metadata;
  @override
  @JsonKey()
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'CalendarView(id: $id, name: $name, userId: $userId, type: $type, filteredProjects: $filteredProjects, filteredClients: $filteredClients, filteredEventTypes: $filteredEventTypes, visibilitySettings: $visibilitySettings, metadata: $metadata)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'CalendarView'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('userId', userId))
      ..add(DiagnosticsProperty('type', type))
      ..add(DiagnosticsProperty('filteredProjects', filteredProjects))
      ..add(DiagnosticsProperty('filteredClients', filteredClients))
      ..add(DiagnosticsProperty('filteredEventTypes', filteredEventTypes))
      ..add(DiagnosticsProperty('visibilitySettings', visibilitySettings))
      ..add(DiagnosticsProperty('metadata', metadata));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CalendarViewImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality()
                .equals(other._filteredProjects, _filteredProjects) &&
            const DeepCollectionEquality()
                .equals(other._filteredClients, _filteredClients) &&
            const DeepCollectionEquality()
                .equals(other._filteredEventTypes, _filteredEventTypes) &&
            const DeepCollectionEquality()
                .equals(other._visibilitySettings, _visibilitySettings) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      userId,
      type,
      const DeepCollectionEquality().hash(_filteredProjects),
      const DeepCollectionEquality().hash(_filteredClients),
      const DeepCollectionEquality().hash(_filteredEventTypes),
      const DeepCollectionEquality().hash(_visibilitySettings),
      const DeepCollectionEquality().hash(_metadata));

  /// Create a copy of CalendarView
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CalendarViewImplCopyWith<_$CalendarViewImpl> get copyWith =>
      __$$CalendarViewImplCopyWithImpl<_$CalendarViewImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CalendarViewImplToJson(
      this,
    );
  }
}

abstract class _CalendarView implements CalendarView {
  const factory _CalendarView(
      {required final String id,
      required final String name,
      required final String userId,
      required final ViewType type,
      final List<String>? filteredProjects,
      final List<String>? filteredClients,
      final List<String>? filteredEventTypes,
      final Map<String, bool> visibilitySettings,
      final Map<String, dynamic> metadata}) = _$CalendarViewImpl;

  factory _CalendarView.fromJson(Map<String, dynamic> json) =
      _$CalendarViewImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get userId;
  @override
  ViewType get type;
  @override
  List<String>? get filteredProjects;
  @override
  List<String>? get filteredClients;
  @override
  List<String>? get filteredEventTypes;
  @override
  Map<String, bool> get visibilitySettings;
  @override
  Map<String, dynamic> get metadata;

  /// Create a copy of CalendarView
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CalendarViewImplCopyWith<_$CalendarViewImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
