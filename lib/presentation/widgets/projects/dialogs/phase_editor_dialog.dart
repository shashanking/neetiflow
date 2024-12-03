import 'package:flutter/material.dart';
import 'package:neetiflow/domain/entities/operations/task.dart';
import 'package:neetiflow/utils/validators.dart';
import 'package:neetiflow/presentation/widgets/projects/dialogs/task_editor_dialog.dart';

import '../../../../domain/entities/operations/phase.dart';

class PhaseEditorDialog extends StatefulWidget {
  final Phase? phase;
  final ValueChanged<Phase> onSave;

  const PhaseEditorDialog({
    Key? key,
    this.phase,
    required this.onSave,
  }) : super(key: key);

  @override
  State<PhaseEditorDialog> createState() => _PhaseEditorDialogState();
}

class _PhaseEditorDialogState extends State<PhaseEditorDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  List<Task> _tasks = [];
  Duration _estimatedDuration = const Duration(days: 7);
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializePhaseData();
  }

  void _initializePhaseData() {
    final phase = widget.phase;
    _nameController.text = phase?.name ?? '';
    _descriptionController.text = phase?.description ?? '';
    _tasks = List.from(phase?.defaultTasks ?? []);
    _estimatedDuration = phase?.estimatedDuration ?? const Duration(days: 7);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _addTask() {
    _showTaskEditor(null);
  }

  void _editTask(int index) {
    _showTaskEditor(_tasks[index], index);
  }

  void _showTaskEditor(Task? task, [int? index]) {
    showDialog(
      context: context,
      builder: (context) => TaskEditorDialog(
        task: task,
        onSave: (updatedTask) {
          setState(() {
            if (index != null) {
              _tasks[index] = updatedTask;
            } else {
              _tasks.add(updatedTask);
            }
          });
        },
      ),
    );
  }

  void _removeTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  bool _validateForm() {
    setState(() {
      _errorMessage = null;
    });

    if (_nameController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Phase name is required';
      });
      return false;
    }

    if (_tasks.isEmpty) {
      setState(() {
        _errorMessage = 'At least one task is required';
      });
      return false;
    }

    if (_estimatedDuration.inDays < 1) {
      setState(() {
        _errorMessage = 'Phase duration must be at least 1 day';
      });
      return false;
    }

    return true;
  }

  void _savePhase() {
    if (_validateForm()) {
      final phase = Phase(
        id: widget.phase?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        order: widget.phase?.order ?? 0,
        startDate: DateTime.now(), // You might want to replace this with an actual date selection
        endDate: DateTime.now().add(_estimatedDuration),
        estimatedDuration: _estimatedDuration,
        taskIds: _tasks.map((task) => task.id).toList(),
        defaultTasks: _tasks,
        isCompleted: widget.phase?.isCompleted ?? false,
        createdAt: widget.phase?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      widget.onSave(phase);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Edit Phase',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Phase Name',
                  border: const OutlineInputBorder(),
                  errorText: _errorMessage?.contains('name') == true ? _errorMessage : null,
                ),
                validator: (value) => Validators.validateNonEmptyText(value, 'Phase Name'),
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
              Row(
                children: [
                  const Text('Estimated Duration:'),
                  const SizedBox(width: 16),
                  DropdownButton<int>(
                    value: _estimatedDuration.inDays,
                    items: List.generate(30, (index) => index + 1)
                        .map((days) => DropdownMenuItem(
                              value: days,
                              child: Text('$days days'),
                            ))
                        .toList(),
                    onChanged: (days) {
                      if (days != null) {
                        setState(() {
                          _estimatedDuration = Duration(days: days);
                        });
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Default Tasks',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _addTask,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (_tasks.isEmpty)
                const Text(
                  'No tasks added yet',
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  itemCount: _tasks.length,
                  itemBuilder: (context, index) {
                    final task = _tasks[index];
                    return ListTile(
                      title: Text(task.name),
                      subtitle: Text(task.description),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _editTask(index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _removeTask(index),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                    textAlign: TextAlign.center,
                  ),
                ),
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
                    onPressed: _savePhase,
                    child: const Text('Save Phase'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
