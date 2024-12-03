// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ProjectMember _$ProjectMemberFromJson(Map<String, dynamic> json) {
  return _ProjectMember.fromJson(json);
}

/// @nodoc
mixin _$ProjectMember {
  String get employeeId => throw _privateConstructorUsedError;
  String get employeeName => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;
  ProjectAccess get access => throw _privateConstructorUsedError;
  DateTime get joinedAt => throw _privateConstructorUsedError;
  String? get department => throw _privateConstructorUsedError;

  /// Serializes this ProjectMember to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProjectMember
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProjectMemberCopyWith<ProjectMember> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProjectMemberCopyWith<$Res> {
  factory $ProjectMemberCopyWith(
          ProjectMember value, $Res Function(ProjectMember) then) =
      _$ProjectMemberCopyWithImpl<$Res, ProjectMember>;
  @useResult
  $Res call(
      {String employeeId,
      String employeeName,
      String role,
      ProjectAccess access,
      DateTime joinedAt,
      String? department});
}

/// @nodoc
class _$ProjectMemberCopyWithImpl<$Res, $Val extends ProjectMember>
    implements $ProjectMemberCopyWith<$Res> {
  _$ProjectMemberCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProjectMember
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? employeeId = null,
    Object? employeeName = null,
    Object? role = null,
    Object? access = null,
    Object? joinedAt = null,
    Object? department = freezed,
  }) {
    return _then(_value.copyWith(
      employeeId: null == employeeId
          ? _value.employeeId
          : employeeId // ignore: cast_nullable_to_non_nullable
              as String,
      employeeName: null == employeeName
          ? _value.employeeName
          : employeeName // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      access: null == access
          ? _value.access
          : access // ignore: cast_nullable_to_non_nullable
              as ProjectAccess,
      joinedAt: null == joinedAt
          ? _value.joinedAt
          : joinedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      department: freezed == department
          ? _value.department
          : department // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProjectMemberImplCopyWith<$Res>
    implements $ProjectMemberCopyWith<$Res> {
  factory _$$ProjectMemberImplCopyWith(
          _$ProjectMemberImpl value, $Res Function(_$ProjectMemberImpl) then) =
      __$$ProjectMemberImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String employeeId,
      String employeeName,
      String role,
      ProjectAccess access,
      DateTime joinedAt,
      String? department});
}

/// @nodoc
class __$$ProjectMemberImplCopyWithImpl<$Res>
    extends _$ProjectMemberCopyWithImpl<$Res, _$ProjectMemberImpl>
    implements _$$ProjectMemberImplCopyWith<$Res> {
  __$$ProjectMemberImplCopyWithImpl(
      _$ProjectMemberImpl _value, $Res Function(_$ProjectMemberImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProjectMember
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? employeeId = null,
    Object? employeeName = null,
    Object? role = null,
    Object? access = null,
    Object? joinedAt = null,
    Object? department = freezed,
  }) {
    return _then(_$ProjectMemberImpl(
      employeeId: null == employeeId
          ? _value.employeeId
          : employeeId // ignore: cast_nullable_to_non_nullable
              as String,
      employeeName: null == employeeName
          ? _value.employeeName
          : employeeName // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      access: null == access
          ? _value.access
          : access // ignore: cast_nullable_to_non_nullable
              as ProjectAccess,
      joinedAt: null == joinedAt
          ? _value.joinedAt
          : joinedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      department: freezed == department
          ? _value.department
          : department // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProjectMemberImpl implements _ProjectMember {
  const _$ProjectMemberImpl(
      {required this.employeeId,
      required this.employeeName,
      required this.role,
      required this.access,
      required this.joinedAt,
      this.department});

  factory _$ProjectMemberImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProjectMemberImplFromJson(json);

  @override
  final String employeeId;
  @override
  final String employeeName;
  @override
  final String role;
  @override
  final ProjectAccess access;
  @override
  final DateTime joinedAt;
  @override
  final String? department;

  @override
  String toString() {
    return 'ProjectMember(employeeId: $employeeId, employeeName: $employeeName, role: $role, access: $access, joinedAt: $joinedAt, department: $department)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProjectMemberImpl &&
            (identical(other.employeeId, employeeId) ||
                other.employeeId == employeeId) &&
            (identical(other.employeeName, employeeName) ||
                other.employeeName == employeeName) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.access, access) || other.access == access) &&
            (identical(other.joinedAt, joinedAt) ||
                other.joinedAt == joinedAt) &&
            (identical(other.department, department) ||
                other.department == department));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, employeeId, employeeName, role,
      access, joinedAt, department);

  /// Create a copy of ProjectMember
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProjectMemberImplCopyWith<_$ProjectMemberImpl> get copyWith =>
      __$$ProjectMemberImplCopyWithImpl<_$ProjectMemberImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProjectMemberImplToJson(
      this,
    );
  }
}

abstract class _ProjectMember implements ProjectMember {
  const factory _ProjectMember(
      {required final String employeeId,
      required final String employeeName,
      required final String role,
      required final ProjectAccess access,
      required final DateTime joinedAt,
      final String? department}) = _$ProjectMemberImpl;

  factory _ProjectMember.fromJson(Map<String, dynamic> json) =
      _$ProjectMemberImpl.fromJson;

  @override
  String get employeeId;
  @override
  String get employeeName;
  @override
  String get role;
  @override
  ProjectAccess get access;
  @override
  DateTime get joinedAt;
  @override
  String? get department;

  /// Create a copy of ProjectMember
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProjectMemberImplCopyWith<_$ProjectMemberImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Project _$ProjectFromJson(Map<String, dynamic> json) {
  return _Project.fromJson(json);
}

/// @nodoc
mixin _$Project {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get clientId => throw _privateConstructorUsedError;
  ProjectType get type => throw _privateConstructorUsedError;
  ProjectStatus get status => throw _privateConstructorUsedError;
  List<Phase> get phases => throw _privateConstructorUsedError;
  List<Milestone> get milestones => throw _privateConstructorUsedError;
  List<ProjectMember> get members => throw _privateConstructorUsedError;
  List<WorkflowTemplate> get workflows => throw _privateConstructorUsedError;
  String get organizationId => throw _privateConstructorUsedError;
  double get value => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  DateTime? get startDate => throw _privateConstructorUsedError;
  DateTime? get endDate => throw _privateConstructorUsedError;
  DateTime? get expectedEndDate => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  String? get templateId => throw _privateConstructorUsedError;
  String? get createdBy => throw _privateConstructorUsedError;
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;
  Map<String, dynamic> get typeSpecificFields =>
      throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Project to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Project
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProjectCopyWith<Project> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProjectCopyWith<$Res> {
  factory $ProjectCopyWith(Project value, $Res Function(Project) then) =
      _$ProjectCopyWithImpl<$Res, Project>;
  @useResult
  $Res call(
      {String id,
      String name,
      String clientId,
      ProjectType type,
      ProjectStatus status,
      List<Phase> phases,
      List<Milestone> milestones,
      List<ProjectMember> members,
      List<WorkflowTemplate> workflows,
      String organizationId,
      double value,
      String? description,
      DateTime? startDate,
      DateTime? endDate,
      DateTime? expectedEndDate,
      DateTime? completedAt,
      String? templateId,
      String? createdBy,
      Map<String, dynamic> metadata,
      Map<String, dynamic> typeSpecificFields,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$ProjectCopyWithImpl<$Res, $Val extends Project>
    implements $ProjectCopyWith<$Res> {
  _$ProjectCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Project
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? clientId = null,
    Object? type = null,
    Object? status = null,
    Object? phases = null,
    Object? milestones = null,
    Object? members = null,
    Object? workflows = null,
    Object? organizationId = null,
    Object? value = null,
    Object? description = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? expectedEndDate = freezed,
    Object? completedAt = freezed,
    Object? templateId = freezed,
    Object? createdBy = freezed,
    Object? metadata = null,
    Object? typeSpecificFields = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
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
      clientId: null == clientId
          ? _value.clientId
          : clientId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ProjectType,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ProjectStatus,
      phases: null == phases
          ? _value.phases
          : phases // ignore: cast_nullable_to_non_nullable
              as List<Phase>,
      milestones: null == milestones
          ? _value.milestones
          : milestones // ignore: cast_nullable_to_non_nullable
              as List<Milestone>,
      members: null == members
          ? _value.members
          : members // ignore: cast_nullable_to_non_nullable
              as List<ProjectMember>,
      workflows: null == workflows
          ? _value.workflows
          : workflows // ignore: cast_nullable_to_non_nullable
              as List<WorkflowTemplate>,
      organizationId: null == organizationId
          ? _value.organizationId
          : organizationId // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expectedEndDate: freezed == expectedEndDate
          ? _value.expectedEndDate
          : expectedEndDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      templateId: freezed == templateId
          ? _value.templateId
          : templateId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      typeSpecificFields: null == typeSpecificFields
          ? _value.typeSpecificFields
          : typeSpecificFields // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProjectImplCopyWith<$Res> implements $ProjectCopyWith<$Res> {
  factory _$$ProjectImplCopyWith(
          _$ProjectImpl value, $Res Function(_$ProjectImpl) then) =
      __$$ProjectImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String clientId,
      ProjectType type,
      ProjectStatus status,
      List<Phase> phases,
      List<Milestone> milestones,
      List<ProjectMember> members,
      List<WorkflowTemplate> workflows,
      String organizationId,
      double value,
      String? description,
      DateTime? startDate,
      DateTime? endDate,
      DateTime? expectedEndDate,
      DateTime? completedAt,
      String? templateId,
      String? createdBy,
      Map<String, dynamic> metadata,
      Map<String, dynamic> typeSpecificFields,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$ProjectImplCopyWithImpl<$Res>
    extends _$ProjectCopyWithImpl<$Res, _$ProjectImpl>
    implements _$$ProjectImplCopyWith<$Res> {
  __$$ProjectImplCopyWithImpl(
      _$ProjectImpl _value, $Res Function(_$ProjectImpl) _then)
      : super(_value, _then);

  /// Create a copy of Project
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? clientId = null,
    Object? type = null,
    Object? status = null,
    Object? phases = null,
    Object? milestones = null,
    Object? members = null,
    Object? workflows = null,
    Object? organizationId = null,
    Object? value = null,
    Object? description = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? expectedEndDate = freezed,
    Object? completedAt = freezed,
    Object? templateId = freezed,
    Object? createdBy = freezed,
    Object? metadata = null,
    Object? typeSpecificFields = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$ProjectImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      clientId: null == clientId
          ? _value.clientId
          : clientId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ProjectType,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ProjectStatus,
      phases: null == phases
          ? _value._phases
          : phases // ignore: cast_nullable_to_non_nullable
              as List<Phase>,
      milestones: null == milestones
          ? _value._milestones
          : milestones // ignore: cast_nullable_to_non_nullable
              as List<Milestone>,
      members: null == members
          ? _value._members
          : members // ignore: cast_nullable_to_non_nullable
              as List<ProjectMember>,
      workflows: null == workflows
          ? _value._workflows
          : workflows // ignore: cast_nullable_to_non_nullable
              as List<WorkflowTemplate>,
      organizationId: null == organizationId
          ? _value.organizationId
          : organizationId // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expectedEndDate: freezed == expectedEndDate
          ? _value.expectedEndDate
          : expectedEndDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      templateId: freezed == templateId
          ? _value.templateId
          : templateId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      typeSpecificFields: null == typeSpecificFields
          ? _value._typeSpecificFields
          : typeSpecificFields // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProjectImpl extends _Project {
  const _$ProjectImpl(
      {required this.id,
      required this.name,
      required this.clientId,
      required this.type,
      required this.status,
      required final List<Phase> phases,
      required final List<Milestone> milestones,
      required final List<ProjectMember> members,
      required final List<WorkflowTemplate> workflows,
      required this.organizationId,
      this.value = 0.0,
      this.description,
      this.startDate,
      this.endDate,
      this.expectedEndDate,
      this.completedAt,
      this.templateId,
      this.createdBy,
      final Map<String, dynamic> metadata = const {},
      final Map<String, dynamic> typeSpecificFields = const {},
      this.createdAt,
      this.updatedAt})
      : _phases = phases,
        _milestones = milestones,
        _members = members,
        _workflows = workflows,
        _metadata = metadata,
        _typeSpecificFields = typeSpecificFields,
        super._();

  factory _$ProjectImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProjectImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String clientId;
  @override
  final ProjectType type;
  @override
  final ProjectStatus status;
  final List<Phase> _phases;
  @override
  List<Phase> get phases {
    if (_phases is EqualUnmodifiableListView) return _phases;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_phases);
  }

  final List<Milestone> _milestones;
  @override
  List<Milestone> get milestones {
    if (_milestones is EqualUnmodifiableListView) return _milestones;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_milestones);
  }

  final List<ProjectMember> _members;
  @override
  List<ProjectMember> get members {
    if (_members is EqualUnmodifiableListView) return _members;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_members);
  }

  final List<WorkflowTemplate> _workflows;
  @override
  List<WorkflowTemplate> get workflows {
    if (_workflows is EqualUnmodifiableListView) return _workflows;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_workflows);
  }

  @override
  final String organizationId;
  @override
  @JsonKey()
  final double value;
  @override
  final String? description;
  @override
  final DateTime? startDate;
  @override
  final DateTime? endDate;
  @override
  final DateTime? expectedEndDate;
  @override
  final DateTime? completedAt;
  @override
  final String? templateId;
  @override
  final String? createdBy;
  final Map<String, dynamic> _metadata;
  @override
  @JsonKey()
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

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
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Project(id: $id, name: $name, clientId: $clientId, type: $type, status: $status, phases: $phases, milestones: $milestones, members: $members, workflows: $workflows, organizationId: $organizationId, value: $value, description: $description, startDate: $startDate, endDate: $endDate, expectedEndDate: $expectedEndDate, completedAt: $completedAt, templateId: $templateId, createdBy: $createdBy, metadata: $metadata, typeSpecificFields: $typeSpecificFields, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProjectImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other._phases, _phases) &&
            const DeepCollectionEquality()
                .equals(other._milestones, _milestones) &&
            const DeepCollectionEquality().equals(other._members, _members) &&
            const DeepCollectionEquality()
                .equals(other._workflows, _workflows) &&
            (identical(other.organizationId, organizationId) ||
                other.organizationId == organizationId) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.expectedEndDate, expectedEndDate) ||
                other.expectedEndDate == expectedEndDate) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.templateId, templateId) ||
                other.templateId == templateId) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            const DeepCollectionEquality()
                .equals(other._typeSpecificFields, _typeSpecificFields) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        name,
        clientId,
        type,
        status,
        const DeepCollectionEquality().hash(_phases),
        const DeepCollectionEquality().hash(_milestones),
        const DeepCollectionEquality().hash(_members),
        const DeepCollectionEquality().hash(_workflows),
        organizationId,
        value,
        description,
        startDate,
        endDate,
        expectedEndDate,
        completedAt,
        templateId,
        createdBy,
        const DeepCollectionEquality().hash(_metadata),
        const DeepCollectionEquality().hash(_typeSpecificFields),
        createdAt,
        updatedAt
      ]);

  /// Create a copy of Project
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProjectImplCopyWith<_$ProjectImpl> get copyWith =>
      __$$ProjectImplCopyWithImpl<_$ProjectImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProjectImplToJson(
      this,
    );
  }
}

abstract class _Project extends Project {
  const factory _Project(
      {required final String id,
      required final String name,
      required final String clientId,
      required final ProjectType type,
      required final ProjectStatus status,
      required final List<Phase> phases,
      required final List<Milestone> milestones,
      required final List<ProjectMember> members,
      required final List<WorkflowTemplate> workflows,
      required final String organizationId,
      final double value,
      final String? description,
      final DateTime? startDate,
      final DateTime? endDate,
      final DateTime? expectedEndDate,
      final DateTime? completedAt,
      final String? templateId,
      final String? createdBy,
      final Map<String, dynamic> metadata,
      final Map<String, dynamic> typeSpecificFields,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$ProjectImpl;
  const _Project._() : super._();

  factory _Project.fromJson(Map<String, dynamic> json) = _$ProjectImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get clientId;
  @override
  ProjectType get type;
  @override
  ProjectStatus get status;
  @override
  List<Phase> get phases;
  @override
  List<Milestone> get milestones;
  @override
  List<ProjectMember> get members;
  @override
  List<WorkflowTemplate> get workflows;
  @override
  String get organizationId;
  @override
  double get value;
  @override
  String? get description;
  @override
  DateTime? get startDate;
  @override
  DateTime? get endDate;
  @override
  DateTime? get expectedEndDate;
  @override
  DateTime? get completedAt;
  @override
  String? get templateId;
  @override
  String? get createdBy;
  @override
  Map<String, dynamic> get metadata;
  @override
  Map<String, dynamic> get typeSpecificFields;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of Project
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProjectImplCopyWith<_$ProjectImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
