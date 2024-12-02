import 'package:injectable/injectable.dart';
import 'package:neetiflow/domain/entities/operations/project.dart';
import 'package:neetiflow/domain/entities/operations/project_template.dart';
import 'package:neetiflow/domain/repositories/clients_repository.dart';
import 'package:neetiflow/utils/logger.dart';

import '../entities/operations/workflow_template.dart';
import '../repositories/employees_repository.dart';
import '../repositories/operations/project_repository.dart';

@injectable
class ProjectService {
  final ProjectRepository _projectRepository;
  final EmployeesRepository _employeeRepository;
  final ClientsRepository _clientRepository;

  ProjectService({
    required ProjectRepository projectRepository,
    required EmployeesRepository employeeRepository,
    required ClientsRepository clientRepository,
  })  : _projectRepository = projectRepository,
        _employeeRepository = employeeRepository,
        _clientRepository = clientRepository;

  Future<Project> createProject({
    required ProjectTemplate template,
    required String name,
    required String clientId,
    required List<String> teamMemberIds,
    DateTime? startDate,
    DateTime? expectedEndDate,
    String? description,
    required String createdBy,
  }) async {
    try {
      logger.i('Creating project: $name');

      // Validate client
      final client = await _clientRepository.getClient(template.organizationId, clientId);
      if (client == null) {
        throw Exception('Invalid client ID');
      }

      // Validate team members
      final teamMembers =
          await _employeeRepository.getEmployeesByIds(teamMemberIds);
      if (teamMembers.length != teamMemberIds.length) {
        throw Exception('One or more team members not found');
      }

      // Prepare project members
      final projectMembers = teamMembers.map((employee) {
        return ProjectMember(
          employeeId: employee.id!,
          employeeName: '${employee.firstName} ${employee.lastName}',
          role: 'Team Member', // Default role
          access: ProjectAccess.view,
          joinedAt: DateTime.now(),
          department: employee.departmentId,
        );
      }).toList();

      // Create project
      final project = Project.fromTemplate(
        template: template,
        name: name,
        clientId: clientId,
        client: client,
        createdBy: createdBy,
        description: description,
        members: projectMembers,
      );

      final createdProject = await _projectRepository.createProject(project);

      logger.i('Project created successfully: ${createdProject.id}');
      return createdProject;
    } catch (e, stackTrace) {
      logger.e('Failed to create project', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<List<Project>> searchProjects({
    String? query,
    ProjectStatus? status,
    String? clientId,
    String? assignedEmployeeId,
    DateTime? startDateFrom,
    DateTime? startDateTo,
    int limit = 20,
  }) async {
    try {
      logger.i('Searching projects with query: $query');

      // Prepare filters
      final filters = <String, dynamic>{
        if (status != null) 'status': status.toString(),
        if (clientId != null) 'clientId': clientId,
        if (assignedEmployeeId != null)
          'members.employeeId': assignedEmployeeId,
      };

      // TODO: Implement more advanced search logic
      // This might involve text search or more complex filtering
      final projects = await _projectRepository.getProjects(
        limit: limit,
        filters: filters,
      );

      logger.i('Found ${projects.length} projects');
      return projects;
    } catch (e, stackTrace) {
      logger.e('Failed to search projects', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> updateProjectStatus(
      String projectId, ProjectStatus newStatus) async {
    try {
      logger.i('Updating project status: $projectId to $newStatus');

      final project = await _projectRepository.getProject(projectId);
      if (project == null) {
        throw Exception('Project not found');
      }

      final updatedProject = project.copyWith(status: newStatus);
      await _projectRepository.updateProject(updatedProject);

      logger.i('Project status updated successfully');
    } catch (e, stackTrace) {
      logger.e('Failed to update project status',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> assignProjectMembers(
      String projectId, List<String> employeeIds) async {
    try {
      logger.i('Assigning members to project: $projectId');

      // Validate employees
      final employees =
          await _employeeRepository.getEmployeesByIds(employeeIds);
      if (employees.length != employeeIds.length) {
        throw Exception('One or more employees not found');
      }

      final project = await _projectRepository.getProject(projectId);
      if (project == null) {
        throw Exception('Project not found');
      }

      // Prepare new members
      final newMembers = employees.map((employee) {
        return ProjectMember(
          employeeId: employee.id!,
          employeeName: '${employee.firstName} ${employee.lastName}',
          role: 'Team Member',
          access: ProjectAccess.view,
          joinedAt: DateTime.now(),
          department: employee.departmentId,
        );
      }).toList();

      // Update project with new members
      final updatedProject = project.copyWith(
        members: [...project.members, ...newMembers],
      );

      await _projectRepository.updateProject(updatedProject);

      logger.i('Project members assigned successfully');
    } catch (e, stackTrace) {
      logger.e('Failed to assign project members',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<List<Project>> getProjectsForEmployee(String employeeId) async {
    try {
      logger.i('Fetching projects for employee: $employeeId');

      final projects = await searchProjects(
        assignedEmployeeId: employeeId,
      );

      logger.i('Found ${projects.length} projects for employee');
      return projects;
    } catch (e, stackTrace) {
      logger.e('Failed to fetch projects for employee',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  // Workflow Management
  Future<WorkflowTemplate> createWorkflow({
    required WorkflowTemplate workflow,
    required String createdBy,
  }) async {
    try {
      logger.i('Creating workflow: ${workflow.name}');

      // Validate workflow
      if (workflow.states.isEmpty) {
        throw Exception('Workflow must have at least one state');
      }

      // Ensure one initial state
      final initialStates = workflow.states.where((state) => state.isInitial);
      if (initialStates.isEmpty || initialStates.length > 1) {
        throw Exception('Workflow must have exactly one initial state');
      }

      // Add metadata
      final enrichedWorkflow = workflow.copyWith(
        metadata: {
          ...workflow.metadata,
          'createdBy': createdBy,
          'createdAt': DateTime.now().toIso8601String(),
        },
      );

      // Save to Firestore via repository
      final savedWorkflow =
          await _projectRepository.createWorkflow(enrichedWorkflow);

      logger.i('Workflow created successfully: ${savedWorkflow.id}');
      return savedWorkflow;
    } catch (e, stackTrace) {
      logger.e('Failed to create workflow', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<WorkflowTemplate?> getWorkflow(String workflowId) async {
    try {
      logger.i('Fetching workflow: $workflowId');

      final workflow = await _projectRepository.getWorkflow(workflowId);

      if (workflow == null) {
        logger.w('Workflow not found: $workflowId');
      }

      return workflow;
    } catch (e, stackTrace) {
      logger.e('Failed to fetch workflow', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<List<WorkflowTemplate>> searchWorkflows({
    String? query,
    int limit = 20,
  }) async {
    try {
      logger.i('Searching workflows with query: $query');

      final filters = <String, dynamic>{
        if (query != null && query.isNotEmpty) 'name': query,
      };

      final workflows = await _projectRepository.getWorkflows(
        filters: filters.isNotEmpty ? filters : null,
        limit: limit,
      );

      logger.i('Found ${workflows.length} workflows');
      return workflows;
    } catch (e, stackTrace) {
      logger.e('Failed to search workflows', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<WorkflowTemplate> updateWorkflow({
    required WorkflowTemplate workflow,
    required String updatedBy,
  }) async {
    try {
      logger.i('Updating workflow: ${workflow.id}');

      // Validate workflow
      if (workflow.states.isEmpty) {
        throw Exception('Workflow must have at least one state');
      }

      // Ensure one initial state
      final initialStates = workflow.states.where((state) => state.isInitial);
      if (initialStates.isEmpty || initialStates.length > 1) {
        throw Exception('Workflow must have exactly one initial state');
      }

      // Add update metadata
      final enrichedWorkflow = workflow.copyWith(
        metadata: {
          ...workflow.metadata,
          'updatedBy': updatedBy,
          'updatedAt': DateTime.now().toIso8601String(),
        },
      );

      // Update in Firestore via repository
      await _projectRepository.updateWorkflow(enrichedWorkflow);

      logger.i('Workflow updated successfully: ${enrichedWorkflow.id}');
      return enrichedWorkflow;
    } catch (e, stackTrace) {
      logger.e('Failed to update workflow', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> deleteWorkflow(String workflowId, String deletedBy) async {
    try {
      logger.i('Deleting workflow: $workflowId');

      await _projectRepository.deleteWorkflow(workflowId);

      logger.i('Workflow deleted successfully');
    } catch (e, stackTrace) {
      logger.e('Failed to delete workflow', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}
