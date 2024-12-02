import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:neetiflow/core/providers/auth_provider.dart';
import 'package:neetiflow/domain/entities/client.dart';
import 'package:neetiflow/domain/entities/operations/project.dart';
import 'package:neetiflow/domain/repositories/auth_repository.dart';
import 'package:neetiflow/domain/repositories/operations_repository.dart';
import 'package:universal_html/html.dart' as html;
import 'package:uuid/uuid.dart';

import '../../../domain/entities/operations/project_template.dart';

@LazySingleton(as: OperationsRepository)
class OperationsRepositoryImpl implements OperationsRepository {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _firebaseStorage;
  final AuthRepository _authRepository;
  final AuthService _authService;
  final _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 50,
      colors: true,
      printEmojis: true,
    ),
  );

  OperationsRepositoryImpl(
    @Named('firestore') this._firestore,
    @Named('firebaseStorage') this._firebaseStorage,
    this._authRepository,
    this._authService,
  );

  Future<String> _getOrganizationId() async {
    try {
      final organizationId = await _authService.getOrganizationId();
      if (organizationId == null || organizationId.isEmpty) {
        _logger.e('No organization ID found in auth service');
        throw Exception('No organization ID found');
      }
      _logger.d('Got organization ID: $organizationId');
      return organizationId;
    } catch (e, stackTrace) {
      _logger.e('Error getting organization ID', error: e, stackTrace: stackTrace);
      throw Exception('Failed to get organization ID: $e');
    }
  }

  @override
  Future<List<Project>> getProjects({
    String? query,
    List<String>? tags,
    List<String>? statuses,
  }) async {
    try {
      final organizationId = await _getOrganizationId();
      if (organizationId == null) {
        throw Exception('No organization ID found');
      }

      var projectsRef = _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('projects');

      Query projectsQuery = projectsRef;

      if (query != null && query.isNotEmpty) {
        projectsQuery = projectsQuery
            .where('name', isGreaterThanOrEqualTo: query)
            .where('name', isLessThan: '${query}z');
      }

      if (tags != null && tags.isNotEmpty) {
        projectsQuery = projectsQuery.where('tags', arrayContainsAny: tags);
      }

      if (statuses != null && statuses.isNotEmpty) {
        projectsQuery = projectsQuery.where('status', whereIn: statuses);
      }

      final snapshot = await projectsQuery.get();
      return snapshot.docs
          .map((doc) => Project.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      _logger.e('Error getting projects: $e');
      rethrow;
    }
  }

  @override
  Future<List<ProjectTemplate>> getProjectTemplates() async {
    try {
      final organizationId = await _getOrganizationId();
      if (organizationId == null) {
        _logger.e('No organization ID found when fetching project templates');
        return [];
      }

      final templatesRef = _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('project_templates');

      final snapshot = await templatesRef.get();
      
      // Log the number of templates found
      _logger.d('Found ${snapshot.docs.length} project templates');

      // Add null checks and error handling
      final templates = snapshot.docs.map((doc) {
        final data = doc.data();
        // Ensure the document has an ID
        data['id'] = doc.id;
        
        try {
          return ProjectTemplate.fromJson(data);
        } catch (e) {
          _logger.e('Error parsing project template: $e');
          _logger.e('Problematic template data: $data');
          return null;
        }
      }).whereType<ProjectTemplate>().toList();

      // If no templates found, return an empty list instead of null
      return templates.isEmpty ? [] : templates;
    } catch (e, stackTrace) {
      _logger.e('Error getting project templates', error: e, stackTrace: stackTrace);
      return []; // Return an empty list instead of throwing an exception
    }
  }

  @override
  Future<List<Client>> getClients() async {
    try {
      final organizationId = await _getOrganizationId();
      _logger.d('Getting clients for organization: $organizationId');

      final clientsRef = _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('clients');

      final snapshot = await clientsRef
          .orderBy('createdAt', descending: true)
          .get();

      _logger.d('Retrieved ${snapshot.docs.length} clients');
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Client.fromJson(data);
      }).toList();
    } catch (e, stackTrace) {
      _logger.e('Error getting clients', error: e, stackTrace: stackTrace);
      throw Exception('Failed to get clients: $e');
    }
  }

  @override
  Future<Project> createProject({
    required String name,
    required String description,
    required ProjectType type,
    required Client client,
    required DateTime startDate,
    required DateTime expectedEndDate,
    String? parentId,
    List<String>? tags,
  }) async {
    try {
      final organizationId = await _getOrganizationId();
      if (organizationId == null) {
        throw Exception('No organization ID found');
      }

      final projectsRef = _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('projects');

      final user = await _authRepository.getCurrentUser();
      if (user == null) {
        throw Exception('No authenticated user found');
      }

      final newProject = Project(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        clientId: client.id,
        client: client,
        type: type,
        status: ProjectStatus.planning,
        phases: [],
        milestones: [],
        members: [],
        typeSpecificFields: {},
        workflows: [],
        startDate: startDate,
        expectedEndDate: expectedEndDate,
        description: description,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        createdBy: user.uid, organizationId: '',
      );

      await projectsRef.doc(newProject.id).set(newProject.toJson());
      return newProject;
    } catch (e) {
      _logger.e('Error creating project: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateProject(Project project) async {
    try {
      final organizationId = await _authService.getOrganizationId();
      if (organizationId == null) {
        throw Exception('No organization ID found');
      }

      await _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('projects')
          .doc(project.id)
          .update(project.toJson());
    } catch (e) {
      _logger.e('Error updating project: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteProject(String id) async {
    try {
      final organizationId = await _authService.getOrganizationId();
      if (organizationId == null) {
        throw Exception('No organization ID found');
      }

      await _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('projects')
          .doc(id)
          .delete();
    } catch (e) {
      _logger.e('Error deleting project: $e');
      rethrow;
    }
  }

  @override
  Future<Project> getProjectById(String id) async {
    try {
      final organizationId = await _authService.getOrganizationId();
      if (organizationId == null) {
        throw Exception('No organization ID found');
      }

      final doc = await _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('projects')
          .doc(id)
          .get(const GetOptions(source: Source.server));

      if (!doc.exists) {
        throw Exception('Project not found');
      }

      return Project.fromJson(doc.data()!);
    } catch (e) {
      _logger.e('Error getting project by ID: $e');
      rethrow;
    }
  }

  @override
  Future<String> uploadProjectFile(String projectId, String filePath) async {
    try {
      final organizationId = await _getOrganizationId();
      if (organizationId == null) {
        throw Exception('No organization ID found');
      }

      // For web, filePath will be a data URL containing the file data
      final fileName = const Uuid().v4(); // Generate a unique filename
      final storageRef = _firebaseStorage.ref().child(
          'organizations/$organizationId/projects/$projectId/files/$fileName');

      late final String downloadUrl;
      late final int fileSize;

      if (filePath.startsWith('data:')) {
        // Web: Handle data URL
        final mimeType = filePath.split(',')[0].split(':')[1].split(';')[0];
        final data = html.window.atob(filePath.split(',')[1]);
        final bytes = Uint8List.fromList(
          data.codeUnits.map((byte) => byte & 0xff).toList(),
        );

        fileSize = bytes.length;
        final metadata = SettableMetadata(contentType: mimeType);
        final uploadTask = await storageRef.putData(bytes, metadata);
        downloadUrl = await uploadTask.ref.getDownloadURL();
      } else {
        throw Exception('Invalid file format');
      }

      // Add file metadata to Firestore
      final fileRef = _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('projects')
          .doc(projectId)
          .collection('files')
          .doc();

      await fileRef.set({
        'name': fileName,
        'url': downloadUrl,
        'uploadedAt': FieldValue.serverTimestamp(),
        'size': fileSize,
      });

      return fileRef.id;
    } catch (e, stackTrace) {
      _logger.e('Error uploading project file',
          error: e, stackTrace: stackTrace);
      throw Exception('Failed to upload project file: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteProjectFile({
    required String projectId,
    required String fileId,
  }) async {
    try {
      final organizationId = await _getOrganizationId();
      if (organizationId == null) {
        throw Exception('No organization ID found');
      }

      // Get file metadata from Firestore
      final fileDoc = await _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('projects')
          .doc(projectId)
          .collection('files')
          .doc(fileId)
          .get(const GetOptions(source: Source.server));

      if (!fileDoc.exists) {
        throw Exception('File not found');
      }

      final fileData = fileDoc.data();
      if (fileData == null) {
        throw Exception('File data not found');
      }

      // Delete file from Storage
      final fileUrl = fileData['url'] as String;
      final storageRef = _firebaseStorage.refFromURL(fileUrl);
      await storageRef.delete();

      // Delete metadata from Firestore
      await fileDoc.reference.delete();
    } catch (e, stackTrace) {
      _logger.e('Error deleting project file',
          error: e, stackTrace: stackTrace);
      throw Exception('Failed to delete project file: ${e.toString()}');
    }
  }

  @override
  Future<void> addTeamMember({
    required String projectId,
    required ProjectMember member,
  }) async {
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
      _logger.e('Error adding team member: $e');
      rethrow;
    }
  }
}
