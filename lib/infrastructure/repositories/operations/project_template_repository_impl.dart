import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:neetiflow/domain/entities/operations/project_template.dart';
import 'package:neetiflow/domain/repositories/operations/project_template_repository.dart';
import 'package:logger/logger.dart';

import '../../../domain/entities/operations/workflow_template.dart';
import '../../services/organization_service.dart';

@LazySingleton(as: ProjectTemplateRepository)
class ProjectTemplateRepositoryImpl implements ProjectTemplateRepository {
  final FirebaseFirestore _firestore;
  final OrganizationService _organizationService;
  final String _collection = 'project_templates';
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 50,
      colors: true,
      printEmojis: true,
    ),
  );

  ProjectTemplateRepositoryImpl(
    @Named('firestore') this._firestore,
    this._organizationService,
  );

  Future<CollectionReference<Map<String, dynamic>>> _getTemplatesRef() async {
    final orgId = await _organizationService.getCurrentOrganizationId();
    if (orgId.isEmpty) {
      _logger.e('🚨 Organization ID is empty');
      throw Exception('Organization ID is empty');
    }
    
    // Detailed Logging
    _logger.d('🏢 Organization Details:');
    _logger.d('Organization ID: $orgId');
    _logger.d('Templates Collection Path: organizations/$orgId/project_templates');

    // Verify organization document exists
    final orgDoc = await _firestore.collection('organizations').doc(orgId).get();
    if (!orgDoc.exists) {
      _logger.e('🚨 Organization document does not exist');
      throw Exception('Organization document not found');
    }

    return _firestore
        .collection('organizations')
        .doc(orgId)
        .collection(_collection);
  }

  @override
  Future<ProjectTemplate> createTemplate(ProjectTemplate template) async {
    try {
      final orgId = await _organizationService.getCurrentOrganizationId();
      if (orgId.isEmpty) {
        throw Exception('Organization ID is empty');
      }
      _logger.d('Organization ID: $orgId');

      // Create a new document reference
      final templatesRef = await _getTemplatesRef();
      final docRef = templatesRef.doc(template.id.isEmpty ? null : template.id);
      _logger.d('Generated document ID: ${docRef.id}');

      // Create new template with generated ID
      final newTemplate = template.copyWith(
        id: docRef.id,
        organizationId: orgId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        version: 1,
      );

      // Comprehensive JSON conversion with detailed logging
      final json = newTemplate.toJson();
      
      // Validate JSON structure
      _logger.d('Template JSON Validation:');
      _logger.d('- ID: ${json['id']}');
      _logger.d('- Name: ${json['name']}');
      _logger.d('- Organization ID: ${json['organizationId']}');
      _logger.d('- CreatedAt: ${json['createdAt']}');
      _logger.d('- UpdatedAt: ${json['updatedAt']}');
      _logger.d('- Version: ${json['version']}');
      
      // Validate config
      if (!json.containsKey('config') || json['config'] == null) {
        throw Exception('Template config is missing or null');
      }
      
      final config = json['config'];
      _logger.d('Config Validation:');
      _logger.d('- Type: ${config['type']}');
      _logger.d('- Default Phases: ${config['defaultPhases']?.length ?? 0}');
      _logger.d('- Default Workflow: ${config['defaultWorkflow']}');
      _logger.d('- Default Milestones: ${config['defaultMilestones']?.length ?? 0}');
      
      // Ensure required fields are present
      if (json['name'] == null || json['name'].isEmpty) {
        throw Exception('Template name is required');
      }
      
      if (config['type'] == null) {
        throw Exception('Template type is required');
      }

      // Convert complex objects to JSON-serializable format
      if (json.containsKey('config') && json['config'] is Map) {
        final config = json['config'] as Map<String, dynamic>;
        
        // Convert workflow to a JSON-serializable representation
        if (config.containsKey('defaultWorkflow')) {
          final workflow = config['defaultWorkflow'];
          if (workflow is WorkflowTemplate) {
            config['defaultWorkflow'] = workflow.toJson();
          } else if (workflow is Map) {
            // Ensure basic structure
            config['defaultWorkflow'] = {
              'id': workflow['id'] ?? 'default_workflow',
              'name': workflow['name'] ?? 'Default Workflow',
              'states': (workflow['states'] as List?)?.map((state) => {
                'id': state['id'] ?? '',
                'name': state['name'] ?? '',
                'color': state['color'] ?? '#808080',
                'isInitial': state['isInitial'] ?? false,
                'isFinal': state['isFinal'] ?? false,
              }).toList() ?? [],
              'transitions': (workflow['transitions'] as List?)?.map((transition) => {
                'id': transition['id'] ?? '',
                'name': transition['name'] ?? '',
                'fromStateId': transition['fromStateId'] ?? '',
                'toStateId': transition['toStateId'] ?? '',
              }).toList() ?? [],
            };
          }
        }
      }

      // Detailed logging of default phases
      if (config['defaultPhases'] is List) {
        _logger.d('Default Phases Details:');
        for (final phase in config['defaultPhases']) {
          _logger.d('- Phase Name: ${phase['name']}');
          _logger.d('- Phase Description: ${phase['description']}');
          _logger.d('- Default Duration: ${phase['defaultDuration']}');
        }
      }

      // Detailed logging of default workflow
      if (config['defaultWorkflow'] is Map) {
        final workflow = config['defaultWorkflow'];
        _logger.d('Default Workflow Details:');
        _logger.d('- Workflow Name: ${workflow['name']}');
        _logger.d('- States: ${workflow['states']?.length ?? 0}');
        _logger.d('- Transitions: ${workflow['transitions']?.length ?? 0}');
      }

      // Detailed logging of default milestones
      if (config['defaultMilestones'] is List) {
        _logger.d('Default Milestones Details:');
        for (final milestone in config['defaultMilestones']) {
          _logger.d('- Milestone Name: ${milestone['name']}');
          _logger.d('- Milestone Description: ${milestone['description']}');
          _logger.d('- Due Date: ${milestone['dueDate']}');
        }
      }

      // Add isArchived field if not present
      if (!json.containsKey('isArchived')) {
        json['isArchived'] = false;
      }

      // Add typeSpecificFields if not present
      if (!json.containsKey('typeSpecificFields')) {
        json['typeSpecificFields'] = {};
      }

      await docRef.set(json);
      _logger.i('Template created successfully with ID: ${docRef.id}');
      
      return newTemplate;
    } catch (e, stackTrace) {
      _logger.e('Error creating template', error: e, stackTrace: stackTrace);
      throw Exception('Failed to create template: $e');
    }
  }

  @override
  Future<ProjectTemplate?> getTemplate(String id) async {
    try {
      final templatesRef = await _getTemplatesRef();
      final doc = await templatesRef.doc(id).get();
      if (!doc.exists) return null;
      return ProjectTemplate.fromJson(doc.data()!);
    } catch (e, stackTrace) {
      _logger.e('Error getting template', error: e, stackTrace: stackTrace);
      throw Exception('Failed to get template: $e');
    }
  }

  @override
  Future<List<ProjectTemplate>> getAllTemplates() async {
    try {
      final templatesRef = await _getTemplatesRef();
      final snapshot = await templatesRef
          .where('isArchived', isEqualTo: false)
          .orderBy('createdAt', descending: true)
          .get();
      
      // Print detailed template information
      print('🔍 Total Templates Found: ${snapshot.docs.length}');
      
      final templates = snapshot.docs
          .map((doc) {
            final template = ProjectTemplate.fromJson(doc.data());
            print('📋 Template Details:');
            print('- ID: ${template.id}');
            print('- Name: ${template.name}');
            print('- Type: ${template.type}');
            print('- Created At: ${template.createdAt}');
            print('- Organization ID: ${template.organizationId}');
            print('- Phases: ${template.phases.length}');
            print('- Workflows: ${template.workflows.length}');
            print('---');
            return template;
          })
          .toList();
      
      return templates;
    } catch (e, stackTrace) {
      print('❌ Error fetching templates: $e');
      print('Stack Trace: $stackTrace');
      return [];
    }
  }

  @override
  Future<List<ProjectTemplate>> getTemplatesByType(ProjectType type) async {
    try {
      final templatesRef = await _getTemplatesRef();
      final snapshot = await templatesRef
          .where('type', isEqualTo: type.toString())
          .where('isArchived', isEqualTo: false)
          .orderBy('createdAt', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => ProjectTemplate.fromJson(doc.data()))
          .toList();
    } catch (e, stackTrace) {
      _logger.e('Error getting templates by type', error: e, stackTrace: stackTrace);
      throw Exception('Failed to get templates by type: $e');
    }
  }

  @override
  Future<ProjectTemplate> updateTemplate(ProjectTemplate template) async {
    _logger.i('Updating template: ${template.id}');
    
    try {
      final templatesRef = await _getTemplatesRef();
      final existingDoc = await templatesRef.doc(template.id).get();
      if (!existingDoc.exists) {
        throw Exception('Template not found');
      }

      // Preserve creation timestamp and organization ID
      final existing = ProjectTemplate.fromJson(existingDoc.data()!);
      final updatedTemplate = template.copyWith(
        createdAt: existing.createdAt,
        organizationId: existing.organizationId,
        updatedAt: DateTime.now(),
        version: existing.version + 1,
      );

      _logger.d('Template details:');
      _logger.d('- ID: ${updatedTemplate.id}');
      _logger.d('- Name: ${updatedTemplate.name}');
      _logger.d('- Type: ${updatedTemplate.type}');
      _logger.d('- Phases count: ${updatedTemplate.phases.length}');
      _logger.d('- Milestones count: ${updatedTemplate.defaultMilestones.length}');
      _logger.d('- Workflows count: ${updatedTemplate.workflows.length}');
      
      // Detailed workflow logging
      _logger.d('\nWorkflow Details:');
      for (final workflow in updatedTemplate.workflows) {
        _logger.d('\nWorkflow: ${workflow.name}');
        _logger.d('- ID: ${workflow.id}');
        _logger.d('- Description: ${workflow.description}');
        _logger.d('- States count: ${workflow.states.length}');
        for (final state in workflow.states) {
          _logger.d('  State: ${state.name}');
          _logger.d('  - ID: ${state.id}');
          _logger.d('  - Color: ${state.color}');
          _logger.d('  - Initial: ${state.isInitial}');
          _logger.d('  - Final: ${state.isFinal}');
        }
        _logger.d('- Transitions count: ${workflow.transitions.length}');
        for (final transition in workflow.transitions) {
          _logger.d('  Transition: ${transition.name}');
          _logger.d('  - ID: ${transition.id}');
          _logger.d('  - From: ${transition.fromStateId}');
          _logger.d('  - To: ${transition.toStateId}');
        }
      }
      
      // Convert to JSON and verify structure
      final json = updatedTemplate.toJson();
      _logger.d('\nVerifying JSON structure:');
      _logger.d('- Has phases: ${json.containsKey('phases')}');
      _logger.d('- Has milestones: ${json.containsKey('defaultMilestones')}');
      _logger.d('- Has workflows: ${json.containsKey('workflows')}');
      
      if (json['workflows'] is List) {
        final workflows = json['workflows'] as List;
        _logger.d('\nWorkflows in JSON:');
        _logger.d('- Count: ${workflows.length}');
        for (final workflow in workflows) {
          _logger.d('\nWorkflow:');
          _logger.d('- Name: ${workflow['name']}');
          _logger.d('- States: ${(workflow['states'] as List?)?.length ?? 0}');
          _logger.d('- Transitions: ${(workflow['transitions'] as List?)?.length ?? 0}');
        }
      }

      // Update the document
      await templatesRef.doc(template.id).update(json);
      _logger.i('Template updated successfully');
      return updatedTemplate;
    } catch (e, stackTrace) {
      _logger.e('Error updating template', error: e, stackTrace: stackTrace);
      throw Exception('Failed to update template: $e');
    }
  }

  @override
  Future<void> archiveTemplate(String id) async {
    try {
      final templatesRef = await _getTemplatesRef();
      await templatesRef.doc(id).update({'isArchived': true});
    } catch (e, stackTrace) {
      _logger.e('Error archiving template', error: e, stackTrace: stackTrace);
      throw Exception('Failed to archive template: $e');
    }
  }

  @override
  Future<void> deleteTemplate(String id) async {
    try {
      final templatesRef = await _getTemplatesRef();
      await templatesRef.doc(id).delete();
    } catch (e, stackTrace) {
      _logger.e('Error deleting template', error: e, stackTrace: stackTrace);
      throw Exception('Failed to delete template: $e');
    }
  }

  @override
  Future<ProjectTemplate> cloneTemplate(String id, {String? newName}) async {
    try {
      final templatesRef = await _getTemplatesRef();
      final template = await getTemplate(id);
      if (template == null) {
        throw Exception('Template not found');
      }

      final docRef = templatesRef.doc();
      final clonedTemplate = template.copyWith(
        id: docRef.id,
        name: newName ?? '${template.name} (Copy)',
        organizationId: await _organizationService.getCurrentOrganizationId(),
        parentTemplateId: id,
        version: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await docRef.set(clonedTemplate.toJson());
      return clonedTemplate;
    } catch (e, stackTrace) {
      _logger.e('Error cloning template', error: e, stackTrace: stackTrace);
      throw Exception('Failed to clone template: $e');
    }
  }

  @override
  Future<ProjectTemplate> createNewVersion(String id) async {
    try {
      final templatesRef = await _getTemplatesRef();
      final template = await getTemplate(id);
      if (template == null) {
        throw Exception('Template not found');
      }

      // Get the latest version number
      final versions = await templatesRef
          .where('parentTemplateId', isEqualTo: id)
          .orderBy('version', descending: true)
          .limit(1)
          .get();

      final latestVersion = versions.docs.isEmpty
          ? template.version
          : ProjectTemplate.fromJson(versions.docs.first.data()).version;

      final docRef = templatesRef.doc();
      final newVersion = template.copyWith(
        id: docRef.id,
        version: latestVersion + 1,
        parentTemplateId: id,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await docRef.set(newVersion.toJson());
      return newVersion;
    } catch (e, stackTrace) {
      _logger.e('Error creating new version', error: e, stackTrace: stackTrace);
      throw Exception('Failed to create new version: $e');
    }
  }

  @override
  Future<bool> validateTemplate(ProjectTemplate template) async {
    final validationErrors = <String>[];

    // Basic validation
    if (template.name.isEmpty) {
      validationErrors.add('Template name is required');
    }

    // Validate project type
    if (template.type == null) {
      validationErrors.add('Project type must be specified');
    }

    // Validate configuration
    if (template.config == null) {
      validationErrors.add('Template configuration is missing');
      return false;
    }

    // Validate phases (with more lenient rules)
    if (template.config.defaultPhases.isEmpty) {
      validationErrors.add('At least one project phase is recommended');
    } else {
      for (final phase in template.config.defaultPhases) {
        if (phase.name.isEmpty) {
          validationErrors.add('Phase name cannot be empty');
        }
        
        // Optional: Check phase duration
        if ((phase.defaultDuration ?? Duration.zero).inDays < 0) {
          validationErrors.add('Phase duration must be non-negative');
        }
      }
    }

    // Validate workflow (with more lenient rules)
    if (template.config.defaultWorkflow == null) {
      validationErrors.add('A default workflow is recommended');
    } else {
      final workflow = template.config.defaultWorkflow;
      if (workflow.states.isEmpty) {
        validationErrors.add('Workflow must have at least one state');
      }
    }

    // Validate milestones (optional)
    if (template.config.defaultMilestones.isNotEmpty) {
      for (final milestone in template.config.defaultMilestones) {
        if (milestone.name.isEmpty) {
          validationErrors.add('Milestone name cannot be empty');
        }
      }
    }

    // Validate organization ID
    if (template.organizationId.isEmpty) {
      validationErrors.add('Organization ID is required');
    }

    // Log validation errors
    if (validationErrors.isNotEmpty) {
      _logger.w('Template Validation Errors:');
      for (final error in validationErrors) {
        _logger.w('- $error');
      }
      return false;
    }

    return true;
  }

  @override
  Stream<List<ProjectTemplate>> watchTemplates() async* {
    try {
      final templatesRef = await _getTemplatesRef();
      _logger.d('Templates Reference Path: ${templatesRef.path}');
      
      yield* templatesRef
          .where('isArchived', isEqualTo: false)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
        _logger.d('Total documents in snapshot: ${snapshot.docs.length}');
        
        final templates = snapshot.docs.map((doc) {
          try {
            // Log document details
            _logger.d('Document ID: ${doc.id}');
            _logger.d('Document Data: ${doc.data()}');

            // Ensure the document data is a map
            final data = doc.data();
            if (data is! Map<String, dynamic>) {
              _logger.e('Invalid template data: $data');
              return null;
            }

            // Ensure config is present and is a map
            if (!data.containsKey('config') || data['config'] is! Map<String, dynamic>) {
              _logger.e('Missing or invalid config in template: $data');
              return null;
            }

            // Ensure required fields are present
            if (!data.containsKey('name') || data['name'] is! String) {
              _logger.e('Missing or invalid name in template: $data');
              return null;
            }

            return ProjectTemplate.fromJson(data);
          } catch (e, stackTrace) {
            _logger.e(
              'Error parsing template ${doc.id}', 
              error: e, 
              stackTrace: stackTrace
            );
            return null;
          }
        }).where((t) => t != null).cast<ProjectTemplate>().toList();
        
        _logger.d('Watching templates: ${templates.length} templates found');
        return templates;
      });
    } catch (e, stackTrace) {
      _logger.e('Error watching templates', error: e, stackTrace: stackTrace);
      yield [];
    }
  }
}
