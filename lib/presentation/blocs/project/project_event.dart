import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:neetiflow/domain/entities/operations/project.dart';

import '../../../domain/entities/client.dart';
import '../../../domain/entities/operations/project_template.dart';
import 'package:neetiflow/domain/entities/operations/project.dart';

part 'project_event.freezed.dart';

@freezed
abstract class ProjectEvent with _$ProjectEvent {
  const factory ProjectEvent.started() = _Started;
  const factory ProjectEvent.refreshed() = _Refreshed;
  const factory ProjectEvent.filtered({
    String? query,
    List<String>? tags,
    List<String>? statuses,
  }) = Filtered;
  const factory ProjectEvent.deleteProject(String projectId) = DeleteProject;
  const factory ProjectEvent.createProject({
    required String name,
    required String description,
    required ProjectType type,
    required Client client,
    required DateTime startDate,
    required DateTime endDate,
  }) = CreateProject;
  const factory ProjectEvent.addTeamMember({
    required String projectId,
    required ProjectMember member,
  }) = AddTeamMember;
  const factory ProjectEvent.fileUploaded({
    required String projectId,
    required String fileData,
  }) = FileUploaded;
  const factory ProjectEvent.fileDeleted({
    required String projectId,
    required String fileId,
  }) = FileDeleted;
  const factory ProjectEvent.projectSelected(dynamic project) = ProjectSelected;
  
  // Form Events
  const factory ProjectEvent.initialized(Project? project) = _Initialized;
  const factory ProjectEvent.nameChanged(String name) = _NameChanged;
  const factory ProjectEvent.clientChanged(Client client) = _ClientChanged;
  const factory ProjectEvent.templateChanged(ProjectTemplate template) = _TemplateChanged;
  const factory ProjectEvent.startDateChanged(DateTime date) = _StartDateChanged;
  const factory ProjectEvent.endDateChanged(DateTime date) = _EndDateChanged;
  const factory ProjectEvent.descriptionChanged(String description) = _DescriptionChanged;
  const factory ProjectEvent.saved() = _Saved;
}
