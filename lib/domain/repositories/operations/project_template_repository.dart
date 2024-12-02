import 'package:neetiflow/domain/entities/operations/project_template.dart';

abstract class ProjectTemplateRepository {
  /// Create a new project template
  Future<ProjectTemplate> createTemplate(ProjectTemplate template);

  /// Get a project template by ID
  Future<ProjectTemplate?> getTemplate(String id);

  /// Get all project templates
  Future<List<ProjectTemplate>> getAllTemplates();

  /// Get templates by type
  Future<List<ProjectTemplate>> getTemplatesByType(ProjectType type);

  /// Update a project template
  Future<ProjectTemplate> updateTemplate(ProjectTemplate template);

  /// Archive a project template
  Future<void> archiveTemplate(String id);

  /// Delete a project template
  Future<void> deleteTemplate(String id);

  /// Clone a project template
  Future<ProjectTemplate> cloneTemplate(String id, {String? newName});

  /// Create a new version of a project template
  Future<ProjectTemplate> createNewVersion(String id);

  /// Stream of project templates for real-time updates
  Stream<List<ProjectTemplate>> watchTemplates();

  /// Validate a project template before creation or update
  Future<bool> validateTemplate(ProjectTemplate template);
}
