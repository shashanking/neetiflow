import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:neetiflow/domain/repositories/operations/project_repository.dart';
import 'package:neetiflow/domain/entities/operations/project.dart';
import 'package:neetiflow/domain/entities/operations/project_activity.dart';
import 'package:neetiflow/domain/entities/operations/project_notification.dart';
import 'package:neetiflow/infrastructure/services/organization_service.dart';
import 'package:logger/logger.dart';

import '../../../domain/entities/operations/workflow_template.dart';

@LazySingleton(as: ProjectRepository)
class ProjectRepositoryImpl implements ProjectRepository {
  final FirebaseFirestore _firestore;
  final OrganizationService _organizationService;
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 50,
      colors: true,
      printEmojis: true,
    ),
  );

  ProjectRepositoryImpl(
    @Named('firestore') this._firestore,
    this._organizationService,
  );

  Future<String> _getOrganizationId() async {
    return _organizationService.getCurrentOrganizationId();
  }

  @override
  Future<Project> createProject(Project project) async {
    try {
      final organizationId = await _getOrganizationId();

      _logger.i('Creating project in organization: $organizationId');
      _logger.d('Project details:');
      _logger.d('- ID: ${project.id}');
      _logger.d('- Name: ${project.name}');
      _logger.d('- Type: ${project.type}');
      _logger.d('- Client: ${project.clientId}');
      _logger.d('- Status: ${project.status}');

      await _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('projects')
          .doc(project.id)
          .set(project.toJson());

      _logger.i('Project created successfully');
      return project;
    } catch (e) {
      _logger.e('Error creating project: $e');
      rethrow;
    }
  }

  @override
  Future<Project> create(Project project) => createProject(project);

  @override
  Future<Project?> getProject(String id) async {
    try {
      final organizationId = await _getOrganizationId();

      final doc = await _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('projects')
          .doc(id)
          .get();

      if (!doc.exists) return null;
      return Project.fromJson(doc.data() as Map<String, dynamic>);
    } catch (e) {
      _logger.e('Error getting project: $e');
      rethrow;
    }
  }

  @override
  Future<List<Project>> getAllProjects() async {
    try {
      final organizationId = await _getOrganizationId();

      _logger.i('Fetching all projects for organization: $organizationId');
      
      final snapshot = await _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('projects')
          .get();

      _logger.i('Found ${snapshot.docs.length} projects');
      
      return snapshot.docs
          .map((doc) => Project.fromJson(doc.data()))
          .toList();
    } catch (e) {
      _logger.e('Error getting projects: $e');
      rethrow;
    }
  }

  @override
  Future<List<Project>> getProjectsByClient(String clientId) async {
    try {
      final organizationId = await _getOrganizationId();
      if (organizationId == null) {
        throw Exception('No organization ID found');
      }

      final snapshot = await _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('projects')
          .where('clientId', isEqualTo: clientId)
          .get();

      return snapshot.docs
          .map((doc) => Project.fromJson(doc.data()))
          .toList();
    } catch (e) {
      _logger.e('Error getting projects by client: $e');
      rethrow;
    }
  }

  @override
  Future<List<Project>> getProjectsByEmployee(String employeeId) async {
    try {
      final organizationId = await _getOrganizationId();
      if (organizationId == null) {
        throw Exception('No organization ID found');
      }

      final snapshot = await _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('projects')
          .where('members', arrayContains: employeeId)
          .get();

      return snapshot.docs
          .map((doc) => Project.fromJson(doc.data()))
          .toList();
    } catch (e) {
      _logger.e('Error getting projects by employee: $e');
      rethrow;
    }
  }

  @override
  Future<Project> updateProject(Project project) async {
    try {
      final organizationId = await _getOrganizationId();
      if (organizationId == null) {
        throw Exception('No organization ID found');
      }

      await _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('projects')
          .doc(project.id)
          .update(project.toJson());
      return project;
    } catch (e) {
      _logger.e('Error updating project: $e');
      rethrow;
    }
  }

  @override
  Future<void> archiveProject(String id, String modifiedBy) async {
    try {
      final organizationId = await _getOrganizationId();
      if (organizationId == null) {
        throw Exception('No organization ID found');
      }

      await _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('projects')
          .doc(id)
          .update({
        'status': 'archived',
        'modifiedBy': modifiedBy,
        'modifiedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      _logger.e('Error archiving project: $e');
      rethrow;
    }
  }

  @override
  Future<void> addProjectMember(String projectId, ProjectMember member) async {
    try {
      final organizationId = await _getOrganizationId();
      if (organizationId == null) {
        throw Exception('No organization ID found');
      }

      await _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('projects')
          .doc(projectId)
          .update({
        'members': FieldValue.arrayUnion([member.toJson()]),
      });
    } catch (e) {
      _logger.e('Error adding project member: $e');
      rethrow;
    }
  }

  @override
  Future<void> removeProjectMember(String projectId, String employeeId) async {
    try {
      final organizationId = await _getOrganizationId();
      if (organizationId == null) {
        throw Exception('No organization ID found');
      }

      final project = await getProject(projectId);
      if (project == null) {
        throw Exception('Project not found');
      }

      final updatedMembers = project.members
          .where((member) => member.employeeId != employeeId)
          .toList();

      await _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('projects')
          .doc(projectId)
          .update({
        'members': updatedMembers.map((m) => m.toJson()).toList(),
      });
    } catch (e) {
      _logger.e('Error removing project member: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateMemberAccess(
    String projectId,
    String employeeId,
    ProjectAccess newAccess,
  ) async {
    try {
      final organizationId = await _getOrganizationId();
      if (organizationId == null) {
        throw Exception('No organization ID found');
      }

      final project = await getProject(projectId);
      if (project == null) {
        throw Exception('Project not found');
      }

      final updatedMembers = project.members.map((member) {
        if (member.employeeId == employeeId) {
          return member.copyWith(access: newAccess);
        }
        return member;
      }).toList();

      await _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('projects')
          .doc(projectId)
          .update({
        'members': updatedMembers.map((m) => m.toJson()).toList(),
      });
    } catch (e) {
      _logger.e('Error updating member access: $e');
      rethrow;
    }
  }

  @override
  Future<ProjectAccess?> checkProjectAccess(String projectId, String employeeId) async {
    try {
      final project = await getProject(projectId);
      if (project == null) {
        return null;
      }

      final member = project.members.firstWhere(
        (m) => m.employeeId == employeeId,
        orElse: () => throw Exception('Member not found'),
      );

      return member.access;
    } catch (e) {
      _logger.e('Error checking project access: $e');
      rethrow;
    }
  }

  @override
  Stream<List<Project>> watchProjects() {
    try {
      return _firestore
          .collection('organizations')
          .doc(_getOrganizationId() as String)
          .collection('projects')
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => Project.fromJson(doc.data()))
              .toList());
    } catch (e) {
      _logger.e('Error watching projects: $e');
      rethrow;
    }
  }

  @override
  Stream<Project?> watchProject(String id) {
    try {
      return _firestore
          .collection('organizations')
          .doc(_getOrganizationId() as String)
          .collection('projects')
          .doc(id)
          .snapshots()
          .map((doc) {
        if (!doc.exists) return null;
        return Project.fromJson(doc.data() as Map<String, dynamic>);
      });
    } catch (e) {
      _logger.e('Error watching project: $e');
      rethrow;
    }
  }

  @override
  Stream<List<ProjectActivity>> watchProjectActivities(String projectId) {
    try {
      return _firestore
          .collection('organizations')
          .doc(_getOrganizationId() as String)
          .collection('projects')
          .doc(projectId)
          .collection('activities')
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) =>
                  ProjectActivity.fromJson(doc.data()))
              .toList());
    } catch (e) {
      _logger.e('Error watching project activities: $e');
      rethrow;
    }
  }

  @override
  Stream<List<ProjectNotification>> watchMemberNotifications(String employeeId) {
    try {
      return _firestore
          .collection('organizations')
          .doc(_getOrganizationId() as String)
          .collection('notifications')
          .where('employeeId', isEqualTo: employeeId)
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) =>
                  ProjectNotification.fromJson(doc.data()))
              .toList());
    } catch (e) {
      _logger.e('Error watching member notifications: $e');
      rethrow;
    }
  }

  @override
  Future<void> addProjectActivity(ProjectActivity activity) async {
    try {
      final organizationId = await _getOrganizationId();
      if (organizationId == null) {
        throw Exception('No organization ID found');
      }

      await _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('project_activities')
          .add(activity.toJson());
    } catch (e) {
      _logger.e('Error adding project activity: $e');
      rethrow;
    }
  }

  @override
  Future<List<ProjectActivity>> getProjectActivities(String projectId) async {
    try {
      final organizationId = await _getOrganizationId();
      if (organizationId == null) {
        throw Exception('No organization ID found');
      }

      final snapshot = await _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('project_activities')
          .where('projectId', isEqualTo: projectId)
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => ProjectActivity.fromJson(doc.data()))
          .toList();
    } catch (e) {
      _logger.e('Error getting project activities: $e');
      rethrow;
    }
  }

  @override
  Future<WorkflowTemplate> createWorkflow(WorkflowTemplate workflow) async {
    try {
      final organizationId = await _getOrganizationId();
      if (organizationId == null) {
        throw Exception('No organization ID found');
      }

      final workflowsRef = _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('workflow_templates');

      final doc = workflowsRef.doc();
      final workflowWithId = workflow.copyWith(id: doc.id);
      
      await doc.set(workflowWithId.toJson());
      return workflowWithId;
    } catch (e) {
      _logger.e('Error creating workflow template: $e');
      rethrow;
    }
  }

  @override
  Future<WorkflowTemplate?> getWorkflow(String id) async {
    try {
      final organizationId = await _getOrganizationId();
      if (organizationId == null) {
        throw Exception('No organization ID found');
      }

      final doc = await _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('workflow_templates')
          .doc(id)
          .get();

      if (!doc.exists) {
        return null;
      }

      return WorkflowTemplate.fromJson(doc.data()!);
    } catch (e) {
      _logger.e('Error getting workflow template: $e');
      rethrow;
    }
  }

  @override
  Future<List<WorkflowTemplate>> searchWorkflows({
    String? query,
    int limit = 20,
  }) async {
    try {
      final organizationId = await _getOrganizationId();
      if (organizationId == null) {
        throw Exception('No organization ID found');
      }

      var queryRef = _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('workflow_templates')
          .limit(limit);

      if (query != null && query.isNotEmpty) {
        queryRef = queryRef.where('name', isGreaterThanOrEqualTo: query)
            .where('name', isLessThan: '${query}z');
      }

      final snapshot = await queryRef.get();
      return snapshot.docs
          .map((doc) => WorkflowTemplate.fromJson(doc.data()))
          .toList();
    } catch (e) {
      _logger.e('Error searching workflow templates: $e');
      rethrow;
    }
  }

  @override
  Future<WorkflowTemplate> updateWorkflow(WorkflowTemplate workflow) async {
    try {
      final organizationId = await _getOrganizationId();
      if (organizationId == null) {
        throw Exception('No organization ID found');
      }

      await _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('workflow_templates')
          .doc(workflow.id)
          .update(workflow.toJson());

      return workflow;
    } catch (e) {
      _logger.e('Error updating workflow template: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteWorkflow(String id) async {
    try {
      final organizationId = await _getOrganizationId();
      if (organizationId == null) {
        throw Exception('No organization ID found');
      }

      await _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('workflow_templates')
          .doc(id)
          .delete();
    } catch (e) {
      _logger.e('Error deleting workflow template: $e');
      rethrow;
    }
  }

  @override
  Future<List<Project>> getProjects({
    Map<String, dynamic>? filters,
    int limit = 20,
  }) async {
    try {
      final organizationId = await _getOrganizationId();
      if (organizationId == null) {
        throw Exception('No organization ID found');
      }

      var query = _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('projects')
          .limit(limit);

      // Apply filters if provided
      if (filters != null) {
        filters.forEach((key, value) {
          query = query.where(key, isEqualTo: value);
        });
      }

      final snapshot = await query.get();
      return snapshot.docs.map((doc) => Project.fromJson(doc.data())).toList();
    } catch (e) {
      _logger.e('Error getting projects: $e');
      rethrow;
    }
  }

  @override
  Future<List<WorkflowTemplate>> getWorkflows({
    Map<String, dynamic>? filters,
    int limit = 20,
  }) async {
    try {
      final organizationId = await _getOrganizationId();
      if (organizationId == null) {
        throw Exception('No organization ID found');
      }

      var query = _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('workflow_templates')
          .limit(limit);

      // Apply filters if provided
      if (filters != null) {
        filters.forEach((key, value) {
          query = query.where(key, isEqualTo: value);
        });
      }

      final snapshot = await query.get();
      return snapshot.docs.map((doc) => WorkflowTemplate.fromJson(doc.data())).toList();
    } catch (e) {
      _logger.e('Error getting workflow templates: $e');
      rethrow;
    }
  }
}
