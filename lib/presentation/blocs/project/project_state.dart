import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:neetiflow/domain/entities/client.dart';
import 'package:neetiflow/domain/entities/operations/project.dart';
import 'package:neetiflow/domain/entities/operations/project_failure.dart';
import 'package:neetiflow/domain/entities/operations/project_template.dart';

part 'project_state.freezed.dart';

@freezed
abstract class ProjectState with _$ProjectState {
  const factory ProjectState.initial() = _Initial;
  const factory ProjectState.loading() = _Loading;
  const factory ProjectState.loaded({
    required List<Project> projects,
    required List<ProjectTemplate> templates,
    required List<Client> clients,
    Project? currentProject,
  }) = _Loaded;
  const factory ProjectState.error(String message) = _Error;
  const factory ProjectState.deleted() = _Deleted;
  const factory ProjectState.form({
    required String name,
    required Client? client,
    required ProjectTemplate? template,
    required DateTime? startDate,
    required DateTime? expectedEndDate,
    required String? description,
    required bool showErrorMessages,
    required bool isSaving,
    required Option<Either<ProjectFailure, Unit>> saveFailureOrSuccessOption,
  }) = _Form;
}

extension ProjectStateX on ProjectState {
  ProjectState toForm() => ProjectState.form(
        name: '',
        client: null,
        template: null,
        startDate: null,
        expectedEndDate: null,
        description: null,
        showErrorMessages: false,
        isSaving: false,
        saveFailureOrSuccessOption: none(),
      );
}
