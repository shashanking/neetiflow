part of 'project_template_bloc.dart';

@freezed
class ProjectTemplateState with _$ProjectTemplateState {
  const factory ProjectTemplateState.initial() = _Initial;
  const factory ProjectTemplateState.loading() = _Loading;
  const factory ProjectTemplateState.loaded(List<ProjectTemplate> templates) = _Loaded;
  const factory ProjectTemplateState.error(String message) = _Error;
}
