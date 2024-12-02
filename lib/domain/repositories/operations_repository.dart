import 'package:neetiflow/domain/entities/client.dart';
import 'package:neetiflow/domain/entities/operations/project.dart' as project;
import 'package:neetiflow/domain/entities/operations/project.dart';
import 'package:neetiflow/domain/entities/operations/project_template.dart';

abstract class OperationsRepository {
  Future<List<project.Project>> getProjects({
    String? query,
    List<String>? tags,
    List<String>? statuses,
  });

  Future<List<ProjectTemplate>> getProjectTemplates();

  Future<List<Client>> getClients();

  Future<project.Project> createProject({
    required String name,
    required String description,
    required ProjectType type,
    required Client client,
    required DateTime startDate,
    required DateTime expectedEndDate,
    String? parentId,
    List<String>? tags,
  });

  Future<void> updateProject(project.Project project);

  Future<void> deleteProject(String id);

  Future<project.Project> getProjectById(String id);

  Future<String> uploadProjectFile(String projectId, String filePath);

  Future<void> deleteProjectFile(
      {required String projectId, required String fileId});

  Future<void> addTeamMember({
    required String projectId,
    required ProjectMember member,
  });
}
