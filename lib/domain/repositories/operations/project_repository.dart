import 'package:neetiflow/domain/entities/operations/project.dart';
import 'package:neetiflow/domain/entities/operations/project_activity.dart';
import 'package:neetiflow/domain/entities/operations/project_notification.dart';

import '../../entities/operations/workflow_template.dart';

abstract class ProjectRepository {
  /// Create a new project
  Future<Project> createProject(Project project);

  /// Alias for createProject
  Future<Project> create(Project project) => createProject(project);

  /// Get a project by ID
  Future<Project?> getProject(String id);

  /// Get all projects
  Future<List<Project>> getAllProjects();

  /// Get projects with filters and pagination
  Future<List<Project>> getProjects({
    Map<String, dynamic>? filters,
    int limit = 20,
  });

  /// Get projects by client
  Future<List<Project>> getProjectsByClient(String clientId);

  /// Get projects by employee (based on project membership)
  Future<List<Project>> getProjectsByEmployee(String employeeId);

  /// Update a project
  Future<Project> updateProject(Project project);

  /// Archive a project
  Future<void> archiveProject(String id, String modifiedBy);

  /// Add member to project
  Future<void> addProjectMember(String projectId, ProjectMember member);

  /// Remove member from project
  Future<void> removeProjectMember(String projectId, String employeeId);

  /// Update member access
  Future<void> updateMemberAccess(
    String projectId,
    String employeeId,
    ProjectAccess newAccess,
  );

  /// Check if employee has access to project
  Future<ProjectAccess?> checkProjectAccess(String projectId, String employeeId);

  /// Stream of projects for real-time updates
  Stream<List<Project>> watchProjects();

  /// Stream of specific project for real-time updates
  Stream<Project?> watchProject(String id);

  // Activity and notification methods
  Stream<List<ProjectActivity>> watchProjectActivities(String projectId);
  Future<List<ProjectActivity>> getProjectActivities(String projectId);
  Future<void> addProjectActivity(ProjectActivity activity);

  Stream<List<ProjectNotification>> watchMemberNotifications(String employeeId);

  // Workflow methods
  Future<WorkflowTemplate> createWorkflow(WorkflowTemplate workflow);
  Future<WorkflowTemplate?> getWorkflow(String id);
  Future<List<WorkflowTemplate>> getWorkflows({
    Map<String, dynamic>? filters,
    int limit = 20,
  });
  Future<List<WorkflowTemplate>> searchWorkflows({String? query, int limit = 20});
  Future<WorkflowTemplate> updateWorkflow(WorkflowTemplate workflow);
  Future<void> deleteWorkflow(String id);
}
