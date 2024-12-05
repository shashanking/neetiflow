// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_template.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TemplateField _$TemplateFieldFromJson(Map<String, dynamic> json) {
  return _TemplateField.fromJson(json);
}

/// @nodoc
mixin _$TemplateField {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  bool get isRequired => throw _privateConstructorUsedError;
  List<String> get options => throw _privateConstructorUsedError;
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;
  String get value => throw _privateConstructorUsedError;

  /// Serializes this TemplateField to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TemplateField
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TemplateFieldCopyWith<TemplateField> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TemplateFieldCopyWith<$Res> {
  factory $TemplateFieldCopyWith(
          TemplateField value, $Res Function(TemplateField) then) =
      _$TemplateFieldCopyWithImpl<$Res, TemplateField>;
  @useResult
  $Res call(
      {String id,
      String name,
      String type,
      String description,
      bool isRequired,
      List<String> options,
      Map<String, dynamic> metadata,
      String value});
}

/// @nodoc
class _$TemplateFieldCopyWithImpl<$Res, $Val extends TemplateField>
    implements $TemplateFieldCopyWith<$Res> {
  _$TemplateFieldCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TemplateField
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? description = null,
    Object? isRequired = null,
    Object? options = null,
    Object? metadata = null,
    Object? value = null,
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
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      isRequired: null == isRequired
          ? _value.isRequired
          : isRequired // ignore: cast_nullable_to_non_nullable
              as bool,
      options: null == options
          ? _value.options
          : options // ignore: cast_nullable_to_non_nullable
              as List<String>,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TemplateFieldImplCopyWith<$Res>
    implements $TemplateFieldCopyWith<$Res> {
  factory _$$TemplateFieldImplCopyWith(
          _$TemplateFieldImpl value, $Res Function(_$TemplateFieldImpl) then) =
      __$$TemplateFieldImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String type,
      String description,
      bool isRequired,
      List<String> options,
      Map<String, dynamic> metadata,
      String value});
}

/// @nodoc
class __$$TemplateFieldImplCopyWithImpl<$Res>
    extends _$TemplateFieldCopyWithImpl<$Res, _$TemplateFieldImpl>
    implements _$$TemplateFieldImplCopyWith<$Res> {
  __$$TemplateFieldImplCopyWithImpl(
      _$TemplateFieldImpl _value, $Res Function(_$TemplateFieldImpl) _then)
      : super(_value, _then);

  /// Create a copy of TemplateField
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? description = null,
    Object? isRequired = null,
    Object? options = null,
    Object? metadata = null,
    Object? value = null,
  }) {
    return _then(_$TemplateFieldImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      isRequired: null == isRequired
          ? _value.isRequired
          : isRequired // ignore: cast_nullable_to_non_nullable
              as bool,
      options: null == options
          ? _value._options
          : options // ignore: cast_nullable_to_non_nullable
              as List<String>,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TemplateFieldImpl implements _TemplateField {
  const _$TemplateFieldImpl(
      {required this.id,
      required this.name,
      required this.type,
      this.description = '',
      this.isRequired = false,
      final List<String> options = const [],
      final Map<String, dynamic> metadata = const {},
      this.value = ''})
      : _options = options,
        _metadata = metadata;

  factory _$TemplateFieldImpl.fromJson(Map<String, dynamic> json) =>
      _$$TemplateFieldImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String type;
  @override
  @JsonKey()
  final String description;
  @override
  @JsonKey()
  final bool isRequired;
  final List<String> _options;
  @override
  @JsonKey()
  List<String> get options {
    if (_options is EqualUnmodifiableListView) return _options;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_options);
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
  @JsonKey()
  final String value;

  @override
  String toString() {
    return 'TemplateField(id: $id, name: $name, type: $type, description: $description, isRequired: $isRequired, options: $options, metadata: $metadata, value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TemplateFieldImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isRequired, isRequired) ||
                other.isRequired == isRequired) &&
            const DeepCollectionEquality().equals(other._options, _options) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      type,
      description,
      isRequired,
      const DeepCollectionEquality().hash(_options),
      const DeepCollectionEquality().hash(_metadata),
      value);

  /// Create a copy of TemplateField
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TemplateFieldImplCopyWith<_$TemplateFieldImpl> get copyWith =>
      __$$TemplateFieldImplCopyWithImpl<_$TemplateFieldImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TemplateFieldImplToJson(
      this,
    );
  }
}

abstract class _TemplateField implements TemplateField {
  const factory _TemplateField(
      {required final String id,
      required final String name,
      required final String type,
      final String description,
      final bool isRequired,
      final List<String> options,
      final Map<String, dynamic> metadata,
      final String value}) = _$TemplateFieldImpl;

  factory _TemplateField.fromJson(Map<String, dynamic> json) =
      _$TemplateFieldImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get type;
  @override
  String get description;
  @override
  bool get isRequired;
  @override
  List<String> get options;
  @override
  Map<String, dynamic> get metadata;
  @override
  String get value;

  /// Create a copy of TemplateField
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TemplateFieldImplCopyWith<_$TemplateFieldImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TemplatePhase _$TemplatePhaseFromJson(Map<String, dynamic> json) {
  return _TemplatePhase.fromJson(json);
}

/// @nodoc
mixin _$TemplatePhase {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  Duration? get defaultDuration => throw _privateConstructorUsedError;
  List<TemplateField> get fields => throw _privateConstructorUsedError;
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;
  DateTime? get startDate => throw _privateConstructorUsedError;
  DateTime? get endDate => throw _privateConstructorUsedError;
  List<String> get taskIds => throw _privateConstructorUsedError;
  bool get isCompleted => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  int get order => throw _privateConstructorUsedError;
  Duration? get estimatedDuration => throw _privateConstructorUsedError;
  List<Map<String, dynamic>> get defaultTasks =>
      throw _privateConstructorUsedError;

  /// Serializes this TemplatePhase to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TemplatePhase
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TemplatePhaseCopyWith<TemplatePhase> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TemplatePhaseCopyWith<$Res> {
  factory $TemplatePhaseCopyWith(
          TemplatePhase value, $Res Function(TemplatePhase) then) =
      _$TemplatePhaseCopyWithImpl<$Res, TemplatePhase>;
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      Duration? defaultDuration,
      List<TemplateField> fields,
      Map<String, dynamic> metadata,
      DateTime? startDate,
      DateTime? endDate,
      List<String> taskIds,
      bool isCompleted,
      DateTime? createdAt,
      DateTime? updatedAt,
      int order,
      Duration? estimatedDuration,
      List<Map<String, dynamic>> defaultTasks});
}

/// @nodoc
class _$TemplatePhaseCopyWithImpl<$Res, $Val extends TemplatePhase>
    implements $TemplatePhaseCopyWith<$Res> {
  _$TemplatePhaseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TemplatePhase
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? defaultDuration = freezed,
    Object? fields = null,
    Object? metadata = null,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? taskIds = null,
    Object? isCompleted = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? order = null,
    Object? estimatedDuration = freezed,
    Object? defaultTasks = null,
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
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      defaultDuration: freezed == defaultDuration
          ? _value.defaultDuration
          : defaultDuration // ignore: cast_nullable_to_non_nullable
              as Duration?,
      fields: null == fields
          ? _value.fields
          : fields // ignore: cast_nullable_to_non_nullable
              as List<TemplateField>,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      taskIds: null == taskIds
          ? _value.taskIds
          : taskIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      estimatedDuration: freezed == estimatedDuration
          ? _value.estimatedDuration
          : estimatedDuration // ignore: cast_nullable_to_non_nullable
              as Duration?,
      defaultTasks: null == defaultTasks
          ? _value.defaultTasks
          : defaultTasks // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TemplatePhaseImplCopyWith<$Res>
    implements $TemplatePhaseCopyWith<$Res> {
  factory _$$TemplatePhaseImplCopyWith(
          _$TemplatePhaseImpl value, $Res Function(_$TemplatePhaseImpl) then) =
      __$$TemplatePhaseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      Duration? defaultDuration,
      List<TemplateField> fields,
      Map<String, dynamic> metadata,
      DateTime? startDate,
      DateTime? endDate,
      List<String> taskIds,
      bool isCompleted,
      DateTime? createdAt,
      DateTime? updatedAt,
      int order,
      Duration? estimatedDuration,
      List<Map<String, dynamic>> defaultTasks});
}

/// @nodoc
class __$$TemplatePhaseImplCopyWithImpl<$Res>
    extends _$TemplatePhaseCopyWithImpl<$Res, _$TemplatePhaseImpl>
    implements _$$TemplatePhaseImplCopyWith<$Res> {
  __$$TemplatePhaseImplCopyWithImpl(
      _$TemplatePhaseImpl _value, $Res Function(_$TemplatePhaseImpl) _then)
      : super(_value, _then);

  /// Create a copy of TemplatePhase
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? defaultDuration = freezed,
    Object? fields = null,
    Object? metadata = null,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? taskIds = null,
    Object? isCompleted = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? order = null,
    Object? estimatedDuration = freezed,
    Object? defaultTasks = null,
  }) {
    return _then(_$TemplatePhaseImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      defaultDuration: freezed == defaultDuration
          ? _value.defaultDuration
          : defaultDuration // ignore: cast_nullable_to_non_nullable
              as Duration?,
      fields: null == fields
          ? _value._fields
          : fields // ignore: cast_nullable_to_non_nullable
              as List<TemplateField>,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      taskIds: null == taskIds
          ? _value._taskIds
          : taskIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      estimatedDuration: freezed == estimatedDuration
          ? _value.estimatedDuration
          : estimatedDuration // ignore: cast_nullable_to_non_nullable
              as Duration?,
      defaultTasks: null == defaultTasks
          ? _value._defaultTasks
          : defaultTasks // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TemplatePhaseImpl implements _TemplatePhase {
  const _$TemplatePhaseImpl(
      {required this.id,
      required this.name,
      this.description = '',
      this.defaultDuration,
      final List<TemplateField> fields = const [],
      final Map<String, dynamic> metadata = const {},
      this.startDate,
      this.endDate,
      final List<String> taskIds = const [],
      this.isCompleted = false,
      this.createdAt,
      this.updatedAt,
      this.order = 0,
      this.estimatedDuration,
      final List<Map<String, dynamic>> defaultTasks = const []})
      : _fields = fields,
        _metadata = metadata,
        _taskIds = taskIds,
        _defaultTasks = defaultTasks;

  factory _$TemplatePhaseImpl.fromJson(Map<String, dynamic> json) =>
      _$$TemplatePhaseImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  @JsonKey()
  final String description;
  @override
  final Duration? defaultDuration;
  final List<TemplateField> _fields;
  @override
  @JsonKey()
  List<TemplateField> get fields {
    if (_fields is EqualUnmodifiableListView) return _fields;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_fields);
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
  final DateTime? startDate;
  @override
  final DateTime? endDate;
  final List<String> _taskIds;
  @override
  @JsonKey()
  List<String> get taskIds {
    if (_taskIds is EqualUnmodifiableListView) return _taskIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_taskIds);
  }

  @override
  @JsonKey()
  final bool isCompleted;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  @JsonKey()
  final int order;
  @override
  final Duration? estimatedDuration;
  final List<Map<String, dynamic>> _defaultTasks;
  @override
  @JsonKey()
  List<Map<String, dynamic>> get defaultTasks {
    if (_defaultTasks is EqualUnmodifiableListView) return _defaultTasks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_defaultTasks);
  }

  @override
  String toString() {
    return 'TemplatePhase(id: $id, name: $name, description: $description, defaultDuration: $defaultDuration, fields: $fields, metadata: $metadata, startDate: $startDate, endDate: $endDate, taskIds: $taskIds, isCompleted: $isCompleted, createdAt: $createdAt, updatedAt: $updatedAt, order: $order, estimatedDuration: $estimatedDuration, defaultTasks: $defaultTasks)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TemplatePhaseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.defaultDuration, defaultDuration) ||
                other.defaultDuration == defaultDuration) &&
            const DeepCollectionEquality().equals(other._fields, _fields) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            const DeepCollectionEquality().equals(other._taskIds, _taskIds) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.estimatedDuration, estimatedDuration) ||
                other.estimatedDuration == estimatedDuration) &&
            const DeepCollectionEquality()
                .equals(other._defaultTasks, _defaultTasks));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      description,
      defaultDuration,
      const DeepCollectionEquality().hash(_fields),
      const DeepCollectionEquality().hash(_metadata),
      startDate,
      endDate,
      const DeepCollectionEquality().hash(_taskIds),
      isCompleted,
      createdAt,
      updatedAt,
      order,
      estimatedDuration,
      const DeepCollectionEquality().hash(_defaultTasks));

  /// Create a copy of TemplatePhase
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TemplatePhaseImplCopyWith<_$TemplatePhaseImpl> get copyWith =>
      __$$TemplatePhaseImplCopyWithImpl<_$TemplatePhaseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TemplatePhaseImplToJson(
      this,
    );
  }
}

abstract class _TemplatePhase implements TemplatePhase {
  const factory _TemplatePhase(
      {required final String id,
      required final String name,
      final String description,
      final Duration? defaultDuration,
      final List<TemplateField> fields,
      final Map<String, dynamic> metadata,
      final DateTime? startDate,
      final DateTime? endDate,
      final List<String> taskIds,
      final bool isCompleted,
      final DateTime? createdAt,
      final DateTime? updatedAt,
      final int order,
      final Duration? estimatedDuration,
      final List<Map<String, dynamic>> defaultTasks}) = _$TemplatePhaseImpl;

  factory _TemplatePhase.fromJson(Map<String, dynamic> json) =
      _$TemplatePhaseImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get description;
  @override
  Duration? get defaultDuration;
  @override
  List<TemplateField> get fields;
  @override
  Map<String, dynamic> get metadata;
  @override
  DateTime? get startDate;
  @override
  DateTime? get endDate;
  @override
  List<String> get taskIds;
  @override
  bool get isCompleted;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  int get order;
  @override
  Duration? get estimatedDuration;
  @override
  List<Map<String, dynamic>> get defaultTasks;

  /// Create a copy of TemplatePhase
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TemplatePhaseImplCopyWith<_$TemplatePhaseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TemplateMilestone _$TemplateMilestoneFromJson(Map<String, dynamic> json) {
  return _TemplateMilestone.fromJson(json);
}

/// @nodoc
mixin _$TemplateMilestone {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  DateTime? get dueDate => throw _privateConstructorUsedError;
  bool get isCompleted => throw _privateConstructorUsedError;
  List<String> get tasks => throw _privateConstructorUsedError;

  /// Serializes this TemplateMilestone to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TemplateMilestone
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TemplateMilestoneCopyWith<TemplateMilestone> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TemplateMilestoneCopyWith<$Res> {
  factory $TemplateMilestoneCopyWith(
          TemplateMilestone value, $Res Function(TemplateMilestone) then) =
      _$TemplateMilestoneCopyWithImpl<$Res, TemplateMilestone>;
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      DateTime? dueDate,
      bool isCompleted,
      List<String> tasks});
}

/// @nodoc
class _$TemplateMilestoneCopyWithImpl<$Res, $Val extends TemplateMilestone>
    implements $TemplateMilestoneCopyWith<$Res> {
  _$TemplateMilestoneCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TemplateMilestone
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? dueDate = freezed,
    Object? isCompleted = null,
    Object? tasks = null,
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
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      dueDate: freezed == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      tasks: null == tasks
          ? _value.tasks
          : tasks // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TemplateMilestoneImplCopyWith<$Res>
    implements $TemplateMilestoneCopyWith<$Res> {
  factory _$$TemplateMilestoneImplCopyWith(_$TemplateMilestoneImpl value,
          $Res Function(_$TemplateMilestoneImpl) then) =
      __$$TemplateMilestoneImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      DateTime? dueDate,
      bool isCompleted,
      List<String> tasks});
}

/// @nodoc
class __$$TemplateMilestoneImplCopyWithImpl<$Res>
    extends _$TemplateMilestoneCopyWithImpl<$Res, _$TemplateMilestoneImpl>
    implements _$$TemplateMilestoneImplCopyWith<$Res> {
  __$$TemplateMilestoneImplCopyWithImpl(_$TemplateMilestoneImpl _value,
      $Res Function(_$TemplateMilestoneImpl) _then)
      : super(_value, _then);

  /// Create a copy of TemplateMilestone
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? dueDate = freezed,
    Object? isCompleted = null,
    Object? tasks = null,
  }) {
    return _then(_$TemplateMilestoneImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      dueDate: freezed == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      tasks: null == tasks
          ? _value._tasks
          : tasks // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TemplateMilestoneImpl implements _TemplateMilestone {
  const _$TemplateMilestoneImpl(
      {required this.id,
      required this.name,
      this.description = '',
      this.dueDate,
      this.isCompleted = false,
      final List<String> tasks = const []})
      : _tasks = tasks;

  factory _$TemplateMilestoneImpl.fromJson(Map<String, dynamic> json) =>
      _$$TemplateMilestoneImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  @JsonKey()
  final String description;
  @override
  final DateTime? dueDate;
  @override
  @JsonKey()
  final bool isCompleted;
  final List<String> _tasks;
  @override
  @JsonKey()
  List<String> get tasks {
    if (_tasks is EqualUnmodifiableListView) return _tasks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tasks);
  }

  @override
  String toString() {
    return 'TemplateMilestone(id: $id, name: $name, description: $description, dueDate: $dueDate, isCompleted: $isCompleted, tasks: $tasks)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TemplateMilestoneImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            const DeepCollectionEquality().equals(other._tasks, _tasks));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, description, dueDate,
      isCompleted, const DeepCollectionEquality().hash(_tasks));

  /// Create a copy of TemplateMilestone
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TemplateMilestoneImplCopyWith<_$TemplateMilestoneImpl> get copyWith =>
      __$$TemplateMilestoneImplCopyWithImpl<_$TemplateMilestoneImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TemplateMilestoneImplToJson(
      this,
    );
  }
}

abstract class _TemplateMilestone implements TemplateMilestone {
  const factory _TemplateMilestone(
      {required final String id,
      required final String name,
      final String description,
      final DateTime? dueDate,
      final bool isCompleted,
      final List<String> tasks}) = _$TemplateMilestoneImpl;

  factory _TemplateMilestone.fromJson(Map<String, dynamic> json) =
      _$TemplateMilestoneImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get description;
  @override
  DateTime? get dueDate;
  @override
  bool get isCompleted;
  @override
  List<String> get tasks;

  /// Create a copy of TemplateMilestone
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TemplateMilestoneImplCopyWith<_$TemplateMilestoneImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ProjectTemplateConfig {
  String get id => throw _privateConstructorUsedError;
  ProjectType get type => throw _privateConstructorUsedError;
  List<TemplatePhase> get defaultPhases => throw _privateConstructorUsedError;
  List<TemplateField> get customFields => throw _privateConstructorUsedError;
  Map<String, List<String>> get requiredRoles =>
      throw _privateConstructorUsedError;
  Map<String, List<String>> get deliverableTypes =>
      throw _privateConstructorUsedError;
  List<String> get defaultTags => throw _privateConstructorUsedError;
  WorkflowTemplate get defaultWorkflow => throw _privateConstructorUsedError;
  List<TemplateMilestone> get defaultMilestones =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> get typeSpecificSettings =>
      throw _privateConstructorUsedError;

  /// Create a copy of ProjectTemplateConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProjectTemplateConfigCopyWith<ProjectTemplateConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProjectTemplateConfigCopyWith<$Res> {
  factory $ProjectTemplateConfigCopyWith(ProjectTemplateConfig value,
          $Res Function(ProjectTemplateConfig) then) =
      _$ProjectTemplateConfigCopyWithImpl<$Res, ProjectTemplateConfig>;
  @useResult
  $Res call(
      {String id,
      ProjectType type,
      List<TemplatePhase> defaultPhases,
      List<TemplateField> customFields,
      Map<String, List<String>> requiredRoles,
      Map<String, List<String>> deliverableTypes,
      List<String> defaultTags,
      WorkflowTemplate defaultWorkflow,
      List<TemplateMilestone> defaultMilestones,
      Map<String, dynamic> typeSpecificSettings});

  $WorkflowTemplateCopyWith<$Res> get defaultWorkflow;
}

/// @nodoc
class _$ProjectTemplateConfigCopyWithImpl<$Res,
        $Val extends ProjectTemplateConfig>
    implements $ProjectTemplateConfigCopyWith<$Res> {
  _$ProjectTemplateConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProjectTemplateConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? defaultPhases = null,
    Object? customFields = null,
    Object? requiredRoles = null,
    Object? deliverableTypes = null,
    Object? defaultTags = null,
    Object? defaultWorkflow = null,
    Object? defaultMilestones = null,
    Object? typeSpecificSettings = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ProjectType,
      defaultPhases: null == defaultPhases
          ? _value.defaultPhases
          : defaultPhases // ignore: cast_nullable_to_non_nullable
              as List<TemplatePhase>,
      customFields: null == customFields
          ? _value.customFields
          : customFields // ignore: cast_nullable_to_non_nullable
              as List<TemplateField>,
      requiredRoles: null == requiredRoles
          ? _value.requiredRoles
          : requiredRoles // ignore: cast_nullable_to_non_nullable
              as Map<String, List<String>>,
      deliverableTypes: null == deliverableTypes
          ? _value.deliverableTypes
          : deliverableTypes // ignore: cast_nullable_to_non_nullable
              as Map<String, List<String>>,
      defaultTags: null == defaultTags
          ? _value.defaultTags
          : defaultTags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      defaultWorkflow: null == defaultWorkflow
          ? _value.defaultWorkflow
          : defaultWorkflow // ignore: cast_nullable_to_non_nullable
              as WorkflowTemplate,
      defaultMilestones: null == defaultMilestones
          ? _value.defaultMilestones
          : defaultMilestones // ignore: cast_nullable_to_non_nullable
              as List<TemplateMilestone>,
      typeSpecificSettings: null == typeSpecificSettings
          ? _value.typeSpecificSettings
          : typeSpecificSettings // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }

  /// Create a copy of ProjectTemplateConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WorkflowTemplateCopyWith<$Res> get defaultWorkflow {
    return $WorkflowTemplateCopyWith<$Res>(_value.defaultWorkflow, (value) {
      return _then(_value.copyWith(defaultWorkflow: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ProjectTemplateConfigImplCopyWith<$Res>
    implements $ProjectTemplateConfigCopyWith<$Res> {
  factory _$$ProjectTemplateConfigImplCopyWith(
          _$ProjectTemplateConfigImpl value,
          $Res Function(_$ProjectTemplateConfigImpl) then) =
      __$$ProjectTemplateConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      ProjectType type,
      List<TemplatePhase> defaultPhases,
      List<TemplateField> customFields,
      Map<String, List<String>> requiredRoles,
      Map<String, List<String>> deliverableTypes,
      List<String> defaultTags,
      WorkflowTemplate defaultWorkflow,
      List<TemplateMilestone> defaultMilestones,
      Map<String, dynamic> typeSpecificSettings});

  @override
  $WorkflowTemplateCopyWith<$Res> get defaultWorkflow;
}

/// @nodoc
class __$$ProjectTemplateConfigImplCopyWithImpl<$Res>
    extends _$ProjectTemplateConfigCopyWithImpl<$Res,
        _$ProjectTemplateConfigImpl>
    implements _$$ProjectTemplateConfigImplCopyWith<$Res> {
  __$$ProjectTemplateConfigImplCopyWithImpl(_$ProjectTemplateConfigImpl _value,
      $Res Function(_$ProjectTemplateConfigImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProjectTemplateConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? defaultPhases = null,
    Object? customFields = null,
    Object? requiredRoles = null,
    Object? deliverableTypes = null,
    Object? defaultTags = null,
    Object? defaultWorkflow = null,
    Object? defaultMilestones = null,
    Object? typeSpecificSettings = null,
  }) {
    return _then(_$ProjectTemplateConfigImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ProjectType,
      defaultPhases: null == defaultPhases
          ? _value._defaultPhases
          : defaultPhases // ignore: cast_nullable_to_non_nullable
              as List<TemplatePhase>,
      customFields: null == customFields
          ? _value._customFields
          : customFields // ignore: cast_nullable_to_non_nullable
              as List<TemplateField>,
      requiredRoles: null == requiredRoles
          ? _value._requiredRoles
          : requiredRoles // ignore: cast_nullable_to_non_nullable
              as Map<String, List<String>>,
      deliverableTypes: null == deliverableTypes
          ? _value._deliverableTypes
          : deliverableTypes // ignore: cast_nullable_to_non_nullable
              as Map<String, List<String>>,
      defaultTags: null == defaultTags
          ? _value._defaultTags
          : defaultTags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      defaultWorkflow: null == defaultWorkflow
          ? _value.defaultWorkflow
          : defaultWorkflow // ignore: cast_nullable_to_non_nullable
              as WorkflowTemplate,
      defaultMilestones: null == defaultMilestones
          ? _value._defaultMilestones
          : defaultMilestones // ignore: cast_nullable_to_non_nullable
              as List<TemplateMilestone>,
      typeSpecificSettings: null == typeSpecificSettings
          ? _value._typeSpecificSettings
          : typeSpecificSettings // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc

class _$ProjectTemplateConfigImpl extends _ProjectTemplateConfig {
  const _$ProjectTemplateConfigImpl(
      {required this.id,
      required this.type,
      required final List<TemplatePhase> defaultPhases,
      final List<TemplateField> customFields = const [],
      final Map<String, List<String>> requiredRoles = const {},
      final Map<String, List<String>> deliverableTypes = const {},
      final List<String> defaultTags = const [],
      required this.defaultWorkflow,
      final List<TemplateMilestone> defaultMilestones = const [],
      final Map<String, dynamic> typeSpecificSettings = const {}})
      : _defaultPhases = defaultPhases,
        _customFields = customFields,
        _requiredRoles = requiredRoles,
        _deliverableTypes = deliverableTypes,
        _defaultTags = defaultTags,
        _defaultMilestones = defaultMilestones,
        _typeSpecificSettings = typeSpecificSettings,
        super._();

  @override
  final String id;
  @override
  final ProjectType type;
  final List<TemplatePhase> _defaultPhases;
  @override
  List<TemplatePhase> get defaultPhases {
    if (_defaultPhases is EqualUnmodifiableListView) return _defaultPhases;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_defaultPhases);
  }

  final List<TemplateField> _customFields;
  @override
  @JsonKey()
  List<TemplateField> get customFields {
    if (_customFields is EqualUnmodifiableListView) return _customFields;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_customFields);
  }

  final Map<String, List<String>> _requiredRoles;
  @override
  @JsonKey()
  Map<String, List<String>> get requiredRoles {
    if (_requiredRoles is EqualUnmodifiableMapView) return _requiredRoles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_requiredRoles);
  }

  final Map<String, List<String>> _deliverableTypes;
  @override
  @JsonKey()
  Map<String, List<String>> get deliverableTypes {
    if (_deliverableTypes is EqualUnmodifiableMapView) return _deliverableTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_deliverableTypes);
  }

  final List<String> _defaultTags;
  @override
  @JsonKey()
  List<String> get defaultTags {
    if (_defaultTags is EqualUnmodifiableListView) return _defaultTags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_defaultTags);
  }

  @override
  final WorkflowTemplate defaultWorkflow;
  final List<TemplateMilestone> _defaultMilestones;
  @override
  @JsonKey()
  List<TemplateMilestone> get defaultMilestones {
    if (_defaultMilestones is EqualUnmodifiableListView)
      return _defaultMilestones;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_defaultMilestones);
  }

  final Map<String, dynamic> _typeSpecificSettings;
  @override
  @JsonKey()
  Map<String, dynamic> get typeSpecificSettings {
    if (_typeSpecificSettings is EqualUnmodifiableMapView)
      return _typeSpecificSettings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_typeSpecificSettings);
  }

  @override
  String toString() {
    return 'ProjectTemplateConfig(id: $id, type: $type, defaultPhases: $defaultPhases, customFields: $customFields, requiredRoles: $requiredRoles, deliverableTypes: $deliverableTypes, defaultTags: $defaultTags, defaultWorkflow: $defaultWorkflow, defaultMilestones: $defaultMilestones, typeSpecificSettings: $typeSpecificSettings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProjectTemplateConfigImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality()
                .equals(other._defaultPhases, _defaultPhases) &&
            const DeepCollectionEquality()
                .equals(other._customFields, _customFields) &&
            const DeepCollectionEquality()
                .equals(other._requiredRoles, _requiredRoles) &&
            const DeepCollectionEquality()
                .equals(other._deliverableTypes, _deliverableTypes) &&
            const DeepCollectionEquality()
                .equals(other._defaultTags, _defaultTags) &&
            (identical(other.defaultWorkflow, defaultWorkflow) ||
                other.defaultWorkflow == defaultWorkflow) &&
            const DeepCollectionEquality()
                .equals(other._defaultMilestones, _defaultMilestones) &&
            const DeepCollectionEquality()
                .equals(other._typeSpecificSettings, _typeSpecificSettings));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      type,
      const DeepCollectionEquality().hash(_defaultPhases),
      const DeepCollectionEquality().hash(_customFields),
      const DeepCollectionEquality().hash(_requiredRoles),
      const DeepCollectionEquality().hash(_deliverableTypes),
      const DeepCollectionEquality().hash(_defaultTags),
      defaultWorkflow,
      const DeepCollectionEquality().hash(_defaultMilestones),
      const DeepCollectionEquality().hash(_typeSpecificSettings));

  /// Create a copy of ProjectTemplateConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProjectTemplateConfigImplCopyWith<_$ProjectTemplateConfigImpl>
      get copyWith => __$$ProjectTemplateConfigImplCopyWithImpl<
          _$ProjectTemplateConfigImpl>(this, _$identity);
}

abstract class _ProjectTemplateConfig extends ProjectTemplateConfig {
  const factory _ProjectTemplateConfig(
          {required final String id,
          required final ProjectType type,
          required final List<TemplatePhase> defaultPhases,
          final List<TemplateField> customFields,
          final Map<String, List<String>> requiredRoles,
          final Map<String, List<String>> deliverableTypes,
          final List<String> defaultTags,
          required final WorkflowTemplate defaultWorkflow,
          final List<TemplateMilestone> defaultMilestones,
          final Map<String, dynamic> typeSpecificSettings}) =
      _$ProjectTemplateConfigImpl;
  const _ProjectTemplateConfig._() : super._();

  @override
  String get id;
  @override
  ProjectType get type;
  @override
  List<TemplatePhase> get defaultPhases;
  @override
  List<TemplateField> get customFields;
  @override
  Map<String, List<String>> get requiredRoles;
  @override
  Map<String, List<String>> get deliverableTypes;
  @override
  List<String> get defaultTags;
  @override
  WorkflowTemplate get defaultWorkflow;
  @override
  List<TemplateMilestone> get defaultMilestones;
  @override
  Map<String, dynamic> get typeSpecificSettings;

  /// Create a copy of ProjectTemplateConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProjectTemplateConfigImplCopyWith<_$ProjectTemplateConfigImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ProjectTemplate {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  bool get isPublic => throw _privateConstructorUsedError;
  bool get isArchived => throw _privateConstructorUsedError;
  bool get isDerived => throw _privateConstructorUsedError;
  String get organizationId => throw _privateConstructorUsedError;
  String get createdBy => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  ProjectTemplateConfig get config => throw _privateConstructorUsedError;
  int get version => throw _privateConstructorUsedError;
  String? get parentTemplateId => throw _privateConstructorUsedError;
  Map<String, dynamic> get typeSpecificFields =>
      throw _privateConstructorUsedError;

  /// Create a copy of ProjectTemplate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProjectTemplateCopyWith<ProjectTemplate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProjectTemplateCopyWith<$Res> {
  factory $ProjectTemplateCopyWith(
          ProjectTemplate value, $Res Function(ProjectTemplate) then) =
      _$ProjectTemplateCopyWithImpl<$Res, ProjectTemplate>;
  @useResult
  $Res call(
      {String id,
      String name,
      String? description,
      List<String> tags,
      bool isPublic,
      bool isArchived,
      bool isDerived,
      String organizationId,
      String createdBy,
      DateTime? createdAt,
      DateTime? updatedAt,
      ProjectTemplateConfig config,
      int version,
      String? parentTemplateId,
      Map<String, dynamic> typeSpecificFields});

  $ProjectTemplateConfigCopyWith<$Res> get config;
}

/// @nodoc
class _$ProjectTemplateCopyWithImpl<$Res, $Val extends ProjectTemplate>
    implements $ProjectTemplateCopyWith<$Res> {
  _$ProjectTemplateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProjectTemplate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? tags = null,
    Object? isPublic = null,
    Object? isArchived = null,
    Object? isDerived = null,
    Object? organizationId = null,
    Object? createdBy = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? config = null,
    Object? version = null,
    Object? parentTemplateId = freezed,
    Object? typeSpecificFields = null,
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
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isPublic: null == isPublic
          ? _value.isPublic
          : isPublic // ignore: cast_nullable_to_non_nullable
              as bool,
      isArchived: null == isArchived
          ? _value.isArchived
          : isArchived // ignore: cast_nullable_to_non_nullable
              as bool,
      isDerived: null == isDerived
          ? _value.isDerived
          : isDerived // ignore: cast_nullable_to_non_nullable
              as bool,
      organizationId: null == organizationId
          ? _value.organizationId
          : organizationId // ignore: cast_nullable_to_non_nullable
              as String,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      config: null == config
          ? _value.config
          : config // ignore: cast_nullable_to_non_nullable
              as ProjectTemplateConfig,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
      parentTemplateId: freezed == parentTemplateId
          ? _value.parentTemplateId
          : parentTemplateId // ignore: cast_nullable_to_non_nullable
              as String?,
      typeSpecificFields: null == typeSpecificFields
          ? _value.typeSpecificFields
          : typeSpecificFields // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }

  /// Create a copy of ProjectTemplate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProjectTemplateConfigCopyWith<$Res> get config {
    return $ProjectTemplateConfigCopyWith<$Res>(_value.config, (value) {
      return _then(_value.copyWith(config: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ProjectTemplateImplCopyWith<$Res>
    implements $ProjectTemplateCopyWith<$Res> {
  factory _$$ProjectTemplateImplCopyWith(_$ProjectTemplateImpl value,
          $Res Function(_$ProjectTemplateImpl) then) =
      __$$ProjectTemplateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String? description,
      List<String> tags,
      bool isPublic,
      bool isArchived,
      bool isDerived,
      String organizationId,
      String createdBy,
      DateTime? createdAt,
      DateTime? updatedAt,
      ProjectTemplateConfig config,
      int version,
      String? parentTemplateId,
      Map<String, dynamic> typeSpecificFields});

  @override
  $ProjectTemplateConfigCopyWith<$Res> get config;
}

/// @nodoc
class __$$ProjectTemplateImplCopyWithImpl<$Res>
    extends _$ProjectTemplateCopyWithImpl<$Res, _$ProjectTemplateImpl>
    implements _$$ProjectTemplateImplCopyWith<$Res> {
  __$$ProjectTemplateImplCopyWithImpl(
      _$ProjectTemplateImpl _value, $Res Function(_$ProjectTemplateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProjectTemplate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? tags = null,
    Object? isPublic = null,
    Object? isArchived = null,
    Object? isDerived = null,
    Object? organizationId = null,
    Object? createdBy = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? config = null,
    Object? version = null,
    Object? parentTemplateId = freezed,
    Object? typeSpecificFields = null,
  }) {
    return _then(_$ProjectTemplateImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isPublic: null == isPublic
          ? _value.isPublic
          : isPublic // ignore: cast_nullable_to_non_nullable
              as bool,
      isArchived: null == isArchived
          ? _value.isArchived
          : isArchived // ignore: cast_nullable_to_non_nullable
              as bool,
      isDerived: null == isDerived
          ? _value.isDerived
          : isDerived // ignore: cast_nullable_to_non_nullable
              as bool,
      organizationId: null == organizationId
          ? _value.organizationId
          : organizationId // ignore: cast_nullable_to_non_nullable
              as String,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      config: null == config
          ? _value.config
          : config // ignore: cast_nullable_to_non_nullable
              as ProjectTemplateConfig,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
      parentTemplateId: freezed == parentTemplateId
          ? _value.parentTemplateId
          : parentTemplateId // ignore: cast_nullable_to_non_nullable
              as String?,
      typeSpecificFields: null == typeSpecificFields
          ? _value._typeSpecificFields
          : typeSpecificFields // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc

class _$ProjectTemplateImpl extends _ProjectTemplate {
  const _$ProjectTemplateImpl(
      {required this.id,
      required this.name,
      this.description,
      final List<String> tags = const [],
      this.isPublic = false,
      this.isArchived = false,
      this.isDerived = false,
      this.organizationId = '',
      this.createdBy = '',
      this.createdAt,
      this.updatedAt,
      required this.config,
      this.version = 1,
      this.parentTemplateId,
      final Map<String, dynamic> typeSpecificFields = const {}})
      : _tags = tags,
        _typeSpecificFields = typeSpecificFields,
        super._();

  @override
  final String id;
  @override
  final String name;
  @override
  final String? description;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  @JsonKey()
  final bool isPublic;
  @override
  @JsonKey()
  final bool isArchived;
  @override
  @JsonKey()
  final bool isDerived;
  @override
  @JsonKey()
  final String organizationId;
  @override
  @JsonKey()
  final String createdBy;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final ProjectTemplateConfig config;
  @override
  @JsonKey()
  final int version;
  @override
  final String? parentTemplateId;
  final Map<String, dynamic> _typeSpecificFields;
  @override
  @JsonKey()
  Map<String, dynamic> get typeSpecificFields {
    if (_typeSpecificFields is EqualUnmodifiableMapView)
      return _typeSpecificFields;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_typeSpecificFields);
  }

  @override
  String toString() {
    return 'ProjectTemplate(id: $id, name: $name, description: $description, tags: $tags, isPublic: $isPublic, isArchived: $isArchived, isDerived: $isDerived, organizationId: $organizationId, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt, config: $config, version: $version, parentTemplateId: $parentTemplateId, typeSpecificFields: $typeSpecificFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProjectTemplateImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.isPublic, isPublic) ||
                other.isPublic == isPublic) &&
            (identical(other.isArchived, isArchived) ||
                other.isArchived == isArchived) &&
            (identical(other.isDerived, isDerived) ||
                other.isDerived == isDerived) &&
            (identical(other.organizationId, organizationId) ||
                other.organizationId == organizationId) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.config, config) || other.config == config) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.parentTemplateId, parentTemplateId) ||
                other.parentTemplateId == parentTemplateId) &&
            const DeepCollectionEquality()
                .equals(other._typeSpecificFields, _typeSpecificFields));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      description,
      const DeepCollectionEquality().hash(_tags),
      isPublic,
      isArchived,
      isDerived,
      organizationId,
      createdBy,
      createdAt,
      updatedAt,
      config,
      version,
      parentTemplateId,
      const DeepCollectionEquality().hash(_typeSpecificFields));

  /// Create a copy of ProjectTemplate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProjectTemplateImplCopyWith<_$ProjectTemplateImpl> get copyWith =>
      __$$ProjectTemplateImplCopyWithImpl<_$ProjectTemplateImpl>(
          this, _$identity);
}

abstract class _ProjectTemplate extends ProjectTemplate {
  const factory _ProjectTemplate(
      {required final String id,
      required final String name,
      final String? description,
      final List<String> tags,
      final bool isPublic,
      final bool isArchived,
      final bool isDerived,
      final String organizationId,
      final String createdBy,
      final DateTime? createdAt,
      final DateTime? updatedAt,
      required final ProjectTemplateConfig config,
      final int version,
      final String? parentTemplateId,
      final Map<String, dynamic> typeSpecificFields}) = _$ProjectTemplateImpl;
  const _ProjectTemplate._() : super._();

  @override
  String get id;
  @override
  String get name;
  @override
  String? get description;
  @override
  List<String> get tags;
  @override
  bool get isPublic;
  @override
  bool get isArchived;
  @override
  bool get isDerived;
  @override
  String get organizationId;
  @override
  String get createdBy;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  ProjectTemplateConfig get config;
  @override
  int get version;
  @override
  String? get parentTemplateId;
  @override
  Map<String, dynamic> get typeSpecificFields;

  /// Create a copy of ProjectTemplate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProjectTemplateImplCopyWith<_$ProjectTemplateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
