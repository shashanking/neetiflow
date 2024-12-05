import 'package:flutter/material.dart';
import 'package:neetiflow/utils/validators.dart';

import '../../../../domain/entities/operations/milestone.dart';

class MilestoneEditorDialog extends StatefulWidget {
  final Milestone? milestone;
  final ValueChanged<Milestone> onSave;

  const MilestoneEditorDialog({
    super.key,
    this.milestone,
    required this.onSave,
  });

  @override
  State<MilestoneEditorDialog> createState() => _MilestoneEditorDialogState();
}

class _MilestoneEditorDialogState extends State<MilestoneEditorDialog> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeMilestoneData();
  }

  void _initializeMilestoneData() {
    _nameController = TextEditingController(text: widget.milestone?.name ?? '');
    _descriptionController = TextEditingController(text: widget.milestone?.description ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  bool _validateForm() {
    setState(() {
      _errorMessage = null;
    });

    if (_nameController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Milestone name is required';
      });
      return false;
    }

    return true;
  }

  void _saveMilestone() {
    if (_validateForm()) {
      try {
        setState(() {
          _isSubmitting = true;
        });

        final milestone = Milestone(
          id: widget.milestone?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim(),
          order: widget.milestone?.order ?? 0,
          dueDate: DateTime.now(), // You might want to replace this with an actual date selection
          completed: widget.milestone?.completed ?? false,
        );

        widget.onSave(milestone);
        Navigator.of(context).pop();
      } catch (e) {
        setState(() {
          _errorMessage = 'Failed to save milestone: ${e.toString()}';
          _isSubmitting = false;
        });
      }
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
                'Edit Milestone',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              
              // Name Field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Milestone Name',
                  border: const OutlineInputBorder(),
                  errorText: _errorMessage?.contains('name') == true ? _errorMessage : null,
                ),
                validator: (value) => Validators.validateNonEmptyText(value, 'Milestone Name'),
              ),

              // Description Field
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (Optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),

              // Error Message Display
              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                  textAlign: TextAlign.center,
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
                    onPressed: _isSubmitting ? null : _saveMilestone,
                    child: _isSubmitting 
                      ? const CircularProgressIndicator()
                      : const Text('Save Milestone'),
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
