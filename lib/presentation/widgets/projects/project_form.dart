import 'package:flutter/material.dart';
import 'package:neetiflow/domain/entities/operations/project.dart';
import 'package:neetiflow/domain/entities/operations/project_template.dart';
import 'package:neetiflow/presentation/widgets/common/date_picker_field.dart';
import 'package:neetiflow/presentation/widgets/common/dropdown_field.dart';
import 'package:neetiflow/presentation/widgets/projects/project_member_selector.dart';
import 'package:neetiflow/presentation/widgets/clients/client_selector.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/entities/client.dart';

class ProjectForm extends StatefulWidget {
  final void Function(Project project) onSubmit;
  final List<ProjectTemplate> availableTemplates;
  final Project? project;

  const ProjectForm({
    Key? key,
    required this.onSubmit,
    required this.availableTemplates,
    this.project,
  }) : super(key: key);

  @override
  State<ProjectForm> createState() => _ProjectFormState();
}

class _ProjectFormState extends State<ProjectForm> {
  final _formKey = GlobalKey<FormState>();
  
  // Form fields
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  ProjectTemplate? _selectedTemplate;
  Client? _selectedClient;
  List<ProjectMember> _selectedMembers = [];
  DateTime? _startDate;
  DateTime? _expectedEndDate;
  DateTime? _endDate;
  ProjectType? _selectedType;
  ProjectStatus? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.project?.name);
    _descriptionController = TextEditingController(text: widget.project?.description);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedTemplate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a project template')),
      );
      return;
    }
    if (_selectedClient == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a client')),
      );
      return;
    }
    if (_selectedMembers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one team member')),
      );
      return;
    }
    if (_startDate == null || _expectedEndDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please set project dates')),
      );
      return;
    }

    final client = _selectedClient ?? Client(
      id: '',
      firstName: '',
      lastName: '',
      email: '',
      phone: '',
      address: '',
      type: ClientType.company,
      status: ClientStatus.active,
      domain: ClientDomain.other,
      rating: 0.0,
      joiningDate: DateTime.now(),
      projects: [],
      lifetimeValue: 0.0,
    );

    final project = Project(
      id: widget.project?.id ?? const Uuid().v4(),
      name: _nameController.text,
      description: _descriptionController.text,
      type: _selectedType ?? ProjectType.custom,
      status: _selectedStatus ?? ProjectStatus.planning,
      clientId: client.id,
      client: client,
      phases: [],  
      milestones: [],  
      members: _selectedMembers.map((member) => ProjectMember(
        employeeName: member.employeeName,
        employeeId: member.employeeId,
        role: member.role,
        joinedAt: DateTime.now(), 
        access: ProjectAccess.view,  
      )).toList(),
      workflows: [],  
      organizationId: widget.project?.organizationId ?? '',  
      value: 0.0,  
      startDate: _startDate,
      endDate: _expectedEndDate,
      expectedEndDate: _expectedEndDate,
      createdBy: '',  
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    widget.onSubmit(project);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Project Template Selection
          DropdownField(
            label: 'Project Template',
            items: widget.availableTemplates.map((template) {
              return DropdownMenuItem(
                value: template,
                child: Text(template.name),
              );
            }).toList(),
            value: _selectedTemplate,
            onChanged: (template) {
              setState(() {
                _selectedTemplate = template;
              });
            },
          ),
          const SizedBox(height: 16),

          // Project Name
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Project Name',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a project name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Project Description
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),

          // Client Selection
          ClientSelector(
            onSelected: (client) {
              setState(() {
                _selectedClient = client;
              });
            },
          ),
          const SizedBox(height: 16),

          // Team Member Selection
          ProjectMemberSelector(
            onMembersSelected: (members) {
              setState(() {
                _selectedMembers = members;
              });
            },
          ),
          const SizedBox(height: 16),

          // Project Type
          DropdownField(
            label: 'Project Type',
            items: ProjectType.values.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text(type.toString()),
              );
            }).toList(),
            value: _selectedType,
            onChanged: (type) {
              setState(() {
                _selectedType = type;
              });
            },
          ),
          const SizedBox(height: 16),

          // Project Status
          DropdownField(
            label: 'Project Status',
            items: ProjectStatus.values.map((status) {
              return DropdownMenuItem(
                value: status,
                child: Text(status.toString()),
              );
            }).toList(),
            value: _selectedStatus,
            onChanged: (status) {
              setState(() {
                _selectedStatus = status;
              });
            },
          ),
          const SizedBox(height: 16),

          // Project Dates
          Row(
            children: [
              Expanded(
                child: DatePickerField(
                  label: 'Start Date',
                  selectedDate: _startDate,
                  onDateSelected: (date) {
                    setState(() {
                      _startDate = date;
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DatePickerField(
                  label: 'Expected End Date',
                  selectedDate: _expectedEndDate,
                  onDateSelected: (date) {
                    setState(() {
                      _expectedEndDate = date;
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DatePickerField(
                  label: 'End Date',
                  selectedDate: _endDate,
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

          // Submit Button
          Center(
            child: ElevatedButton(
              onPressed: _handleSubmit,
              child: const Text('Create Project'),
            ),
          ),
        ],
      ),
    );
  }
}
