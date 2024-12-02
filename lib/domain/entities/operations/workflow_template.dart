import 'package:freezed_annotation/freezed_annotation.dart';

part 'workflow_template.freezed.dart';
part 'workflow_template.g.dart';

@freezed
class WorkflowState with _$WorkflowState {
  const WorkflowState._();

  const factory WorkflowState({
    required String id,
    required String name,
    @Default('#808080') String color,
    @Default('') String description,
    @Default(false) bool isInitial,
    @Default(false) bool isFinal,
    @Default({}) Map<String, dynamic> metadata,
  }) = _WorkflowState;

  factory WorkflowState.fromJson(Map<String, dynamic> json) =>
      _$WorkflowStateFromJson(json);
}

@freezed
class WorkflowTransition with _$WorkflowTransition {
  const factory WorkflowTransition({
    required String id,
    required String name,
    required String fromStateId,
    required String toStateId,
    @Default({}) Map<String, dynamic> metadata,
  }) = _WorkflowTransition;

  factory WorkflowTransition.fromJson(Map<String, dynamic> json) =>
      _$WorkflowTransitionFromJson(json);
}

@freezed
class WorkflowTemplate with _$WorkflowTemplate {
  const WorkflowTemplate._();

  const factory WorkflowTemplate({
    required String id,
    required String name,
    String? description,
    required List<WorkflowState> states,
    required List<WorkflowTransition> transitions,
    @Default({}) Map<String, dynamic> metadata,
  }) = _WorkflowTemplate;

  factory WorkflowTemplate.fromJson(Map<String, dynamic> json) =>
      _$WorkflowTemplateFromJson(json);
}
