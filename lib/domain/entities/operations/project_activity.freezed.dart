// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_activity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ProjectActivity _$ProjectActivityFromJson(Map<String, dynamic> json) {
  return _ProjectActivity.fromJson(json);
}

/// @nodoc
mixin _$ProjectActivity {
  String get id => throw _privateConstructorUsedError;
  String get projectId => throw _privateConstructorUsedError;
  String get employeeId => throw _privateConstructorUsedError;
  String get employeeName => throw _privateConstructorUsedError;
  String get action => throw _privateConstructorUsedError;
  Map<String, dynamic> get details => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;

  /// Serializes this ProjectActivity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProjectActivity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProjectActivityCopyWith<ProjectActivity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProjectActivityCopyWith<$Res> {
  factory $ProjectActivityCopyWith(
          ProjectActivity value, $Res Function(ProjectActivity) then) =
      _$ProjectActivityCopyWithImpl<$Res, ProjectActivity>;
  @useResult
  $Res call(
      {String id,
      String projectId,
      String employeeId,
      String employeeName,
      String action,
      Map<String, dynamic> details,
      DateTime timestamp});
}

/// @nodoc
class _$ProjectActivityCopyWithImpl<$Res, $Val extends ProjectActivity>
    implements $ProjectActivityCopyWith<$Res> {
  _$ProjectActivityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProjectActivity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? projectId = null,
    Object? employeeId = null,
    Object? employeeName = null,
    Object? action = null,
    Object? details = null,
    Object? timestamp = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      projectId: null == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String,
      employeeId: null == employeeId
          ? _value.employeeId
          : employeeId // ignore: cast_nullable_to_non_nullable
              as String,
      employeeName: null == employeeName
          ? _value.employeeName
          : employeeName // ignore: cast_nullable_to_non_nullable
              as String,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as String,
      details: null == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProjectActivityImplCopyWith<$Res>
    implements $ProjectActivityCopyWith<$Res> {
  factory _$$ProjectActivityImplCopyWith(_$ProjectActivityImpl value,
          $Res Function(_$ProjectActivityImpl) then) =
      __$$ProjectActivityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String projectId,
      String employeeId,
      String employeeName,
      String action,
      Map<String, dynamic> details,
      DateTime timestamp});
}

/// @nodoc
class __$$ProjectActivityImplCopyWithImpl<$Res>
    extends _$ProjectActivityCopyWithImpl<$Res, _$ProjectActivityImpl>
    implements _$$ProjectActivityImplCopyWith<$Res> {
  __$$ProjectActivityImplCopyWithImpl(
      _$ProjectActivityImpl _value, $Res Function(_$ProjectActivityImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProjectActivity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? projectId = null,
    Object? employeeId = null,
    Object? employeeName = null,
    Object? action = null,
    Object? details = null,
    Object? timestamp = null,
  }) {
    return _then(_$ProjectActivityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      projectId: null == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String,
      employeeId: null == employeeId
          ? _value.employeeId
          : employeeId // ignore: cast_nullable_to_non_nullable
              as String,
      employeeName: null == employeeName
          ? _value.employeeName
          : employeeName // ignore: cast_nullable_to_non_nullable
              as String,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as String,
      details: null == details
          ? _value._details
          : details // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProjectActivityImpl implements _ProjectActivity {
  const _$ProjectActivityImpl(
      {required this.id,
      required this.projectId,
      required this.employeeId,
      required this.employeeName,
      required this.action,
      required final Map<String, dynamic> details,
      required this.timestamp})
      : _details = details;

  factory _$ProjectActivityImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProjectActivityImplFromJson(json);

  @override
  final String id;
  @override
  final String projectId;
  @override
  final String employeeId;
  @override
  final String employeeName;
  @override
  final String action;
  final Map<String, dynamic> _details;
  @override
  Map<String, dynamic> get details {
    if (_details is EqualUnmodifiableMapView) return _details;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_details);
  }

  @override
  final DateTime timestamp;

  @override
  String toString() {
    return 'ProjectActivity(id: $id, projectId: $projectId, employeeId: $employeeId, employeeName: $employeeName, action: $action, details: $details, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProjectActivityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.projectId, projectId) ||
                other.projectId == projectId) &&
            (identical(other.employeeId, employeeId) ||
                other.employeeId == employeeId) &&
            (identical(other.employeeName, employeeName) ||
                other.employeeName == employeeName) &&
            (identical(other.action, action) || other.action == action) &&
            const DeepCollectionEquality().equals(other._details, _details) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      projectId,
      employeeId,
      employeeName,
      action,
      const DeepCollectionEquality().hash(_details),
      timestamp);

  /// Create a copy of ProjectActivity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProjectActivityImplCopyWith<_$ProjectActivityImpl> get copyWith =>
      __$$ProjectActivityImplCopyWithImpl<_$ProjectActivityImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProjectActivityImplToJson(
      this,
    );
  }
}

abstract class _ProjectActivity implements ProjectActivity {
  const factory _ProjectActivity(
      {required final String id,
      required final String projectId,
      required final String employeeId,
      required final String employeeName,
      required final String action,
      required final Map<String, dynamic> details,
      required final DateTime timestamp}) = _$ProjectActivityImpl;

  factory _ProjectActivity.fromJson(Map<String, dynamic> json) =
      _$ProjectActivityImpl.fromJson;

  @override
  String get id;
  @override
  String get projectId;
  @override
  String get employeeId;
  @override
  String get employeeName;
  @override
  String get action;
  @override
  Map<String, dynamic> get details;
  @override
  DateTime get timestamp;

  /// Create a copy of ProjectActivity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProjectActivityImplCopyWith<_$ProjectActivityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
