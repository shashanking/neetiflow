import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:neetiflow/domain/entities/operations/project_template.dart';
import 'package:neetiflow/domain/repositories/operations/project_template_repository.dart';
import 'package:neetiflow/infrastructure/services/organization_service.dart';
import 'package:logger/logger.dart';

part 'project_template_event.dart';
part 'project_template_state.dart';
part 'project_template_bloc.freezed.dart';

@injectable
class ProjectTemplateBloc extends Bloc<ProjectTemplateEvent, ProjectTemplateState> {
  final ProjectTemplateRepository _repository;
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
  StreamSubscription? _templatesSubscription;

  ProjectTemplateBloc(
    this._repository,
    this._organizationService,
  ) : super(const ProjectTemplateState.initial()) {
    on<_Started>(_onStarted);
    on<_Created>(_onCreated);
    on<_Updated>(_onUpdated);
    on<_Deleted>(_onDeleted);
    on<_Cloned>(_onCloned);
    on<_TemplatesReceived>(_onTemplatesReceived);
  }

  Future<void> _onStarted(_Started event, Emitter<ProjectTemplateState> emit) async {
    _logger.i('Starting ProjectTemplateBloc');
    emit(const ProjectTemplateState.loading());
    
    try {
      await _organizationService.initializeDefaultOrganization();
      await _templatesSubscription?.cancel();
      
      _logger.d('Setting up templates subscription');
      _templatesSubscription = _repository.watchTemplates().listen(
        (templates) {
          if (templates != null) {  
            _logger.d('Received ${templates.length} templates');
            add(ProjectTemplateEvent.templatesReceived(templates));
          } else {
            _logger.d('Received null templates');
            add(const ProjectTemplateEvent.templatesReceived([]));  
          }
        },
        onError: (error) {
          _logger.e('Error watching templates', error: error);
          emit(ProjectTemplateState.error(error.toString()));
        },
      );
    } catch (e, stackTrace) {
      _logger.e('Error in _onStarted', error: e, stackTrace: stackTrace);
      emit(ProjectTemplateState.error(e.toString()));
    }
  }

  Future<void> _onCreated(_Created event, Emitter<ProjectTemplateState> emit) async {
    _logger.i('Creating template: ${event.template.name}');
    _logger.d('Template details:');
    _logger.d('- Name: ${event.template.name}');
    _logger.d('- Type: ${event.template.type}');
    _logger.d('- Organization ID: ${event.template.organizationId}');
    _logger.d('- Phases: ${event.template.config.defaultPhases.length}');
    _logger.d('- Workflow: ${event.template.config.defaultWorkflow.name}');
    
    try {
      final createdTemplate = await _repository.createTemplate(event.template);
      _logger.i('Template created successfully: ${createdTemplate.id}');
      
      // Emit the newly created template
      emit(ProjectTemplateState.loaded([createdTemplate]));
      
    } catch (e, stackTrace) {
      _logger.e('Error creating template', error: e, stackTrace: stackTrace);
      emit(ProjectTemplateState.error('Failed to create template: $e'));
      // Reload templates after error
      add(const ProjectTemplateEvent.started());
    }
  }

  Future<void> _onUpdated(_Updated event, Emitter<ProjectTemplateState> emit) async {
    _logger.i('Updating template: ${event.template.id}');
    _logger.d('Template details:');
    _logger.d('- ID: ${event.template.id}');
    _logger.d('- Name: ${event.template.name}');
    _logger.d('- Type: ${event.template.type}');
    _logger.d('- Phases: ${event.template.phases.length}');
    _logger.d('- Milestones: ${event.template.defaultMilestones.length}');
    
    try {
      final updatedTemplate = await _repository.updateTemplate(event.template);
      _logger.i('Template updated successfully: ${updatedTemplate.id}');
      
      // Let the stream subscription handle the state update
      // The watchTemplates() stream will automatically emit the new state
      
    } catch (e, stackTrace) {
      _logger.e('Error updating template', error: e, stackTrace: stackTrace);
      emit(ProjectTemplateState.error('Failed to update template: $e'));
      // Reload templates after error
      add(const ProjectTemplateEvent.started());
    }
  }

  Future<void> _onDeleted(_Deleted event, Emitter<ProjectTemplateState> emit) async {
    _logger.i('Deleting template: ${event.id}');
    
    try {
      await _repository.deleteTemplate(event.id);
      _logger.i('Template deleted successfully: ${event.id}');
      
      // Let the stream subscription handle the state update
      // The watchTemplates() stream will automatically emit the new state
      
    } catch (e, stackTrace) {
      _logger.e('Error deleting template', error: e, stackTrace: stackTrace);
      emit(ProjectTemplateState.error('Failed to delete template: $e'));
      // Reload templates after error
      add(const ProjectTemplateEvent.started());
    }
  }

  Future<void> _onCloned(_Cloned event, Emitter<ProjectTemplateState> emit) async {
    _logger.i('Cloning template: ${event.template.id}');
    _logger.d('Original template details:');
    _logger.d('- ID: ${event.template.id}');
    _logger.d('- Name: ${event.template.name}');
    
    try {
      final clonedTemplate = await _repository.cloneTemplate(event.template.id);
      _logger.i('Template cloned successfully:');
      _logger.d('- New ID: ${clonedTemplate.id}');
      _logger.d('- New Name: ${clonedTemplate.name}');
      
      // Let the stream subscription handle the state update
      // The watchTemplates() stream will automatically emit the new state
      
    } catch (e, stackTrace) {
      _logger.e('Error cloning template', error: e, stackTrace: stackTrace);
      emit(ProjectTemplateState.error('Failed to clone template: $e'));
      // Reload templates after error
      add(const ProjectTemplateEvent.started());
    }
  }

  void _onTemplatesReceived(_TemplatesReceived event, Emitter<ProjectTemplateState> emit) {
    if (event.templates.isEmpty) {
      _logger.d('Received empty templates list');
    } else {
      _logger.d('Received ${event.templates.length} templates');
    }
    emit(ProjectTemplateState.loaded(event.templates));
  }

  @override
  Future<void> close() async {
    await _templatesSubscription?.cancel();
    return super.close();
  }
}
