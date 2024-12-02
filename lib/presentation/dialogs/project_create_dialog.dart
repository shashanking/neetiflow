import 'package:flutter/material.dart';
import 'package:neetiflow/domain/entities/client.dart';
import 'package:neetiflow/domain/entities/operations/project_template.dart';

class ProjectCreateDialog extends StatefulWidget {
  final List<Client> clients;
  final List<ProjectTemplate> templates;
  final Function(String name, String description, ProjectTemplate template, Client client,
      DateTime startDate, DateTime endDate) onSubmit;
  final VoidCallback emptyName;
  final VoidCallback noClient;
  final VoidCallback noTemplate;
  final VoidCallback noStartDate;
  final VoidCallback noEndDate;
  final VoidCallback invalidDates;
  final VoidCallback insufficientPermissions;
  final VoidCallback unableToUpdate;
  final VoidCallback unableToDelete;
  final VoidCallback unexpected;

  const ProjectCreateDialog({
    super.key,
    required this.clients,
    required this.templates,
    required this.onSubmit,
    required this.emptyName,
    required this.noClient,
    required this.noTemplate,
    required this.noStartDate,
    required this.noEndDate,
    required this.invalidDates,
    required this.insufficientPermissions,
    required this.unableToUpdate,
    required this.unableToDelete,
    required this.unexpected,
  });

  @override
  State<ProjectCreateDialog> createState() => _ProjectCreateDialogState();
}

class _ProjectCreateDialogState extends State<ProjectCreateDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  ProjectType _selectedType = ProjectType.custom;
  Client? _selectedClient;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 30));

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create New Project',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                if (widget.templates.isEmpty || widget.clients.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      widget.templates.isEmpty && widget.clients.isEmpty
                          ? 'Please create a template and add a client before creating a project.'
                          : widget.templates.isEmpty
                              ? 'Please create a template before creating a project.'
                              : 'Please add a client before creating a project.',
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                  ),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Project Name',
                    hintText: 'Enter project name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a project name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Enter project description',
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a project description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                if (widget.templates.isNotEmpty)
                  DropdownButtonFormField<ProjectTemplate>(
                    value: null,
                    decoration: const InputDecoration(
                      labelText: 'Project Template',
                    ),
                    items: widget.templates.map((template) {
                      return DropdownMenuItem(
                        value: template,
                        child: Text('${template.name} (${_getProjectTypeName(template.type)})'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedType = value.type;
                        });
                      }
                    },
                    validator: (value) {
                      if (value == null) {
                        widget.noTemplate();
                        return 'Please select a project template';
                      }
                      return null;
                    },
                  )
                else
                  const Center(
                    child: Text(
                      'No templates available. Please create a template first.',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                const SizedBox(height: 16),
                if (widget.clients.isNotEmpty)
                  DropdownButtonFormField<Client>(
                    value: _selectedClient,
                    decoration: const InputDecoration(
                      labelText: 'Client',
                      hintText: 'Select a client',
                    ),
                    items: widget.clients.map((client) {
                      return DropdownMenuItem(
                        value: client,
                        child: Text('${client.name} (${client.email})'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedClient = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        widget.noClient();
                        return 'Please select a client';
                      }
                      return null;
                    },
                  )
                else
                  const Center(
                    child: Text(
                      'No clients available. Please add clients first.',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _DatePickerField(
                        label: 'Start Date',
                        selectedDate: _startDate,
                        onDateSelected: (date) {
                          setState(() {
                            _startDate = date;
                            if (_endDate.isBefore(_startDate)) {
                              _endDate = _startDate.add(const Duration(days: 1));
                            }
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _DatePickerField(
                        label: 'End Date',
                        selectedDate: _endDate,
                        firstDate: _startDate.add(const Duration(days: 1)),
                        onDateSelected: (date) {
                          setState(() {
                            _endDate = date;
                          });
                        },
                      ),
                    ),
                  ],
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
                    FilledButton(
                      onPressed: widget.clients.isNotEmpty ? _submitForm : null,
                      child: const Text('Create Project'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() == true && _selectedClient != null) {
      // Find matching template
      final template = widget.templates.firstWhere(
        (t) => t.type == _selectedType,
        orElse: () => throw Exception('No template found for type $_selectedType'),
      );

      try {
        widget.onSubmit(
          _nameController.text,
          _descriptionController.text,
          template,
          _selectedClient!,
          _startDate,
          _endDate,
        );
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating project: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } else {
      // Show validation errors
      setState(() {});
    }
  }

  String _getProjectTypeName(ProjectType type) {
    switch (type) {
      case ProjectType.socialMedia:
        return 'Social Media';
      case ProjectType.ecommerce:
        return 'E-commerce';
      case ProjectType.appDevelopment:
        return 'App Development';
      case ProjectType.uiuxDesign:
        return 'UI/UX Design';
      case ProjectType.webDevelopment:
        return 'Web Development';
      case ProjectType.marketing:
        return 'Marketing';
      case ProjectType.custom:
        return 'Custom';
      case ProjectType.software:
        return 'Software';
      default:
        return 'Unknown';
    }
  }
}

class _DatePickerField extends StatelessWidget {
  final String label;
  final DateTime selectedDate;
  final DateTime? firstDate;
  final Function(DateTime) onDateSelected;

  const _DatePickerField({
    required this.label,
    required this.selectedDate,
    this.firstDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<DateTime>(
      initialValue: selectedDate,
      validator: (value) {
        if (value == null) {
          return 'Please select a date';
        }
        return null;
      },
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: firstDate ?? DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                );
                if (date != null) {
                  onDateSelected(date);
                  state.didChange(date);
                }
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: label,
                  errorText: state.errorText,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                    ),
                    const Icon(Icons.calendar_today_outlined),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
