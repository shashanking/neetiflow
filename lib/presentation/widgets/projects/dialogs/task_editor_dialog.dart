import 'package:flutter/material.dart';
import 'package:neetiflow/domain/entities/operations/task.dart';
import 'package:neetiflow/utils/validators.dart';

class TaskEditorDialog extends StatefulWidget {
  final Task? task;
  final void Function(Task task) onSave;

  const TaskEditorDialog({
    Key? key,
    this.task,
    required this.onSave,
  }) : super(key: key);

  @override
  State<TaskEditorDialog> createState() => _TaskEditorDialogState();
}

class _TaskEditorDialogState extends State<TaskEditorDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  Priority _priority = Priority.medium;
  TaskStatus _status = TaskStatus.todo;
  DateTime? _dueDate;
  String? _assigneeId;
  List<String> _labels = [];

  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeTaskData();
  }

  void _initializeTaskData() {
    final task = widget.task;
    if (task != null) {
      _nameController.text = task.name;
      _descriptionController.text = task.description;
      _priority = task.priority;
      _status = task.status;
      _dueDate = task.dueDate;
      _assigneeId = task.assigneeId;
      _labels = List<String>.from(task.labels);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  bool _validateForm() {
    if (!_formKey.currentState!.validate()) {
      return false;
    }

    setState(() {
      _errorMessage = null;
    });

    if (_nameController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Task name is required';
      });
      return false;
    }

    if (_dueDate == null) {
      setState(() {
        _errorMessage = 'Due date is required';
      });
      return false;
    }

    if (_assigneeId == null) {
      setState(() {
        _errorMessage = 'Assignee is required';
      });
      return false;
    }

    return true;
  }

  void _handleSubmit() {
    if (_validateForm()) {
      final task = Task(
        id: widget.task?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        priority: _priority,
        status: _status,
        dueDate: _dueDate!,
        assigneeId: _assigneeId!,
        labels: _labels,
        createdAt: widget.task?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
        metadata: widget.task?.metadata ?? {},
      );

      widget.onSave(task);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Edit Task',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              
              // Title Field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Task Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => Validators.validateNonEmptyText(value, 'Task Title'),
              ),
              const SizedBox(height: 16),

              // Description Field
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (Optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              // Priority Dropdown
              DropdownButtonFormField<Priority>(
                value: _priority,
                decoration: const InputDecoration(
                  labelText: 'Priority',
                  border: OutlineInputBorder(),
                ),
                items: Priority.values.map((priority) {
                  return DropdownMenuItem(
                    value: priority,
                    child: Text(priority.name.toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _priority = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),

              // Status Dropdown
              DropdownButtonFormField<TaskStatus>(
                value: _status,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                items: TaskStatus.values.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status.name.toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _status = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),

              // Due Date Picker
              InputDatePickerFormField(
                initialDate: _dueDate ?? DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
                errorFormatText: 'Invalid date format',
                errorInvalidText: 'Invalid date',
                fieldLabelText: 'Due Date',
                onDateSaved: (date) {
                  setState(() {
                    _dueDate = date;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Assignee Field
              TextFormField(
                initialValue: _assigneeId,
                decoration: const InputDecoration(
                  labelText: 'Assignee',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => Validators.validateNonEmptyText(value, 'Assignee'),
                onFieldSubmitted: (value) {
                  setState(() {
                    _assigneeId = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Labels Section
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Add Label',
                        border: OutlineInputBorder(),
                      ),
                      onFieldSubmitted: (value) {
                        setState(() {
                          _labels.add(value.trim());
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: _labels.map((label) {
                  return Chip(
                    label: Text(label),
                    onDeleted: () => setState(() {
                      _labels.remove(label);
                    }),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Error Message Display
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                    textAlign: TextAlign.center,
                  ),
                ),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _handleSubmit,
                    child: const Text('Save Task'),
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
