import 'package:flutter/material.dart';

import '../../../domain/entities/operations/milestone.dart';

class MilestoneEditorPage extends StatefulWidget {
  final Milestone milestone;
  final ValueChanged<Milestone> onSave;

  const MilestoneEditorPage({
    Key? key,
    required this.milestone,
    required this.onSave,
  }) : super(key: key);

  @override
  State<MilestoneEditorPage> createState() => _MilestoneEditorPageState();
}

class _MilestoneEditorPageState extends State<MilestoneEditorPage> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.milestone.name);
    _descriptionController = TextEditingController(text: widget.milestone.description);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState?.validate() ?? false) {
      final updatedMilestone = widget.milestone.copyWith(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        dueDate: DateTime.now(), // You might want to replace this with an actual date selection
        order: widget.milestone.order, // Preserve the existing order
      );
      widget.onSave(updatedMilestone);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Milestone'),
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
                labelText: 'Milestone Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter milestone name';
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
          ],
        ),
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
