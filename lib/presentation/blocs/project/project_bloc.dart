import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:neetiflow/domain/entities/operations/project.dart';
import 'package:neetiflow/domain/repositories/operations/project_repository.dart';
import 'package:neetiflow/domain/repositories/operations_repository.dart';
import 'package:neetiflow/presentation/blocs/project/project_event.dart';
import 'package:neetiflow/presentation/blocs/project/project_state.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/entities/operations/project_template.dart';

@injectable
class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  final OperationsRepository _repository;
  final ProjectRepository _projectRepository;
  Project? _selectedProject;

  ProjectBloc(
    this._repository,
    this._projectRepository,
    ) : super(const ProjectState.initial()) {
    on<ProjectEvent>((event, emit) async {
      await event.map(
        started: (_) async {
          emit(const ProjectState.loading());
          try {
            final projects = await _repository.getProjects();
            final templates = await _repository.getProjectTemplates();
            final clients = await _repository.getClients();
            
            emit(ProjectState.loaded(
              projects: projects,
              templates: templates,
              clients: clients,
              currentProject: _selectedProject,
            ));
          } catch (e) {
            emit(ProjectState.error(e.toString()));
          }
        },
        refreshed: (_) async {
          try {
            final projects = await _repository.getProjects();
            final templates = await _repository.getProjectTemplates();
            final clients = await _repository.getClients();
            
            emit(ProjectState.loaded(
              projects: projects,
              templates: templates,
              clients: clients,
              currentProject: _selectedProject,
            ));
          } catch (e) {
            emit(ProjectState.error(e.toString()));
          }
        },
        filtered: (event) async {
          emit(const ProjectState.loading());
          try {
            final projects = await _repository.getProjects(
              query: event.query,
              tags: event.tags,
              statuses: event.statuses,
            );
            final templates = await _repository.getProjectTemplates();
            final clients = await _repository.getClients();
            
            emit(ProjectState.loaded(
              projects: projects,
              templates: templates,
              clients: clients,
              currentProject: _selectedProject,
            ));
          } catch (e) {
            emit(ProjectState.error(e.toString()));
          }
        },
        deleteProject: (event) async {
          try {
            await _repository.deleteProject(event.projectId);
            emit(const ProjectState.deleted());
          } catch (e) {
            emit(ProjectState.error(e.toString()));
          }
        },
        createProject: (event) async {
          try {
            final project = await _projectRepository.create(Project(
              id: const Uuid().v4(),
              name: event.name,
              description: event.description,
              type: event.type,
              clientId: event.client.id,
              client: event.client,
              status: ProjectStatus.planning,
              phases: const [],
              milestones: const [],
              members: const [],
              workflows: const [],
              startDate: event.startDate,
              expectedEndDate: event.endDate, organizationId: '',
            ));
            add(const ProjectEvent.refreshed());
          } catch (e) {
            emit(ProjectState.error(e.toString()));
          }
        },
        addTeamMember: (event) async {
          try {
            await _repository.addTeamMember(
              projectId: event.projectId,
              member: event.member,
            );
            add(const ProjectEvent.refreshed());
          } catch (e) {
            emit(ProjectState.error(e.toString()));
          }
        },
        fileUploaded: (event) async {
          try {
            // Handle file upload using the storage service
            add(const ProjectEvent.refreshed());
          } catch (e) {
            emit(ProjectState.error(e.toString()));
          }
        },
        fileDeleted: (event) async {
          try {
            // Handle file deletion using the storage service
            add(const ProjectEvent.refreshed());
          } catch (e) {
            emit(ProjectState.error(e.toString()));
          }
        },
        projectSelected: (event) async {
          _selectedProject = event.project;
          add(const ProjectEvent.refreshed());
        },
        // Form Events
        initialized: (e) async {
          if (e.project != null) {
            emit(ProjectState.form(
              name: e.project!.name,
              client: e.project!.client,
              template: null, // Set appropriate template
              startDate: e.project!.startDate,
              expectedEndDate: e.project!.expectedEndDate,
              description: e.project!.description,
              showErrorMessages: false,
              isSaving: false,
              saveFailureOrSuccessOption: none(),
            ));
          } else {
            emit(state.toForm());
          }
        },
        nameChanged: (e) async {
          state.maybeMap(
            form: (formState) => emit(formState.copyWith(
              name: e.name,
              saveFailureOrSuccessOption: none(),
            )),
            orElse: () {},
          );
        },
        clientChanged: (e) async {
          state.maybeMap(
            form: (formState) => emit(formState.copyWith(
              client: e.client,
              saveFailureOrSuccessOption: none(),
            )),
            orElse: () {},
          );
        },
        templateChanged: (e) async {
          state.maybeMap(
            form: (formState) => emit(formState.copyWith(
              template: e.template,
              saveFailureOrSuccessOption: none(),
            )),
            orElse: () {},
          );
        },
        startDateChanged: (e) async {
          state.maybeMap(
            form: (formState) => emit(formState.copyWith(
              startDate: e.date,
              saveFailureOrSuccessOption: none(),
            )),
            orElse: () {},
          );
        },
        endDateChanged: (e) async {
          state.maybeMap(
            form: (formState) => emit(formState.copyWith(
              expectedEndDate: e.date,
              saveFailureOrSuccessOption: none(),
            )),
            orElse: () {},
          );
        },
        descriptionChanged: (e) async {
          state.maybeMap(
            form: (formState) => emit(formState.copyWith(
              description: e.description,
              saveFailureOrSuccessOption: none(),
            )),
            orElse: () {},
          );
        },
        saved: (_) async {
          state.maybeMap(
            form: (formState) async {
              if (formState.client == null) {
                emit(formState.copyWith(
                  showErrorMessages: true,
                  saveFailureOrSuccessOption: none(),
                ));
                return;
              }

              try {
                final project = await _projectRepository.create(Project(
                  id: const Uuid().v4(),
                  name: formState.name,
                  description: formState.description ?? '',
                  type: formState.template?.type ?? ProjectType.software,
                  clientId: formState.client!.id,
                  client: formState.client!,
                  status: ProjectStatus.planning,
                  phases: const [],
                  milestones: const [],
                  members: const [],
                  workflows: const [],
                  startDate: formState.startDate ?? DateTime.now(),
                  expectedEndDate: formState.expectedEndDate ?? DateTime.now().add(const Duration(days: 30)), organizationId: '',
                ));
                add(const ProjectEvent.refreshed());
              } catch (e) {
                emit(ProjectState.error(e.toString()));
              }
            },
            orElse: () {},
          );
        },
      );
    });
  }
}
