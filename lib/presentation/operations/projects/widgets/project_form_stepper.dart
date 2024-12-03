import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neetiflow/domain/entities/operations/project.dart';
import 'package:neetiflow/domain/entities/operations/project_template.dart';
import 'package:neetiflow/presentation/blocs/project/project_bloc.dart';
import 'package:neetiflow/presentation/blocs/project/project_event.dart';
import 'package:neetiflow/presentation/blocs/project/project_state.dart';
import 'package:neetiflow/presentation/operations/projects/widgets/template_selection_step.dart';
import 'package:neetiflow/presentation/operations/projects/widgets/template_config_step.dart';
import 'package:neetiflow/presentation/operations/projects/widgets/project_details_step.dart';

class ProjectFormStepper extends StatefulWidget {
  final Project? initialProject;
  final VoidCallback onSave;
  final bool unableToDelete;

  const ProjectFormStepper({
    super.key,
    this.initialProject,
    required this.onSave,
    this.unableToDelete = false,
  });

  @override
  State<ProjectFormStepper> createState() => _ProjectFormStepperState();
}

class _ProjectFormStepperState extends State<ProjectFormStepper> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectBloc, ProjectState>(
      builder: (context, state) {
        return state.maybeMap(
          form: (formState) => Stepper(
            type: StepperType.horizontal,
            currentStep: _currentStep,
            onStepContinue: () {
              if (_validateCurrentStep(formState)) {
                if (_currentStep < 2) {
                  setState(() {
                    _currentStep += 1;
                  });
                } else {
                  widget.onSave();
                }
              }
            },
            onStepCancel: () {
              if (_currentStep > 0) {
                setState(() {
                  _currentStep -= 1;
                });
              }
            },
            onStepTapped: (step) {
              if (_validateCurrentStep(formState)) {
                setState(() {
                  _currentStep = step;
                });
              }
            },
            steps: [
              Step(
                title: const Text('Details'),
                content: ProjectDetailsStep(
                  name: formState.name,
                  description: formState.description ?? '',
                  client: formState.client,
                  startDate: formState.startDate,
                  endDate: formState.expectedEndDate,
                  onNameChanged: (value) => context
                      .read<ProjectBloc>()
                      .add(ProjectEvent.nameChanged(value)),
                  onDescriptionChanged: (value) => context
                      .read<ProjectBloc>()
                      .add(ProjectEvent.descriptionChanged(value)),
                  onClientChanged: (client) => context
                      .read<ProjectBloc>()
                      .add(ProjectEvent.clientChanged(client)),
                  onStartDateChanged: (date) => context
                      .read<ProjectBloc>()
                      .add(ProjectEvent.startDateChanged(date)),
                  onEndDateChanged: (date) => context
                      .read<ProjectBloc>()
                      .add(ProjectEvent.endDateChanged(date)),
                ),
                isActive: _currentStep >= 0,
                state: _getStepState(0),
              ),
              Step(
                title: const Text('Select Template'),
                content: TemplateSelectionStep(
                  selectedTemplate: formState.template,
                  showErrorMessages: formState.showErrorMessages,
                  onTemplateChanged: (template) => context
                      .read<ProjectBloc>()
                      .add(ProjectEvent.templateChanged(template)),
                  onTemplateSelected: (template) => context
                      .read<ProjectBloc>()
                      .add(ProjectEvent.templateChanged(template)),
                ),
                isActive: _currentStep >= 1,
                state: _getStepState(1),
              ),
              Step(
                title: const Text('Configuration'),
                content: TemplateConfigStep(
                  templateConfig: formState.template?.config ?? ProjectTemplateConfig.empty(),
                  showErrorMessages: formState.showErrorMessages,
                  onConfigChanged: (config) {
                    if (formState.template != null) {
                      final updatedTemplate = formState.template!.copyWith(config: config);
                      context
                          .read<ProjectBloc>()
                          .add(ProjectEvent.templateChanged(updatedTemplate));
                    }
                  },
                  onFieldChanged: (String fieldId, dynamic value) {
                    if (formState.template != null) {
                      final updatedConfig = formState.template!.config.copyWith(
                        customFields: formState.template!.config.customFields.map((field) {
                          return field.id == fieldId 
                            ? field.copyWith(value: value ?? '') 
                            : field;
                        }).toList(),
                      );
                      final updatedTemplate = formState.template!.copyWith(
                        config: updatedConfig,
                      );
                      context
                          .read<ProjectBloc>()
                          .add(ProjectEvent.templateChanged(updatedTemplate));
                    }
                  },
                ),
                isActive: _currentStep >= 2,
                state: _getStepState(2),
              ),
            ],
          ),
          orElse: () => const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  StepState _getStepState(int step) {
    if (step == _currentStep) {
      return StepState.editing;
    } else if (step < _currentStep) {
      return StepState.complete;
    } else {
      return StepState.indexed;
    }
  }

  bool _validateCurrentStep(ProjectState state) {
    return state.maybeMap(
      form: (formState) {
        switch (_currentStep) {
          case 0:
            return formState.name.isNotEmpty &&
                formState.client != null &&
                formState.startDate != null &&
                formState.expectedEndDate != null;
          case 1:
            return formState.template != null;
          case 2:
            return true;
          default:
            return false;
        }
      },
      orElse: () => false,
    );
  }
}
