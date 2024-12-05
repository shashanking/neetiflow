part of 'project_template_bloc.dart';

@freezed
class ProjectTemplateEvent with _$ProjectTemplateEvent {
  const factory ProjectTemplateEvent.started() = _Started;
  const factory ProjectTemplateEvent.created(ProjectTemplate template) = _Created;
  const factory ProjectTemplateEvent.updated(ProjectTemplate template) = _Updated;
  const factory ProjectTemplateEvent.deleted(String id) = _Deleted;
  const factory ProjectTemplateEvent.cloned(ProjectTemplate template) = _Cloned;
  const factory ProjectTemplateEvent.templatesReceived(List<ProjectTemplate> templates) = _TemplatesReceived;
}
