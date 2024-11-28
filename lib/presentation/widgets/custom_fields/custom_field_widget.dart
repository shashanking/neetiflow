import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:neetiflow/domain/entities/custom_field.dart';

class CustomFieldWidget extends StatelessWidget {
  final CustomField field;
  final dynamic value;
  final bool readOnly;
  final ValueChanged<dynamic>? onChanged;

  const CustomFieldWidget({
    super.key,
    required this.field,
    this.value,
    this.readOnly = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (field.label.isNotEmpty) ...[
          Text(
            field.label,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
        ],
        _buildFieldWidget(),
        if (field.description != null && field.description!.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            field.description!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).hintColor,
                ),
          ),
        ],
      ],
    );
  }

  Widget _buildFieldWidget() {
    switch (field.type) {
      case CustomFieldType.text:
      case CustomFieldType.email:
      case CustomFieldType.url:
      case CustomFieldType.phone:
        return _buildTextField();
      case CustomFieldType.number:
      case CustomFieldType.currency:
        return _buildNumberField();
      case CustomFieldType.date:
        return _buildDateField();
      case CustomFieldType.dropdown:
        return _buildDropdownField();
      case CustomFieldType.checkbox:
        return _buildCheckboxField();
      case CustomFieldType.textarea:
        return _buildTextAreaField();
    }
  }

  Widget _buildTextField() {
    return TextFormField(
      initialValue: value?.toString() ?? '',
      decoration: InputDecoration(
        hintText: field.placeholder,
        border: const OutlineInputBorder(),
      ),
      readOnly: readOnly,
      keyboardType: _getKeyboardType(),
      validator: _buildValidator(),
      onChanged: onChanged,
    );
  }

  Widget _buildNumberField() {
    return TextFormField(
      initialValue: value?.toString() ?? '',
      decoration: InputDecoration(
        hintText: field.placeholder,
        border: const OutlineInputBorder(),
        prefixIcon: field.type == CustomFieldType.currency
            ? const Icon(Icons.attach_money)
            : null,
      ),
      readOnly: readOnly,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      validator: _buildValidator(),
      onChanged: onChanged,
    );
  }

  Widget _buildDateField() {
    return Builder(
      builder: (context) {
        final formattedDate = value != null
            ? DateFormat('yyyy-MM-dd').format(value as DateTime)
            : 'Select Date';

        return InkWell(
          onTap: readOnly ? null : () => _showDatePicker(context),
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: field.label,
              hintText: 'Select Date',
              helperText: field.description,
              enabled: !readOnly,
              border: const OutlineInputBorder(),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(formattedDate),
                if (!readOnly) const Icon(Icons.calendar_today),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDropdownField() {
    final options = field.validation.allowedValues ?? [];
    return DropdownButtonFormField<String>(
      value: value as String?,
      decoration: InputDecoration(
        hintText: field.placeholder,
        border: const OutlineInputBorder(),
      ),
      items: options.map((option) {
        return DropdownMenuItem(
          value: option,
          child: Text(option),
        );
      }).toList(),
      onChanged: readOnly ? null : onChanged,
    );
  }

  Widget _buildCheckboxField() {
    return CheckboxListTile(
      title: Text(field.label),
      value: value as bool? ?? false,
      onChanged: readOnly ? null : (bool? newValue) {
        if (onChanged != null) {
          onChanged!(newValue);
        }
      },
      controlAffinity: ListTileControlAffinity.leading,
    );
  }

  Widget _buildTextAreaField() {
    return TextFormField(
      initialValue: value?.toString() ?? '',
      decoration: InputDecoration(
        hintText: field.placeholder,
        border: const OutlineInputBorder(),
      ),
      readOnly: readOnly,
      maxLines: 4,
      validator: _buildValidator(),
      onChanged: onChanged,
    );
  }

  TextInputType _getKeyboardType() {
    switch (field.type) {
      case CustomFieldType.email:
        return TextInputType.emailAddress;
      case CustomFieldType.phone:
        return TextInputType.phone;
      case CustomFieldType.url:
        return TextInputType.url;
      default:
        return TextInputType.text;
    }
  }

  FormFieldValidator<String>? _buildValidator() {
    return (value) {
      if (field.validation.required && (value == null || value.isEmpty)) {
        return 'This field is required';
      }

      if (value != null && value.isNotEmpty) {
        if (field.validation.regex != null) {
          final regex = RegExp(field.validation.regex!);
          if (!regex.hasMatch(value)) {
            return 'Invalid format';
          }
        }

        switch (field.type) {
          case CustomFieldType.email:
            final emailRegex = RegExp(
              r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
            );
            if (!emailRegex.hasMatch(value)) {
              return 'Invalid email format';
            }
            break;
          case CustomFieldType.url:
            final urlRegex = RegExp(
              r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)',
            );
            if (!urlRegex.hasMatch(value)) {
              return 'Invalid URL format';
            }
            break;
          case CustomFieldType.phone:
            final phoneRegex = RegExp(r'^\+?[\d\s-]+$');
            if (!phoneRegex.hasMatch(value)) {
              return 'Invalid phone number format';
            }
            break;
          default:
            break;
        }
      }

      return null;
    };
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final initialDate = value as DateTime? ?? DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && onChanged != null) {
      onChanged!(pickedDate);
    }
  }
}
