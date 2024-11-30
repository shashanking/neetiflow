import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neetiflow/domain/entities/lead.dart';
import 'package:neetiflow/presentation/blocs/auth/auth_bloc.dart';
import 'package:neetiflow/presentation/blocs/custom_fields/custom_fields_bloc.dart';
import 'package:neetiflow/presentation/widgets/custom_fields/custom_field_widget.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../data/repositories/custom_fields_repository.dart';
import '../../../domain/entities/custom_field.dart';
import '../../../domain/entities/custom_field_value.dart';
import '../../../domain/entities/timeline_event.dart';
import 'status_note_dialog.dart';

class LeadForm extends StatefulWidget {
  final Lead? lead;
  final Function(Lead) onSave;

  const LeadForm({
    super.key,
    this.lead,
    required this.onSave,
  });

  @override
  State<LeadForm> createState() => _LeadFormState();
}

class _LeadFormState extends State<LeadForm> {
  final _formKey = GlobalKey<FormState>();
  late String _firstName;
  late String _lastName;
  late String _email;
  late String _phone;
  late String _subject;
  late String _message;
  late LeadStatus _status;
  late ProcessStatus _processStatus;
  late Map<String, CustomFieldValue> _customFieldValues = {};

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    final lead = widget.lead;
    if (lead != null) {
      _firstName = lead.firstName;
      _lastName = lead.lastName;
      _email = lead.email;
      _phone = lead.phone;
      _subject = lead.subject;
      _message = lead.message;
      _status = lead.status;
      _processStatus = lead.processStatus;
      _customFieldValues = Map<String, CustomFieldValue>.from(lead.customFields
          .map((key, value) => MapEntry(
              key,
              // ignore: unnecessary_type_check
              value is CustomFieldValue
                  ? value
                  : CustomFieldValue(
                      fieldId: key, value: value, updatedAt: DateTime.now()))));
    } else {
      _firstName = '';
      _lastName = '';
      _email = '';
      _phone = '';
      _subject = '';
      _message = '';
      _status = LeadStatus.cold;
      _processStatus = ProcessStatus.fresh;
      _customFieldValues = {};
    }
  }

  Future<bool> _handleStatusChange(
    String title,
    String oldValue,
    String newValue,
  ) async {
    final note = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatusNoteDialog(
        title: title,
        oldValue: oldValue,
        newValue: newValue,
      ),
    );

    if (note == null) return false;

    final event = TimelineEvent(
      id: const Uuid().v4(),
      leadId: widget.lead?.id ?? '',
      title: title,
      description: note,
      timestamp: DateTime.now(),
      category: 'status_change',
      metadata: {
        'old_value': oldValue,
        'new_value': newValue,
      },
    );

    // Update the lead with the new event
    final lead = Lead(
      id: widget.lead?.id ?? const Uuid().v4(),
      firstName: _firstName,
      lastName: _lastName,
      email: _email,
      phone: _phone,
      subject: _subject,
      message: _message,
      status: _status,
      processStatus: _processStatus,
      createdAt: widget.lead?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
      customFields: _customFieldValues,
      timelineEvents: [
        ...widget.lead?.timelineEvents ?? [],
        event,
      ],
    );

    widget.onSave(lead);
    return true;
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      final lead = Lead(
        id: widget.lead?.id ?? const Uuid().v4(),
        firstName: _firstName,
        lastName: _lastName,
        email: _email,
        phone: _phone,
        subject: _subject,
        message: _message,
        status: _status,
        processStatus: _processStatus,
        createdAt: widget.lead?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
        customFields: _customFieldValues,
        timelineEvents: widget.lead?.timelineEvents ?? [],
      );
      widget.onSave(lead);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<CustomFieldsRepository>(
          create: (context) {
            final authState = context.read<AuthBloc>().state;
            String organizationId = '';

            if (authState is Authenticated) {
              organizationId = authState.employee.companyId ?? '';
            }

            return CustomFieldsRepository(
              organizationId: organizationId,
            );
          },
        ),
        ProxyProvider<CustomFieldsRepository, CustomFieldsBloc>(
          create: (context) => CustomFieldsBloc(
            repository: context.read<CustomFieldsRepository>(),
            entityType: 'leads',
            organizationId: context.read<AuthBloc>().state is Authenticated
                ? (context.read<AuthBloc>().state as Authenticated).employee.companyId ?? ''
                : '',
          ),
          update: (context, repository, bloc) =>
              bloc ?? CustomFieldsBloc(
                repository: repository,
                entityType: 'leads',
                organizationId: context.read<AuthBloc>().state is Authenticated
                    ? (context.read<AuthBloc>().state as Authenticated).employee.companyId ?? ''
                    : '',
              ),
          lazy: false, // Ensure the bloc is created immediately
        ),
      ],
      child: Material(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: BlocBuilder<CustomFieldsBloc, CustomFieldsState>(
              builder: (context, customFieldState) {
                // Trigger loading of custom fields
                if (customFieldState is! CustomFieldsLoaded &&
                    customFieldState is! CustomFieldsLoading) {
                  context.read<CustomFieldsBloc>().add(LoadCustomFields());
                }

                if (customFieldState is CustomFieldsLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (customFieldState is CustomFieldsError) {
                  return Center(
                    child: Text(
                      'Error loading custom fields: ${customFieldState.message}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                final List<CustomField> customFields =
                    customFieldState is CustomFieldsLoaded
                        ? customFieldState.fields
                        : [];

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: _firstName,
                              decoration: const InputDecoration(
                                labelText: 'First Name',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.person),
                              ),
                              onChanged: (value) => _firstName = value,
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
                              initialValue: _lastName,
                              decoration: const InputDecoration(
                                labelText: 'Last Name',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.person_outline),
                              ),
                              onChanged: (value) => _lastName = value,
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
                        initialValue: _email,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email),
                        ),
                        onChanged: (value) => _email = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter email';
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        initialValue: _phone,
                        decoration: const InputDecoration(
                          labelText: 'Phone',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.phone),
                        ),
                        onChanged: (value) => _phone = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter phone number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        initialValue: _subject,
                        decoration: const InputDecoration(
                          labelText: 'Subject',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.subject),
                        ),
                        onChanged: (value) => _subject = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter subject';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        initialValue: _message,
                        decoration: const InputDecoration(
                          labelText: 'Message',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.message),
                        ),
                        maxLines: 3,
                        onChanged: (value) => _message = value,
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
                                labelText: 'Status',
                                border: OutlineInputBorder(),
                              ),
                              items: LeadStatus.values.map((status) {
                                return DropdownMenuItem(
                                  value: status,
                                  child:
                                      Text(status.toString().split('.').last),
                                );
                              }).toList(),
                              onChanged: (newStatus) async {
                                if (newStatus == null) return;

                                final oldStatus = _status;
                                if (oldStatus != newStatus) {
                                  final success = await _handleStatusChange(
                                    'Lead Status Changed',
                                    oldStatus.toString().split('.').last,
                                    newStatus.toString().split('.').last,
                                  );

                                  if (success) {
                                    setState(() {
                                      _status = newStatus;
                                    });
                                  }
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
                                  child:
                                      Text(status.toString().split('.').last),
                                );
                              }).toList(),
                              onChanged: (newStatus) async {
                                if (newStatus == null) return;

                                final oldStatus = _processStatus;
                                if (oldStatus != newStatus) {
                                  final success = await _handleStatusChange(
                                    'Process Status Changed',
                                    oldStatus.toString().split('.').last,
                                    newStatus.toString().split('.').last,
                                  );

                                  if (success) {
                                    setState(() {
                                      _processStatus = newStatus;
                                    });
                                  }
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Dynamic Custom Fields
                      if (customFields.isNotEmpty) ...[
                        const Text(
                          'Custom Fields',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...customFields.map((field) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: CustomFieldWidget(
                                field: field,
                                value: _customFieldValues[field.id]?.value,
                                onChanged: (value) {
                                  setState(() {
                                    _customFieldValues[field.id] =
                                        CustomFieldValue(
                                            fieldId: field.id,
                                            value: value,
                                            updatedAt: DateTime.now());
                                  });
                                },
                              ),
                            )),
                      ],
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _handleSubmit,
                        child: const Text('Save Lead'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
