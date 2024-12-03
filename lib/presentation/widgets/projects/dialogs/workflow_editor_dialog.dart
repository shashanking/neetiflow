import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:neetiflow/utils/validators.dart';

import '../../../../domain/entities/operations/workflow_template.dart';

class WorkflowEditorDialog extends StatefulWidget {
  final WorkflowTemplate? workflow;
  final ValueChanged<WorkflowTemplate> onSave;

  const WorkflowEditorDialog({
    Key? key,
    this.workflow,
    required this.onSave,
  }) : super(key: key);

  @override
  State<WorkflowEditorDialog> createState() => _WorkflowEditorDialogState();
}

class _WorkflowEditorDialogState extends State<WorkflowEditorDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  List<WorkflowState> _states = [];
  List<WorkflowTransition> _transitions = [];
  
  String? _errorMessage;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _initializeWorkflowData();
  }

  void _initializeWorkflowData() {
    final workflow = widget.workflow;
    _nameController.text = workflow?.name ?? '';
    _descriptionController.text = workflow?.description ?? '';
    _states = List.from(workflow?.states ?? []);
    _transitions = List.from(workflow?.transitions ?? []);

    // Ensure at least one initial state
    if (_states.isEmpty) {
      _addState(isInitial: true);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _addState({bool isInitial = false}) {
    setState(() {
      final newState = WorkflowState(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: 'New State',
        color: '#808080',
        metadata: {'description': ''},
        isInitial: isInitial || _states.isEmpty,
        isFinal: false,
      );
      
      // Ensure only one initial state
      if (isInitial) {
        _states = _states.map((state) => state.copyWith(isInitial: false)).toList();
      }
      
      _states.add(newState);
    });
  }


  void _removeState(int index) {
    setState(() {
      _states.removeAt(index);
      
      // Remove related transitions
      _transitions.removeWhere((transition) => 
        transition.fromStateId == _states[index].id || 
        transition.toStateId == _states[index].id
      );
      
      // Ensure at least one initial state
      if (_states.isNotEmpty && !_states.any((state) => state.isInitial)) {
        _states[0] = _states[0].copyWith(isInitial: true);
      }
    });
  }

  void _addTransition() {
    setState(() {
      final newTransition = WorkflowTransition(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: 'New Transition',
        fromStateId: _states.first.id,
        toStateId: _states.length > 1 ? _states[1].id : _states.first.id,
        metadata: {},
      );
      _transitions.add(newTransition);
    });
  }

  void _editTransition(int index, WorkflowTransition updatedTransition) {
    setState(() {
      _transitions[index] = updatedTransition;
    });
  }

  void _removeTransition(int index) {
    setState(() {
      _transitions.removeAt(index);
    });
  }

  bool _validateWorkflow() {
    setState(() {
      _errorMessage = null;
    });

    // Validate name
    if (_nameController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Workflow name is required';
      });
      return false;
    }

    // Validate states
    if (_states.isEmpty) {
      setState(() {
        _errorMessage = 'At least one state is required';
      });
      return false;
    }

    // Validate initial state
    if (!_states.any((state) => state.isInitial)) {
      setState(() {
        _errorMessage = 'One state must be set as the initial state';
      });
      return false;
    }

    // Validate unique state names
    final stateNames = _states.map((state) => state.name.toLowerCase()).toList();
    if (stateNames.length != stateNames.toSet().length) {
      setState(() {
        _errorMessage = 'State names must be unique';
      });
      return false;
    }

    return true;
  }

  void _saveWorkflow() {
    if (!_validateWorkflow()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final workflow = WorkflowTemplate(
        id: widget.workflow?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        states: _states,
        transitions: _transitions,
      );

      // Call onSave callback
      widget.onSave(workflow);

      // Close dialog after successful save
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to save workflow: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  void _showColorPicker(WorkflowState state, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pick a state color'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: Color(int.parse(state.color.replaceFirst('#', '0xFF'))),
            onColorChanged: (color) {
              setState(() {
                _states[index] = state.copyWith(
                  color: '#${color.value.toRadixString(16).substring(2)}',
                );
              });
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
    );
  }

  void _showStateEditDialog(WorkflowState state, int index) {
    final nameController = TextEditingController(text: state.name);
    final descriptionController = TextEditingController(text: state.metadata['description'] ?? '');
    final isInitialNotifier = ValueNotifier<bool>(state.isInitial);
    final isFinalNotifier = ValueNotifier<bool>(state.isFinal);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit State'),
        content: Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'State Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => Validators.validateNonEmptyText(value, 'State Name'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'State Description',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  ValueListenableBuilder<bool>(
                    valueListenable: isInitialNotifier,
                    builder: (context, isInitial, child) => CheckboxListTile(
                      value: isInitial,
                      onChanged: (value) {
                        if (value == true) {
                          // Ensure only one initial state
                          _states = _states.map((s) => s.copyWith(isInitial: false)).toList();
                        }
                        isInitialNotifier.value = value ?? false;
                      },
                      title: const Text('Initial State'),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: isFinalNotifier,
                    builder: (context, isFinal, child) => CheckboxListTile(
                      value: isFinal,
                      onChanged: (value) => isFinalNotifier.value = value ?? false,
                      title: const Text('Final State'),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  final updatedState = state.copyWith(
                    name: nameController.text.trim(),
                    metadata: {'description': descriptionController.text.trim()},
                    isInitial: isInitialNotifier.value,
                    isFinal: isFinalNotifier.value,
                  );
                  
                  setState(() {
                    _states[index] = updatedState;
                  });
                  
                  Navigator.of(context).pop();
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTransitionEditDialog(WorkflowTransition transition, int index) {
    final nameController = TextEditingController(text: transition.name);
    final descriptionController = TextEditingController(text: transition.metadata['description'] ?? '');
    final rolesController = TextEditingController(text: (transition.metadata['requiredRoles'] ?? []).join(', '));

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Transition'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Transition Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => Validators.validateNonEmptyText(value, 'Transition Name'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: rolesController,
                decoration: const InputDecoration(
                  labelText: 'Required Roles (comma-separated)',
                  border: OutlineInputBorder(),
                  helperText: 'Example: admin, manager, qa',
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: transition.fromStateId,
                decoration: const InputDecoration(
                  labelText: 'From State',
                  border: OutlineInputBorder(),
                ),
                items: _states.map((state) => DropdownMenuItem(
                  value: state.id,
                  child: Text(state.name),
                )).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _transitions[index] = transition.copyWith(fromStateId: value);
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: transition.toStateId,
                decoration: const InputDecoration(
                  labelText: 'To State',
                  border: OutlineInputBorder(),
                ),
                items: _states.map((state) => DropdownMenuItem(
                  value: state.id,
                  child: Text(state.name),
                )).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _transitions[index] = transition.copyWith(toStateId: value);
                    });
                  }
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final updatedTransition = transition.copyWith(
                name: nameController.text.trim(),
                metadata: {
                  'description': descriptionController.text.trim(),
                  'requiredRoles': rolesController.text
                      .split(',')
                      .map((role) => role.trim())
                      .where((role) => role.isNotEmpty)
                      .toList(),
                },
              );
              _editTransition(index, updatedTransition);
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800, maxHeight: 600),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.workflow == null ? 'Create Workflow' : 'Edit Workflow',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    hintText: 'Enter workflow name',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Name is required';
                    }
                    return null;
                  },
                  autofocus: true,
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
                const SizedBox(height: 24),

                // States Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Workflow States',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: _addState,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    itemCount: _states.length,
                    itemBuilder: (context, index) {
                      final state = _states[index];
                      return ListTile(
                        title: Text(state.name),
                        subtitle: Text('Description: ${state.metadata['description'] ?? ''}'),
                        leading: CircleAvatar(
                          backgroundColor: Color(int.parse(state.color.replaceFirst('#', '0xFF'))),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                              value: state.isInitial,
                              onChanged: (value) {
                                if (value == true) {
                                  setState(() {
                                    _states = _states.map((s) => s.copyWith(isInitial: false)).toList();
                                    final int stateIndex = _states.indexWhere((s) => s.id == state.id);
                                    if (stateIndex != -1) {
                                      _states[stateIndex] = _states[stateIndex].copyWith(isInitial: true);
                                    }
                                  });
                                }
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.color_lens),
                              onPressed: () => _showColorPicker(state, index),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _showStateEditDialog(state, index),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _removeState(index),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // Transitions Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Workflow Transitions',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: _addTransition,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    itemCount: _transitions.length,
                    itemBuilder: (context, index) {
                      final transition = _transitions[index];
                      final fromState = _states.firstWhere((s) => s.id == transition.fromStateId);
                      final toState = _states.firstWhere((s) => s.id == transition.toStateId);
                      
                      return ListTile(
                        title: Text('${fromState.name} → ${toState.name}'),
                        subtitle: Text('Description: ${transition.metadata['description'] ?? ''}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                _showTransitionEditDialog(transition, index);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _removeTransition(index),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Error Message Display
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: Theme.of(context).colorScheme.error),
                      textAlign: TextAlign.center,
                    ),
                  ),

                // Action Buttons
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: _isSubmitting ? null : _saveWorkflow,
                      child: _isSubmitting 
                        ? const CircularProgressIndicator()
                        : const Text('Save Workflow'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
