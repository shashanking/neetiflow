// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_notification.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ProjectNotification _$ProjectNotificationFromJson(Map<String, dynamic> json) {
  return _ProjectNotification.fromJson(json);
}

/// @nodoc
mixin _$ProjectNotification {
  String get id => throw _privateConstructorUsedError;
  String get recipientId => throw _privateConstructorUsedError;
  String get projectId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  NotificationType get type => throw _privateConstructorUsedError;
  Map<String, dynamic> get data => throw _privateConstructorUsedError;
  bool get isRead => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this ProjectNotification to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProjectNotification
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProjectNotificationCopyWith<ProjectNotification> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProjectNotificationCopyWith<$Res> {
  factory $ProjectNotificationCopyWith(
          ProjectNotification value, $Res Function(ProjectNotification) then) =
      _$ProjectNotificationCopyWithImpl<$Res, ProjectNotification>;
  @useResult
  $Res call(
      {String id,
      String recipientId,
      String projectId,
      String title,
      String message,
      NotificationType type,
      Map<String, dynamic> data,
      bool isRead,
      DateTime createdAt});
}

/// @nodoc
class _$ProjectNotificationCopyWithImpl<$Res, $Val extends ProjectNotification>
    implements $ProjectNotificationCopyWith<$Res> {
  _$ProjectNotificationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProjectNotification
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? recipientId = null,
    Object? projectId = null,
    Object? title = null,
    Object? message = null,
    Object? type = null,
    Object? data = null,
    Object? isRead = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      recipientId: null == recipientId
          ? _value.recipientId
          : recipientId // ignore: cast_nullable_to_non_nullable
              as String,
      projectId: null == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as NotificationType,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProjectNotificationImplCopyWith<$Res>
    implements $ProjectNotificationCopyWith<$Res> {
  factory _$$ProjectNotificationImplCopyWith(_$ProjectNotificationImpl value,
          $Res Function(_$ProjectNotificationImpl) then) =
      __$$ProjectNotificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String recipientId,
      String projectId,
      String title,
      String message,
      NotificationType type,
      Map<String, dynamic> data,
      bool isRead,
      DateTime createdAt});
}

/// @nodoc
class __$$ProjectNotificationImplCopyWithImpl<$Res>
    extends _$ProjectNotificationCopyWithImpl<$Res, _$ProjectNotificationImpl>
    implements _$$ProjectNotificationImplCopyWith<$Res> {
  __$$ProjectNotificationImplCopyWithImpl(_$ProjectNotificationImpl _value,
      $Res Function(_$ProjectNotificationImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProjectNotification
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? recipientId = null,
    Object? projectId = null,
    Object? title = null,
    Object? message = null,
    Object? type = null,
    Object? data = null,
    Object? isRead = null,
    Object? createdAt = null,
  }) {
    return _then(_$ProjectNotificationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      recipientId: null == recipientId
          ? _value.recipientId
          : recipientId // ignore: cast_nullable_to_non_nullable
              as String,
      projectId: null == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as NotificationType,
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProjectNotificationImpl implements _ProjectNotification {
  const _$ProjectNotificationImpl(
      {required this.id,
      required this.recipientId,
      required this.projectId,
      required this.title,
      required this.message,
      required this.type,
      required final Map<String, dynamic> data,
      required this.isRead,
      required this.createdAt})
      : _data = data;

  factory _$ProjectNotificationImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProjectNotificationImplFromJson(json);

  @override
  final String id;
  @override
  final String recipientId;
  @override
  final String projectId;
  @override
  final String title;
  @override
  final String message;
  @override
  final NotificationType type;
  final Map<String, dynamic> _data;
  @override
  Map<String, dynamic> get data {
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_data);
  }

  @override
  final bool isRead;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'ProjectNotification(id: $id, recipientId: $recipientId, projectId: $projectId, title: $title, message: $message, type: $type, data: $data, isRead: $isRead, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProjectNotificationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.recipientId, recipientId) ||
                other.recipientId == recipientId) &&
            (identical(other.projectId, projectId) ||
                other.projectId == projectId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      recipientId,
      projectId,
      title,
      message,
      type,
      const DeepCollectionEquality().hash(_data),
      isRead,
      createdAt);

  /// Create a copy of ProjectNotification
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProjectNotificationImplCopyWith<_$ProjectNotificationImpl> get copyWith =>
      __$$ProjectNotificationImplCopyWithImpl<_$ProjectNotificationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProjectNotificationImplToJson(
      this,
    );
  }
}

abstract class _ProjectNotification implements ProjectNotification {
  const factory _ProjectNotification(
      {required final String id,
      required final String recipientId,
      required final String projectId,
      required final String title,
      required final String message,
      required final NotificationType type,
      required final Map<String, dynamic> data,
      required final bool isRead,
      required final DateTime createdAt}) = _$ProjectNotificationImpl;

  factory _ProjectNotification.fromJson(Map<String, dynamic> json) =
      _$ProjectNotificationImpl.fromJson;

  @override
  String get id;
  @override
  String get recipientId;
  @override
  String get projectId;
  @override
  String get title;
  @override
  String get message;
  @override
  NotificationType get type;
  @override
  Map<String, dynamic> get data;
  @override
  bool get isRead;
  @override
  DateTime get createdAt;

  /// Create a copy of ProjectNotification
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProjectNotificationImplCopyWith<_$ProjectNotificationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
