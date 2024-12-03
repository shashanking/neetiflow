import 'package:neetiflow/domain/entities/operations/milestone.dart';
import 'package:neetiflow/domain/entities/operations/project_template.dart';
import 'package:neetiflow/domain/repositories/operations/project_template_repository.dart';

import '../../entities/operations/workflow_template.dart';

class ProjectTemplateService {
  final ProjectTemplateRepository _repository;

  ProjectTemplateService(this._repository);

  Future<ProjectTemplate> createSocialMediaTemplate({
    required String name,
    String? description,
    List<TemplatePhase>? phases,
    List<Milestone>? defaultMilestones,
    Map<String, dynamic>? typeSpecificFields,
    List<WorkflowTemplate>? workflows,
    List<String>? requiredRoles,
    Duration? estimatedDuration,
    String? organizationId,
  }) async {
    // Define workflow states
    final states = [
      const WorkflowState(
        id: 'planning',
        name: 'Planning',
        color: '#FFA500', // Orange
        description: 'Initial project planning phase',
        isInitial: true,
        isFinal: false,
      ),
      const WorkflowState(
        id: 'content_creation',
        name: 'Content Creation',
        color: '#4CAF50', // Green
        description: 'Creating social media content',
        isInitial: false,
        isFinal: false,
      ),
      const WorkflowState(
        id: 'scheduling',
        name: 'Scheduling',
        color: '#2196F3', // Blue
        description: 'Scheduling social media posts',
        isInitial: false,
        isFinal: false,
      ),
      const WorkflowState(
        id: 'publishing',
        name: 'Publishing',
        color: '#9C27B0', // Purple
        description: 'Publishing social media content',
        isInitial: false,
        isFinal: false,
      ),
      const WorkflowState(
        id: 'completed',
        name: 'Completed',
        color: '#00BCD4', // Cyan
        description: 'Project completed',
        isInitial: false,
        isFinal: true,
      ),
    ];

    // Define workflow transitions
    final transitions = [
      const WorkflowTransition(
        id: 'start_to_content_creation',
        name: 'Start Content Creation',
        fromStateId: 'planning',
        toStateId: 'content_creation',
      ),
      const WorkflowTransition(
        id: 'content_to_scheduling',
        name: 'Move to Scheduling',
        fromStateId: 'content_creation',
        toStateId: 'scheduling',
      ),
      const WorkflowTransition(
        id: 'scheduling_to_publishing',
        name: 'Move to Publishing',
        fromStateId: 'scheduling',
        toStateId: 'publishing',
      ),
      const WorkflowTransition(
        id: 'publishing_to_completed',
        name: 'Complete Project',
        fromStateId: 'publishing',
        toStateId: 'completed',
      ),
    ];

    // Create default workflow
    final defaultWorkflow = workflows?.first ??
        WorkflowTemplate(
          id: 'social_media_default',
          name: 'Social Media Project Workflow',
          description: 'Standard workflow for social media project management',
          states: states,
          transitions: transitions,
        );

    final baseConfig = ProjectTemplateConfig.socialMedia();
    final config = baseConfig.copyWith(
      defaultPhases: phases ?? baseConfig.defaultPhases,
      defaultWorkflow: defaultWorkflow,
      typeSpecificSettings: typeSpecificFields ?? {},
    );

    // If no organization ID is provided, log a warning
    if (organizationId == null || organizationId.isEmpty) {
      print('Warning: No organization ID provided. Using a placeholder.');
    }

    final template = ProjectTemplate(
      id: '', // Let repository generate ID
      name: name,
      description: description,
      config: config,
      organizationId: organizationId ?? 'default_org_id',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    return await _repository.createTemplate(template);
  }

  // Add more template creation methods for other project types
  // Example: createEcommerceTemplate(), createAppDevelopmentTemplate(), etc.
}
