import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:neetiflow/infrastructure/services/organization_service.dart';
import 'package:neetiflow/presentation/pages/projects/milestone_editor_page.dart';
import 'package:neetiflow/presentation/pages/projects/phase_editor_page.dart';
import 'package:neetiflow/presentation/pages/projects/workflow_editor_page.dart';
import 'package:neetiflow/utils/validators.dart';

import '../../../domain/entities/operations/milestone.dart';
import '../../../domain/entities/operations/phase.dart';
import '../../../domain/entities/operations/project_template.dart';
import '../../../domain/entities/operations/workflow_template.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../domain/repositories/operations/project_template_repository.dart';
import '../../blocs/project_template/project_template_bloc.dart';

class ProjectTemplateForm extends StatefulWidget {
  final ProjectTemplate? template;
  final Function(ProjectTemplate) onSubmit;
  final VoidCallback onCancel;

  const ProjectTemplateForm({
    Key? key,
    this.template,
    required this.onSubmit,
    required this.onCancel,
  }) : super(key: key);

  @override
  State<ProjectTemplateForm> createState() => _ProjectTemplateFormState();
}

class _ProjectTemplateFormState extends State<ProjectTemplateForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _requiredSkillsController = TextEditingController();
  final _estimatedBudgetController = TextEditingController();

  late ProjectTemplateBloc _projectTemplateBloc;
  late ProjectTemplateRepository _projectTemplateRepository;
  late AuthRepository _authRepository;

  ProjectType? _selectedType;
  Duration _estimatedDuration = const Duration(days: 30);
  Complexity? _selectedComplexity;

  bool _isSubmitting = false;
  String? _errorMessage;

  // Template components
  List<Phase> _phases = [];
  List<Milestone> _milestones = [];
  List<WorkflowTemplate> _workflows = [];

  @override
  void initState() {
    super.initState();
    _projectTemplateRepository = GetIt.I<ProjectTemplateRepository>();
    _authRepository = GetIt.I<AuthRepository>();
    _projectTemplateBloc = ProjectTemplateBloc(
      _projectTemplateRepository, 
      GetIt.I<OrganizationService>(),
    );
    
    // Print all templates for debugging
    _projectTemplateRepository.getAllTemplates().then((templates) {
      print('🚀 Initialized Templates in Form: ${templates.length}');
    }).catchError((error) {
      print('❌ Error initializing templates: $error');
    });

    _selectedType = widget.template?.type ?? ProjectType.custom;
    _phases = (widget.template?.phases ?? [])
        .map((p) => Phase(
              id: p.id,
              name: p.name,
              description: p.description,
              startDate: DateTime.now(),
              endDate: DateTime.now().add(const Duration(days: 7)),
              taskIds: const [],
              isCompleted: false,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              order: p.order,
              estimatedDuration: p.defaultDuration ?? const Duration(days: 7),
              defaultTasks: const [], // Initialize with empty tasks since Phase doesn't have them
            ))
        .toList();

    // Initialize controllers
    _nameController.text = widget.template?.name ?? '';
    _descriptionController.text = widget.template?.description ?? '';
    _requiredSkillsController.text = 
      (widget.template?.typeSpecificFields['requiredSkills'] as List?)?.join(', ') ?? '';
    _estimatedBudgetController.text = 
      widget.template?.typeSpecificFields['estimatedBudget'] ?? '';
    _selectedComplexity = widget.template?.typeSpecificFields['complexity'] != null
      ? Complexity.values.firstWhere(
          (c) => c.toString().split('.').last == widget.template?.typeSpecificFields['complexity']
        )
      : null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _requiredSkillsController.dispose();
    _estimatedBudgetController.dispose();
    _projectTemplateBloc.close();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
        _errorMessage = null;
      });

      try {
        // Validate form inputs
        if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
          setState(() {
            _isSubmitting = false;
            _errorMessage = 'Please fill in all required fields';
          });
          return;
        }

        // Ensure type is selected
        if (_selectedType == null) {
          setState(() {
            _isSubmitting = false;
            _errorMessage = 'Please select a template type';
          });
          return;
        }

        // Get organization ID using the repository
        final organizationId = await _authRepository.getCurrentUser().then((user) => 
          user != null 
            ? _authRepository.getEmployeeData(user.uid).then((employee) => employee?.companyId)
            : null
        );

        if (organizationId == null || organizationId.isEmpty) {
          setState(() {
            _isSubmitting = false;
            _errorMessage = 'Unable to retrieve organization ID';
          });
          return;
        }

        // Generate a more predictable ID
        final templateId = 'tmpl_${DateTime.now().millisecondsSinceEpoch.toString()}';

        final template = ProjectTemplate(
          id: templateId,
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim(),
          config: ProjectTemplateConfig(
            id: templateId, // Add required ID
            type: _selectedType!,
            defaultPhases: _phases
                .map((p) => TemplatePhase(
                      id: p.id,
                      name: p.name,
                      description: p.description,
                      defaultDuration: p.estimatedDuration,
                      fields: const [], // Initialize with empty fields
                      defaultTasks: p.defaultTasks
                          .map((t) => {
                                'name': t.name,
                                'description': t.description,
                                'dueDate': t.dueDate.toIso8601String(),
                                'metadata': t.metadata,
                              })
                          .toList(),
                    ))
                .toList(),
            defaultWorkflow: _workflows.isNotEmpty
                ? _workflows.first
                : WorkflowTemplate.fromJson({
                    'id': 'default_workflow',
                    'name': 'Default Workflow',
                    'states': [
                      {
                        'id': 'todo',
                        'name': 'To Do',
                        'color': '#808080',
                        'isInitial': true,
                        'isFinal': false,
                      },
                      {
                        'id': 'done',
                        'name': 'Done',
                        'color': '#00FF00',
                        'isInitial': false,
                        'isFinal': true,
                      },
                    ],
                    'transitions': [
                      {
                        'id': 'todo_to_done',
                        'name': 'Complete',
                        'fromStateId': 'todo',
                        'toStateId': 'done',
                      }
                    ]
                  }),
            defaultMilestones: _milestones
                .map((m) => TemplateMilestone(
                      id: m.id,
                      name: m.name,
                      description: m.description ?? '',
                      dueDate: m.dueDate,
                      isCompleted: m.completed,
                      tasks: [], // Milestone doesn't have tasks
                    ))
                .toList(),
            typeSpecificSettings: {
              'requiredSkills': _requiredSkillsController.text.split(',')
                  .map((skill) => skill.trim())
                  .where((skill) => skill.isNotEmpty)
                  .toList(),
              'estimatedBudget': _estimatedBudgetController.text.trim(),
              'complexity': _selectedComplexity?.toString().split('.').last,
            },
          ),
          createdAt: widget.template?.createdAt ?? DateTime.now(),
          updatedAt: DateTime.now(),
          isArchived: widget.template?.isArchived ?? false,
          version: widget.template?.version != null
              ? widget.template!.version + 1
              : 1,
          typeSpecificFields: {
            'requiredSkills': _requiredSkillsController.text.split(',')
                .map((skill) => skill.trim())
                .where((skill) => skill.isNotEmpty)
                .toList(),
            'estimatedBudget': _estimatedBudgetController.text.trim(),
            'complexity': _selectedComplexity?.toString().split('.').last,
          },
          organizationId: organizationId,
        );

        // Validate template before submission
        final isValid = await _projectTemplateRepository.validateTemplate(template);

        if (!isValid) {
          setState(() {
            _isSubmitting = false;
            _errorMessage = 'Template validation failed. Please check your inputs.';
          });
          return;
        }

        // Add template creation event to bloc
        _projectTemplateBloc.add(ProjectTemplateEvent.created(template));

        // Close the dialog or form
        Navigator.of(context).pop();

        setState(() {
          _isSubmitting = false;
        });
      } catch (e) {
        setState(() {
          _isSubmitting = false;
          _errorMessage = 'Failed to create template: ${e.toString()}';
        });

        // Show error dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Template Creation Error'),
            content: Text('$_errorMessage\n\nPlease check your inputs and try again.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK')
              )
            ],
          )
        );
      }
    }
  }

  void _addPhase() {
    final now = DateTime.now();
    final phase = Phase(
      id: now.millisecondsSinceEpoch.toString(),
      name: 'New Phase',
      description: '',
      order: _phases.length,
      startDate: now,
      endDate: now.add(const Duration(days: 7)),
      estimatedDuration: const Duration(days: 7),
      taskIds: [],
      defaultTasks: [],
      isCompleted: false,
      createdAt: now,
      updatedAt: now,
    );

    setState(() {
      _phases.add(phase);
    });
  }

  void _addMilestone() {
    final now = DateTime.now();
    final milestone = Milestone(
      id: now.millisecondsSinceEpoch.toString(),
      name: 'New Milestone',
      description: '',
      order: _milestones.length,
      dueDate: now.add(const Duration(days: 30)),
      completed: false,
    );

    setState(() {
      _milestones.add(milestone);
    });
  }

  void _addWorkflow() {
    final workflow = WorkflowTemplate(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: 'New Workflow',
      description: '',
      states: [
        const WorkflowState(
          id: 'todo',
          name: 'To Do',
          color: '#808080',
          isInitial: true,
          isFinal: false,
        ),
        const WorkflowState(
          id: 'in_progress',
          name: 'In Progress',
          color: '#0088cc',
          isInitial: false,
          isFinal: false,
        ),
        const WorkflowState(
          id: 'done',
          name: 'Done',
          color: '#00cc00',
          isInitial: false,
          isFinal: true,
        ),
      ],
      transitions: [
        const WorkflowTransition(
          id: 'start',
          name: 'Start',
          fromStateId: 'todo',
          toStateId: 'in_progress',
        ),
        const WorkflowTransition(
          id: 'complete',
          name: 'Complete',
          fromStateId: 'in_progress',
          toStateId: 'done',
        ),
      ],
    );

    setState(() {
      _workflows.add(workflow);
    });
  }

  List<Widget> _buildPhasesList() {
    return _phases
        .map((phase) => Card(
              child: ListTile(
                title: Text(phase.name),
                subtitle: Text(phase.description),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      _phases.removeWhere((p) => p.id == phase.id);
                      // Reorder remaining phases
                      for (var i = 0; i < _phases.length; i++) {
                        _phases[i] = _phases[i].copyWith(order: i);
                      }
                    });
                  },
                ),
                onTap: () => _editPhase(phase),
              ),
            ))
        .toList();
  }

  List<Widget> _buildMilestonesList() {
    return _milestones
        .map((milestone) => Card(
              child: ListTile(
                title: Text(milestone.name),
                subtitle: Text(milestone.description ?? ''),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      _milestones.removeWhere((m) => m.id == milestone.id);
                      // Reorder remaining milestones
                      for (var i = 0; i < _milestones.length; i++) {
                        _milestones[i] = _milestones[i].copyWith(order: i);
                      }
                    });
                  },
                ),
                onTap: () => _editMilestone(milestone),
              ),
            ))
        .toList();
  }

  List<Widget> _buildWorkflowsList() {
    return _workflows
        .map((workflow) => Card(
              child: ListTile(
                title: Text(workflow.name),
                subtitle: Text('${workflow.states.length} states'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      _workflows.removeWhere((w) => w.id == workflow.id);
                    });
                  },
                ),
                onTap: () => _editWorkflow(workflow),
              ),
            ))
        .toList();
  }

  Widget _buildSectionHeader(BuildContext context, String title,
      {VoidCallback? onAdd}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        if (onAdd != null)
          ElevatedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: const Text('Add'),
          ),
      ],
    );
  }

  Future<void> _editPhase(Phase phase) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (context) => PhaseEditorPage(
          phase: phase,
          onSave: (updatedPhase) {
            setState(() {
              final index = _phases.indexWhere((p) => p.id == phase.id);
              if (index != -1) {
                _phases[index] = updatedPhase;
              }
            });
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  Future<void> _editMilestone(Milestone milestone) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (context) => MilestoneEditorPage(
          milestone: milestone,
          onSave: (updatedMilestone) {
            setState(() {
              final index = _milestones.indexWhere((m) => m.id == milestone.id);
              if (index != -1) {
                _milestones[index] = updatedMilestone;
              }
            });
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  Future<void> _editWorkflow(WorkflowTemplate workflow) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (context) => WorkflowEditorPage(
          workflow: workflow,
          onSave: (updatedWorkflow) {
            setState(() {
              final index = _workflows.indexWhere((w) => w.id == workflow.id);
              if (index != -1) {
                _workflows[index] = updatedWorkflow;
              }
            });
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.template == null ? 'Create Template' : 'Edit Template',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: const OutlineInputBorder(),
                errorText: _errorMessage?.contains('name') == true
                    ? _errorMessage
                    : null,
              ),
              validator: (value) =>
                  Validators.validateNonEmptyText(value, 'Template Name'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (Optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<ProjectType>(
              value: _selectedType,
              decoration: InputDecoration(
                labelText: 'Type',
                border: const OutlineInputBorder(),
                errorText: _errorMessage?.contains('type') == true
                    ? _errorMessage
                    : null,
              ),
              items: ProjectType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.name.toUpperCase()),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedType = value;
                });
              },
              validator: (value) =>
                  value == null ? 'Please select a project type' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: _estimatedDuration.inDays.toString(),
              decoration: const InputDecoration(
                labelText: 'Estimated Duration (Days)',
                border: OutlineInputBorder(),
                suffixText: 'days',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter project duration';
                }
                final days = int.tryParse(value);
                if (days == null || days < 1) {
                  return 'Duration must be at least 1 day';
                }
                return null;
              },
              onChanged: (value) {
                final days = int.tryParse(value) ?? 30;
                setState(() {
                  _estimatedDuration = Duration(days: days);
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _requiredSkillsController,
              decoration: const InputDecoration(
                labelText: 'Required Skills (comma-separated)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _estimatedBudgetController,
              decoration: const InputDecoration(
                labelText: 'Estimated Budget',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Complexity>(
              value: _selectedComplexity,
              decoration: const InputDecoration(
                labelText: 'Complexity',
                border: OutlineInputBorder(),
              ),
              items: Complexity.values.map((complexity) {
                return DropdownMenuItem(
                  value: complexity,
                  child: Text(complexity.toString().split('.').last),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedComplexity = value;
                });
              },
            ),
            const SizedBox(height: 16),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            _buildSectionHeader(context, 'Phases', onAdd: () => _addPhase()),
            ..._buildPhasesList(),
            const SizedBox(height: 24),
            _buildSectionHeader(context, 'Milestones',
                onAdd: () => _addMilestone()),
            ..._buildMilestonesList(),
            const SizedBox(height: 24),
            _buildSectionHeader(context, 'Workflows',
                onAdd: () => _addWorkflow()),
            ..._buildWorkflowsList(),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: widget.onCancel,
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitForm,
                  child: _isSubmitting
                      ? const CircularProgressIndicator()
                      : const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
