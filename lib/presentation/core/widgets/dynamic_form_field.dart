import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import '../../../domain/entities/operations/project_template.dart';

class DynamicFormField extends StatelessWidget {
  final TemplateField field;
  final Function(dynamic) onChanged;
  final dynamic initialValue;

  const DynamicFormField({
    super.key,
    required this.field,
    required this.onChanged,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    switch (field.type) {
      case 'text':
        return _buildTextField();
      case 'number':
        return _buildNumberField();
      case 'date':
        return _buildDateField(context);
      case 'select':
        return _buildSelectField();
      case 'multiselect':
        return _buildMultiSelectField(context);
      case 'file':
        return _buildFileField();
      default:
        return _buildTextField();
    }
  }

  Widget _buildTextField() {
    return TextFormField(
      initialValue: initialValue as String?,
      decoration: InputDecoration(
        labelText: field.name,
        helperText: field.description,
        helperMaxLines: 2,
      ),
      onChanged: onChanged,
      validator: field.isRequired
          ? (value) => value?.isEmpty ?? true ? 'This field is required' : null
          : null,
    );
  }

  Widget _buildNumberField() {
    return TextFormField(
      initialValue: (initialValue as num?)?.toString(),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: field.name,
        helperText: field.description,
        helperMaxLines: 2,
      ),
      onChanged: (value) {
        final number = num.tryParse(value);
        onChanged(number);
      },
      validator: field.isRequired
          ? (value) {
              if (value?.isEmpty ?? true) return 'This field is required';
              if (num.tryParse(value!) == null) return 'Please enter a valid number';
              return null;
            }
          : null,
    );
  }

  Widget _buildDateField(BuildContext context) {
    return FormField<DateTime>(
      initialValue: initialValue as DateTime?,
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              field.name,
              style: const TextStyle(fontSize: 16),
            ),
            if (field.description != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  field.description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: state.value ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (date != null) {
                  state.didChange(date);
                  onChanged(date);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      state.value?.toString() ?? 'Select Date',
                      style: TextStyle(
                        color: state.value != null
                            ? Colors.black87
                            : Colors.grey.shade600,
                      ),
                    ),
                    Icon(
                      Icons.calendar_today,
                      color: Colors.grey.shade600,
                    ),
                  ],
                ),
              ),
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  state.errorText!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
      validator: field.isRequired
          ? (value) => value == null ? 'This field is required' : null
          : null,
    );
  }

  Widget _buildSelectField() {
    return FormField<String>(
      initialValue: initialValue as String?,
      builder: (FormFieldState<String> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              field.name,
              style: const TextStyle(fontSize: 16),
            ),
            if (field.description != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  field.description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ),
            const SizedBox(height: 8),
            Builder(
              builder: (BuildContext context) => DropdownButtonFormField<String>(
                value: state.value,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                ),
                items: field.options.map((option) {
                  return DropdownMenuItem(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (value) {
                  state.didChange(value);
                  onChanged(value);
                },
              ),
            ),
            if (state.hasError)
              Builder(
                builder: (BuildContext context) => Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    state.errorText!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
      validator: field.isRequired
          ? (value) => value == null ? 'This field is required' : null
          : null,
    );
  }

  Widget _buildMultiSelectField(BuildContext context) {
    return FormField<List<String>>(
      initialValue: initialValue as List<String>?,
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              field.name,
              style: const TextStyle(fontSize: 16),
            ),
            if (field.description != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  field.description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: field.options?.map((option) {
                final isSelected = state.value?.contains(option) ?? false;
                return FilterChip(
                  label: Text(option),
                  selected: isSelected,
                  onSelected: (selected) {
                    final newValue = List<String>.from(state.value ?? []);
                    if (selected) {
                      newValue.add(option);
                    } else {
                      newValue.remove(option);
                    }
                    state.didChange(newValue);
                    onChanged(newValue);
                  },
                );
              }).toList() ?? [],
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  state.errorText!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
      validator: field.isRequired
          ? (value) =>
              value == null || value.isEmpty ? 'This field is required' : null
          : null,
    );
  }

  Widget _buildFileField() {
    return FormField<String>(
      initialValue: initialValue as String?,
      builder: (FormFieldState<String> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              field.name,
              style: const TextStyle(fontSize: 16),
            ),
            if (field.description != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  field.description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ),
            const SizedBox(height: 8),
            Builder(
              builder: (BuildContext context) => InkWell(
                onTap: () async {
                  try {
                    final result = await FilePicker.platform.pickFiles(
                      type: FileType.any,
                      allowMultiple: false,
                      withData: false,
                      withReadStream: true,
                    );
                    if (result != null && result.files.isNotEmpty) {
                      final file = result.files.first;
                      state.didChange(file.path);
                      onChanged({
                        'path': file.path,
                        'name': file.name,
                        'size': file.size,
                        'extension': file.extension,
                      });
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error picking file: $e'),
                        backgroundColor: Theme.of(context).colorScheme.error,
                      ),
                    );
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.upload_file,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          state.value ?? 'Click to upload file',
                          style: TextStyle(
                            color: state.value != null
                                ? Colors.black87
                                : Colors.grey.shade600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (state.value != null)
                        IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            state.didChange(null);
                            onChanged(null);
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),
            if (state.hasError)
              Builder(
                builder: (BuildContext context) => Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    state.errorText!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
      validator: field.isRequired
          ? (value) => value == null ? 'This field is required' : null
          : null,
    );
  }
}
