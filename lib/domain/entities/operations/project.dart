import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:neetiflow/domain/entities/operations/phase.dart';
import 'package:neetiflow/domain/entities/operations/project_template.dart';
import 'package:neetiflow/domain/entities/operations/workflow_template.dart';
import 'package:neetiflow/domain/entities/operations/task.dart';
import 'package:neetiflow/domain/entities/operations/milestone.dart';
import 'package:uuid/uuid.dart';

part 'project.freezed.dart';
part 'project.g.dart';

enum ProjectStatus {
  planning,
  active,
  inProgress,
  onHold,
  completed,
  cancelled
}

enum ProjectAccess {
  view,
  edit,
  admin
}

@freezed
class ProjectMember with _$ProjectMember {
  const factory ProjectMember({
    required String employeeId,
    required String employeeName,
    required String role,
    required ProjectAccess access,
    required DateTime joinedAt,
    String? department,
  }) = _ProjectMember;

  factory ProjectMember.fromJson(Map<String, dynamic> json) =>
      _$ProjectMemberFromJson(json);
}

@freezed
class Project with _$Project {
  const Project._();

  const factory Project({
    required String id,
    required String name,
    required String clientId,
    required ProjectType type,
    required ProjectStatus status,
    required List<Phase> phases,
    required List<Milestone> milestones,
    required List<ProjectMember> members,
    required List<WorkflowTemplate> workflows,
    required String organizationId,
    @Default(0.0) double value,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? expectedEndDate,
    DateTime? completedAt,
    String? templateId,
    String? createdBy,
    @Default({}) Map<String, dynamic> metadata,
    @Default({}) Map<String, dynamic> typeSpecificFields,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Project;

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);

  factory Project.fromTemplate({
    required ProjectTemplate template,
    required List<ProjectMember> members,
    required String name,
    required String clientId,
    required String createdBy,
    double? value,
    String? description,
    Map<String, dynamic>? typeSpecificFields,
  }) {
    final now = DateTime.now();
    final expectedEndDate = now.add(template.estimatedDuration);
    
    return Project(
      id: const Uuid().v4(),
      name: name,
      description: description ?? template.description ?? '',
      type: template.type,
      templateId: template.id,
      clientId: clientId,
      status: ProjectStatus.planning,
      phases: template.phases.map((phase) => Phase(
        id: phase.id,
        name: phase.name,
        description: phase.description,
        startDate: phase.startDate ?? now,
        endDate: phase.endDate ?? now.add(phase.defaultDuration ?? const Duration(days: 7)),
        taskIds: [],
        isCompleted: false,
        order: 0,
        estimatedDuration: phase.estimatedDuration ?? const Duration(days: 7),
        createdAt: now,
        updatedAt: now,
        defaultTasks: phase.defaultTasks.map((taskData) => Task(
          id: const Uuid().v4(),
          name: taskData['name'] as String? ?? '',
          description: taskData['description'] as String? ?? '',
          status: TaskStatus.todo,
          assigneeId: '',
          dueDate: now.add(const Duration(days: 7)),
          priority: Priority.low,
          labels: const [],
          createdAt: now,
          updatedAt: now,
          metadata: const {},
        )).toList(),
      )).toList(),
      milestones: template.defaultMilestones,
      members: members,
      startDate: now,
      endDate: expectedEndDate,
      createdBy: createdBy,
      createdAt: now,
      updatedAt: now,
      typeSpecificFields: typeSpecificFields ?? {},
      workflows: template.workflows,
      organizationId: template.organizationId,
      value: value ?? 0.0,
    );
  }
}
