import 'package:flutter/material.dart';
import 'package:neetiflow/domain/entities/operations/task.dart';

import '../../../domain/entities/operations/phase.dart';

class PhaseEditorPage extends StatefulWidget {
  final Phase phase;
  final ValueChanged<Phase> onSave;

  const PhaseEditorPage({
    Key? key,
    required this.phase,
    required this.onSave,
  }) : super(key: key);

  @override
  State<PhaseEditorPage> createState() => _PhaseEditorPageState();
}

class _PhaseEditorPageState extends State<PhaseEditorPage> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late List<Task> _tasks;
  late Duration _estimatedDuration;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.phase.name);
    _descriptionController = TextEditingController(text: widget.phase.description);
    _tasks = List.from(widget.phase.defaultTasks);
    _estimatedDuration = widget.phase.estimatedDuration;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _addTask() {
    setState(() {
      _tasks.add(Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: 'New Task',
        description: '',
        status: TaskStatus.todo,
        assigneeId: '',
        dueDate: DateTime.now().add(const Duration(days: 7)),
        priority: Priority.medium,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));
    });
  }

  void _removeTask(String taskId) {
    setState(() {
      _tasks.removeWhere((task) => task.id == taskId);
    });
  }

  void _updateTask(int index, Task updatedTask) {
    setState(() {
      _tasks[index] = updatedTask;
    });
  }

  void _save() {
    if (_formKey.currentState?.validate() ?? false) {
      final updatedPhase = widget.phase.copyWith(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        defaultTasks: _tasks,
        estimatedDuration: _estimatedDuration,
      );
      widget.onSave(updatedPhase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Phase'),
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
                labelText: 'Phase Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter phase name';
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
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Estimated Duration'),
              subtitle: Text('${_estimatedDuration.inDays} days'),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  final days = await showDialog<int>(
                    context: context,
                    builder: (context) => NumberPickerDialog(
                      minValue: 1,
                      maxValue: 365,
                      initialValue: _estimatedDuration.inDays,
                      title: 'Set Duration (Days)',
                    ),
                  );
                  if (days != null && mounted) {
                    setState(() {
                      _estimatedDuration = Duration(days: days);
                    });
                  }
                },
              ),
            ),
            const SizedBox(height: 16),
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
                          'Default Tasks',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: _addTask,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _tasks.length,
                      itemBuilder: (context, index) {
                        final task = _tasks[index];
                        return TaskListItem(
                          task: task,
                          onDelete: () => _removeTask(task.id),
                          onUpdate: (updatedTask) => _updateTask(index, updatedTask),
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

class TaskListItem extends StatelessWidget {
  final Task task;
  final VoidCallback onDelete;
  final ValueChanged<Task> onUpdate;

  const TaskListItem({
    Key? key,
    required this.task,
    required this.onDelete,
    required this.onUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(task.name),
      subtitle: Text(task.description),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(task.priority.name),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final result = await showDialog<Task>(
                context: context,
                builder: (context) => TaskEditorDialog(task: task),
              );
              if (result != null) {
                onUpdate(result);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}

class NumberPickerDialog extends StatefulWidget {
  final int minValue;
  final int maxValue;
  final int initialValue;
  final String title;

  const NumberPickerDialog({
    Key? key,
    required this.minValue,
    required this.maxValue,
    required this.initialValue,
    required this.title,
  }) : super(key: key);

  @override
  State<NumberPickerDialog> createState() => _NumberPickerDialogState();
}

class _NumberPickerDialogState extends State<NumberPickerDialog> {
  late int _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: _selectedValue > widget.minValue
                ? () => setState(() => _selectedValue--)
                : null,
          ),
          Text(
            _selectedValue.toString(),
            style: const TextStyle(fontSize: 20),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _selectedValue < widget.maxValue
                ? () => setState(() => _selectedValue++)
                : null,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, _selectedValue),
          child: const Text('OK'),
        ),
      ],
    );
  }
}

class TaskEditorDialog extends StatefulWidget {
  final Task task;

  const TaskEditorDialog({
    Key? key,
    required this.task,
  }) : super(key: key);

  @override
  State<TaskEditorDialog> createState() => _TaskEditorDialogState();
}

class _TaskEditorDialogState extends State<TaskEditorDialog> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late Priority _priority;
  late DateTime _dueDate;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.task.name);
    _descriptionController = TextEditingController(text: widget.task.description);
    _priority = widget.task.priority;
    _dueDate = widget.task.dueDate;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Task'),
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
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            ListTile(
              title: const Text('Due Date'),
              subtitle: Text(_dueDate.toString().split(' ')[0]),
              trailing: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _dueDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    setState(() => _dueDate = date);
                  }
                },
              ),
            ),
            DropdownButtonFormField<Priority>(
              value: _priority,
              decoration: const InputDecoration(
                labelText: 'Priority',
                border: OutlineInputBorder(),
              ),
              items: Priority.values.map((priority) {
                return DropdownMenuItem(
                  value: priority,
                  child: Text(priority.name),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _priority = value);
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
            final updatedTask = widget.task.copyWith(
              name: _nameController.text.trim(),
              description: _descriptionController.text.trim(),
              priority: _priority,
              dueDate: _dueDate,
              updatedAt: DateTime.now(),
            );
            Navigator.pop(context, updatedTask);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
