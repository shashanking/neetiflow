import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:neetiflow/domain/entities/operations/workflow_template.dart';
import 'package:neetiflow/domain/entities/operations/milestone.dart';

part 'project_template.freezed.dart';
part 'project_template.g.dart';

@freezed
class TemplateField with _$TemplateField {
  const factory TemplateField({
    required String id,
    required String name,
    required String type,
    @Default('') String description,
    @Default(false) bool isRequired,
    @Default([]) List<String> options,
    @Default({}) Map<String, dynamic> metadata,
    @Default('') String value,
  }) = _TemplateField;

  factory TemplateField.fromJson(Map<String, dynamic> json) =>
      _$TemplateFieldFromJson(json);
}

@freezed
class TemplatePhase with _$TemplatePhase {
  const factory TemplatePhase({
    required String id,
    required String name,
    @Default('') String description,
    Duration? defaultDuration,
    @Default([]) List<TemplateField> fields,
    @Default({}) Map<String, dynamic> metadata,
    DateTime? startDate,
    DateTime? endDate,
    @Default([]) List<String> taskIds,
    @Default(false) bool isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
    @Default(0) int order,
    Duration? estimatedDuration,
    @Default([]) List<Map<String, dynamic>> defaultTasks,
  }) = _TemplatePhase;

  factory TemplatePhase.fromJson(Map<String, dynamic> json) =>
      _$TemplatePhaseFromJson(json);
}

enum ProjectType {
  custom,
  socialMedia,
  software,
  ecommerce,
  appDevelopment,
  uiuxDesign,
  webDevelopment,
  marketing,
  event,
  research,
  construction,
  education,
  other
}

enum Complexity {
  low,
  medium,
  high,
  complex
}

@freezed
class TemplateMilestone with _$TemplateMilestone {
  const factory TemplateMilestone({
    required String id,
    required String name,
    @Default('') String description,
    DateTime? dueDate,
    @Default(false) bool isCompleted,
    @Default([]) List<String> tasks,
  }) = _TemplateMilestone;

  factory TemplateMilestone.fromJson(Map<String, dynamic> json) =>
      _$TemplateMilestoneFromJson(json);
}

@freezed
class ProjectTemplateConfig with _$ProjectTemplateConfig {
  const ProjectTemplateConfig._();

  const factory ProjectTemplateConfig({
    required String id,
    required ProjectType type,
    required List<TemplatePhase> defaultPhases,
    @Default([]) List<TemplateField> customFields,
    @Default({}) Map<String, List<String>> requiredRoles,
    @Default({}) Map<String, List<String>> deliverableTypes,
    @Default([]) List<String> defaultTags,
    required WorkflowTemplate defaultWorkflow,
    @Default([]) List<TemplateMilestone> defaultMilestones,
    @Default({}) Map<String, dynamic> typeSpecificSettings,
  }) = _ProjectTemplateConfig;

  factory ProjectTemplateConfig.empty() => ProjectTemplateConfig(
        id: 'default',
        type: ProjectType.custom,
        defaultPhases: const [],
        defaultWorkflow: WorkflowTemplate.fromJson({
          'id': 'default',
          'name': 'Default Workflow',
          'states': [
            {
              'id': 'todo',
              'name': 'To Do',
              'color': '#808080',
              'isInitial': true,
              'isFinal': false,
            },
            {
              'id': 'done',
              'name': 'Done',
              'color': '#00FF00',
              'isInitial': false,
              'isFinal': true,
            },
          ],
          'transitions': [
            {
              'id': 'complete',
              'name': 'Complete',
              'fromStateId': 'todo',
              'toStateId': 'done',
            },
          ],
        }),
      );

  factory ProjectTemplateConfig.socialMedia() => ProjectTemplateConfig(
        id: 'social_media',
        type: ProjectType.socialMedia,
        defaultPhases: [
          const TemplatePhase(
            id: 'research',
            name: 'Research & Planning',
            description: 'Market research and content strategy planning',
            defaultDuration: Duration(days: 7),
            fields: [
              TemplateField(
                id: 'target_audience',
                name: 'Target Audience',
                type: 'text',
                isRequired: true,
                description: 'Define the target audience for this campaign',
              ),
              TemplateField(
                id: 'platforms',
                name: 'Social Media Platforms',
                type: 'multiselect',
                isRequired: true,
                options: ['Instagram', 'Facebook', 'Twitter', 'LinkedIn'],
              ),
            ],
          ),
        ],
        defaultWorkflow: WorkflowTemplate.fromJson({
          'id': 'default_workflow',
          'name': 'Default Workflow',
          'states': [],
          'transitions': [],
        }),
        defaultMilestones: [
          TemplateMilestone(
            id: 'initial_research',
            name: 'Initial Research',
            description: 'Conduct initial market and audience research',
            dueDate: DateTime.now().add(const Duration(days: 7)),
            isCompleted: false,
            tasks: [],
          ),
        ],
      );

  factory ProjectTemplateConfig.fromJson(Map<String, dynamic> json) {
    // Determine the project type, defaulting to custom
    final typeString = json['type'] is String 
      ? json['type'] as String 
      : 'custom';
    final type = ProjectType.values.firstWhere(
      (e) => e.toString().split('.').last == typeString, 
      orElse: () => ProjectType.custom,
    );

    // Handle default workflow
    final defaultWorkflow = json['defaultWorkflow'] is Map<String, dynamic>
      ? WorkflowTemplate.fromJson(json['defaultWorkflow'] as Map<String, dynamic>)
      : WorkflowTemplate(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: 'Default Workflow',
          states: [
            WorkflowState(
              id: 'todo', 
              name: 'To Do', 
              isInitial: true, 
              isFinal: false,
              color: '#808080',
            ),
            WorkflowState(
              id: 'in_progress', 
              name: 'In Progress', 
              isInitial: false, 
              isFinal: false,
              color: '#0088cc',
            ),
            WorkflowState(
              id: 'done', 
              name: 'Done', 
              isInitial: false, 
              isFinal: true,
              color: '#00cc00',
            ),
          ],
          transitions: [
            WorkflowTransition(
              id: 'start', 
              name: 'Start', 
              fromStateId: 'todo', 
              toStateId: 'in_progress',
            ),
            WorkflowTransition(
              id: 'complete', 
              name: 'Complete', 
              fromStateId: 'in_progress', 
              toStateId: 'done',
            ),
          ],
        );

    // Handle default phases
    final defaultPhases = (json['defaultPhases'] as List?)?.map((phaseJson) {
      try {
        return TemplatePhase.fromJson(phaseJson as Map<String, dynamic>);
      } catch (e) {
        // If parsing fails, create a default phase
        return TemplatePhase(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: 'Default Phase',
          defaultDuration: const Duration(days: 7),
        );
      }
    }).toList() ?? [
      TemplatePhase(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: 'Default Phase',
        defaultDuration: const Duration(days: 7),
      )
    ];

    // Handle default milestones
    final defaultMilestones = (json['defaultMilestones'] as List?)?.map((milestoneJson) {
      try {
        return TemplateMilestone.fromJson(milestoneJson as Map<String, dynamic>);
      } catch (e) {
        // If parsing fails, create a default milestone
        return TemplateMilestone(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: 'Default Milestone',
          description: 'Default milestone description',
          dueDate: DateTime.now().add(const Duration(days: 30)),
          isCompleted: false,
        );
      }
    }).toList() ?? [];

    return ProjectTemplateConfig(
      id: json['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
      type: type,
      defaultWorkflow: defaultWorkflow,
      defaultPhases: defaultPhases,
      defaultMilestones: defaultMilestones,
      customFields: (json['customFields'] as List?)?.map((e) => 
        TemplateField.fromJson(e as Map<String, dynamic>)
      ).toList() ?? [],
      requiredRoles: (json['requiredRoles'] as Map?)?.cast<String, List<String>>() ?? {},
      deliverableTypes: (json['deliverableTypes'] as Map?)?.cast<String, List<String>>() ?? {},
      defaultTags: (json['defaultTags'] as List?)?.map((e) => e.toString()).toList() ?? [],
      typeSpecificSettings: (json['typeSpecificSettings'] as Map?)?.cast<String, dynamic>() ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString().split('.').last,
      'defaultPhases': defaultPhases.map((e) => e.toJson()).toList(),
      'customFields': customFields.map((e) => e.toJson()).toList(),
      'requiredRoles': requiredRoles,
      'deliverableTypes': deliverableTypes,
      'defaultTags': defaultTags,
      'defaultWorkflow': defaultWorkflow.toJson(),
      'defaultMilestones': defaultMilestones.map((e) => e.toJson()).toList(),
      'typeSpecificSettings': typeSpecificSettings,
    };
  }
}

@freezed
class ProjectTemplate with _$ProjectTemplate {
  const ProjectTemplate._();

  const factory ProjectTemplate({
    required String id,
    required String name,
    String? description,
    @Default([]) List<String> tags,
    @Default(false) bool isPublic,
    @Default(false) bool isArchived,
    @Default(false) bool isDerived,
    @Default('') String organizationId,
    @Default('') String createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    required ProjectTemplateConfig config,
    @Default(1) int version,
    String? parentTemplateId,
    @Default({}) Map<String, dynamic> typeSpecificFields,
  }) = _ProjectTemplate;

  ProjectType get type => config.type;
  List<Milestone> get defaultMilestones => config.defaultMilestones
      .map((milestone) => Milestone(
            id: milestone.id,
            name: milestone.name,
            description: milestone.description,
            dueDate: milestone.dueDate ?? DateTime.now(),
            completed: milestone.isCompleted,
            order: 0,
          ))
      .toList();
  List<WorkflowTemplate> get workflows => [config.defaultWorkflow];
  List<TemplatePhase> get phases => config.defaultPhases;
  String get organizationId => config.defaultWorkflow.metadata['organizationId'] ?? '';

  Duration get estimatedDuration {
    if (config.defaultPhases.isEmpty) {
      return const Duration(days: 30); // Default duration if no phases
    }
    return config.defaultPhases.fold(
      Duration.zero,
      (total, phase) => total + (phase.defaultDuration ?? const Duration(days: 7)),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'tags': tags,
      'isPublic': isPublic,
      'isArchived': isArchived,
      'isDerived': isDerived,
      'organizationId': organizationId,
      'createdBy': createdBy,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'config': config.toJson(), // Ensure config is converted to a map
      'version': version,
      'parentTemplateId': parentTemplateId,
      'typeSpecificFields': typeSpecificFields,
    };
  }

  factory ProjectTemplate.fromJson(Map<String, dynamic> json) {
    // Ensure config is a map
    final configMap = json['config'] is Map<String, dynamic> 
      ? json['config'] as Map<String, dynamic>
      : <String, dynamic>{};

    // Determine the project type, defaulting to custom
    final typeString = configMap['type'] is String 
      ? configMap['type'] as String 
      : 'custom';
    final type = ProjectType.values.firstWhere(
      (e) => e.toString().split('.').last == typeString, 
      orElse: () => ProjectType.custom,
    );

    // Handle default workflow
    final defaultWorkflow = configMap['defaultWorkflow'] is Map<String, dynamic>
      ? WorkflowTemplate.fromJson(configMap['defaultWorkflow'] as Map<String, dynamic>)
      : WorkflowTemplate(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: 'Default Workflow',
          states: [
            WorkflowState(
              id: 'todo', 
              name: 'To Do', 
              isInitial: true, 
              isFinal: false,
              color: '#808080',
            ),
            WorkflowState(
              id: 'in_progress', 
              name: 'In Progress', 
              isInitial: false, 
              isFinal: false,
              color: '#0088cc',
            ),
            WorkflowState(
              id: 'done', 
              name: 'Done', 
              isInitial: false, 
              isFinal: true,
              color: '#00cc00',
            ),
          ],
          transitions: [
            WorkflowTransition(
              id: 'start', 
              name: 'Start', 
              fromStateId: 'todo', 
              toStateId: 'in_progress',
            ),
            WorkflowTransition(
              id: 'complete', 
              name: 'Complete', 
              fromStateId: 'in_progress', 
              toStateId: 'done',
            ),
          ],
        );

    // Handle default phases
    final defaultPhases = (configMap['defaultPhases'] as List?)?.map((phaseJson) {
      try {
        return TemplatePhase.fromJson(phaseJson as Map<String, dynamic>);
      } catch (e) {
        // If parsing fails, create a default phase
        return TemplatePhase(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: 'Default Phase',
          defaultDuration: const Duration(days: 7),
        );
      }
    }).toList() ?? [
      TemplatePhase(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: 'Default Phase',
        defaultDuration: const Duration(days: 7),
      )
    ];

    // Handle default milestones
    final defaultMilestones = (configMap['defaultMilestones'] as List?)?.map((milestoneJson) {
      try {
        return TemplateMilestone.fromJson(milestoneJson as Map<String, dynamic>);
      } catch (e) {
        // If parsing fails, create a default milestone
        return TemplateMilestone(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: 'Default Milestone',
          description: 'Default milestone description',
          dueDate: DateTime.now().add(const Duration(days: 30)),
          isCompleted: false,
        );
      }
    }).toList() ?? [];

    final config = ProjectTemplateConfig(
      id: configMap['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
      type: type,
      defaultWorkflow: defaultWorkflow,
      defaultPhases: defaultPhases,
      defaultMilestones: defaultMilestones,
      customFields: (configMap['customFields'] as List?)?.map((e) => 
        TemplateField.fromJson(e as Map<String, dynamic>)
      ).toList() ?? [],
      requiredRoles: (configMap['requiredRoles'] as Map?)?.cast<String, List<String>>() ?? {},
      deliverableTypes: (configMap['deliverableTypes'] as Map?)?.cast<String, List<String>>() ?? {},
      defaultTags: (configMap['defaultTags'] as List?)?.map((e) => e.toString()).toList() ?? [],
      typeSpecificSettings: (configMap['typeSpecificSettings'] as Map?)?.cast<String, dynamic>() ?? {},
    );

    return ProjectTemplate(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Unnamed Template',
      description: json['description'] as String?,
      tags: (json['tags'] as List?)?.map((e) => e.toString()).toList() ?? [],
      isPublic: json['isPublic'] as bool? ?? false,
      isArchived: json['isArchived'] as bool? ?? false,
      isDerived: json['isDerived'] as bool? ?? false,
      organizationId: json['organizationId'] as String? ?? '',
      createdBy: json['createdBy'] as String? ?? '',
      createdAt: json['createdAt'] is String 
        ? DateTime.tryParse(json['createdAt'] as String) 
        : null,
      updatedAt: json['updatedAt'] is String 
        ? DateTime.tryParse(json['updatedAt'] as String) 
        : null,
      config: config,
      version: json['version'] as int? ?? 1,
      parentTemplateId: json['parentTemplateId'] as String?,
      typeSpecificFields: (json['typeSpecificFields'] as Map?)?.cast<String, dynamic>() ?? {},
    );
  }
}
