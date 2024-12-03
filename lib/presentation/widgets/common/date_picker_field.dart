import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerField extends StatelessWidget {
  final String label;
  final DateTime? selectedDate;
  final void Function(DateTime date) onDateSelected;
  final bool enabled;

  const DatePickerField({
    Key? key,
    required this.label,
    this.selectedDate,
    required this.onDateSelected,
    this.enabled = true,
  }) : super(key: key);

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != selectedDate) {
      onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: TextEditingController(
        text: selectedDate != null
            ? DateFormat('MMM d, yyyy').format(selectedDate!)
            : '',
      ),
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: enabled ? () => _selectDate(context) : null,
        ),
      ),
      readOnly: true,
      enabled: enabled,
      onTap: enabled ? () => _selectDate(context) : null,
    );
  }
}
