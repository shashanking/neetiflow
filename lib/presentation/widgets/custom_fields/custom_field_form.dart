import 'package:flutter/material.dart';
import 'package:neetiflow/domain/entities/custom_field.dart';
import 'package:uuid/uuid.dart';

class CustomFieldForm extends StatefulWidget {
  final CustomField? field;
  final Function(CustomField) onSave;

  const CustomFieldForm({
    super.key,
    this.field,
    required this.onSave,
  });

  @override
  State<CustomFieldForm> createState() => _CustomFieldFormState();
}

class _CustomFieldFormState extends State<CustomFieldForm> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _label;
  late CustomFieldType _type;
  late bool _required;
  late String? _description;
  late String? _placeholder;
  late String? _regex;
  late List<String> _allowedValues;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    final field = widget.field;
    if (field != null) {
      _name = field.name;
      _label = field.label;
      _type = field.type;
      _required = field.validation.required;
      _description = field.description;
      _placeholder = field.placeholder;
      _regex = field.validation.regex;
      _allowedValues = field.validation.allowedValues ?? [];
      _isActive = field.isActive;
    } else {
      _name = '';
      _label = '';
      _type = CustomFieldType.text;
      _required = false;
      _description = null;
      _placeholder = null;
      _regex = null;
      _allowedValues = [];
      _isActive = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            initialValue: _name,
            decoration: const InputDecoration(
              labelText: 'Field Name*',
              hintText: 'Enter a unique identifier for this field',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a field name';
              }
              if (!RegExp(r'^[a-zA-Z][a-zA-Z0-9_]*$').hasMatch(value)) {
                return 'Field name must start with a letter and contain only letters, numbers, and underscores';
              }
              return null;
            },
            onSaved: (value) => _name = value!,
          ),
          const SizedBox(height: 16),
          TextFormField(
            initialValue: _label,
            decoration: const InputDecoration(
              labelText: 'Display Label*',
              hintText: 'Enter the label to display for this field',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a display label';
              }
              return null;
            },
            onSaved: (value) => _label = value!,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<CustomFieldType>(
            value: _type,
            decoration: const InputDecoration(
              labelText: 'Field Type*',
              border: OutlineInputBorder(),
            ),
            items: CustomFieldType.values.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text(type.toString().split('.').last),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _type = value!;
              });
            },
          ),
          const SizedBox(height: 16),
          CheckboxListTile(
            title: const Text('Required Field'),
            value: _required,
            onChanged: (value) {
              setState(() {
                _required = value!;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
          ),
          const SizedBox(height: 16),
          TextFormField(
            initialValue: _description,
            decoration: const InputDecoration(
              labelText: 'Description',
              hintText: 'Enter a description for this field',
              border: OutlineInputBorder(),
            ),
            onSaved: (value) => _description = value,
          ),
          const SizedBox(height: 16),
          TextFormField(
            initialValue: _placeholder,
            decoration: const InputDecoration(
              labelText: 'Placeholder',
              hintText: 'Enter placeholder text',
              border: OutlineInputBorder(),
            ),
            onSaved: (value) => _placeholder = value,
          ),
          const SizedBox(height: 16),
          if (_type == CustomFieldType.dropdown) ...[
            _buildAllowedValuesField(),
            const SizedBox(height: 16),
          ],
          TextFormField(
            initialValue: _regex,
            decoration: const InputDecoration(
              labelText: 'Validation Pattern',
              hintText: 'Enter a regular expression for validation',
              border: OutlineInputBorder(),
            ),
            onSaved: (value) => _regex = value,
          ),
          const SizedBox(height: 16),
          CheckboxListTile(
            title: const Text('Active'),
            value: _isActive,
            onChanged: (value) {
              setState(() {
                _isActive = value!;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveField,
              child: const Text('Save Field'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllowedValuesField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Allowed Values'),
        const SizedBox(height: 8),
        ..._allowedValues.asMap().entries.map((entry) {
          final index = entry.key;
          final value = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: value,
                    decoration: InputDecoration(
                      labelText: 'Option ${index + 1}',
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (newValue) {
                      setState(() {
                        _allowedValues[index] = newValue;
                      });
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () {
                    setState(() {
                      _allowedValues.removeAt(index);
                    });
                  },
                ),
              ],
            ),
          );
        // ignore: unnecessary_to_list_in_spreads
        }).toList(),
        TextButton.icon(
          onPressed: () {
            setState(() {
              _allowedValues.add('');
            });
          },
          icon: const Icon(Icons.add),
          label: const Text('Add Option'),
        ),
      ],
    );
  }

  void _saveField() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final field = CustomField(
        id: widget.field?.id ?? const Uuid().v4(),
        name: _name,
        label: _label,
        type: _type,
        validation: CustomFieldValidation(
          required: _required,
          regex: _regex,
          allowedValues: _type == CustomFieldType.dropdown ? _allowedValues : null,
        ),
        description: _description,
        placeholder: _placeholder,
        isActive: _isActive,
        createdAt: widget.field?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      widget.onSave(field);
    }
  }
}
