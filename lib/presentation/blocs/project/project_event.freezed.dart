// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ProjectEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function() refreshed,
    required TResult Function(
            String? query, List<String>? tags, List<String>? statuses)
        filtered,
    required TResult Function(String projectId) deleteProject,
    required TResult Function(String name, String description, ProjectType type,
            Client? client, DateTime startDate, DateTime endDate)
        createProject,
    required TResult Function(String projectId, ProjectMember member)
        addTeamMember,
    required TResult Function(String projectId, String fileData) fileUploaded,
    required TResult Function(String projectId, String fileId) fileDeleted,
    required TResult Function(dynamic project) projectSelected,
    required TResult Function(Project? project) initialized,
    required TResult Function(String name) nameChanged,
    required TResult Function(Client client) clientChanged,
    required TResult Function(ProjectTemplate template) templateChanged,
    required TResult Function(DateTime date) startDateChanged,
    required TResult Function(DateTime date) endDateChanged,
    required TResult Function(String description) descriptionChanged,
    required TResult Function() saved,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function()? refreshed,
    TResult? Function(
            String? query, List<String>? tags, List<String>? statuses)?
        filtered,
    TResult? Function(String projectId)? deleteProject,
    TResult? Function(String name, String description, ProjectType type,
            Client? client, DateTime startDate, DateTime endDate)?
        createProject,
    TResult? Function(String projectId, ProjectMember member)? addTeamMember,
    TResult? Function(String projectId, String fileData)? fileUploaded,
    TResult? Function(String projectId, String fileId)? fileDeleted,
    TResult? Function(dynamic project)? projectSelected,
    TResult? Function(Project? project)? initialized,
    TResult? Function(String name)? nameChanged,
    TResult? Function(Client client)? clientChanged,
    TResult? Function(ProjectTemplate template)? templateChanged,
    TResult? Function(DateTime date)? startDateChanged,
    TResult? Function(DateTime date)? endDateChanged,
    TResult? Function(String description)? descriptionChanged,
    TResult? Function()? saved,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function()? refreshed,
    TResult Function(String? query, List<String>? tags, List<String>? statuses)?
        filtered,
    TResult Function(String projectId)? deleteProject,
    TResult Function(String name, String description, ProjectType type,
            Client? client, DateTime startDate, DateTime endDate)?
        createProject,
    TResult Function(String projectId, ProjectMember member)? addTeamMember,
    TResult Function(String projectId, String fileData)? fileUploaded,
    TResult Function(String projectId, String fileId)? fileDeleted,
    TResult Function(dynamic project)? projectSelected,
    TResult Function(Project? project)? initialized,
    TResult Function(String name)? nameChanged,
    TResult Function(Client client)? clientChanged,
    TResult Function(ProjectTemplate template)? templateChanged,
    TResult Function(DateTime date)? startDateChanged,
    TResult Function(DateTime date)? endDateChanged,
    TResult Function(String description)? descriptionChanged,
    TResult Function()? saved,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_Refreshed value) refreshed,
    required TResult Function(Filtered value) filtered,
    required TResult Function(DeleteProject value) deleteProject,
    required TResult Function(CreateProject value) createProject,
    required TResult Function(AddTeamMember value) addTeamMember,
    required TResult Function(FileUploaded value) fileUploaded,
    required TResult Function(FileDeleted value) fileDeleted,
    required TResult Function(ProjectSelected value) projectSelected,
    required TResult Function(_Initialized value) initialized,
    required TResult Function(_NameChanged value) nameChanged,
    required TResult Function(_ClientChanged value) clientChanged,
    required TResult Function(_TemplateChanged value) templateChanged,
    required TResult Function(_StartDateChanged value) startDateChanged,
    required TResult Function(_EndDateChanged value) endDateChanged,
    required TResult Function(_DescriptionChanged value) descriptionChanged,
    required TResult Function(_Saved value) saved,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_Refreshed value)? refreshed,
    TResult? Function(Filtered value)? filtered,
    TResult? Function(DeleteProject value)? deleteProject,
    TResult? Function(CreateProject value)? createProject,
    TResult? Function(AddTeamMember value)? addTeamMember,
    TResult? Function(FileUploaded value)? fileUploaded,
    TResult? Function(FileDeleted value)? fileDeleted,
    TResult? Function(ProjectSelected value)? projectSelected,
    TResult? Function(_Initialized value)? initialized,
    TResult? Function(_NameChanged value)? nameChanged,
    TResult? Function(_ClientChanged value)? clientChanged,
    TResult? Function(_TemplateChanged value)? templateChanged,
    TResult? Function(_StartDateChanged value)? startDateChanged,
    TResult? Function(_EndDateChanged value)? endDateChanged,
    TResult? Function(_DescriptionChanged value)? descriptionChanged,
    TResult? Function(_Saved value)? saved,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_Refreshed value)? refreshed,
    TResult Function(Filtered value)? filtered,
    TResult Function(DeleteProject value)? deleteProject,
    TResult Function(CreateProject value)? createProject,
    TResult Function(AddTeamMember value)? addTeamMember,
    TResult Function(FileUploaded value)? fileUploaded,
    TResult Function(FileDeleted value)? fileDeleted,
    TResult Function(ProjectSelected value)? projectSelected,
    TResult Function(_Initialized value)? initialized,
    TResult Function(_NameChanged value)? nameChanged,
    TResult Function(_ClientChanged value)? clientChanged,
    TResult Function(_TemplateChanged value)? templateChanged,
    TResult Function(_StartDateChanged value)? startDateChanged,
    TResult Function(_EndDateChanged value)? endDateChanged,
    TResult Function(_DescriptionChanged value)? descriptionChanged,
    TResult Function(_Saved value)? saved,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProjectEventCopyWith<$Res> {
  factory $ProjectEventCopyWith(
          ProjectEvent value, $Res Function(ProjectEvent) then) =
      _$ProjectEventCopyWithImpl<$Res, ProjectEvent>;
}

/// @nodoc
class _$ProjectEventCopyWithImpl<$Res, $Val extends ProjectEvent>
    implements $ProjectEventCopyWith<$Res> {
  _$ProjectEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProjectEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$StartedImplCopyWith<$Res> {
  factory _$$StartedImplCopyWith(
          _$StartedImpl value, $Res Function(_$StartedImpl) then) =
      __$$StartedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$StartedImplCopyWithImpl<$Res>
    extends _$ProjectEventCopyWithImpl<$Res, _$StartedImpl>
    implements _$$StartedImplCopyWith<$Res> {
  __$$StartedImplCopyWithImpl(
      _$StartedImpl _value, $Res Function(_$StartedImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProjectEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$StartedImpl implements _Started {
  const _$StartedImpl();

  @override
  String toString() {
    return 'ProjectEvent.started()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$StartedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function() refreshed,
    required TResult Function(
            String? query, List<String>? tags, List<String>? statuses)
        filtered,
    required TResult Function(String projectId) deleteProject,
    required TResult Function(String name, String description, ProjectType type,
            Client? client, DateTime startDate, DateTime endDate)
        createProject,
    required TResult Function(String projectId, ProjectMember member)
        addTeamMember,
    required TResult Function(String projectId, String fileData) fileUploaded,
    required TResult Function(String projectId, String fileId) fileDeleted,
    required TResult Function(dynamic project) projectSelected,
    required TResult Function(Project? project) initialized,
    required TResult Function(String name) nameChanged,
    required TResult Function(Client client) clientChanged,
    required TResult Function(ProjectTemplate template) templateChanged,
    required TResult Function(DateTime date) startDateChanged,
    required TResult Function(DateTime date) endDateChanged,
    required TResult Function(String description) descriptionChanged,
    required TResult Function() saved,
  }) {
    return started();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function()? refreshed,
    TResult? Function(
            String? query, List<String>? tags, List<String>? statuses)?
        filtered,
    TResult? Function(String projectId)? deleteProject,
    TResult? Function(String name, String description, ProjectType type,
            Client? client, DateTime startDate, DateTime endDate)?
        createProject,
    TResult? Function(String projectId, ProjectMember member)? addTeamMember,
    TResult? Function(String projectId, String fileData)? fileUploaded,
    TResult? Function(String projectId, String fileId)? fileDeleted,
    TResult? Function(dynamic project)? projectSelected,
    TResult? Function(Project? project)? initialized,
    TResult? Function(String name)? nameChanged,
    TResult? Function(Client client)? clientChanged,
    TResult? Function(ProjectTemplate template)? templateChanged,
    TResult? Function(DateTime date)? startDateChanged,
    TResult? Function(DateTime date)? endDateChanged,
    TResult? Function(String description)? descriptionChanged,
    TResult? Function()? saved,
  }) {
    return started?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function()? refreshed,
    TResult Function(String? query, List<String>? tags, List<String>? statuses)?
        filtered,
    TResult Function(String projectId)? deleteProject,
    TResult Function(String name, String description, ProjectType type,
            Client? client, DateTime startDate, DateTime endDate)?
        createProject,
    TResult Function(String projectId, ProjectMember member)? addTeamMember,
    TResult Function(String projectId, String fileData)? fileUploaded,
    TResult Function(String projectId, String fileId)? fileDeleted,
    TResult Function(dynamic project)? projectSelected,
    TResult Function(Project? project)? initialized,
    TResult Function(String name)? nameChanged,
    TResult Function(Client client)? clientChanged,
    TResult Function(ProjectTemplate template)? templateChanged,
    TResult Function(DateTime date)? startDateChanged,
    TResult Function(DateTime date)? endDateChanged,
    TResult Function(String description)? descriptionChanged,
    TResult Function()? saved,
    required TResult orElse(),
  }) {
    if (started != null) {
      return started();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_Refreshed value) refreshed,
    required TResult Function(Filtered value) filtered,
    required TResult Function(DeleteProject value) deleteProject,
    required TResult Function(CreateProject value) createProject,
    required TResult Function(AddTeamMember value) addTeamMember,
    required TResult Function(FileUploaded value) fileUploaded,
    required TResult Function(FileDeleted value) fileDeleted,
    required TResult Function(ProjectSelected value) projectSelected,
    required TResult Function(_Initialized value) initialized,
    required TResult Function(_NameChanged value) nameChanged,
    required TResult Function(_ClientChanged value) clientChanged,
    required TResult Function(_TemplateChanged value) templateChanged,
    required TResult Function(_StartDateChanged value) startDateChanged,
    required TResult Function(_EndDateChanged value) endDateChanged,
    required TResult Function(_DescriptionChanged value) descriptionChanged,
    required TResult Function(_Saved value) saved,
  }) {
    return started(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_Refreshed value)? refreshed,
    TResult? Function(Filtered value)? filtered,
    TResult? Function(DeleteProject value)? deleteProject,
    TResult? Function(CreateProject value)? createProject,
    TResult? Function(AddTeamMember value)? addTeamMember,
    TResult? Function(FileUploaded value)? fileUploaded,
    TResult? Function(FileDeleted value)? fileDeleted,
    TResult? Function(ProjectSelected value)? projectSelected,
    TResult? Function(_Initialized value)? initialized,
    TResult? Function(_NameChanged value)? nameChanged,
    TResult? Function(_ClientChanged value)? clientChanged,
    TResult? Function(_TemplateChanged value)? templateChanged,
    TResult? Function(_StartDateChanged value)? startDateChanged,
    TResult? Function(_EndDateChanged value)? endDateChanged,
    TResult? Function(_DescriptionChanged value)? descriptionChanged,
    TResult? Function(_Saved value)? saved,
  }) {
    return started?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_Refreshed value)? refreshed,
    TResult Function(Filtered value)? filtered,
    TResult Function(DeleteProject value)? deleteProject,
    TResult Function(CreateProject value)? createProject,
    TResult Function(AddTeamMember value)? addTeamMember,
    TResult Function(FileUploaded value)? fileUploaded,
    TResult Function(FileDeleted value)? fileDeleted,
    TResult Function(ProjectSelected value)? projectSelected,
    TResult Function(_Initialized value)? initialized,
    TResult Function(_NameChanged value)? nameChanged,
    TResult Function(_ClientChanged value)? clientChanged,
    TResult Function(_TemplateChanged value)? templateChanged,
    TResult Function(_StartDateChanged value)? startDateChanged,
    TResult Function(_EndDateChanged value)? endDateChanged,
    TResult Function(_DescriptionChanged value)? descriptionChanged,
    TResult Function(_Saved value)? saved,
    required TResult orElse(),
  }) {
    if (started != null) {
      return started(this);
    }
    return orElse();
  }
}

abstract class _Started implements ProjectEvent {
  const factory _Started() = _$StartedImpl;
}

/// @nodoc
abstract class _$$RefreshedImplCopyWith<$Res> {
  factory _$$RefreshedImplCopyWith(
          _$RefreshedImpl value, $Res Function(_$RefreshedImpl) then) =
      __$$RefreshedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$RefreshedImplCopyWithImpl<$Res>
    extends _$ProjectEventCopyWithImpl<$Res, _$RefreshedImpl>
    implements _$$RefreshedImplCopyWith<$Res> {
  __$$RefreshedImplCopyWithImpl(
      _$RefreshedImpl _value, $Res Function(_$RefreshedImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProjectEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$RefreshedImpl implements _Refreshed {
  const _$RefreshedImpl();

  @override
  String toString() {
    return 'ProjectEvent.refreshed()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$RefreshedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function() refreshed,
    required TResult Function(
            String? query, List<String>? tags, List<String>? statuses)
        filtered,
    required TResult Function(String projectId) deleteProject,
    required TResult Function(String name, String description, ProjectType type,
            Client? client, DateTime startDate, DateTime endDate)
        createProject,
    required TResult Function(String projectId, ProjectMember member)
        addTeamMember,
    required TResult Function(String projectId, String fileData) fileUploaded,
    required TResult Function(String projectId, String fileId) fileDeleted,
    required TResult Function(dynamic project) projectSelected,
    required TResult Function(Project? project) initialized,
    required TResult Function(String name) nameChanged,
    required TResult Function(Client client) clientChanged,
    required TResult Function(ProjectTemplate template) templateChanged,
    required TResult Function(DateTime date) startDateChanged,
    required TResult Function(DateTime date) endDateChanged,
    required TResult Function(String description) descriptionChanged,
    required TResult Function() saved,
  }) {
    return refreshed();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function()? refreshed,
    TResult? Function(
            String? query, List<String>? tags, List<String>? statuses)?
        filtered,
    TResult? Function(String projectId)? deleteProject,
    TResult? Function(String name, String description, ProjectType type,
            Client? client, DateTime startDate, DateTime endDate)?
        createProject,
    TResult? Function(String projectId, ProjectMember member)? addTeamMember,
    TResult? Function(String projectId, String fileData)? fileUploaded,
    TResult? Function(String projectId, String fileId)? fileDeleted,
    TResult? Function(dynamic project)? projectSelected,
    TResult? Function(Project? project)? initialized,
    TResult? Function(String name)? nameChanged,
    TResult? Function(Client client)? clientChanged,
    TResult? Function(ProjectTemplate template)? templateChanged,
    TResult? Function(DateTime date)? startDateChanged,
    TResult? Function(DateTime date)? endDateChanged,
    TResult? Function(String description)? descriptionChanged,
    TResult? Function()? saved,
  }) {
    return refreshed?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function()? refreshed,
    TResult Function(String? query, List<String>? tags, List<String>? statuses)?
        filtered,
    TResult Function(String projectId)? deleteProject,
    TResult Function(String name, String description, ProjectType type,
            Client? client, DateTime startDate, DateTime endDate)?
        createProject,
    TResult Function(String projectId, ProjectMember member)? addTeamMember,
    TResult Function(String projectId, String fileData)? fileUploaded,
    TResult Function(String projectId, String fileId)? fileDeleted,
    TResult Function(dynamic project)? projectSelected,
    TResult Function(Project? project)? initialized,
    TResult Function(String name)? nameChanged,
    TResult Function(Client client)? clientChanged,
    TResult Function(ProjectTemplate template)? templateChanged,
    TResult Function(DateTime date)? startDateChanged,
    TResult Function(DateTime date)? endDateChanged,
    TResult Function(String description)? descriptionChanged,
    TResult Function()? saved,
    required TResult orElse(),
  }) {
    if (refreshed != null) {
      return refreshed();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_Refreshed value) refreshed,
    required TResult Function(Filtered value) filtered,
    required TResult Function(DeleteProject value) deleteProject,
    required TResult Function(CreateProject value) createProject,
    required TResult Function(AddTeamMember value) addTeamMember,
    required TResult Function(FileUploaded value) fileUploaded,
    required TResult Function(FileDeleted value) fileDeleted,
    required TResult Function(ProjectSelected value) projectSelected,
    required TResult Function(_Initialized value) initialized,
    required TResult Function(_NameChanged value) nameChanged,
    required TResult Function(_ClientChanged value) clientChanged,
    required TResult Function(_TemplateChanged value) templateChanged,
    required TResult Function(_StartDateChanged value) startDateChanged,
    required TResult Function(_EndDateChanged value) endDateChanged,
    required TResult Function(_DescriptionChanged value) descriptionChanged,
    required TResult Function(_Saved value) saved,
  }) {
    return refreshed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_Refreshed value)? refreshed,
    TResult? Function(Filtered value)? filtered,
    TResult? Function(DeleteProject value)? deleteProject,
    TResult? Function(CreateProject value)? createProject,
    TResult? Function(AddTeamMember value)? addTeamMember,
    TResult? Function(FileUploaded value)? fileUploaded,
    TResult? Function(FileDeleted value)? fileDeleted,
    TResult? Function(ProjectSelected value)? projectSelected,
    TResult? Function(_Initialized value)? initialized,
    TResult? Function(_NameChanged value)? nameChanged,
    TResult? Function(_ClientChanged value)? clientChanged,
    TResult? Function(_TemplateChanged value)? templateChanged,
    TResult? Function(_StartDateChanged value)? startDateChanged,
    TResult? Function(_EndDateChanged value)? endDateChanged,
    TResult? Function(_DescriptionChanged value)? descriptionChanged,
    TResult? Function(_Saved value)? saved,
  }) {
    return refreshed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_Refreshed value)? refreshed,
    TResult Function(Filtered value)? filtered,
    TResult Function(DeleteProject value)? deleteProject,
    TResult Function(CreateProject value)? createProject,
    TResult Function(AddTeamMember value)? addTeamMember,
    TResult Function(FileUploaded value)? fileUploaded,
    TResult Function(FileDeleted value)? fileDeleted,
    TResult Function(ProjectSelected value)? projectSelected,
    TResult Function(_Initialized value)? initialized,
    TResult Function(_NameChanged value)? nameChanged,
    TResult Function(_ClientChanged value)? clientChanged,
    TResult Function(_TemplateChanged value)? templateChanged,
    TResult Function(_StartDateChanged value)? startDateChanged,
    TResult Function(_EndDateChanged value)? endDateChanged,
    TResult Function(_DescriptionChanged value)? descriptionChanged,
    TResult Function(_Saved value)? saved,
    required TResult orElse(),
  }) {
    if (refreshed != null) {
      return refreshed(this);
    }
    return orElse();
  }
}

abstract class _Refreshed implements ProjectEvent {
  const factory _Refreshed() = _$RefreshedImpl;
}

/// @nodoc
abstract class _$$FilteredImplCopyWith<$Res> {
  factory _$$FilteredImplCopyWith(
          _$FilteredImpl value, $Res Function(_$FilteredImpl) then) =
      __$$FilteredImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String? query, List<String>? tags, List<String>? statuses});
}

/// @nodoc
class __$$FilteredImplCopyWithImpl<$Res>
    extends _$ProjectEventCopyWithImpl<$Res, _$FilteredImpl>
    implements _$$FilteredImplCopyWith<$Res> {
  __$$FilteredImplCopyWithImpl(
      _$FilteredImpl _value, $Res Function(_$FilteredImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProjectEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? query = freezed,
    Object? tags = freezed,
    Object? statuses = freezed,
  }) {
    return _then(_$FilteredImpl(
      query: freezed == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: freezed == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      statuses: freezed == statuses
          ? _value._statuses
          : statuses // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc

class _$FilteredImpl implements Filtered {
  const _$FilteredImpl(
      {this.query, final List<String>? tags, final List<String>? statuses})
      : _tags = tags,
        _statuses = statuses;

  @override
  final String? query;
  final List<String>? _tags;
  @override
  List<String>? get tags {
    final value = _tags;
    if (value == null) return null;
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _statuses;
  @override
  List<String>? get statuses {
    final value = _statuses;
    if (value == null) return null;
    if (_statuses is EqualUnmodifiableListView) return _statuses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'ProjectEvent.filtered(query: $query, tags: $tags, statuses: $statuses)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FilteredImpl &&
            (identical(other.query, query) || other.query == query) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            const DeepCollectionEquality().equals(other._statuses, _statuses));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      query,
      const DeepCollectionEquality().hash(_tags),
      const DeepCollectionEquality().hash(_statuses));

  /// Create a copy of ProjectEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FilteredImplCopyWith<_$FilteredImpl> get copyWith =>
      __$$FilteredImplCopyWithImpl<_$FilteredImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function() refreshed,
    required TResult Function(
            String? query, List<String>? tags, List<String>? statuses)
        filtered,
    required TResult Function(String projectId) deleteProject,
    required TResult Function(String name, String description, ProjectType type,
            Client? client, DateTime startDate, DateTime endDate)
        createProject,
    required TResult Function(String projectId, ProjectMember member)
        addTeamMember,
    required TResult Function(String projectId, String fileData) fileUploaded,
    required TResult Function(String projectId, String fileId) fileDeleted,
    required TResult Function(dynamic project) projectSelected,
    required TResult Function(Project? project) initialized,
    required TResult Function(String name) nameChanged,
    required TResult Function(Client client) clientChanged,
    required TResult Function(ProjectTemplate template) templateChanged,
    required TResult Function(DateTime date) startDateChanged,
    required TResult Function(DateTime date) endDateChanged,
    required TResult Function(String description) descriptionChanged,
    required TResult Function() saved,
  }) {
    return filtered(query, tags, statuses);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function()? refreshed,
    TResult? Function(
            String? query, List<String>? tags, List<String>? statuses)?
        filtered,
    TResult? Function(String projectId)? deleteProject,
    TResult? Function(String name, String description, ProjectType type,
            Client? client, DateTime startDate, DateTime endDate)?
        createProject,
    TResult? Function(String projectId, ProjectMember member)? addTeamMember,
    TResult? Function(String projectId, String fileData)? fileUploaded,
    TResult? Function(String projectId, String fileId)? fileDeleted,
    TResult? Function(dynamic project)? projectSelected,
    TResult? Function(Project? project)? initialized,
    TResult? Function(String name)? nameChanged,
    TResult? Function(Client client)? clientChanged,
    TResult? Function(ProjectTemplate template)? templateChanged,
    TResult? Function(DateTime date)? startDateChanged,
    TResult? Function(DateTime date)? endDateChanged,
    TResult? Function(String description)? descriptionChanged,
    TResult? Function()? saved,
  }) {
    return filtered?.call(query, tags, statuses);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function()? refreshed,
    TResult Function(String? query, List<String>? tags, List<String>? statuses)?
        filtered,
    TResult Function(String projectId)? deleteProject,
    TResult Function(String name, String description, ProjectType type,
            Client? client, DateTime startDate, DateTime endDate)?
        createProject,
    TResult Function(String projectId, ProjectMember member)? addTeamMember,
    TResult Function(String projectId, String fileData)? fileUploaded,
    TResult Function(String projectId, String fileId)? fileDeleted,
    TResult Function(dynamic project)? projectSelected,
    TResult Function(Project? project)? initialized,
    TResult Function(String name)? nameChanged,
    TResult Function(Client client)? clientChanged,
    TResult Function(ProjectTemplate template)? templateChanged,
    TResult Function(DateTime date)? startDateChanged,
    TResult Function(DateTime date)? endDateChanged,
    TResult Function(String description)? descriptionChanged,
    TResult Function()? saved,
    required TResult orElse(),
  }) {
    if (filtered != null) {
      return filtered(query, tags, statuses);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_Refreshed value) refreshed,
    required TResult Function(Filtered value) filtered,
    required TResult Function(DeleteProject value) deleteProject,
    required TResult Function(CreateProject value) createProject,
    required TResult Function(AddTeamMember value) addTeamMember,
    required TResult Function(FileUploaded value) fileUploaded,
    required TResult Function(FileDeleted value) fileDeleted,
    required TResult Function(ProjectSelected value) projectSelected,
    required TResult Function(_Initialized value) initialized,
    required TResult Function(_NameChanged value) nameChanged,
    required TResult Function(_ClientChanged value) clientChanged,
    required TResult Function(_TemplateChanged value) templateChanged,
    required TResult Function(_StartDateChanged value) startDateChanged,
    required TResult Function(_EndDateChanged value) endDateChanged,
    required TResult Function(_DescriptionChanged value) descriptionChanged,
    required TResult Function(_Saved value) saved,
  }) {
    return filtered(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_Refreshed value)? refreshed,
    TResult? Function(Filtered value)? filtered,
    TResult? Function(DeleteProject value)? deleteProject,
    TResult? Function(CreateProject value)? createProject,
    TResult? Function(AddTeamMember value)? addTeamMember,
    TResult? Function(FileUploaded value)? fileUploaded,
    TResult? Function(FileDeleted value)? fileDeleted,
    TResult? Function(ProjectSelected value)? projectSelected,
    TResult? Function(_Initialized value)? initialized,
    TResult? Function(_NameChanged value)? nameChanged,
    TResult? Function(_ClientChanged value)? clientChanged,
    TResult? Function(_TemplateChanged value)? templateChanged,
    TResult? Function(_StartDateChanged value)? startDateChanged,
    TResult? Function(_EndDateChanged value)? endDateChanged,
    TResult? Function(_DescriptionChanged value)? descriptionChanged,
    TResult? Function(_Saved value)? saved,
  }) {
    return filtered?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_Refreshed value)? refreshed,
    TResult Function(Filtered value)? filtered,
    TResult Function(DeleteProject value)? deleteProject,
    TResult Function(CreateProject value)? createProject,
    TResult Function(AddTeamMember value)? addTeamMember,
    TResult Function(FileUploaded value)? fileUploaded,
    TResult Function(FileDeleted value)? fileDeleted,
    TResult Function(ProjectSelected value)? projectSelected,
    TResult Function(_Initialized value)? initialized,
    TResult Function(_NameChanged value)? nameChanged,
    TResult Function(_ClientChanged value)? clientChanged,
    TResult Function(_TemplateChanged value)? templateChanged,
    TResult Function(_StartDateChanged value)? startDateChanged,
    TResult Function(_EndDateChanged value)? endDateChanged,
    TResult Function(_DescriptionChanged value)? descriptionChanged,
    TResult Function(_Saved value)? saved,
    required TResult orElse(),
  }) {
    if (filtered != null) {
      return filtered(this);
    }
    return orElse();
  }
}

abstract class Filtered implements ProjectEvent {
  const factory Filtered(
      {final String? query,
      final List<String>? tags,
      final List<String>? statuses}) = _$FilteredImpl;

  String? get query;
  List<String>? get tags;
  List<String>? get statuses;

  /// Create a copy of ProjectEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FilteredImplCopyWith<_$FilteredImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DeleteProjectImplCopyWith<$Res> {
  factory _$$DeleteProjectImplCopyWith(
          _$DeleteProjectImpl value, $Res Function(_$DeleteProjectImpl) then) =
      __$$DeleteProjectImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String projectId});
}

/// @nodoc
class __$$DeleteProjectImplCopyWithImpl<$Res>
    extends _$ProjectEventCopyWithImpl<$Res, _$DeleteProjectImpl>
    implements _$$DeleteProjectImplCopyWith<$Res> {
  __$$DeleteProjectImplCopyWithImpl(
      _$DeleteProjectImpl _value, $Res Function(_$DeleteProjectImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProjectEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? projectId = null,
  }) {
    return _then(_$DeleteProjectImpl(
      null == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$DeleteProjectImpl implements DeleteProject {
  const _$DeleteProjectImpl(this.projectId);

  @override
  final String projectId;

  @override
  String toString() {
    return 'ProjectEvent.deleteProject(projectId: $projectId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeleteProjectImpl &&
            (identical(other.projectId, projectId) ||
                other.projectId == projectId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, projectId);

  /// Create a copy of ProjectEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeleteProjectImplCopyWith<_$DeleteProjectImpl> get copyWith =>
      __$$DeleteProjectImplCopyWithImpl<_$DeleteProjectImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function() refreshed,
    required TResult Function(
            String? query, List<String>? tags, List<String>? statuses)
        filtered,
    required TResult Function(String projectId) deleteProject,
    required TResult Function(String name, String description, ProjectType type,
            Client? client, DateTime startDate, DateTime endDate)
        createProject,
    required TResult Function(String projectId, ProjectMember member)
        addTeamMember,
    required TResult Function(String projectId, String fileData) fileUploaded,
    required TResult Function(String projectId, String fileId) fileDeleted,
    required TResult Function(dynamic project) projectSelected,
    required TResult Function(Project? project) initialized,
    required TResult Function(String name) nameChanged,
    required TResult Function(Client client) clientChanged,
    required TResult Function(ProjectTemplate template) templateChanged,
    required TResult Function(DateTime date) startDateChanged,
    required TResult Function(DateTime date) endDateChanged,
    required TResult Function(String description) descriptionChanged,
    required TResult Function() saved,
  }) {
    return deleteProject(projectId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function()? refreshed,
    TResult? Function(
            String? query, List<String>? tags, List<String>? statuses)?
        filtered,
    TResult? Function(String projectId)? deleteProject,
    TResult? Function(String name, String description, ProjectType type,
            Client? client, DateTime startDate, DateTime endDate)?
        createProject,
    TResult? Function(String projectId, ProjectMember member)? addTeamMember,
    TResult? Function(String projectId, String fileData)? fileUploaded,
    TResult? Function(String projectId, String fileId)? fileDeleted,
    TResult? Function(dynamic project)? projectSelected,
    TResult? Function(Project? project)? initialized,
    TResult? Function(String name)? nameChanged,
    TResult? Function(Client client)? clientChanged,
    TResult? Function(ProjectTemplate template)? templateChanged,
    TResult? Function(DateTime date)? startDateChanged,
    TResult? Function(DateTime date)? endDateChanged,
    TResult? Function(String description)? descriptionChanged,
    TResult? Function()? saved,
  }) {
    return deleteProject?.call(projectId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function()? refreshed,
    TResult Function(String? query, List<String>? tags, List<String>? statuses)?
        filtered,
    TResult Function(String projectId)? deleteProject,
    TResult Function(String name, String description, ProjectType type,
            Client? client, DateTime startDate, DateTime endDate)?
        createProject,
    TResult Function(String projectId, ProjectMember member)? addTeamMember,
    TResult Function(String projectId, String fileData)? fileUploaded,
    TResult Function(String projectId, String fileId)? fileDeleted,
    TResult Function(dynamic project)? projectSelected,
    TResult Function(Project? project)? initialized,
    TResult Function(String name)? nameChanged,
    TResult Function(Client client)? clientChanged,
    TResult Function(ProjectTemplate template)? templateChanged,
    TResult Function(DateTime date)? startDateChanged,
    TResult Function(DateTime date)? endDateChanged,
    TResult Function(String description)? descriptionChanged,
    TResult Function()? saved,
    required TResult orElse(),
  }) {
    if (deleteProject != null) {
      return deleteProject(projectId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_Refreshed value) refreshed,
    required TResult Function(Filtered value) filtered,
    required TResult Function(DeleteProject value) deleteProject,
    required TResult Function(CreateProject value) createProject,
    required TResult Function(AddTeamMember value) addTeamMember,
    required TResult Function(FileUploaded value) fileUploaded,
    required TResult Function(FileDeleted value) fileDeleted,
    required TResult Function(ProjectSelected value) projectSelected,
    required TResult Function(_Initialized value) initialized,
    required TResult Function(_NameChanged value) nameChanged,
    required TResult Function(_ClientChanged value) clientChanged,
    required TResult Function(_TemplateChanged value) templateChanged,
    required TResult Function(_StartDateChanged value) startDateChanged,
    required TResult Function(_EndDateChanged value) endDateChanged,
    required TResult Function(_DescriptionChanged value) descriptionChanged,
    required TResult Function(_Saved value) saved,
  }) {
    return deleteProject(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_Refreshed value)? refreshed,
    TResult? Function(Filtered value)? filtered,
    TResult? Function(DeleteProject value)? deleteProject,
    TResult? Function(CreateProject value)? createProject,
    TResult? Function(AddTeamMember value)? addTeamMember,
    TResult? Function(FileUploaded value)? fileUploaded,
    TResult? Function(FileDeleted value)? fileDeleted,
    TResult? Function(ProjectSelected value)? projectSelected,
    TResult? Function(_Initialized value)? initialized,
    TResult? Function(_NameChanged value)? nameChanged,
    TResult? Function(_ClientChanged value)? clientChanged,
    TResult? Function(_TemplateChanged value)? templateChanged,
    TResult? Function(_StartDateChanged value)? startDateChanged,
    TResult? Function(_EndDateChanged value)? endDateChanged,
    TResult? Function(_DescriptionChanged value)? descriptionChanged,
    TResult? Function(_Saved value)? saved,
  }) {
    return deleteProject?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_Refreshed value)? refreshed,
    TResult Function(Filtered value)? filtered,
    TResult Function(DeleteProject value)? deleteProject,
    TResult Function(CreateProject value)? createProject,
    TResult Function(AddTeamMember value)? addTeamMember,
    TResult Function(FileUploaded value)? fileUploaded,
    TResult Function(FileDeleted value)? fileDeleted,
    TResult Function(ProjectSelected value)? projectSelected,
    TResult Function(_Initialized value)? initialized,
    TResult Function(_NameChanged value)? nameChanged,
    TResult Function(_ClientChanged value)? clientChanged,
    TResult Function(_TemplateChanged value)? templateChanged,
    TResult Function(_StartDateChanged value)? startDateChanged,
    TResult Function(_EndDateChanged value)? endDateChanged,
    TResult Function(_DescriptionChanged value)? descriptionChanged,
    TResult Function(_Saved value)? saved,
    required TResult orElse(),
  }) {
    if (deleteProject != null) {
      return deleteProject(this);
    }
    return orElse();
  }
}

abstract class DeleteProject implements ProjectEvent {
  const factory DeleteProject(final String projectId) = _$DeleteProjectImpl;

  String get projectId;

  /// Create a copy of ProjectEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeleteProjectImplCopyWith<_$DeleteProjectImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CreateProjectImplCopyWith<$Res> {
  factory _$$CreateProjectImplCopyWith(
          _$CreateProjectImpl value, $Res Function(_$CreateProjectImpl) then) =
      __$$CreateProjectImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {String name,
      String description,
      ProjectType type,
      Client? client,
      DateTime startDate,
      DateTime endDate});
}

/// @nodoc
class __$$CreateProjectImplCopyWithImpl<$Res>
    extends _$ProjectEventCopyWithImpl<$Res, _$CreateProjectImpl>
    implements _$$CreateProjectImplCopyWith<$Res> {
  __$$CreateProjectImplCopyWithImpl(
      _$CreateProjectImpl _value, $Res Function(_$CreateProjectImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProjectEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? description = null,
    Object? type = null,
    Object? client = freezed,
    Object? startDate = null,
    Object? endDate = null,
  }) {
    return _then(_$CreateProjectImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ProjectType,
      client: freezed == client
          ? _value.client
          : client // ignore: cast_nullable_to_non_nullable
              as Client?,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$CreateProjectImpl implements CreateProject {
  const _$CreateProjectImpl(
      {required this.name,
      required this.description,
      required this.type,
      required this.client,
      required this.startDate,
      required this.endDate});

  @override
  final String name;
  @override
  final String description;
  @override
  final ProjectType type;
  @override
  final Client? client;
  @override
  final DateTime startDate;
  @override
  final DateTime endDate;

  @override
  String toString() {
    return 'ProjectEvent.createProject(name: $name, description: $description, type: $type, client: $client, startDate: $startDate, endDate: $endDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateProjectImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.client, client) || other.client == client) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, name, description, type, client, startDate, endDate);

  /// Create a copy of ProjectEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateProjectImplCopyWith<_$CreateProjectImpl> get copyWith =>
      __$$CreateProjectImplCopyWithImpl<_$CreateProjectImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function() refreshed,
    required TResult Function(
            String? query, List<String>? tags, List<String>? statuses)
        filtered,
    required TResult Function(String projectId) deleteProject,
    required TResult Function(String name, String description, ProjectType type,
            Client? client, DateTime startDate, DateTime endDate)
        createProject,
    required TResult Function(String projectId, ProjectMember member)
        addTeamMember,
    required TResult Function(String projectId, String fileData) fileUploaded,
    required TResult Function(String projectId, String fileId) fileDeleted,
    required TResult Function(dynamic project) projectSelected,
    required TResult Function(Project? project) initialized,
    required TResult Function(String name) nameChanged,
    required TResult Function(Client client) clientChanged,
    required TResult Function(ProjectTemplate template) templateChanged,
    required TResult Function(DateTime date) startDateChanged,
    required TResult Function(DateTime date) endDateChanged,
    required TResult Function(String description) descriptionChanged,
    required TResult Function() saved,
  }) {
    return createProject(name, description, type, client, startDate, endDate);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function()? refreshed,
    TResult? Function(
            String? query, List<String>? tags, List<String>? statuses)?
        filtered,
    TResult? Function(String projectId)? deleteProject,
    TResult? Function(String name, String description, ProjectType type,
            Client? client, DateTime startDate, DateTime endDate)?
        createProject,
    TResult? Function(String projectId, ProjectMember member)? addTeamMember,
    TResult? Function(String projectId, String fileData)? fileUploaded,
    TResult? Function(String projectId, String fileId)? fileDeleted,
    TResult? Function(dynamic project)? projectSelected,
    TResult? Function(Project? project)? initialized,
    TResult? Function(String name)? nameChanged,
    TResult? Function(Client client)? clientChanged,
    TResult? Function(ProjectTemplate template)? templateChanged,
    TResult? Function(DateTime date)? startDateChanged,
    TResult? Function(DateTime date)? endDateChanged,
    TResult? Function(String description)? descriptionChanged,
    TResult? Function()? saved,
  }) {
    return createProject?.call(
        name, description, type, client, startDate, endDate);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function()? refreshed,
    TResult Function(String? query, List<String>? tags, List<String>? statuses)?
        filtered,
    TResult Function(String projectId)? deleteProject,
    TResult Function(String name, String description, ProjectType type,
            Client? client, DateTime startDate, DateTime endDate)?
        createProject,
    TResult Function(String projectId, ProjectMember member)? addTeamMember,
    TResult Function(String projectId, String fileData)? fileUploaded,
    TResult Function(String projectId, String fileId)? fileDeleted,
    TResult Function(dynamic project)? projectSelected,
    TResult Function(Project? project)? initialized,
    TResult Function(String name)? nameChanged,
    TResult Function(Client client)? clientChanged,
    TResult Function(ProjectTemplate template)? templateChanged,
    TResult Function(DateTime date)? startDateChanged,
    TResult Function(DateTime date)? endDateChanged,
    TResult Function(String description)? descriptionChanged,
    TResult Function()? saved,
    required TResult orElse(),
  }) {
    if (createProject != null) {
      return createProject(name, description, type, client, startDate, endDate);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_Refreshed value) refreshed,
    required TResult Function(Filtered value) filtered,
    required TResult Function(DeleteProject value) deleteProject,
    required TResult Function(CreateProject value) createProject,
    required TResult Function(AddTeamMember value) addTeamMember,
    required TResult Function(FileUploaded value) fileUploaded,
    required TResult Function(FileDeleted value) fileDeleted,
    required TResult Function(ProjectSelected value) projectSelected,
    required TResult Function(_Initialized value) initialized,
    required TResult Function(_NameChanged value) nameChanged,
    required TResult Function(_ClientChanged value) clientChanged,
    required TResult Function(_TemplateChanged value) templateChanged,
    required TResult Function(_StartDateChanged value) startDateChanged,
    required TResult Function(_EndDateChanged value) endDateChanged,
    required TResult Function(_DescriptionChanged value) descriptionChanged,
    required TResult Function(_Saved value) saved,
  }) {
    return createProject(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_Refreshed value)? refreshed,
    TResult? Function(Filtered value)? filtered,
    TResult? Function(DeleteProject value)? deleteProject,
    TResult? Function(CreateProject value)? createProject,
    TResult? Function(AddTeamMember value)? addTeamMember,
    TResult? Function(FileUploaded value)? fileUploaded,
    TResult? Function(FileDeleted value)? fileDeleted,
    TResult? Function(ProjectSelected value)? projectSelected,
    TResult? Function(_Initialized value)? initialized,
    TResult? Function(_NameChanged value)? nameChanged,
    TResult? Function(_ClientChanged value)? clientChanged,
    TResult? Function(_TemplateChanged value)? templateChanged,
    TResult? Function(_StartDateChanged value)? startDateChanged,
    TResult? Function(_EndDateChanged value)? endDateChanged,
    TResult? Function(_DescriptionChanged value)? descriptionChanged,
    TResult? Function(_Saved value)? saved,
  }) {
    return createProject?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_Refreshed value)? refreshed,
    TResult Function(Filtered value)? filtered,
    TResult Function(DeleteProject value)? deleteProject,
    TResult Function(CreateProject value)? createProject,
    TResult Function(AddTeamMember value)? addTeamMember,
    TResult Function(FileUploaded value)? fileUploaded,
    TResult Function(FileDeleted value)? fileDeleted,
    TResult Function(ProjectSelected value)? projectSelected,
    TResult Function(_Initialized value)? initialized,
    TResult Function(_NameChanged value)? nameChanged,
    TResult Function(_ClientChanged value)? clientChanged,
    TResult Function(_TemplateChanged value)? templateChanged,
    TResult Function(_StartDateChanged value)? startDateChanged,
    TResult Function(_EndDateChanged value)? endDateChanged,
    TResult Function(_DescriptionChanged value)? descriptionChanged,
    TResult Function(_Saved value)? saved,
    required TResult orElse(),
  }) {
    if (createProject != null) {
      return createProject(this);
    }
    return orElse();
  }
}

abstract class CreateProject implements ProjectEvent {
  const factory CreateProject(
      {required final String name,
      required final String description,
      required final ProjectType type,
      required final Client? client,
      required final DateTime startDate,
      required final DateTime endDate}) = _$CreateProjectImpl;

  String get name;
  String get description;
  ProjectType get type;
  Client? get client;
  DateTime get startDate;
  DateTime get endDate;

  /// Create a copy of ProjectEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateProjectImplCopyWith<_$CreateProjectImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AddTeamMemberImplCopyWith<$Res> {
  factory _$$AddTeamMemberImplCopyWith(
          _$AddTeamMemberImpl value, $Res Function(_$AddTeamMemberImpl) then) =
      __$$AddTeamMemberImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String projectId, ProjectMember member});

  $ProjectMemberCopyWith<$Res> get member;
}

/// @nodoc
class __$$AddTeamMemberImplCopyWithImpl<$Res>
    extends _$ProjectEventCopyWithImpl<$Res, _$AddTeamMemberImpl>
    implements _$$AddTeamMemberImplCopyWith<$Res> {
  __$$AddTeamMemberImplCopyWithImpl(
      _$AddTeamMemberImpl _value, $Res Function(_$AddTeamMemberImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProjectEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? projectId = null,
    Object? member = null,
  }) {
    return _then(_$AddTeamMemberImpl(
      projectId: null == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String,
      member: null == member
          ? _value.member
          : member // ignore: cast_nullable_to_non_nullable
              as ProjectMember,
    ));
  }

  /// Create a copy of ProjectEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProjectMemberCopyWith<$Res> get member {
    return $ProjectMemberCopyWith<$Res>(_value.member, (value) {
      return _then(_value.copyWith(member: value));
    });
  }
}

/// @nodoc

class _$AddTeamMemberImpl implements AddTeamMember {
  const _$AddTeamMemberImpl({required this.projectId, required this.member});

  @override
  final String projectId;
  @override
  final ProjectMember member;

  @override
  String toString() {
    return 'ProjectEvent.addTeamMember(projectId: $projectId, member: $member)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddTeamMemberImpl &&
            (identical(other.projectId, projectId) ||
                other.projectId == projectId) &&
            (identical(other.member, member) || other.member == member));
  }

  @override
  int get hashCode => Object.hash(runtimeType, projectId, member);

  /// Create a copy of ProjectEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AddTeamMemberImplCopyWith<_$AddTeamMemberImpl> get copyWith =>
      __$$AddTeamMemberImplCopyWithImpl<_$AddTeamMemberImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function() refreshed,
    required TResult Function(
            String? query, List<String>? tags, List<String>? statuses)
        filtered,
    required TResult Function(String projectId) deleteProject,
    required TResult Function(String name, String description, ProjectType type,
            Client? client, DateTime startDate, DateTime endDate)
        createProject,
    required TResult Function(String projectId, ProjectMember member)
        addTeamMember,
    required TResult Function(String projectId, String fileData) fileUploaded,
    required TResult Function(String projectId, String fileId) fileDeleted,
    required TResult Function(dynamic project) projectSelected,
    required TResult Function(Project? project) initialized,
    required TResult Function(String name) nameChanged,
    required TResult Function(Client client) clientChanged,
    required TResult Function(ProjectTemplate template) templateChanged,
    required TResult Function(DateTime date) startDateChanged,
    required TResult Function(DateTime date) endDateChanged,
    required TResult Function(String description) descriptionChanged,
    required TResult Function() saved,
  }) {
    return addTeamMember(projectId, member);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function()? refreshed,
    TResult? Function(
            String? query, List<String>? tags, List<String>? statuses)?
        filtered,
    TResult? Function(String projectId)? deleteProject,
    TResult? Function(String name, String description, ProjectType type,
            Client? client, DateTime startDate, DateTime endDate)?
        createProject,
    TResult? Function(String projectId, ProjectMember member)? addTeamMember,
    TResult? Function(String projectId, String fileData)? fileUploaded,
    TResult? Function(String projectId, String fileId)? fileDeleted,
    TResult? Function(dynamic project)? projectSelected,
    TResult? Function(Project? project)? initialized,
    TResult? Function(String name)? nameChanged,
    TResult? Function(Client client)? clientChanged,
    TResult? Function(ProjectTemplate template)? templateChanged,
    TResult? Function(DateTime date)? startDateChanged,
    TResult? Function(DateTime date)? endDateChanged,
    TResult? Function(String description)? descriptionChanged,
    TResult? Function()? saved,
  }) {
    return addTeamMember?.call(projectId, member);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function()? refreshed,
    TResult Function(String? query, List<String>? tags, List<String>? statuses)?
        filtered,
    TResult Function(String projectId)? deleteProject,
    TResult Function(String name, String description, ProjectType type,
            Client? client, DateTime startDate, DateTime endDate)?
        createProject,
    TResult Function(String projectId, ProjectMember member)? addTeamMember,
    TResult Function(String projectId, String fileData)? fileUploaded,
    TResult Function(String projectId, String fileId)? fileDeleted,
    TResult Function(dynamic project)? projectSelected,
    TResult Function(Project? project)? initialized,
    TResult Function(String name)? nameChanged,
    TResult Function(Client client)? clientChanged,
    TResult Function(ProjectTemplate template)? templateChanged,
    TResult Function(DateTime date)? startDateChanged,
    TResult Function(DateTime date)? endDateChanged,
    TResult Function(String description)? descriptionChanged,
    TResult Function()? saved,
    required TResult orElse(),
  }) {
    if (addTeamMember != null) {
      return addTeamMember(projectId, member);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_Refreshed value) refreshed,
    required TResult Function(Filtered value) filtered,
    required TResult Function(DeleteProject value) deleteProject,
    required TResult Function(CreateProject value) createProject,
    required TResult Function(AddTeamMember value) addTeamMember,
    required TResult Function(FileUploaded value) fileUploaded,
    required TResult Function(FileDeleted value) fileDeleted,
    required TResult Function(ProjectSelected value) projectSelected,
    required TResult Function(_Initialized value) initialized,
    required TResult Function(_NameChanged value) nameChanged,
    required TResult Function(_ClientChanged value) clientChanged,
    required TResult Function(_TemplateChanged value) templateChanged,
    required TResult Function(_StartDateChanged value) startDateChanged,
    required TResult Function(_EndDateChanged value) endDateChanged,
    required TResult Function(_DescriptionChanged value) descriptionChanged,
    required TResult Function(_Saved value) saved,
  }) {
    return addTeamMember(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_Refreshed value)? refreshed,
    TResult? Function(Filtered value)? filtered,
    TResult? Function(DeleteProject value)? deleteProject,
    TResult? Function(CreateProject value)? createProject,
    TResult? Function(AddTeamMember value)? addTeamMember,
    TResult? Function(FileUploaded value)? fileUploaded,
    TResult? Function(FileDeleted value)? fileDeleted,
    TResult? Function(ProjectSelected value)? projectSelected,
    TResult? Function(_Initialized value)? initialized,
    TResult? Function(_NameChanged value)? nameChanged,
    TResult? Function(_ClientChanged value)? clientChanged,
    TResult? Function(_TemplateChanged value)? templateChanged,
    TResult? Function(_StartDateChanged value)? startDateChanged,
    TResult? Function(_EndDateChanged value)? endDateChanged,
    TResult? Function(_DescriptionChanged value)? descriptionChanged,
    TResult? Function(_Saved value)? saved,
  }) {
    return addTeamMember?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_Refreshed value)? refreshed,
    TResult Function(Filtered value)? filtered,
    TResult Function(DeleteProject value)? deleteProject,
    TResult Function(CreateProject value)? createProject,
    TResult Function(AddTeamMember value)? addTeamMember,
    TResult Function(FileUploaded value)? fileUploaded,
    TResult Function(FileDeleted value)? fileDeleted,
    TResult Function(ProjectSelected value)? projectSelected,
    TResult Function(_Initialized value)? initialized,
    TResult Function(_NameChanged value)? nameChanged,
    TResult Function(_ClientChanged value)? clientChanged,
    TResult Function(_TemplateChanged value)? templateChanged,
    TResult Function(_StartDateChanged value)? startDateChanged,
    TResult Function(_EndDateChanged value)? endDateChanged,
    TResult Function(_DescriptionChanged value)? descriptionChanged,
    TResult Function(_Saved value)? saved,
    required TResult orElse(),
  }) {
    if (addTeamMember != null) {
      return addTeamMember(this);
    }
    return orElse();
  }
}

abstract class AddTeamMember implements ProjectEvent {
  const factory AddTeamMember(
      {required final String projectId,
      required final ProjectMember member}) = _$AddTeamMemberImpl;

  String get projectId;
  ProjectMember get member;

  /// Create a copy of ProjectEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AddTeamMemberImplCopyWith<_$AddTeamMemberImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$FileUploadedImplCopyWith<$Res> {
  factory _$$FileUploadedImplCopyWith(
          _$FileUploadedImpl value, $Res Function(_$FileUploadedImpl) then) =
      __$$FileUploadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String projectId, String fileData});
}

/// @nodoc
class __$$FileUploadedImplCopyWithImpl<$Res>
    extends _$ProjectEventCopyWithImpl<$Res, _$FileUploadedImpl>
    implements _$$FileUploadedImplCopyWith<$Res> {
  __$$FileUploadedImplCopyWithImpl(
      _$FileUploadedImpl _value, $Res Function(_$FileUploadedImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProjectEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? projectId = null,
    Object? fileData = null,
  }) {
    return _then(_$FileUploadedImpl(
      projectId: null == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String,
      fileData: null == fileData
          ? _value.fileData
          : fileData // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$FileUploadedImpl implements FileUploaded {
  const _$FileUploadedImpl({required this.projectId, required this.fileData});

  @override
  final String projectId;
  @override
  final String fileData;

  @override
  String toString() {
    return 'ProjectEvent.fileUploaded(projectId: $projectId, fileData: $fileData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FileUploadedImpl &&
            (identical(other.projectId, projectId) ||
                other.projectId == projectId) &&
            (identical(other.fileData, fileData) ||
                other.fileData == fileData));
  }

  @override
  int get hashCode => Object.hash(runtimeType, projectId, fileData);

  /// Create a copy of ProjectEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FileUploadedImplCopyWith<_$FileUploadedImpl> get copyWith =>
      __$$FileUploadedImplCopyWithImpl<_$FileUploadedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function() refreshed,
    required TResult Function(
            String? query, List<String>? tags, List<String>? statuses)
        filtered,
    required TResult Function(String projectId) deleteProject,
    required TResult Function(String name, String description, ProjectType type,
            Client? client, DateTime startDate, DateTime endDate)
        createProject,
    required TResult Function(String projectId, ProjectMember member)
        addTeamMember,
    required TResult Function(String projectId, String fileData) fileUploaded,
    required TResult Function(String projectId, String fileId) fileDeleted,
    required TResult Function(dynamic project) projectSelected,
    required TResult Function(Project? project) initialized,
    required TResult Function(String name) nameChanged,
    required TResult Function(Client client) clientChanged,
    required TResult Function(ProjectTemplate template) templateChanged,
    required TResult Function(DateTime date) startDateChanged,
    required TResult Function(DateTime date) endDateChanged,
    required TResult Function(String description) descriptionChanged,
    required TResult Function() saved,
  }) {
    return fileUploaded(projectId, fileData);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function()? refreshed,
    TResult? Function(
            String? query, List<String>? tags, List<String>? statuses)?
        filtered,
    TResult? Function(String projectId)? deleteProject,
    TResult? Function(String name, String description, ProjectType type,
            Client? client, DateTime startDate, DateTime endDate)?
        createProject,
    TResult? Function(String projectId, ProjectMember member)? addTeamMember,
    TResult? Function(String projectId, String fileData)? fileUploaded,
    TResult? Function(String projectId, String fileId)? fileDeleted,
    TResult? Function(dynamic project)? projectSelected,
    TResult? Function(Project? project)? initialized,
    TResult? Function(String name)? nameChanged,
    TResult? Function(Client client)? clientChanged,
    TResult? Function(ProjectTemplate template)? templateChanged,
    TResult? Function(DateTime date)? startDateChanged,
    TResult? Function(DateTime date)? endDateChanged,
    TResult? Function(String description)? descriptionChanged,
    TResult? Function()? saved,
  }) {
    return fileUploaded?.call(projectId, fileData);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function()? refreshed,
    TResult Function(String? query, List<String>? tags, List<String>? statuses)?
        filtered,
    TResult Function(String projectId)? deleteProject,
    TResult Function(String name, String description, ProjectType type,
            Client? client, DateTime startDate, DateTime endDate)?
        createProject,
    TResult Function(String projectId, ProjectMember member)? addTeamMember,
    TResult Function(String projectId, String fileData)? fileUploaded,
    TResult Function(String projectId, String fileId)? fileDeleted,
    TResult Function(dynamic project)? projectSelected,
    TResult Function(Project? project)? initialized,
    TResult Function(String name)? nameChanged,
    TResult Function(Client client)? clientChanged,
    TResult Function(ProjectTemplate template)? templateChanged,
    TResult Function(DateTime date)? startDateChanged,
    TResult Function(DateTime date)? endDateChanged,
    TResult Function(String description)? descriptionChanged,
    TResult Function()? saved,
    required TResult orElse(),
  }) {
    if (fileUploaded != null) {
      return fileUploaded(projectId, fileData);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_Refreshed value) refreshed,
    required TResult Function(Filtered value) filtered,
    required TResult Function(DeleteProject value) deleteProject,
    required TResult Function(CreateProject value) createProject,
    required TResult Function(AddTeamMember value) addTeamMember,
    required TResult Function(FileUploaded value) fileUploaded,
    required TResult Function(FileDeleted value) fileDeleted,
    required TResult Function(ProjectSelected value) projectSelected,
    required TResult Function(_Initialized value) initialized,
    required TResult Function(_NameChanged value) nameChanged,
    required TResult Function(_ClientChanged value) clientChanged,
    required TResult Function(_TemplateChanged value) templateChanged,
    required TResult Function(_StartDateChanged value) startDateChanged,
    required TResult Function(_EndDateChanged value) endDateChanged,
    required TResult Function(_DescriptionChanged value) descriptionChanged,
    required TResult Function(_Saved value) saved,
  }) {
    return fileUploaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_Refreshed value)? refreshed,
    TResult? Function(Filtered value)? filtered,
    TResult? Function(DeleteProject value)? deleteProject,
    TResult? Function(CreateProject value)? createProject,
    TResult? Function(AddTeamMember value)? addTeamMember,
    TResult? Function(FileUploaded value)? fileUploaded,
    TResult? Function(FileDeleted value)? fileDeleted,
    TResult? Function(ProjectSelected value)? projectSelected,
    TResult? Function(_Initialized value)? initialized,
    TResult? Function(_NameChanged value)? nameChanged,
    TResult? Function(_ClientChanged value)? clientChanged,
    TResult? Function(_TemplateChanged value)? templateChanged,
    TResult? Function(_StartDateChanged value)? startDateChanged,
    TResult? Function(_EndDateChanged value)? endDateChanged,
    TResult? Function(_DescriptionChanged value)? descriptionChanged,
    TResult? Function(_Saved value)? saved,
  }) {
    return fileUploaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_Refreshed value)? refreshed,
    TResult Function(Filtered value)? filtered,
    TResult Function(DeleteProject value)? deleteProject,
    TResult Function(CreateProject value)? createProject,
    TResult Function(AddTeamMember value)? addTeamMember,
    TResult Function(FileUploaded value)? fileUploaded,
    TResult Function(FileDeleted value)? fileDeleted,
    TResult Function(ProjectSelected value)? projectSelected,
    TResult Function(_Initialized value)? initialized,
    TResult Function(_NameChanged value)? nameChanged,
    TResult Function(_ClientChanged value)? clientChanged,
    TResult Function(_TemplateChanged value)? templateChanged,
    TResult Function(_StartDateChanged value)? startDateChanged,
    TResult Function(_EndDateChanged value)? endDateChanged,
    TResult Function(_DescriptionChanged value)? descriptionChanged,
    TResult Function(_Saved value)? saved,
    required TResult orElse(),
  }) {
    if (fileUploaded != null) {
      return fileUploaded(this);
    }
    return orElse();
  }
}

abstract class FileUploaded implements ProjectEvent {
  const factory FileUploaded(
      {required final String projectId,
      required final String fileData}) = _$FileUploadedImpl;

  String get projectId;
  String get fileData;

  /// Create a copy of ProjectEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FileUploadedImplCopyWith<_$FileUploadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$FileDeletedImplCopyWith<$Res> {
  factory _$$FileDeletedImplCopyWith(
          _$FileDeletedImpl value, $Res Function(_$FileDeletedImpl) then) =
      __$$FileDeletedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String projectId, String fileId});
}

/// @nodoc
class __$$FileDeletedImplCopyWithImpl<$Res>
    extends _$ProjectEventCopyWithImpl<$Res, _$FileDeletedImpl>
    implements _$$FileDeletedImplCopyWith<$Res> {
  __$$FileDeletedImplCopyWithImpl(
      _$FileDeletedImpl _value, $Res Function(_$FileDeletedImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProjectEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? projectId = null,
    Object? fileId = null,
  }) {
    return _then(_$FileDeletedImpl(
      projectId: null == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String,
      fileId: null == fileId
          ? _value.fileId
          : fileId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$FileDeletedImpl implements FileDeleted {
  const _$FileDeletedImpl({required this.projectId, required this.fileId});

  @override
  final String projectId;
  @override
  final String fileId;

  @override
  String toString() {
    return 'ProjectEvent.fileDeleted(projectId: $projectId, fileId: $fileId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FileDeletedImpl &&
            (identical(other.projectId, projectId) ||
                other.projectId == projectId) &&
            (identical(other.fileId, fileId) || other.fileId == fileId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, projectId, fileId);

  /// Create a copy of ProjectEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FileDeletedImplCopyWith<_$FileDeletedImpl> get copyWith =>
      __$$FileDeletedImplCopyWithImpl<_$FileDeletedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function() refreshed,
    required TResult Function(
            String? query, List<String>? tags, List<String>? statuses)
        filtered,
    required TResult Function(String projectId) deleteProject,
    required TResult Function(String name, String description, ProjectType type,
            Client? client, DateTime startDate, DateTime endDate)
        createProject,
    required TResult Function(String projectId, ProjectMember member)
        addTeamMember,
    required TResult Function(String projectId, String fileData) fileUploaded,
    required TResult Function(String projectId, String fileId) fileDeleted,
    required TResult Function(dynamic project) projectSelected,
    required TResult Function(Project? project) initialized,
    required TResult Function(String name) nameChanged,
    required TResult Function(Client client) clientChanged,
    required TResult Function(ProjectTemplate template) templateChanged,
    required TResult Function(DateTime date) startDateChanged,
    required TResult Function(DateTime date) endDateChanged,
    required TResult Function(String description) descriptionChanged,
    required TResult Function() saved,
  }) {
    return fileDeleted(projectId, fileId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function()? refreshed,
    TResult? Function(
            String? query, List<String>? tags, List<String>? statuses)?
        filtered,
    TResult? Function(String projectId)? deleteProject,
    TResult? Function(String name, String description, ProjectType type,
            Client? client, DateTime startDate, DateTime endDate)?
        createProject,
    TResult? Function(String projectId, ProjectMember member)? addTeamMember,
    TResult? Function(String projectId, String fileData)? fileUploaded,
    TResult? Function(String projectId, String fileId)? fileDeleted,
    TResult? Function(dynamic project)? projectSelected,
    TResult? Function(Project? project)? initialized,
    TResult? Function(String name)? nameChanged,
    TResult? Function(Client client)? clientChanged,
    TResult? Function(ProjectTemplate template)? templateChanged,
    TResult? Function(DateTime date)? startDateChanged,
    TResult? Function(DateTime date)? endDateChanged,
    TResult? Function(String description)? descriptionChanged,
    TResult? Function()? saved,
  }) {
    return fileDeleted?.call(projectId, fileId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function()? refreshed,
    TResult Function(String? query, List<String>? tags, List<String>? statuses)?
        filtered,
    TResult Function(String projectId)? deleteProject,
    TResult Function(String name, String description, ProjectType type,
            Client? client, DateTime startDate, DateTime endDate)?
        createProject,
    TResult Function(String projectId, ProjectMember member)? addTeamMember,
    TResult Function(String projectId, String fileData)? fileUploaded,
    TResult Function(String projectId, String fileId)? fileDeleted,
    TResult Function(dynamic project)? projectSelected,
    TResult Function(Project? project)? initialized,
    TResult Function(String name)? nameChanged,
    TResult Function(Client client)? clientChanged,
    TResult Function(ProjectTemplate template)? templateChanged,
    TResult Function(DateTime date)? startDateChanged,
    TResult Function(DateTime date)? endDateChanged,
    TResult Function(String description)? descriptionChanged,
    TResult Function()? saved,
    required TResult orElse(),
  }) {
    if (fileDeleted != null) {
      return fileDeleted(projectId, fileId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_Refreshed value) refreshed,
    required TResult Function(Filtered value) filtered,
    required TResult Function(DeleteProject value) deleteProject,
    required TResult Function(CreateProject value) createProject,
    required TResult Function(AddTeamMember value) addTeamMember,
    required TResult Function(FileUploaded value) fileUploaded,
    required TResult Function(FileDeleted value) fileDeleted,
    required TResult Function(ProjectSelected value) projectSelected,
    required TResult Function(_Initialized value) initialized,
    required TResult Function(_NameChanged value) nameChanged,
    required TResult Function(_ClientChanged value) clientChanged,
    required TResult Function(_TemplateChanged value) templateChanged,
    required TResult Function(_StartDateChanged value) startDateChanged,
    required TResult Function(_EndDateChanged value) endDateChanged,
    required TResult Function(_DescriptionChanged value) descriptionChanged,
    required TResult Function(_Saved value) saved,
  }) {
    return fileDeleted(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_Refreshed value)? refreshed,
    TResult? Function(Filtered value)? filtered,
    TResult? Function(DeleteProject value)? deleteProject,
    TResult? Function(CreateProject value)? createProject,
    TResult? Function(AddTeamMember value)? addTeamMember,
    TResult? Function(FileUploaded value)? fileUploaded,
    TResult? Function(FileDeleted value)? fileDeleted,
    TResult? Function(ProjectSelected value)? projectSelected,
    TResult? Function(_Initialized value)? initialized,
    TResult? Function(_NameChanged value)? nameChanged,
    TResult? Function(_ClientChanged value)? clientChanged,
    TResult? Function(_TemplateChanged value)? templateChanged,
    TResult? Function(_StartDateChanged value)? startDateChanged,
    TResult? Function(_EndDateChanged value)? endDateChanged,
    TResult? Function(_DescriptionChanged value)? descriptionChanged,
    TResult? Function(_Saved value)? saved,
  }) {
    return fileDeleted?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_Refreshed value)? refreshed,
    TResult Function(Filtered value)? filtered,
    TResult Function(DeleteProject value)? deleteProject,
    TResult Function(CreateProject value)? createProject,
    TResult Function(AddTeamMember value)? addTeamMember,
    TResult Function(FileUploaded value)? fileUploaded,
    TResult Function(FileDeleted value)? fileDeleted,
    TResult Function(ProjectSelected value)? projectSelected,
    TResult Function(_Initialized value)? initialized,
    TResult Function(_NameChanged value)? nameChanged,
    TResult Function(_ClientChanged value)? clientChanged,
    TResult Function(_TemplateChanged value)? templateChanged,
    TResult Function(_StartDateChanged value)? startDateChanged,
    TResult Function(_EndDateChanged value)? endDateChanged,
    TResult Function(_DescriptionChanged value)? descriptionChanged,
    TResult Function(_Saved value)? saved,
    required TResult orElse(),
  }) {
    if (fileDeleted != null) {
      return fileDeleted(this);
    }
    return orElse();
  }
}

abstract class FileDeleted implements ProjectEvent {
  const factory FileDeleted(
      {required final String projectId,
      required final String fileId}) = _$FileDeletedImpl;

  String get projectId;
  String get fileId;

  /// Create a copy of ProjectEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FileDeletedImplCopyWith<_$FileDeletedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ProjectSelectedImplCopyWith<$Res> {
  factory _$$ProjectSelectedImplCopyWith(_$ProjectSelectedImpl value,
          $Res Function(_$ProjectSelectedImpl) then) =
      __$$ProjectSelectedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({dynamic project});
}

/// @nodoc
class __$$ProjectSelectedImplCopyWithImpl<$Res>
    extends _$ProjectEventCopyWithImpl<$Res, _$ProjectSelectedImpl>
    implements _$$ProjectSelectedImplCopyWith<$Res> {
  __$$ProjectSelectedImplCopyWithImpl(
      _$ProjectSelectedImpl _value, $Res Function(_$ProjectSelectedImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProjectEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? project = freezed,
  }) {
    return _then(_$ProjectSelectedImpl(
      freezed == project
          ? _value.project
          : project // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// @nodoc

class _$ProjectSelectedImpl implements ProjectSelected {
  const _$ProjectSelectedImpl(this.project);

  @override
  final dynamic project;

  @override
  String toString() {
    return 'ProjectEvent.projectSelected(project: $project)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProjectSelectedImpl &&
            const DeepCollectionEquality().equals(other.project, project));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(project));

  /// Create a copy of ProjectEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProjectSelectedImplCopyWith<_$ProjectSelectedImpl> get copyWith =>
      __$$ProjectSelectedImplCopyWithImpl<_$ProjectSelectedImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function() refreshed,
    required TResult Function(
            String? query, List<String>? tags, List<String>? statuses)
        filtered,
    required TResult Function(String projectId) deleteProject,
    required TResult Function(String name, String description, ProjectType type,
            Client? client, DateTime startDate, DateTime endDate)
        createProject,
    required TResult Function(String projectId, ProjectMember member)
        addTeamMember,
    required TResult Function(String projectId, String fileData) fileUploaded,
    required TResult Function(String projectId, String fileId) fileDeleted,
    required TResult Function(dynamic project) projectSelected,
    required TResult Function(Project? project) initialized,
    required TResult Function(String name) nameChanged,
    required TResult Function(Client client) clientChanged,
    required TResult Function(ProjectTemplate template) templateChanged,
    required TResult Function(DateTime date) startDateChanged,
    required TResult Function(DateTime date) endDateChanged,
    required TResult Function(String description) descriptionChanged,
    required TResult Function() saved,
  }) {
    return projectSelected(project);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function()? refreshed,
    TResult? Function(
            String? query, List<String>? tags, List<String>? statuses)?
        filtered,
    TResult? Function(String projectId)? deleteProject,
    TResult? Function(String name, String description, ProjectType type,
            Client? client, DateTime startDate, DateTime endDate)?
        createProject,
    TResult? Function(String projectId, ProjectMember member)? addTeamMember,
    TResult? Function(String projectId, String fileData)? fileUploaded,
    TResult? Function(String projectId, String fileId)? fileDeleted,
    TResult? Function(dynamic project)? projectSelected,
    TResult? Function(Project? project)? initialized,
    TResult? Function(String name)? nameChanged,
    TResult? Function(Client client)? clientChanged,
    TResult? Function(ProjectTemplate template)? templateChanged,
    TResult? Function(DateTime date)? startDateChanged,
    TResult? Function(DateTime date)? endDateChanged,
    TResult? Function(String description)? descriptionChanged,
    TResult? Function()? saved,
  }) {
    return projectSelected?.call(project);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function()? refreshed,
    TResult Function(String? query, List<String>? tags, List<String>? statuses)?
        filtered,
    TResult Function(String projectId)? deleteProject,
    TResult Function(String name, String description, ProjectType type,
            Client? client, DateTime startDate, DateTime endDate)?
        createProject,
    TResult Function(String projectId, ProjectMember member)? addTeamMember,
    TResult Function(String projectId, String fileData)? fileUploaded,
    TResult Function(String projectId, String fileId)? fileDeleted,
    TResult Function(dynamic project)? projectSelected,
    TResult Function(Project? project)? initialized,
    TResult Function(String name)? nameChanged,
    TResult Function(Client client)? clientChanged,
    TResult Function(ProjectTemplate template)? templateChanged,
    TResult Function(DateTime date)? startDateChanged,
    TResult Function(DateTime date)? endDateChanged,
    TResult Function(String description)? descriptionChanged,
    TResult Function()? saved,
    required TResult orElse(),
  }) {
    if (projectSelected != null) {
      return projectSelected(project);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_Refreshed value) refreshed,
    required TResult Function(Filtered value) filtered,
    required TResult Function(DeleteProject value) deleteProject,
    required TResult Function(CreateProject value) createProject,
    required TResult Function(AddTeamMember value) addTeamMember,
    required TResult Function(FileUploaded value) fileUploaded,
    required TResult Function(FileDeleted value) fileDeleted,
    required TResult Function(ProjectSelected value) projectSelected,
    required TResult Function(_Initialized value) initialized,
    required TResult Function(_NameChanged value) nameChanged,
    required TResult Function(_ClientChanged value) clientChanged,
    required TResult Function(_TemplateChanged value) templateChanged,
    required TResult Function(_StartDateChanged value) startDateChanged,
    required TResult Function(_EndDateChanged value) endDateChanged,
    required TResult Function(_DescriptionChanged value) descriptionChanged,
    required TResult Function(_Saved value) saved,
  }) {
    return projectSelected(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_Refreshed value)? refreshed,
    TResult? Function(Filtered value)? filtered,
    TResult? Function(DeleteProject value)? deleteProject,
    TResult? Function(CreateProject value)? createProject,
    TResult? Function(AddTeamMember value)? addTeamMember,
    TResult? Function(FileUploaded value)? fileUploaded,
    TResult? Function(FileDeleted value)? fileDeleted,
    TResult? Function(ProjectSelected value)? projectSelected,
    TResult? Function(_Initialized value)? initialized,
    TResult? Function(_NameChanged value)? nameChanged,
    TResult? Function(_ClientChanged value)? clientChanged,
    TResult? Function(_TemplateChanged value)? templateChanged,
    TResult? Function(_StartDateChanged value)? startDateChanged,
    TResult? Function(_EndDateChanged value)? endDateChanged,
    TResult? Function(_DescriptionChanged value)? descriptionChanged,
    TResult? Function(_Saved value)? saved,
  }) {
    return projectSelected?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_Refreshed value)? refreshed,
    TResult Function(Filtered value)? filtered,
    TResult Function(DeleteProject value)? deleteProject,
    TResult Function(CreateProject value)? createProject,
    TResult Function(AddTeamMember value)? addTeamMember,
    TResult Function(FileUploaded value)? fileUploaded,
    TResult Function(FileDeleted value)? fileDeleted,
    TResult Function(ProjectSelected value)? projectSelected,
    TResult Function(_Initialized value)? initialized,
    TResult Function(_NameChanged value)? nameChanged,
    TResult Function(_ClientChanged value)? clientChanged,
    TResult Function(_TemplateChanged value)? templateChanged,
    TResult Function(_StartDateChanged value)? startDateChanged,
    TResult Function(_EndDateChanged value)? endDateChanged,
    TResult Function(_DescriptionChanged value)? descriptionChanged,
    TResult Function(_Saved value)? saved,
    required TResult orElse(),
  }) {
    if (projectSelected != null) {
      return projectSelected(this);
    }
    return orElse();
  }
}

abstract class ProjectSelected implements ProjectEvent {
  const factory ProjectSelected(final dynamic project) = _$ProjectSelectedImpl;

  dynamic get project;

  /// Create a copy of ProjectEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProjectSelectedImplCopyWith<_$ProjectSelectedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$InitializedImplCopyWith<$Res> {
  factory _$$InitializedImplCopyWith(
          _$InitializedImpl value, $Res Function(_$InitializedImpl) then) =
      __$$InitializedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Project? project});

  $ProjectCopyWith<$Res>? get project;
}

/// @nodoc
class __$$InitializedImplCopyWithImpl<$Res>
    extends _$ProjectEventCopyWithImpl<$Res, _$InitializedImpl>
    implements _$$InitializedImplCopyWith<$Res> {
  __$$InitializedImplCopyWithImpl(
      _$InitializedImpl _value, $Res Function(_$InitializedImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProjectEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? project = freezed,
  }) {
    return _then(_$InitializedImpl(
      freezed == project
          ? _value.project
          : project // ignore: cast_nullable_to_non_nullable
              as Project?,
    ));
  }

  /// Create a copy of ProjectEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProjectCopyWith<$Res>? get project {
    if (_value.project == null) {
      return null;
    }

    return $ProjectCopyWith<$Res>(_value.project!, (value) {
      return _then(_value.copyWith(project: value));
    });
  }
}

/// @nodoc

class _$InitializedImpl implements _Initialized {
  const _$InitializedImpl(this.project);

  @override
  final Project? project;

  @override
  String toString() {
    return 'ProjectEvent.initialized(project: $project)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InitializedImpl &&
            (identical(other.project, project) || other.project == project));
  }

  @override
  int get hashCode => Object.hash(runtimeType, project);

  /// Create a copy of ProjectEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InitializedImplCopyWith<_$InitializedImpl> get copyWith =>
      __$$InitializedImplCopyWithImpl<_$InitializedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function() refreshed,
    required TResult Function(
            String? query, List<String>? tags, List<String>? statuses)
        filtered,
    required TResult Function(String projectId) deleteProject,
    required TResult Function(String name, String description, ProjectType type,
            Client? client, DateTime startDate, DateTime endDate)
        createProject,
    required TResult Function(String projectId, ProjectMember member)
        addTeamMember,
    required TResult Function(String projectId, String fileData) fileUploaded,
    required TResult Function(String projectId, String fileId) fileDeleted,
    required TResult Function(dynamic project) projectSelected,
    required TResult Function(Project? project) initialized,
    required TResult Function(String name) nameChanged,
    required TResult Function(Client client) clientChanged,
    required TResult Function(ProjectTemplate template) templateChanged,
    required TResult Function(DateTime date) startDateChanged,
    required TResult Function(DateTime date) endDateChanged,
    required TResult Function(String description) descriptionChanged,
    required TResult Function() saved,
  }) {
    return initialized(project);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function()? refreshed,
    TResult? Function(
            String? query, List<String>? tags, List<String>? statuses)?
        filtered,
    TResult? Function(String projectId)? deleteProject,
    TResult? Function(String name, String description, ProjectType type,
            Client? client, DateTime startDate, DateTime endDate)?
        createProject,
    TResult? Function(String projectId, ProjectMember member)? addTeamMember,
    TResult? Function(String projectId, String fileData)? fileUploaded,
    TResult? Function(String projectId, String fileId)? fileDeleted,
    TResult? Function(dynamic project)? projectSelected,
    TResult? Function(Project? project)? initialized,
    TResult? Function(String name)? nameChanged,
    TResult? Function(Client client)? clientChanged,
    TResult? Function(ProjectTemplate template)? templateChanged,
    TResult? Function(DateTime date)? startDateChanged,
    TResult? Function(DateTime date)? endDateChanged,
    TResult? Function(String description)? descriptionChanged,
    TResult? Function()? saved,
  }) {
    return initialized?.call(project);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function()? refreshed,
    TResult Function(String? query, List<String>? tags, List<String>? statuses)?
        filtered,
    TResult Function(String projectId)? deleteProject,
    TResult Function(String name, String description, ProjectType type,
            Client? client, DateTime startDate, DateTime endDate)?
        createProject,
    TResult Function(String projectId, ProjectMember member)? addTeamMember,
    TResult Function(String projectId, String fileData)? fileUploaded,
    TResult Function(String projectId, String fileId)? fileDeleted,
    TResult Function(dynamic project)? projectSelected,
    TResult Function(Project? project)? initialized,
    TResult Function(String name)? nameChanged,
    TResult Function(Client client)? clientChanged,
    TResult Function(ProjectTemplate template)? templateChanged,
    TResult Function(DateTime date)? startDateChanged,
    TResult Function(DateTime date)? endDateChanged,
    TResult Function(String description)? descriptionChanged,
    TResult Function()? saved,
    required TResult orElse(),
  }) {
    if (initialized != null) {
      return initialized(project);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_Refreshed value) refreshed,
    required TResult Function(Filtered value) filtered,
    required TResult Function(DeleteProject value) deleteProject,
    required TResult Function(CreateProject value) createProject,
    required TResult Function(AddTeamMember value) addTeamMember,
    required TResult Function(FileUploaded value) fileUploaded,
    required TResult Function(FileDeleted value) fileDeleted,
    required TResult Function(ProjectSelected value) projectSelected,
    required TResult Function(_Initialized value) initialized,
    required TResult Function(_NameChanged value) nameChanged,
    required TResult Function(_ClientChanged value) clientChanged,
    required TResult Function(_TemplateChanged value) templateChanged,
    required TResult Function(_StartDateChanged value) startDateChanged,
    required TResult Function(_EndDateChanged value) endDateChanged,
    required TResult Function(_DescriptionChanged value) descriptionChanged,
    required TResult Function(_Saved value) saved,
  }) {
    return initialized(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_Refreshed value)? refreshed,
    TResult? Function(Filtered value)? filtered,
    TResult? Function(DeleteProject value)? deleteProject,
    TResult? Function(CreateProject value)? createProject,
    TResult? Function(AddTeamMember value)? addTeamMember,
    TResult? Function(FileUploaded value)? fileUploaded,
    TResult? Function(FileDeleted value)? fileDeleted,
    TResult? Function(ProjectSelected value)? projectSelected,
    TResult? Function(_Initialized value)? initialized,
    TResult? Function(_NameChanged value)? nameChanged,
    TResult? Function(_ClientChanged value)? clientChanged,
    TResult? Function(_TemplateChanged value)? templateChanged,
    TResult? Function(_StartDateChanged value)? startDateChanged,
    TResult? Function(_EndDateChanged value)? endDateChanged,
    TResult? Function(_DescriptionChanged value)? descriptionChanged,
    TResult? Function(_Saved value)? saved,
  }) {
    return initialized?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_Refreshed value)? refreshed,
    TResult Function(Filtered value)? filtered,
    TResult Function(DeleteProject value)? deleteProject,
    TResult Function(CreateProject value)? createProject,
    TResult Function(AddTeamMember value)? addTeamMember,
    TResult Function(FileUploaded value)? fileUploaded,
    TResult Function(FileDeleted value)? fileDeleted,
    TResult Function(ProjectSelected value)? projectSelected,
    TResult Function(_Initialized value)? initialized,
    TResult Function(_NameChanged value)? nameChanged,
    TResult Function(_ClientChanged value)? clientChanged,
    TResult Function(_TemplateChanged value)? templateChanged,
    TResult Function(_StartDateChanged value)? startDateChanged,
    TResult Function(_EndDateChanged value)? endDateChanged,
    TResult Function(_DescriptionChanged value)? descriptionChanged,
    TResult Function(_Saved value)? saved,
    required TResult orElse(),
  }) {
    if (initialized != null) {
      return initialized(this);
    }
    return orElse();
  }
}

abstract class _Initialized implements ProjectEvent {
  const factory _Initialized(final Project? project) = _$InitializedImpl;

  Project? get project;

  /// Create a copy of ProjectEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InitializedImplCopyWith<_$InitializedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$NameChangedImplCopyWith<$Res> {
  factory _$$NameChangedImplCopyWith(
          _$NameChangedImpl value, $Res Function(_$NameChangedImpl) then) =
      __$$NameChangedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String name});
}

/// @nodoc
class __$$NameChangedImplCopyWithImpl<$Res>
    extends _$ProjectEventCopyWithImpl<$Res, _$NameChangedImpl>
    implements _$$NameChangedImplCopyWith<$Res> {
  __$$NameChangedImplCopyWithImpl(
      _$NameChangedImpl _value, $Res Function(_$NameChangedImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProjectEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
  }) {
    return _then(_$NameChangedImpl(
      null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$NameChangedImpl implements _NameChanged {
  const _$NameChangedImpl(this.name);

  @override
  final String name;

  @override
  String toString() {
    return 'ProjectEvent.nameChanged(name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NameChangedImpl &&
            (identical(other.name, name) || other.name == name));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name);

  /// Create a copy of ProjectEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NameChangedImplCopyWith<_$NameChangedImpl> get copyWith =>
      __$$NameChangedImplCopyWithImpl<_$NameChangedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function() refreshed,
    required TResult Function(
            String? query, List<String>? tags, List<String>? statuses)
        filtered,
    required TResult Function(String projectId) deleteProject,
    required TResult Function(String name, String description, ProjectType type,
            Client? client, DateTime startDate, DateTime endDate)
        createProject,
    required TResult Function(String projectId, ProjectMember member)
        addTeamMember,
    required TResult Function(String projectId, String fileData) fileUploaded,
    required TResult Function(String projectId, String fileId) fileDeleted,
    required TResult Function(dynamic project) projectSelected,
    required TResult Function(Project? project) initialized,
    required TResult Function(String name) nameChanged,
    required TResult Function(Client client) clientChanged,
    required TResult Function(ProjectTemplate template) templateChanged,
    required TResult Function(DateTime date) startDateChanged,
    required TResult Function(DateTime date) endDateChanged,
    required TResult Function(String description) descriptionChanged,
    required TResult Function() saved,
  }) {
    return nameChanged(name);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function()? refreshed,
    TResult? Function(
            String? query, List<String>? tags, List<String>? statuses)?
        filtered,
    TResult? Function(String projectId)? deleteProject,
    TResult? Function(String name, String description, ProjectType type,
            Client? client, DateTime startDate, DateTime endDate)?
        createProject,
    TResult? Function(String projectId, ProjectMember member)? addTeamMember,
    TResult? Function(String projectId, String fileData)? fileUploaded,
    TResult? Function(String projectId, String fileId)? fileDeleted,
    TResult? Function(dynamic project)? projectSelected,
    TResult? Function(Project? project)? initialized,
    TResult? Function(String name)? nameChanged,
    TResult? Function(Client client)? clientChanged,
    TResult? Function(ProjectTemplate template)? templateChanged,
    TResult? Function(DateTime date)? startDateChanged,
    TResult? Function(DateTime date)? endDateChanged,
    TResult? Function(String description)? descriptionChanged,
    TResult? Function()? saved,
  }) {
    return nameChanged?.call(name);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function()? refreshed,
    TResult Function(String? query, List<String>? tags, List<String>? statuses)?
        filtered,
    TResult Function(String projectId)? deleteProject,
    TResult Function(String name, String description, ProjectType type,
            Client? client, DateTime startDate, DateTime endDate)?
        createProject,
    TResult Function(String projectId, ProjectMember member)? addTeamMember,
    TResult Function(String projectId, String fileData)? fileUploaded,
    TResult Function(String projectId, String fileId)? fileDeleted,
    TResult Function(dynamic project)? projectSelected,
    TResult Function(Project? project)? initialized,
    TResult Function(String name)? nameChanged,
    TResult Function(Client client)? clientChanged,
    TResult Function(ProjectTemplate template)? templateChanged,
    TResult Function(DateTime date)? startDateChanged,
    TResult Function(DateTime date)? endDateChanged,
    TResult Function(String description)? descriptionChanged,
    TResult Function()? saved,
    required TResult orElse(),
  }) {
    if (nameChanged != null) {
      return nameChanged(name);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_Refreshed value) refreshed,
    required TResult Function(Filtered value) filtered,
    required TResult Function(DeleteProject value) deleteProject,
    required TResult Function(CreateProject value) createProject,
    required TResult Function(AddTeamMember value) addTeamMember,
    required TResult Function(FileUploaded value) fileUploaded,
    required TResult Function(FileDeleted value) fileDeleted,
    required TResult Function(ProjectSelected value) projectSelected,
    required TResult Function(_Initialized value) initialized,
    required TResult Function(_NameChanged value) nameChanged,
    required TResult Function(_ClientChanged value) clientChanged,
    required TResult Function(_TemplateChanged value) templateChanged,
    required TResult Function(_StartDateChanged value) startDateChanged,
    required TResult Function(_EndDateChanged value) endDateChanged,
    required TResult Function(_DescriptionChanged value) descriptionChanged,
    required TResult Function(_Saved value) saved,
  }) {
    return nameChanged(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_Refreshed value)? refreshed,
    TResult? Function(Filtered value)? filtered,
    TResult? Function(DeleteProject value)? deleteProject,
    TResult? Function(CreateProject value)? createProject,
    TResult? Function(AddTeamMember value)? addTeamMember,
    TResult? Function(FileUploaded value)? fileUploaded,
    TResult? Function(FileDeleted value)? fileDeleted,
    TResult? Function(ProjectSelected value)? projectSelected,
    TResult? Function(_Initialized value)? initialized,
    TResult? Function(_NameChanged value)? nameChanged,
    TResult? Function(_ClientChanged value)? clientChanged,
    TResult? Function(_TemplateChanged value)? templateChanged,
    TResult? Function(_StartDateChanged value)? startDateChanged,
    TResult? Function(_EndDateChanged value)? endDateChanged,
    TResult? Function(_DescriptionChanged value)? descriptionChanged,
    TResult? Function(_Saved value)? saved,
  }) {
    return nameChanged?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_Refreshed value)? refreshed,
    TResult Function(Filtered value)? filtered,
    TResult Function(DeleteProject value)? deleteProject,
    TResult Function(CreateProject value)? createProject,
    TResult Function(AddTeamMember value)? addTeamMember,
    TResult Function(FileUploaded value)? fileUploaded,
    TResult Function(FileDeleted value)? fileDeleted,
    TResult Function(ProjectSelected value)? projectSelected,
    TResult Function(_Initialized value)? initialized,
    TResult Function(_NameChanged value)? nameChanged,
    TResult Function(_ClientChanged value)? clientChanged,
    TResult Function(_TemplateChanged value)? templateChanged,
    TResult Function(_StartDateChanged value)? startDateChanged,
    TResult Function(_EndDateChanged value)? endDateChanged,
    TResult Function(_DescriptionChanged value)? descriptionChanged,
    TResult Function(_Saved value)? saved,
    required TResult orElse(),
  }) {
    if (nameChanged != null) {
      return nameChanged(this);
    }
    return orElse();
  }
}

abstract class _NameChanged implements ProjectEvent {
  const factory _NameChanged(final String name) = _$NameChangedImpl;

  String get name;

  /// Create a copy of ProjectEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NameChangedImplCopyWith<_$NameChangedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ClientChangedImplCopyWith<$Res> {
  factory _$$ClientChangedImplCopyWith(
          _$ClientChangedImpl value, $Res Function(_$ClientChangedImpl) then) =
      __$$ClientChangedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Client client});
}

/// @nodoc
class __$$ClientChangedImplCopyWithImpl<$Res>
    extends _$ProjectEventCopyWithImpl<$Res, _$ClientChangedImpl>
    implements _$$ClientChangedImplCopyWith<$Res> {
  __$$ClientChangedImplCopyWithImpl(
      _$ClientChangedImpl _value, $Res Function(_$ClientChangedImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProjectEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? client = null,
  }) {
    return _then(_$ClientChangedImpl(
      null == client
          ? _value.client
          : client // ignore: cast_nullable_to_non_nullable
              as Client,
    ));
  }
}

/// @nodoc

class _$ClientChangedImpl implements _ClientChanged {
  const _$ClientChangedImpl(this.client);

  @override
  final Client client;

  @override
  String toString() {
    return 'ProjectEvent.clientChanged(client: $client)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClientChangedImpl &&
            (identical(other.client, client) || other.client == client));
  }

  @override
  int get hashCode => Object.hash(runtimeType, client);

  /// Create a copy of ProjectEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ClientChangedImplCopyWith<_$ClientChangedImpl> get copyWith =>
      __$$ClientChangedImplCopyWithImpl<_$ClientChangedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function() refreshed,
    required TResult Function(
            String? query, List<String>? tags, List<String>? statuses)
        filtered,
    required TResult Function(String projectId) deleteProject,
    required TResult Function(String name, String description, ProjectType type,
            Client? client, DateTime startDate, DateTime endDate)
        createProject,
    required TResult Function(String projectId, ProjectMember member)
        addTeamMember,
    required TResult Function(String projectId, String fileData) fileUploaded,
    required TResult Function(String projectId, String fileId) fileDeleted,
    required TResult Function(dynamic project) projectSelected,
    required TResult Function(Project? project) initialized,
    required TResult Function(String name) nameChanged,
    required TResult Function(Client client) clientChanged,
    required TResult Function(ProjectTemplate template) templateChanged,
    required TResult Function(DateTime date) startDateChanged,
    required TResult Function(DateTime date) endDateChanged,
    required TResult Function(String description) descriptionChanged,
    required TResult Function() saved,
  }) {
    return clientChanged(client);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function()? refreshed,
    TResult? Function(
            String? query, List<String>? tags, List<String>? statuses)?
        filtered,
    TResult? Function(String projectId)? deleteProject,
    TResult? Function(String name, String description, ProjectType type,
            Client? client, DateTime startDate, DateTime endDate)?
        createProject,
    TResult? Function(String projectId, ProjectMember member)? addTeamMember,
    TResult? Function(String projectId, String fileData)? fileUploaded,
    TResult? Function(String projectId, String fileId)? fileDeleted,
    TResult? Function(dynamic project)? projectSelected,
    TResult? Function(Project? project)? initialized,
    TResult? Function(String name)? nameChanged,
    TResult? Function(Client client)? clientChanged,
    TResult? Function(ProjectTemplate template)? templateChanged,
    TResult? Function(DateTime date)? startDateChanged,
    TResult? Function(DateTime date)? endDateChanged,
    TResult? Function(String description)? descriptionChanged,
    TResult? Function()? saved,
  }) {
    return clientChanged?.call(client);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function()? refreshed,
    TResult Function(String? query, List<String>? tags, List<String>? statuses)?
        filtered,
    TResult Function(String projectId)? deleteProject,
    TResult Function(String name, String description, ProjectType type,
            Client? client, DateTime startDate, DateTime endDate)?
        createProject,
    TResult Function(String projectId, ProjectMember member)? addTeamMember,
    TResult Function(String projectId, String fileData)? fileUploaded,
    TResult Function(String projectId, String fileId)? fileDeleted,
    TResult Function(dynamic project)? projectSelected,
    TResult Function(Project? project)? initialized,
    TResult Function(String name)? nameChanged,
    TResult Function(Client client)? clientChanged,
    TResult Function(ProjectTemplate template)? templateChanged,
    TResult Function(DateTime date)? startDateChanged,
    TResult Function(DateTime date)? endDateChanged,
    TResult Function(String description)? descriptionChanged,
    TResult Function()? saved,
    required TResult orElse(),
  }) {
    if (clientChanged != null) {
      return clientChanged(client);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_Refreshed value) refreshed,
    required TResult Function(Filtered value) filtered,
    required TResult Function(DeleteProject value) deleteProject,
    required TResult Function(CreateProject value) createProject,
    required TResult Function(AddTeamMember value) addTeamMember,
    required TResult Function(FileUploaded value) fileUploaded,
    required TResult Function(FileDeleted value) fileDeleted,
    required TResult Function(ProjectSelected value) projectSelected,
    required TResult Function(_Initialized value) initialized,
    required TResult Function(_NameChanged value) nameChanged,
    required TResult Function(_ClientChanged value) clientChanged,
    required TResult Function(_TemplateChanged value) templateChanged,
    required TResult Function(_StartDateChanged value) startDateChanged,
    required TResult Function(_EndDateChanged value) endDateChanged,
    required TResult Function(_DescriptionChanged value) descriptionChanged,
    required TResult Function(_Saved value) saved,
  }) {
    return clientChanged(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_Refreshed value)? refreshed,
    TResult? Function(Filtered value)? filtered,
    TResult? Function(DeleteProject value)? deleteProject,
    TResult? Function(CreateProject value)? createProject,
    TResult? Function(AddTeamMember value)? addTeamMember,
    TResult? Function(FileUploaded value)? fileUploaded,
    TResult? Function(FileDeleted value)? fileDeleted,
    TResult? Function(ProjectSelected value)? projectSelected,
    TResult? Function(_Initialized value)? initialized,
    TResult? Function(_NameChanged value)? nameChanged,
    TResult? Function(_ClientChanged value)? clientChanged,
    TResult? Function(_TemplateChanged value)? templateChanged,
    TResult? Function(_StartDateChanged value)? startDateChanged,
    TResult? Function(_EndDateChanged value)? endDateChanged,
    TResult? Function(_DescriptionChanged value)? descriptionChanged,
    TResult? Function(_Saved value)? saved,
  }) {
    return clientChanged?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_Refreshed value)? refreshed,
    TResult Function(Filtered value)? filtered,
    TResult Function(DeleteProject value)? deleteProject,
    TResult Function(CreateProject value)? createProject,
    TResult Function(AddTeamMember value)? addTeamMember,
    TResult Function(FileUploaded value)? fileUploaded,
    TResult Function(FileDeleted value)? fileDeleted,
    TResult Function(ProjectSelected value)? projectSelected,
    TResult Function(_Initialized value)? initialized,
    TResult Function(_NameChanged value)? nameChanged,
    TResult Function(_ClientChanged value)? clientChanged,
    TResult Function(_TemplateChanged value)? templateChanged,
    TResult Function(_StartDateChanged value)? startDateChanged,
    TResult Function(_EndDateChanged value)? endDateChanged,
    TResult Function(_DescriptionChanged value)? descriptionChanged,
    TResult Function(_Saved value)? saved,
    required TResult orElse(),
  }) {
    if (clientChanged != null) {
      return clientChanged(this);
    }
    return orElse();
  }
}

abstract class _ClientChanged implements ProjectEvent {
  const factory _ClientChanged(final Client client) = _$ClientChangedImpl;

  Client get client;

  /// Create a copy of ProjectEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ClientChangedImplCopyWith<_$ClientChangedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TemplateChangedImplCopyWith<$Res> {
  factory _$$TemplateChangedImplCopyWith(_$TemplateChangedImpl value,
          $Res Function(_$TemplateChangedImpl) then) =
      __$$TemplateChangedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({ProjectTemplate template});

  $ProjectTemplateCopyWith<$Res> get template;
}

/// @nodoc
class __$$TemplateChangedImplCopyWithImpl<$Res>
    extends _$ProjectEventCopyWithImpl<$Res, _$TemplateChangedImpl>
    implements _$$TemplateChangedImplCopyWith<$Res> {
  __$$TemplateChangedImplCopyWithImpl(
      _$TemplateChangedImpl _value, $Res Function(_$TemplateChangedImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProjectEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? template = null,
  }) {
    return _then(_$TemplateChangedImpl(
      null == template
          ? _value.template
          : template // ignore: cast_nullable_to_non_nullable
              as ProjectTemplate,
    ));
  }

  /// Create a copy of ProjectEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProjectTemplateCopyWith<$Res> get template {
    return $ProjectTemplateCopyWith<$Res>(_value.template, (value) {
      return _then(_value.copyWith(template: value));
    });
  }
}

/// @nodoc

class _$TemplateChangedImpl implements _TemplateChanged {
  const _$TemplateChangedImpl(this.template);

  @override
  final ProjectTemplate template;

  @override
  String toString() {
    return 'ProjectEvent.templateChanged(template: $template)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TemplateChangedImpl &&
            (identical(other.template, template) ||
                other.template == template));
  }

  @override
  int get hashCode => Object.hash(runtimeType, template);

  /// Create a copy of ProjectEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TemplateChangedImplCopyWith<_$TemplateChangedImpl> get copyWith =>
      __$$TemplateChangedImplCopyWithImpl<_$TemplateChangedImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function() refreshed,
    required TResult Function(
            String? query, List<String>? tags, List<String>? statuses)
        filtered,
    required TResult Function(String projectId) deleteProject,
    required TResult Function(String name, String description, ProjectType type,
            Client? client, DateTime startDate, DateTime endDate)
        createProject,
    required TResult Function(String projectId, ProjectMember member)
        addTeamMember,
    required TResult Function(String projectId, String fileData) fileUploaded,
    required TResult Function(String projectId, String fileId) fileDeleted,
    required TResult Function(dynamic project) projectSelected,
    required TResult Function(Project? project) initialized,
    required TResult Function(String name) nameChanged,
    required TResult Function(Client client) clientChanged,
    required TResult Function(ProjectTemplate template) templateChanged,
    required TResult Function(DateTime date) startDateChanged,
    required TResult Function(DateTime date) endDateChanged,
    required TResult Function(String description) descriptionChanged,
    required TResult Function() saved,
  }) {
    return templateChanged(template);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function()? refreshed,
    TResult? Function(
            String? query, List<String>? tags, List<String>? statuses)?
        filtered,
    TResult? Function(String projectId)? deleteProject,
    TResult? Function(String name, String description, ProjectType type,
            Client? client, DateTime startDate, DateTime endDate)?
        createProject,
    TResult? Function(String projectId, ProjectMember member)? addTeamMember,
    TResult? Function(String projectId, String fileData)? fileUploaded,
    TResult? Function(String projectId, String fileId)? fileDeleted,
    TResult? Function(dynamic project)? projectSelected,
    TResult? Function(Project? project)? initialized,
    TResult? Function(String name)? nameChanged,
    TResult? Function(Client client)? clientChanged,
    TResult? Function(ProjectTemplate template)? templateChanged,
    TResult? Function(DateTime date)? startDateChanged,
    TResult? Function(DateTime date)? endDateChanged,
    TResult? Function(String description)? descriptionChanged,
    TResult? Function()? saved,
  }) {
    return templateChanged?.call(template);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function()? refreshed,
    TResult Function(String? query, List<String>? tags, List<String>? statuses)?
        filtered,
    TResult Function(String projectId)? deleteProject,
    TResult Function(String name, String description, ProjectType type,
            Client? client, DateTime startDate, DateTime endDate)?
        createProject,
    TResult Function(String projectId, ProjectMember member)? addTeamMember,
    TResult Function(String projectId, String fileData)? fileUploaded,
    TResult Function(String projectId, String fileId)? fileDeleted,
    TResult Function(dynamic project)? projectSelected,
    TResult Function(Project? project)? initialized,
    TResult Function(String name)? nameChanged,
    TResult Function(Client client)? clientChanged,
    TResult Function(ProjectTemplate template)? templateChanged,
    TResult Function(DateTime date)? startDateChanged,
    TResult Function(DateTime date)? endDateChanged,
    TResult Function(String description)? descriptionChanged,
    TResult Function()? saved,
    required TResult orElse(),
  }) {
    if (templateChanged != null) {
      return templateChanged(template);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_Refreshed value) refreshed,
    required TResult Function(Filtered value) filtered,
    required TResult Function(DeleteProject value) deleteProject,
    required TResult Function(CreateProject value) createProject,
    required TResult Function(AddTeamMember value) addTeamMember,
    required TResult Function(FileUploaded value) fileUploaded,
    required TResult Function(FileDeleted value) fileDeleted,
    required TResult Function(ProjectSelected value) projectSelected,
    required TResult Function(_Initialized value) initialized,
    required TResult Function(_NameChanged value) nameChanged,
    required TResult Function(_ClientChanged value) clientChanged,
    required TResult Function(_TemplateChanged value) templateChanged,
    required TResult Function(_StartDateChanged value) startDateChanged,
    required TResult Function(_EndDateChanged value) endDateChanged,
    required TResult Function(_DescriptionChanged value) descriptionChanged,
    required TResult Function(_Saved value) saved,
  }) {
    return templateChanged(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_Refreshed value)? refreshed,
    TResult? Function(Filtered value)? filtered,
    TResult? Function(DeleteProject value)? deleteProject,
    TResult? Function(CreateProject value)? createProject,
    TResult? Function(AddTeamMember value)? addTeamMember,
    TResult? Function(FileUploaded value)? fileUploaded,
    TResult? Function(FileDeleted value)? fileDeleted,
    TResult? Function(ProjectSelected value)? projectSelected,
    TResult? Function(_Initialized value)? initialized,
    TResult? Function(_NameChanged value)? nameChanged,
    TResult? Function(_ClientChanged value)? clientChanged,
    TResult? Function(_TemplateChanged value)? templateChanged,
    TResult? Function(_StartDateChanged value)? startDateChanged,
    TResult? Function(_EndDateChanged value)? endDateChanged,
    TResult? Function(_DescriptionChanged value)? descriptionChanged,
    TResult? Function(_Saved value)? saved,
  }) {
    return templateChanged?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_Refreshed value)? refreshed,
    TResult Function(Filtered value)? filtered,
    TResult Function(DeleteProject value)? deleteProject,
    TResult Function(CreateProject value)? createProject,
    TResult Function(AddTeamMember value)? addTeamMember,
    TResult Function(FileUploaded value)? fileUploaded,
    TResult Function(FileDeleted value)? fileDeleted,
    TResult Function(ProjectSelected value)? projectSelected,
    TResult Function(_Initialized value)? initialized,
    TResult Function(_NameChanged value)? nameChanged,
    TResult Function(_ClientChanged value)? clientChanged,
    TResult Function(_TemplateChanged value)? templateChanged,
    TResult Function(_StartDateChanged value)? startDateChanged,
    TResult Function(_EndDateChanged value)? endDateChanged,
    TResult Function(_DescriptionChanged value)? descriptionChanged,
    TResult Function(_Saved value)? saved,
    required TResult orElse(),
  }) {
    if (templateChanged != null) {
      return templateChanged(this);
    }
    return orElse();
  }
}

abstract class _TemplateChanged implements ProjectEvent {
  const factory _TemplateChanged(final ProjectTemplate template) =
      _$TemplateChangedImpl;

  ProjectTemplate get template;

  /// Create a copy of ProjectEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TemplateChangedImplCopyWith<_$TemplateChangedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StartDateChangedImplCopyWith<$Res> {
  factory _$$StartDateChangedImplCopyWith(_$StartDateChangedImpl value,
          $Res Function(_$StartDateChangedImpl) then) =
      __$$StartDateChangedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({DateTime date});
}

/// @nodoc
class __$$StartDateChangedImplCopyWithImpl<$Res>
    extends _$ProjectEventCopyWithImpl<$Res, _$StartDateChangedImpl>
    implements _$$StartDateChangedImplCopyWith<$Res> {
  __$$StartDateChangedImplCopyWithImpl(_$StartDateChangedImpl _value,
      $Res Function(_$StartDateChangedImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProjectEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
  }) {
    return _then(_$StartDateChangedImpl(
      null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$StartDateChangedImpl implements _StartDateChanged {
  const _$StartDateChangedImpl(this.date);

  @override
  final DateTime date;

  @override
  String toString() {
    return 'ProjectEvent.startDateChanged(date: $date)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StartDateChangedImpl &&
            (identical(other.date, date) || other.date == date));
  }

  @override
  int get hashCode => Object.hash(runtimeType, date);

  /// Create a copy of ProjectEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StartDateChangedImplCopyWith<_$StartDateChangedImpl> get copyWith =>
      __$$StartDateChangedImplCopyWithImpl<_$StartDateChangedImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function() refreshed,
    required TResult Function(
            String? query, List<String>? tags, List<String>? statuses)
        filtered,
    required TResult Function(String projectId) deleteProject,
    required TResult Function(String name, String description, ProjectType type,
            Client? client, DateTime startDate, DateTime endDate)
        createProject,
    required TResult Function(String projectId, ProjectMember member)
        addTeamMember,
    required TResult Function(String projectId, String fileData) fileUploaded,
    required TResult Function(String projectId, String fileId) fileDeleted,
    required TResult Function(dynamic project) projectSelected,
    required TResult Function(Project? project) initialized,
    required TResult Function(String name) nameChanged,
    required TResult Function(Client client) clientChanged,
    required TResult Function(ProjectTemplate template) templateChanged,
    required TResult Function(DateTime date) startDateChanged,
    required TResult Function(DateTime date) endDateChanged,
    required TResult Function(String description) descriptionChanged,
    required TResult Function() saved,
  }) {
    return startDateChanged(date);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function()? refreshed,
    TResult? Function(
            String? query, List<String>? tags, List<String>? statuses)?
        filtered,
    TResult? Function(String projectId)? deleteProject,
    TResult? Function(String name, String description, ProjectType type,
            Client? client, DateTime startDate, DateTime endDate)?
        createProject,
    TResult? Function(String projectId, ProjectMember member)? addTeamMember,
    TResult? Function(String projectId, String fileData)? fileUploaded,
    TResult? Function(String projectId, String fileId)? fileDeleted,
    TResult? Function(dynamic project)? projectSelected,
    TResult? Function(Project? project)? initialized,
    TResult? Function(String name)? nameChanged,
    TResult? Function(Client client)? clientChanged,
    TResult? Function(ProjectTemplate template)? templateChanged,
    TResult? Function(DateTime date)? startDateChanged,
    TResult? Function(DateTime date)? endDateChanged,
    TResult? Function(String description)? descriptionChanged,
    TResult? Function()? saved,
  }) {
    return startDateChanged?.call(date);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function()? refreshed,
    TResult Function(String? query, List<String>? tags, List<String>? statuses)?
        filtered,
    TResult Function(String projectId)? deleteProject,
    TResult Function(String name, String description, ProjectType type,
            Client? client, DateTime startDate, DateTime endDate)?
        createProject,
    TResult Function(String projectId, ProjectMember member)? addTeamMember,
    TResult Function(String projectId, String fileData)? fileUploaded,
    TResult Function(String projectId, String fileId)? fileDeleted,
    TResult Function(dynamic project)? projectSelected,
    TResult Function(Project? project)? initialized,
    TResult Function(String name)? nameChanged,
    TResult Function(Client client)? clientChanged,
    TResult Function(ProjectTemplate template)? templateChanged,
    TResult Function(DateTime date)? startDateChanged,
    TResult Function(DateTime date)? endDateChanged,
    TResult Function(String description)? descriptionChanged,
    TResult Function()? saved,
    required TResult orElse(),
  }) {
    if (startDateChanged != null) {
      return startDateChanged(date);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_Refreshed value) refreshed,
    required TResult Function(Filtered value) filtered,
    required TResult Function(DeleteProject value) deleteProject,
    required TResult Function(CreateProject value) createProject,
    required TResult Function(AddTeamMember value) addTeamMember,
    required TResult Function(FileUploaded value) fileUploaded,
    required TResult Function(FileDeleted value) fileDeleted,
    required TResult Function(ProjectSelected value) projectSelected,
    required TResult Function(_Initialized value) initialized,
    required TResult Function(_NameChanged value) nameChanged,
    required TResult Function(_ClientChanged value) clientChanged,
    required TResult Function(_TemplateChanged value) templateChanged,
    required TResult Function(_StartDateChanged value) startDateChanged,
    required TResult Function(_EndDateChanged value) endDateChanged,
    required TResult Function(_DescriptionChanged value) descriptionChanged,
    required TResult Function(_Saved value) saved,
  }) {
    return startDateChanged(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_Refreshed value)? refreshed,
    TResult? Function(Filtered value)? filtered,
    TResult? Function(DeleteProject value)? deleteProject,
    TResult? Function(CreateProject value)? createProject,
    TResult? Function(AddTeamMember value)? addTeamMember,
    TResult? Function(FileUploaded value)? fileUploaded,
    TResult? Function(FileDeleted value)? fileDeleted,
    TResult? Function(ProjectSelected value)? projectSelected,
    TResult? Function(_Initialized value)? initialized,
    TResult? Function(_NameChanged value)? nameChanged,
    TResult? Function(_ClientChanged value)? clientChanged,
    TResult? Function(_TemplateChanged value)? templateChanged,
    TResult? Function(_StartDateChanged value)? startDateChanged,
    TResult? Function(_EndDateChanged value)? endDateChanged,
    TResult? Function(_DescriptionChanged value)? descriptionChanged,
    TResult? Function(_Saved value)? saved,
  }) {
    return startDateChanged?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_Refreshed value)? refreshed,
    TResult Function(Filtered value)? filtered,
    TResult Function(DeleteProject value)? deleteProject,
    TResult Function(CreateProject value)? createProject,
    TResult Function(AddTeamMember value)? addTeamMember,
    TResult Function(FileUploaded value)? fileUploaded,
    TResult Function(FileDeleted value)? fileDeleted,
    TResult Function(ProjectSelected value)? projectSelected,
    TResult Function(_Initialized value)? initialized,
    TResult Function(_NameChanged value)? nameChanged,
    TResult Function(_ClientChanged value)? clientChanged,
    TResult Function(_TemplateChanged value)? templateChanged,
    TResult Function(_StartDateChanged value)? startDateChanged,
    TResult Function(_EndDateChanged value)? endDateChanged,
    TResult Function(_DescriptionChanged value)? descriptionChanged,
    TResult Function(_Saved value)? saved,
    required TResult orElse(),
  }) {
    if (startDateChanged != null) {
      return startDateChanged(this);
    }
    return orElse();
  }
}

abstract class _StartDateChanged implements ProjectEvent {
  const factory _StartDateChanged(final DateTime date) = _$StartDateChangedImpl;

  DateTime get date;

  /// Create a copy of ProjectEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StartDateChangedImplCopyWith<_$StartDateChangedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$EndDateChangedImplCopyWith<$Res> {
  factory _$$EndDateChangedImplCopyWith(_$EndDateChangedImpl value,
          $Res Function(_$EndDateChangedImpl) then) =
      __$$EndDateChangedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({DateTime date});
}

/// @nodoc
class __$$EndDateChangedImplCopyWithImpl<$Res>
    extends _$ProjectEventCopyWithImpl<$Res, _$EndDateChangedImpl>
    implements _$$EndDateChangedImplCopyWith<$Res> {
  __$$EndDateChangedImplCopyWithImpl(
      _$EndDateChangedImpl _value, $Res Function(_$EndDateChangedImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProjectEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
  }) {
    return _then(_$EndDateChangedImpl(
      null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$EndDateChangedImpl implements _EndDateChanged {
  const _$EndDateChangedImpl(this.date);

  @override
  final DateTime date;

  @override
  String toString() {
    return 'ProjectEvent.endDateChanged(date: $date)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EndDateChangedImpl &&
            (identical(other.date, date) || other.date == date));
  }

  @override
  int get hashCode => Object.hash(runtimeType, date);

  /// Create a copy of ProjectEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EndDateChangedImplCopyWith<_$EndDateChangedImpl> get copyWith =>
      __$$EndDateChangedImplCopyWithImpl<_$EndDateChangedImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function() refreshed,
    required TResult Function(
            String? query, List<String>? tags, List<String>? statuses)
        filtered,
    required TResult Function(String projectId) deleteProject,
    required TResult Function(String name, String description, ProjectType type,
            Client? client, DateTime startDate, DateTime endDate)
        createProject,
    required TResult Function(String projectId, ProjectMember member)
        addTeamMember,
    required TResult Function(String projectId, String fileData) fileUploaded,
    required TResult Function(String projectId, String fileId) fileDeleted,
    required TResult Function(dynamic project) projectSelected,
    required TResult Function(Project? project) initialized,
    required TResult Function(String name) nameChanged,
    required TResult Function(Client client) clientChanged,
    required TResult Function(ProjectTemplate template) templateChanged,
    required TResult Function(DateTime date) startDateChanged,
    required TResult Function(DateTime date) endDateChanged,
    required TResult Function(String description) descriptionChanged,
    required TResult Function() saved,
  }) {
    return endDateChanged(date);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function()? refreshed,
    TResult? Function(
            String? query, List<String>? tags, List<String>? statuses)?
        filtered,
    TResult? Function(String projectId)? deleteProject,
    TResult? Function(String name, String description, ProjectType type,
            Client? client, DateTime startDate, DateTime endDate)?
        createProject,
    TResult? Function(String projectId, ProjectMember member)? addTeamMember,
    TResult? Function(String projectId, String fileData)? fileUploaded,
    TResult? Function(String projectId, String fileId)? fileDeleted,
    TResult? Function(dynamic project)? projectSelected,
    TResult? Function(Project? project)? initialized,
    TResult? Function(String name)? nameChanged,
    TResult? Function(Client client)? clientChanged,
    TResult? Function(ProjectTemplate template)? templateChanged,
    TResult? Function(DateTime date)? startDateChanged,
    TResult? Function(DateTime date)? endDateChanged,
    TResult? Function(String description)? descriptionChanged,
    TResult? Function()? saved,
  }) {
    return endDateChanged?.call(date);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function()? refreshed,
    TResult Function(String? query, List<String>? tags, List<String>? statuses)?
        filtered,
    TResult Function(String projectId)? deleteProject,
    TResult Function(String name, String description, ProjectType type,
            Client? client, DateTime startDate, DateTime endDate)?
        createProject,
    TResult Function(String projectId, ProjectMember member)? addTeamMember,
    TResult Function(String projectId, String fileData)? fileUploaded,
    TResult Function(String projectId, String fileId)? fileDeleted,
    TResult Function(dynamic project)? projectSelected,
    TResult Function(Project? project)? initialized,
    TResult Function(String name)? nameChanged,
    TResult Function(Client client)? clientChanged,
    TResult Function(ProjectTemplate template)? templateChanged,
    TResult Function(DateTime date)? startDateChanged,
    TResult Function(DateTime date)? endDateChanged,
    TResult Function(String description)? descriptionChanged,
    TResult Function()? saved,
    required TResult orElse(),
  }) {
    if (endDateChanged != null) {
      return endDateChanged(date);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_Refreshed value) refreshed,
    required TResult Function(Filtered value) filtered,
    required TResult Function(DeleteProject value) deleteProject,
    required TResult Function(CreateProject value) createProject,
    required TResult Function(AddTeamMember value) addTeamMember,
    required TResult Function(FileUploaded value) fileUploaded,
    required TResult Function(FileDeleted value) fileDeleted,
    required TResult Function(ProjectSelected value) projectSelected,
    required TResult Function(_Initialized value) initialized,
    required TResult Function(_NameChanged value) nameChanged,
    required TResult Function(_ClientChanged value) clientChanged,
    required TResult Function(_TemplateChanged value) templateChanged,
    required TResult Function(_StartDateChanged value) startDateChanged,
    required TResult Function(_EndDateChanged value) endDateChanged,
    required TResult Function(_DescriptionChanged value) descriptionChanged,
    required TResult Function(_Saved value) saved,
  }) {
    return endDateChanged(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_Refreshed value)? refreshed,
    TResult? Function(Filtered value)? filtered,
    TResult? Function(DeleteProject value)? deleteProject,
    TResult? Function(CreateProject value)? createProject,
    TResult? Function(AddTeamMember value)? addTeamMember,
    TResult? Function(FileUploaded value)? fileUploaded,
    TResult? Function(FileDeleted value)? fileDeleted,
    TResult? Function(ProjectSelected value)? projectSelected,
    TResult? Function(_Initialized value)? initialized,
    TResult? Function(_NameChanged value)? nameChanged,
    TResult? Function(_ClientChanged value)? clientChanged,
    TResult? Function(_TemplateChanged value)? templateChanged,
    TResult? Function(_StartDateChanged value)? startDateChanged,
    TResult? Function(_EndDateChanged value)? endDateChanged,
    TResult? Function(_DescriptionChanged value)? descriptionChanged,
    TResult? Function(_Saved value)? saved,
  }) {
    return endDateChanged?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_Refreshed value)? refreshed,
    TResult Function(Filtered value)? filtered,
    TResult Function(DeleteProject value)? deleteProject,
    TResult Function(CreateProject value)? createProject,
    TResult Function(AddTeamMember value)? addTeamMember,
    TResult Function(FileUploaded value)? fileUploaded,
    TResult Function(FileDeleted value)? fileDeleted,
    TResult Function(ProjectSelected value)? projectSelected,
    TResult Function(_Initialized value)? initialized,
    TResult Function(_NameChanged value)? nameChanged,
    TResult Function(_ClientChanged value)? clientChanged,
    TResult Function(_TemplateChanged value)? templateChanged,
    TResult Function(_StartDateChanged value)? startDateChanged,
    TResult Function(_EndDateChanged value)? endDateChanged,
    TResult Function(_DescriptionChanged value)? descriptionChanged,
    TResult Function(_Saved value)? saved,
    required TResult orElse(),
  }) {
    if (endDateChanged != null) {
      return endDateChanged(this);
    }
    return orElse();
  }
}

abstract class _EndDateChanged implements ProjectEvent {
  const factory _EndDateChanged(final DateTime date) = _$EndDateChangedImpl;

  DateTime get date;

  /// Create a copy of ProjectEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EndDateChangedImplCopyWith<_$EndDateChangedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DescriptionChangedImplCopyWith<$Res> {
  factory _$$DescriptionChangedImplCopyWith(_$DescriptionChangedImpl value,
          $Res Function(_$DescriptionChangedImpl) then) =
      __$$DescriptionChangedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String description});
}

/// @nodoc
class __$$DescriptionChangedImplCopyWithImpl<$Res>
    extends _$ProjectEventCopyWithImpl<$Res, _$DescriptionChangedImpl>
    implements _$$DescriptionChangedImplCopyWith<$Res> {
  __$$DescriptionChangedImplCopyWithImpl(_$DescriptionChangedImpl _value,
      $Res Function(_$DescriptionChangedImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProjectEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? description = null,
  }) {
    return _then(_$DescriptionChangedImpl(
      null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$DescriptionChangedImpl implements _DescriptionChanged {
  const _$DescriptionChangedImpl(this.description);

  @override
  final String description;

  @override
  String toString() {
    return 'ProjectEvent.descriptionChanged(description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DescriptionChangedImpl &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @override
  int get hashCode => Object.hash(runtimeType, description);

  /// Create a copy of ProjectEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DescriptionChangedImplCopyWith<_$DescriptionChangedImpl> get copyWith =>
      __$$DescriptionChangedImplCopyWithImpl<_$DescriptionChangedImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function() refreshed,
    required TResult Function(
            String? query, List<String>? tags, List<String>? statuses)
        filtered,
    required TResult Function(String projectId) deleteProject,
    required TResult Function(String name, String description, ProjectType type,
            Client? client, DateTime startDate, DateTime endDate)
        createProject,
    required TResult Function(String projectId, ProjectMember member)
        addTeamMember,
    required TResult Function(String projectId, String fileData) fileUploaded,
    required TResult Function(String projectId, String fileId) fileDeleted,
    required TResult Function(dynamic project) projectSelected,
    required TResult Function(Project? project) initialized,
    required TResult Function(String name) nameChanged,
    required TResult Function(Client client) clientChanged,
    required TResult Function(ProjectTemplate template) templateChanged,
    required TResult Function(DateTime date) startDateChanged,
    required TResult Function(DateTime date) endDateChanged,
    required TResult Function(String description) descriptionChanged,
    required TResult Function() saved,
  }) {
    return descriptionChanged(description);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function()? refreshed,
    TResult? Function(
            String? query, List<String>? tags, List<String>? statuses)?
        filtered,
    TResult? Function(String projectId)? deleteProject,
    TResult? Function(String name, String description, ProjectType type,
            Client? client, DateTime startDate, DateTime endDate)?
        createProject,
    TResult? Function(String projectId, ProjectMember member)? addTeamMember,
    TResult? Function(String projectId, String fileData)? fileUploaded,
    TResult? Function(String projectId, String fileId)? fileDeleted,
    TResult? Function(dynamic project)? projectSelected,
    TResult? Function(Project? project)? initialized,
    TResult? Function(String name)? nameChanged,
    TResult? Function(Client client)? clientChanged,
    TResult? Function(ProjectTemplate template)? templateChanged,
    TResult? Function(DateTime date)? startDateChanged,
    TResult? Function(DateTime date)? endDateChanged,
    TResult? Function(String description)? descriptionChanged,
    TResult? Function()? saved,
  }) {
    return descriptionChanged?.call(description);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function()? refreshed,
    TResult Function(String? query, List<String>? tags, List<String>? statuses)?
        filtered,
    TResult Function(String projectId)? deleteProject,
    TResult Function(String name, String description, ProjectType type,
            Client? client, DateTime startDate, DateTime endDate)?
        createProject,
    TResult Function(String projectId, ProjectMember member)? addTeamMember,
    TResult Function(String projectId, String fileData)? fileUploaded,
    TResult Function(String projectId, String fileId)? fileDeleted,
    TResult Function(dynamic project)? projectSelected,
    TResult Function(Project? project)? initialized,
    TResult Function(String name)? nameChanged,
    TResult Function(Client client)? clientChanged,
    TResult Function(ProjectTemplate template)? templateChanged,
    TResult Function(DateTime date)? startDateChanged,
    TResult Function(DateTime date)? endDateChanged,
    TResult Function(String description)? descriptionChanged,
    TResult Function()? saved,
    required TResult orElse(),
  }) {
    if (descriptionChanged != null) {
      return descriptionChanged(description);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_Refreshed value) refreshed,
    required TResult Function(Filtered value) filtered,
    required TResult Function(DeleteProject value) deleteProject,
    required TResult Function(CreateProject value) createProject,
    required TResult Function(AddTeamMember value) addTeamMember,
    required TResult Function(FileUploaded value) fileUploaded,
    required TResult Function(FileDeleted value) fileDeleted,
    required TResult Function(ProjectSelected value) projectSelected,
    required TResult Function(_Initialized value) initialized,
    required TResult Function(_NameChanged value) nameChanged,
    required TResult Function(_ClientChanged value) clientChanged,
    required TResult Function(_TemplateChanged value) templateChanged,
    required TResult Function(_StartDateChanged value) startDateChanged,
    required TResult Function(_EndDateChanged value) endDateChanged,
    required TResult Function(_DescriptionChanged value) descriptionChanged,
    required TResult Function(_Saved value) saved,
  }) {
    return descriptionChanged(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_Refreshed value)? refreshed,
    TResult? Function(Filtered value)? filtered,
    TResult? Function(DeleteProject value)? deleteProject,
    TResult? Function(CreateProject value)? createProject,
    TResult? Function(AddTeamMember value)? addTeamMember,
    TResult? Function(FileUploaded value)? fileUploaded,
    TResult? Function(FileDeleted value)? fileDeleted,
    TResult? Function(ProjectSelected value)? projectSelected,
    TResult? Function(_Initialized value)? initialized,
    TResult? Function(_NameChanged value)? nameChanged,
    TResult? Function(_ClientChanged value)? clientChanged,
    TResult? Function(_TemplateChanged value)? templateChanged,
    TResult? Function(_StartDateChanged value)? startDateChanged,
    TResult? Function(_EndDateChanged value)? endDateChanged,
    TResult? Function(_DescriptionChanged value)? descriptionChanged,
    TResult? Function(_Saved value)? saved,
  }) {
    return descriptionChanged?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_Refreshed value)? refreshed,
    TResult Function(Filtered value)? filtered,
    TResult Function(DeleteProject value)? deleteProject,
    TResult Function(CreateProject value)? createProject,
    TResult Function(AddTeamMember value)? addTeamMember,
    TResult Function(FileUploaded value)? fileUploaded,
    TResult Function(FileDeleted value)? fileDeleted,
    TResult Function(ProjectSelected value)? projectSelected,
    TResult Function(_Initialized value)? initialized,
    TResult Function(_NameChanged value)? nameChanged,
    TResult Function(_ClientChanged value)? clientChanged,
    TResult Function(_TemplateChanged value)? templateChanged,
    TResult Function(_StartDateChanged value)? startDateChanged,
    TResult Function(_EndDateChanged value)? endDateChanged,
    TResult Function(_DescriptionChanged value)? descriptionChanged,
    TResult Function(_Saved value)? saved,
    required TResult orElse(),
  }) {
    if (descriptionChanged != null) {
      return descriptionChanged(this);
    }
    return orElse();
  }
}

abstract class _DescriptionChanged implements ProjectEvent {
  const factory _DescriptionChanged(final String description) =
      _$DescriptionChangedImpl;

  String get description;

  /// Create a copy of ProjectEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DescriptionChangedImplCopyWith<_$DescriptionChangedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SavedImplCopyWith<$Res> {
  factory _$$SavedImplCopyWith(
          _$SavedImpl value, $Res Function(_$SavedImpl) then) =
      __$$SavedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SavedImplCopyWithImpl<$Res>
    extends _$ProjectEventCopyWithImpl<$Res, _$SavedImpl>
    implements _$$SavedImplCopyWith<$Res> {
  __$$SavedImplCopyWithImpl(
      _$SavedImpl _value, $Res Function(_$SavedImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProjectEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SavedImpl implements _Saved {
  const _$SavedImpl();

  @override
  String toString() {
    return 'ProjectEvent.saved()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SavedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function() refreshed,
    required TResult Function(
            String? query, List<String>? tags, List<String>? statuses)
        filtered,
    required TResult Function(String projectId) deleteProject,
    required TResult Function(String name, String description, ProjectType type,
            Client? client, DateTime startDate, DateTime endDate)
        createProject,
    required TResult Function(String projectId, ProjectMember member)
        addTeamMember,
    required TResult Function(String projectId, String fileData) fileUploaded,
    required TResult Function(String projectId, String fileId) fileDeleted,
    required TResult Function(dynamic project) projectSelected,
    required TResult Function(Project? project) initialized,
    required TResult Function(String name) nameChanged,
    required TResult Function(Client client) clientChanged,
    required TResult Function(ProjectTemplate template) templateChanged,
    required TResult Function(DateTime date) startDateChanged,
    required TResult Function(DateTime date) endDateChanged,
    required TResult Function(String description) descriptionChanged,
    required TResult Function() saved,
  }) {
    return saved();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function()? refreshed,
    TResult? Function(
            String? query, List<String>? tags, List<String>? statuses)?
        filtered,
    TResult? Function(String projectId)? deleteProject,
    TResult? Function(String name, String description, ProjectType type,
            Client? client, DateTime startDate, DateTime endDate)?
        createProject,
    TResult? Function(String projectId, ProjectMember member)? addTeamMember,
    TResult? Function(String projectId, String fileData)? fileUploaded,
    TResult? Function(String projectId, String fileId)? fileDeleted,
    TResult? Function(dynamic project)? projectSelected,
    TResult? Function(Project? project)? initialized,
    TResult? Function(String name)? nameChanged,
    TResult? Function(Client client)? clientChanged,
    TResult? Function(ProjectTemplate template)? templateChanged,
    TResult? Function(DateTime date)? startDateChanged,
    TResult? Function(DateTime date)? endDateChanged,
    TResult? Function(String description)? descriptionChanged,
    TResult? Function()? saved,
  }) {
    return saved?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function()? refreshed,
    TResult Function(String? query, List<String>? tags, List<String>? statuses)?
        filtered,
    TResult Function(String projectId)? deleteProject,
    TResult Function(String name, String description, ProjectType type,
            Client? client, DateTime startDate, DateTime endDate)?
        createProject,
    TResult Function(String projectId, ProjectMember member)? addTeamMember,
    TResult Function(String projectId, String fileData)? fileUploaded,
    TResult Function(String projectId, String fileId)? fileDeleted,
    TResult Function(dynamic project)? projectSelected,
    TResult Function(Project? project)? initialized,
    TResult Function(String name)? nameChanged,
    TResult Function(Client client)? clientChanged,
    TResult Function(ProjectTemplate template)? templateChanged,
    TResult Function(DateTime date)? startDateChanged,
    TResult Function(DateTime date)? endDateChanged,
    TResult Function(String description)? descriptionChanged,
    TResult Function()? saved,
    required TResult orElse(),
  }) {
    if (saved != null) {
      return saved();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_Refreshed value) refreshed,
    required TResult Function(Filtered value) filtered,
    required TResult Function(DeleteProject value) deleteProject,
    required TResult Function(CreateProject value) createProject,
    required TResult Function(AddTeamMember value) addTeamMember,
    required TResult Function(FileUploaded value) fileUploaded,
    required TResult Function(FileDeleted value) fileDeleted,
    required TResult Function(ProjectSelected value) projectSelected,
    required TResult Function(_Initialized value) initialized,
    required TResult Function(_NameChanged value) nameChanged,
    required TResult Function(_ClientChanged value) clientChanged,
    required TResult Function(_TemplateChanged value) templateChanged,
    required TResult Function(_StartDateChanged value) startDateChanged,
    required TResult Function(_EndDateChanged value) endDateChanged,
    required TResult Function(_DescriptionChanged value) descriptionChanged,
    required TResult Function(_Saved value) saved,
  }) {
    return saved(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_Refreshed value)? refreshed,
    TResult? Function(Filtered value)? filtered,
    TResult? Function(DeleteProject value)? deleteProject,
    TResult? Function(CreateProject value)? createProject,
    TResult? Function(AddTeamMember value)? addTeamMember,
    TResult? Function(FileUploaded value)? fileUploaded,
    TResult? Function(FileDeleted value)? fileDeleted,
    TResult? Function(ProjectSelected value)? projectSelected,
    TResult? Function(_Initialized value)? initialized,
    TResult? Function(_NameChanged value)? nameChanged,
    TResult? Function(_ClientChanged value)? clientChanged,
    TResult? Function(_TemplateChanged value)? templateChanged,
    TResult? Function(_StartDateChanged value)? startDateChanged,
    TResult? Function(_EndDateChanged value)? endDateChanged,
    TResult? Function(_DescriptionChanged value)? descriptionChanged,
    TResult? Function(_Saved value)? saved,
  }) {
    return saved?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_Refreshed value)? refreshed,
    TResult Function(Filtered value)? filtered,
    TResult Function(DeleteProject value)? deleteProject,
    TResult Function(CreateProject value)? createProject,
    TResult Function(AddTeamMember value)? addTeamMember,
    TResult Function(FileUploaded value)? fileUploaded,
    TResult Function(FileDeleted value)? fileDeleted,
    TResult Function(ProjectSelected value)? projectSelected,
    TResult Function(_Initialized value)? initialized,
    TResult Function(_NameChanged value)? nameChanged,
    TResult Function(_ClientChanged value)? clientChanged,
    TResult Function(_TemplateChanged value)? templateChanged,
    TResult Function(_StartDateChanged value)? startDateChanged,
    TResult Function(_EndDateChanged value)? endDateChanged,
    TResult Function(_DescriptionChanged value)? descriptionChanged,
    TResult Function(_Saved value)? saved,
    required TResult orElse(),
  }) {
    if (saved != null) {
      return saved(this);
    }
    return orElse();
  }
}

abstract class _Saved implements ProjectEvent {
  const factory _Saved() = _$SavedImpl;
}
