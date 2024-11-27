import 'package:flutter/material.dart';
import 'package:neetiflow/domain/entities/lead.dart';

class LeadForm extends StatefulWidget {
  final Lead? lead;
  final Function(Lead) onSubmit;

  const LeadForm({
    super.key,
    this.lead,
    required this.onSubmit,
  });

  @override
  State<LeadForm> createState() => _LeadFormState();
}

class _LeadFormState extends State<LeadForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _subjectController;
  late TextEditingController _messageController;
  late LeadStatus _status;
  late ProcessStatus _processStatus;

  @override
  void initState() {
    super.initState();
    final lead = widget.lead;
    _firstNameController = TextEditingController(text: lead?.firstName ?? '');
    _lastNameController = TextEditingController(text: lead?.lastName ?? '');
    _emailController = TextEditingController(text: lead?.email ?? '');
    _phoneController = TextEditingController(text: lead?.phone ?? '');
    _subjectController = TextEditingController(text: lead?.subject ?? '');
    _messageController = TextEditingController(text: lead?.message ?? '');
    _status = lead?.status ?? LeadStatus.warm;
    _processStatus = lead?.processStatus ?? ProcessStatus.fresh;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      final lead = Lead(
        id: widget.lead?.id ?? '',  // New leads will get ID from repository
        uid: widget.lead?.uid ?? '', // New leads will get UID from repository
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        subject: _subjectController.text,
        message: _messageController.text,
        status: _status,
        processStatus: _processStatus,
        createdAt: widget.lead?.createdAt ?? DateTime.now(),
        metadata: widget.lead?.metadata,
        segments: widget.lead?.segments,
      );
      widget.onSubmit(lead);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _firstNameController,
                      decoration: const InputDecoration(
                        labelText: 'First Name',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter first name';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _lastNameController,
                      decoration: const InputDecoration(
                        labelText: 'Last Name',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter last name';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _subjectController,
                decoration: const InputDecoration(
                  labelText: 'Subject',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.subject),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter subject';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _messageController,
                decoration: const InputDecoration(
                  labelText: 'Message',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.message),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter message';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<LeadStatus>(
                      value: _status,
                      decoration: const InputDecoration(
                        labelText: 'Lead Status',
                        border: OutlineInputBorder(),
                      ),
                      items: LeadStatus.values.map((status) {
                        return DropdownMenuItem(
                          value: status,
                          child: Text(status.toString().split('.').last),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _status = value);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<ProcessStatus>(
                      value: _processStatus,
                      decoration: const InputDecoration(
                        labelText: 'Process Status',
                        border: OutlineInputBorder(),
                      ),
                      items: ProcessStatus.values.map((status) {
                        return DropdownMenuItem(
                          value: status,
                          child: Text(status.toString().split('.').last),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _processStatus = value);
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.cancel),
                    label: const Text('Cancel'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: _handleSubmit,
                    icon: const Icon(Icons.save),
                    label: Text(widget.lead == null ? 'Create' : 'Update'),
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
