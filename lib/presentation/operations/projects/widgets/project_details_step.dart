import 'package:flutter/material.dart';
import 'package:neetiflow/domain/entities/client.dart';
import 'package:neetiflow/presentation/core/widgets/client_selector.dart';

class ProjectDetailsStep extends StatelessWidget {
  final String? name;
  final Client? client;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? description;
  final bool showErrors;
  final Function(String) onNameChanged;
  final Function(Client) onClientChanged;
  final Function(DateTime) onStartDateChanged;
  final Function(DateTime) onEndDateChanged;
  final Function(String) onDescriptionChanged;

  const ProjectDetailsStep({
    super.key,
    this.name,
    this.client,
    this.startDate,
    this.endDate,
    this.description,
    this.showErrors = false,
    required this.onNameChanged,
    required this.onClientChanged,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
    required this.onDescriptionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProjectNameField(),
          const SizedBox(height: 24),
          _buildClientSelector(),
          const SizedBox(height: 24),
          _buildDateFields(context),
          const SizedBox(height: 24),
          _buildDescriptionField(),
        ],
      ),
    );
  }

  Widget _buildProjectNameField() {
    return TextFormField(
      initialValue: name,
      decoration: InputDecoration(
        labelText: 'Project Name',
        hintText: 'Enter a descriptive name for your project',
        prefixIcon: const Icon(Icons.edit_outlined),
        errorText: showErrors && (name?.isEmpty ?? true)
            ? 'Project name is required'
            : null,
      ),
      onChanged: onNameChanged,
      textInputAction: TextInputAction.next,
    );
  }

  Widget _buildClientSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Client',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        ClientSelector(
          selectedClient: client,
          onClientSelected: onClientChanged,
          showError: showErrors && client == null,
        ),
      ],
    );
  }

  Widget _buildDateFields(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildDateField(
            context,
            'Start Date',
            startDate,
            onStartDateChanged,
            endDate != null ? DateTime(2000) : null,
            endDate,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildDateField(
            context,
            'End Date',
            endDate,
            onEndDateChanged,
            startDate,
            null,
          ),
        ),
      ],
    );
  }

  Widget _buildDateField(
    BuildContext context,
    String label,
    DateTime? value,
    Function(DateTime) onChanged,
    DateTime? firstDate,
    DateTime? lastDate,
  ) {
    return FormField<DateTime>(
      initialValue: value,
      validator: (value) {
        if (showErrors && value == null) {
          return '$label is required';
        }
        return null;
      },
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: value ?? DateTime.now(),
                  firstDate: firstDate ?? DateTime.now(),
                  lastDate: lastDate ?? DateTime(2100),
                );
                if (date != null) {
                  onChanged(date);
                  state.didChange(date);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: state.hasError
                        ? Theme.of(context).colorScheme.error
                        : Colors.grey.shade300,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        value?.toString().split(' ')[0] ?? 'Select $label',
                        style: TextStyle(
                          color: value != null
                              ? Theme.of(context).textTheme.bodyLarge?.color
                              : Colors.grey.shade600,
                        ),
                      ),
                    ),
                    const Icon(Icons.calendar_today_outlined),
                  ],
                ),
              ),
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 8),
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
    );
  }

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Description',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: description,
          decoration: const InputDecoration(
            hintText: 'Describe your project objectives, scope, and key deliverables',
            border: OutlineInputBorder(),
          ),
          maxLines: 5,
          onChanged: onDescriptionChanged,
        ),
      ],
    );
  }
}
