import 'package:flutter/material.dart';

import '../../../domain/entities/operations/workflow_template.dart';

class WorkflowEditorPage extends StatefulWidget {
  final WorkflowTemplate workflow;
  final ValueChanged<WorkflowTemplate> onSave;

  const WorkflowEditorPage({
    Key? key,
    required this.workflow,
    required this.onSave,
  }) : super(key: key);

  @override
  State<WorkflowEditorPage> createState() => _WorkflowEditorPageState();
}

class _WorkflowEditorPageState extends State<WorkflowEditorPage> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late List<WorkflowState> _states;
  late List<WorkflowTransition> _transitions;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.workflow.name);
    _descriptionController =
        TextEditingController(text: widget.workflow.description);
    _states = List.from(widget.workflow.states);
    _transitions = List.from(widget.workflow.transitions);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _addState() {
    final state = WorkflowState(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: 'New State',
      color: '#808080',
      isInitial: false,
      isFinal: false,
    );
    setState(() {
      _states.add(state);
    });
  }

  void _editState(int index) async {
    final state = _states[index];
    final result = await showDialog<WorkflowState>(
      context: context,
      builder: (context) => StateEditorDialog(state: state),
    );
    if (result != null && mounted) {
      setState(() {
        _states[index] = result;
      });
    }
  }

  void _removeState(String stateId) {
    setState(() {
      _states.removeWhere((s) => s.id == stateId);
      _transitions.removeWhere(
        (t) => t.fromStateId == stateId || t.toStateId == stateId,
      );
    });
  }

  void _addTransition() {
    if (_states.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Add at least 2 states to create a transition'),
        ),
      );
      return;
    }

    final transition = WorkflowTransition(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: 'New Transition',
      fromStateId: _states[0].id,
      toStateId: _states[1].id,
    );
    setState(() {
      _transitions.add(transition);
    });
  }

  void _editTransition(int index) async {
    final transition = _transitions[index];
    final result = await showDialog<WorkflowTransition>(
      context: context,
      builder: (context) => TransitionEditorDialog(
        transition: transition,
        states: _states,
      ),
    );
    if (result != null && mounted) {
      setState(() {
        _transitions[index] = result;
      });
    }
  }

  void _removeTransition(String transitionId) {
    setState(() {
      _transitions.removeWhere((t) => t.id == transitionId);
    });
  }

  void _save() {
    if (_formKey.currentState?.validate() ?? false) {
      final updatedWorkflow = widget.workflow.copyWith(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        states: _states,
        transitions: _transitions,
      );
      widget.onSave(updatedWorkflow);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Workflow'),
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text('Save'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Workflow Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter workflow name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'States',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: _addState,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _states.length,
                      itemBuilder: (context, index) {
                        final state = _states[index];
                        return ListTile(
                          leading: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Color(
                                int.parse(state.color.replaceAll('#', 'FF'),
                                    radix: 16),
                              ),
                              shape: BoxShape.circle,
                            ),
                          ),
                          title: Text(state.name),
                          subtitle: Text(
                            [
                              if (state.isInitial) 'Initial',
                              if (state.isFinal) 'Final',
                            ].join(' • '),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _editState(index),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _removeState(state.id),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Transitions',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: _addTransition,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _transitions.length,
                      itemBuilder: (context, index) {
                        final transition = _transitions[index];
                        final fromState = _states.firstWhere(
                          (s) => s.id == transition.fromStateId,
                          orElse: () => const WorkflowState(
                            id: '',
                            name: 'Unknown',
                            color: '#808080',
                            isInitial: false,
                            isFinal: false,
                          ),
                        );
                        final toState = _states.firstWhere(
                          (s) => s.id == transition.toStateId,
                          orElse: () => const WorkflowState(
                            id: '',
                            name: 'Unknown',
                            color: '#808080',
                            isInitial: false,
                            isFinal: false,
                          ),
                        );
                        return ListTile(
                          title: Text(transition.name),
                          subtitle: Text('${fromState.name} → ${toState.name}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _editTransition(index),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () =>
                                    _removeTransition(transition.id),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StateEditorDialog extends StatefulWidget {
  final WorkflowState state;

  const StateEditorDialog({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  State<StateEditorDialog> createState() => _StateEditorDialogState();
}

class _StateEditorDialogState extends State<StateEditorDialog> {
  late TextEditingController _nameController;
  late String _color;
  late bool _isInitial;
  late bool _isFinal;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.state.name);
    _color = widget.state.color;
    _isInitial = widget.state.isInitial;
    _isFinal = widget.state.isFinal;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit State'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Color'),
              trailing: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Color(
                    int.parse(_color.replaceAll('#', 'FF'), radix: 16),
                  ),
                  shape: BoxShape.circle,
                ),
              ),
              onTap: () {
                // TODO: Add color picker
              },
            ),
            CheckboxListTile(
              title: const Text('Initial State'),
              value: _isInitial,
              onChanged: (value) {
                if (value != null) {
                  setState(() => _isInitial = value);
                }
              },
            ),
            CheckboxListTile(
              title: const Text('Final State'),
              value: _isFinal,
              onChanged: (value) {
                if (value != null) {
                  setState(() => _isFinal = value);
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            final updatedState = widget.state.copyWith(
              name: _nameController.text.trim(),
              color: _color,
              isInitial: _isInitial,
              isFinal: _isFinal,
            );
            Navigator.pop(context, updatedState);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class TransitionEditorDialog extends StatefulWidget {
  final WorkflowTransition transition;
  final List<WorkflowState> states;

  const TransitionEditorDialog({
    Key? key,
    required this.transition,
    required this.states,
  }) : super(key: key);

  @override
  State<TransitionEditorDialog> createState() => _TransitionEditorDialogState();
}

class _TransitionEditorDialogState extends State<TransitionEditorDialog> {
  late TextEditingController _nameController;
  late String _fromStateId;
  late String _toStateId;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.transition.name);
    _fromStateId = widget.transition.fromStateId;
    _toStateId = widget.transition.toStateId;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Transition'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _fromStateId,
              decoration: const InputDecoration(
                labelText: 'From State',
                border: OutlineInputBorder(),
              ),
              items: widget.states.map((state) {
                return DropdownMenuItem(
                  value: state.id,
                  child: Text(state.name),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _fromStateId = value);
                }
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _toStateId,
              decoration: const InputDecoration(
                labelText: 'To State',
                border: OutlineInputBorder(),
              ),
              items: widget.states.map((state) {
                return DropdownMenuItem(
                  value: state.id,
                  child: Text(state.name),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _toStateId = value);
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            final updatedTransition = widget.transition.copyWith(
              name: _nameController.text.trim(),
              fromStateId: _fromStateId,
              toStateId: _toStateId,
            );
            Navigator.pop(context, updatedTransition);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
