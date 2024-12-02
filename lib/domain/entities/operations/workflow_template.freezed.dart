// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workflow_template.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WorkflowState _$WorkflowStateFromJson(Map<String, dynamic> json) {
  return _WorkflowState.fromJson(json);
}

/// @nodoc
mixin _$WorkflowState {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get color => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  bool get isInitial => throw _privateConstructorUsedError;
  bool get isFinal => throw _privateConstructorUsedError;
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;

  /// Serializes this WorkflowState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkflowState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkflowStateCopyWith<WorkflowState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkflowStateCopyWith<$Res> {
  factory $WorkflowStateCopyWith(
          WorkflowState value, $Res Function(WorkflowState) then) =
      _$WorkflowStateCopyWithImpl<$Res, WorkflowState>;
  @useResult
  $Res call(
      {String id,
      String name,
      String color,
      String description,
      bool isInitial,
      bool isFinal,
      Map<String, dynamic> metadata});
}

/// @nodoc
class _$WorkflowStateCopyWithImpl<$Res, $Val extends WorkflowState>
    implements $WorkflowStateCopyWith<$Res> {
  _$WorkflowStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkflowState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? color = null,
    Object? description = null,
    Object? isInitial = null,
    Object? isFinal = null,
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
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      isInitial: null == isInitial
          ? _value.isInitial
          : isInitial // ignore: cast_nullable_to_non_nullable
              as bool,
      isFinal: null == isFinal
          ? _value.isFinal
          : isFinal // ignore: cast_nullable_to_non_nullable
              as bool,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkflowStateImplCopyWith<$Res>
    implements $WorkflowStateCopyWith<$Res> {
  factory _$$WorkflowStateImplCopyWith(
          _$WorkflowStateImpl value, $Res Function(_$WorkflowStateImpl) then) =
      __$$WorkflowStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String color,
      String description,
      bool isInitial,
      bool isFinal,
      Map<String, dynamic> metadata});
}

/// @nodoc
class __$$WorkflowStateImplCopyWithImpl<$Res>
    extends _$WorkflowStateCopyWithImpl<$Res, _$WorkflowStateImpl>
    implements _$$WorkflowStateImplCopyWith<$Res> {
  __$$WorkflowStateImplCopyWithImpl(
      _$WorkflowStateImpl _value, $Res Function(_$WorkflowStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkflowState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? color = null,
    Object? description = null,
    Object? isInitial = null,
    Object? isFinal = null,
    Object? metadata = null,
  }) {
    return _then(_$WorkflowStateImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      isInitial: null == isInitial
          ? _value.isInitial
          : isInitial // ignore: cast_nullable_to_non_nullable
              as bool,
      isFinal: null == isFinal
          ? _value.isFinal
          : isFinal // ignore: cast_nullable_to_non_nullable
              as bool,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkflowStateImpl extends _WorkflowState {
  const _$WorkflowStateImpl(
      {required this.id,
      required this.name,
      this.color = '#808080',
      this.description = '',
      this.isInitial = false,
      this.isFinal = false,
      final Map<String, dynamic> metadata = const {}})
      : _metadata = metadata,
        super._();

  factory _$WorkflowStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkflowStateImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  @JsonKey()
  final String color;
  @override
  @JsonKey()
  final String description;
  @override
  @JsonKey()
  final bool isInitial;
  @override
  @JsonKey()
  final bool isFinal;
  final Map<String, dynamic> _metadata;
  @override
  @JsonKey()
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  String toString() {
    return 'WorkflowState(id: $id, name: $name, color: $color, description: $description, isInitial: $isInitial, isFinal: $isFinal, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkflowStateImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isInitial, isInitial) ||
                other.isInitial == isInitial) &&
            (identical(other.isFinal, isFinal) || other.isFinal == isFinal) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, color, description,
      isInitial, isFinal, const DeepCollectionEquality().hash(_metadata));

  /// Create a copy of WorkflowState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkflowStateImplCopyWith<_$WorkflowStateImpl> get copyWith =>
      __$$WorkflowStateImplCopyWithImpl<_$WorkflowStateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkflowStateImplToJson(
      this,
    );
  }
}

abstract class _WorkflowState extends WorkflowState {
  const factory _WorkflowState(
      {required final String id,
      required final String name,
      final String color,
      final String description,
      final bool isInitial,
      final bool isFinal,
      final Map<String, dynamic> metadata}) = _$WorkflowStateImpl;
  const _WorkflowState._() : super._();

  factory _WorkflowState.fromJson(Map<String, dynamic> json) =
      _$WorkflowStateImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get color;
  @override
  String get description;
  @override
  bool get isInitial;
  @override
  bool get isFinal;
  @override
  Map<String, dynamic> get metadata;

  /// Create a copy of WorkflowState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkflowStateImplCopyWith<_$WorkflowStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WorkflowTransition _$WorkflowTransitionFromJson(Map<String, dynamic> json) {
  return _WorkflowTransition.fromJson(json);
}

/// @nodoc
mixin _$WorkflowTransition {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get fromStateId => throw _privateConstructorUsedError;
  String get toStateId => throw _privateConstructorUsedError;
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;

  /// Serializes this WorkflowTransition to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkflowTransition
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkflowTransitionCopyWith<WorkflowTransition> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkflowTransitionCopyWith<$Res> {
  factory $WorkflowTransitionCopyWith(
          WorkflowTransition value, $Res Function(WorkflowTransition) then) =
      _$WorkflowTransitionCopyWithImpl<$Res, WorkflowTransition>;
  @useResult
  $Res call(
      {String id,
      String name,
      String fromStateId,
      String toStateId,
      Map<String, dynamic> metadata});
}

/// @nodoc
class _$WorkflowTransitionCopyWithImpl<$Res, $Val extends WorkflowTransition>
    implements $WorkflowTransitionCopyWith<$Res> {
  _$WorkflowTransitionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkflowTransition
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? fromStateId = null,
    Object? toStateId = null,
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
      fromStateId: null == fromStateId
          ? _value.fromStateId
          : fromStateId // ignore: cast_nullable_to_non_nullable
              as String,
      toStateId: null == toStateId
          ? _value.toStateId
          : toStateId // ignore: cast_nullable_to_non_nullable
              as String,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkflowTransitionImplCopyWith<$Res>
    implements $WorkflowTransitionCopyWith<$Res> {
  factory _$$WorkflowTransitionImplCopyWith(_$WorkflowTransitionImpl value,
          $Res Function(_$WorkflowTransitionImpl) then) =
      __$$WorkflowTransitionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String fromStateId,
      String toStateId,
      Map<String, dynamic> metadata});
}

/// @nodoc
class __$$WorkflowTransitionImplCopyWithImpl<$Res>
    extends _$WorkflowTransitionCopyWithImpl<$Res, _$WorkflowTransitionImpl>
    implements _$$WorkflowTransitionImplCopyWith<$Res> {
  __$$WorkflowTransitionImplCopyWithImpl(_$WorkflowTransitionImpl _value,
      $Res Function(_$WorkflowTransitionImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkflowTransition
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? fromStateId = null,
    Object? toStateId = null,
    Object? metadata = null,
  }) {
    return _then(_$WorkflowTransitionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      fromStateId: null == fromStateId
          ? _value.fromStateId
          : fromStateId // ignore: cast_nullable_to_non_nullable
              as String,
      toStateId: null == toStateId
          ? _value.toStateId
          : toStateId // ignore: cast_nullable_to_non_nullable
              as String,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkflowTransitionImpl implements _WorkflowTransition {
  const _$WorkflowTransitionImpl(
      {required this.id,
      required this.name,
      required this.fromStateId,
      required this.toStateId,
      final Map<String, dynamic> metadata = const {}})
      : _metadata = metadata;

  factory _$WorkflowTransitionImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkflowTransitionImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String fromStateId;
  @override
  final String toStateId;
  final Map<String, dynamic> _metadata;
  @override
  @JsonKey()
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  String toString() {
    return 'WorkflowTransition(id: $id, name: $name, fromStateId: $fromStateId, toStateId: $toStateId, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkflowTransitionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.fromStateId, fromStateId) ||
                other.fromStateId == fromStateId) &&
            (identical(other.toStateId, toStateId) ||
                other.toStateId == toStateId) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, fromStateId, toStateId,
      const DeepCollectionEquality().hash(_metadata));

  /// Create a copy of WorkflowTransition
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkflowTransitionImplCopyWith<_$WorkflowTransitionImpl> get copyWith =>
      __$$WorkflowTransitionImplCopyWithImpl<_$WorkflowTransitionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkflowTransitionImplToJson(
      this,
    );
  }
}

abstract class _WorkflowTransition implements WorkflowTransition {
  const factory _WorkflowTransition(
      {required final String id,
      required final String name,
      required final String fromStateId,
      required final String toStateId,
      final Map<String, dynamic> metadata}) = _$WorkflowTransitionImpl;

  factory _WorkflowTransition.fromJson(Map<String, dynamic> json) =
      _$WorkflowTransitionImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get fromStateId;
  @override
  String get toStateId;
  @override
  Map<String, dynamic> get metadata;

  /// Create a copy of WorkflowTransition
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkflowTransitionImplCopyWith<_$WorkflowTransitionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WorkflowTemplate _$WorkflowTemplateFromJson(Map<String, dynamic> json) {
  return _WorkflowTemplate.fromJson(json);
}

/// @nodoc
mixin _$WorkflowTemplate {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  List<WorkflowState> get states => throw _privateConstructorUsedError;
  List<WorkflowTransition> get transitions =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;

  /// Serializes this WorkflowTemplate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkflowTemplate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkflowTemplateCopyWith<WorkflowTemplate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkflowTemplateCopyWith<$Res> {
  factory $WorkflowTemplateCopyWith(
          WorkflowTemplate value, $Res Function(WorkflowTemplate) then) =
      _$WorkflowTemplateCopyWithImpl<$Res, WorkflowTemplate>;
  @useResult
  $Res call(
      {String id,
      String name,
      String? description,
      List<WorkflowState> states,
      List<WorkflowTransition> transitions,
      Map<String, dynamic> metadata});
}

/// @nodoc
class _$WorkflowTemplateCopyWithImpl<$Res, $Val extends WorkflowTemplate>
    implements $WorkflowTemplateCopyWith<$Res> {
  _$WorkflowTemplateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkflowTemplate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? states = null,
    Object? transitions = null,
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
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      states: null == states
          ? _value.states
          : states // ignore: cast_nullable_to_non_nullable
              as List<WorkflowState>,
      transitions: null == transitions
          ? _value.transitions
          : transitions // ignore: cast_nullable_to_non_nullable
              as List<WorkflowTransition>,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkflowTemplateImplCopyWith<$Res>
    implements $WorkflowTemplateCopyWith<$Res> {
  factory _$$WorkflowTemplateImplCopyWith(_$WorkflowTemplateImpl value,
          $Res Function(_$WorkflowTemplateImpl) then) =
      __$$WorkflowTemplateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String? description,
      List<WorkflowState> states,
      List<WorkflowTransition> transitions,
      Map<String, dynamic> metadata});
}

/// @nodoc
class __$$WorkflowTemplateImplCopyWithImpl<$Res>
    extends _$WorkflowTemplateCopyWithImpl<$Res, _$WorkflowTemplateImpl>
    implements _$$WorkflowTemplateImplCopyWith<$Res> {
  __$$WorkflowTemplateImplCopyWithImpl(_$WorkflowTemplateImpl _value,
      $Res Function(_$WorkflowTemplateImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkflowTemplate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? states = null,
    Object? transitions = null,
    Object? metadata = null,
  }) {
    return _then(_$WorkflowTemplateImpl(
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
      states: null == states
          ? _value._states
          : states // ignore: cast_nullable_to_non_nullable
              as List<WorkflowState>,
      transitions: null == transitions
          ? _value._transitions
          : transitions // ignore: cast_nullable_to_non_nullable
              as List<WorkflowTransition>,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkflowTemplateImpl extends _WorkflowTemplate {
  const _$WorkflowTemplateImpl(
      {required this.id,
      required this.name,
      this.description,
      required final List<WorkflowState> states,
      required final List<WorkflowTransition> transitions,
      final Map<String, dynamic> metadata = const {}})
      : _states = states,
        _transitions = transitions,
        _metadata = metadata,
        super._();

  factory _$WorkflowTemplateImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkflowTemplateImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? description;
  final List<WorkflowState> _states;
  @override
  List<WorkflowState> get states {
    if (_states is EqualUnmodifiableListView) return _states;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_states);
  }

  final List<WorkflowTransition> _transitions;
  @override
  List<WorkflowTransition> get transitions {
    if (_transitions is EqualUnmodifiableListView) return _transitions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_transitions);
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
  String toString() {
    return 'WorkflowTemplate(id: $id, name: $name, description: $description, states: $states, transitions: $transitions, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkflowTemplateImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._states, _states) &&
            const DeepCollectionEquality()
                .equals(other._transitions, _transitions) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      description,
      const DeepCollectionEquality().hash(_states),
      const DeepCollectionEquality().hash(_transitions),
      const DeepCollectionEquality().hash(_metadata));

  /// Create a copy of WorkflowTemplate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkflowTemplateImplCopyWith<_$WorkflowTemplateImpl> get copyWith =>
      __$$WorkflowTemplateImplCopyWithImpl<_$WorkflowTemplateImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkflowTemplateImplToJson(
      this,
    );
  }
}

abstract class _WorkflowTemplate extends WorkflowTemplate {
  const factory _WorkflowTemplate(
      {required final String id,
      required final String name,
      final String? description,
      required final List<WorkflowState> states,
      required final List<WorkflowTransition> transitions,
      final Map<String, dynamic> metadata}) = _$WorkflowTemplateImpl;
  const _WorkflowTemplate._() : super._();

  factory _WorkflowTemplate.fromJson(Map<String, dynamic> json) =
      _$WorkflowTemplateImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get description;
  @override
  List<WorkflowState> get states;
  @override
  List<WorkflowTransition> get transitions;
  @override
  Map<String, dynamic> get metadata;

  /// Create a copy of WorkflowTemplate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkflowTemplateImplCopyWith<_$WorkflowTemplateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
