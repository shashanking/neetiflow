import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neetiflow/domain/entities/employee.dart';
import 'package:neetiflow/domain/entities/lead.dart';
import 'package:neetiflow/presentation/blocs/custom_fields/custom_fields_bloc.dart';
import 'package:neetiflow/presentation/blocs/employees/employees_bloc.dart';
import 'package:neetiflow/presentation/blocs/leads/leads_bloc.dart';
import 'package:neetiflow/presentation/widgets/custom_fields/custom_field_widget.dart';
import 'package:neetiflow/presentation/widgets/leads/lead_assignment_dialog.dart';
import 'package:neetiflow/presentation/widgets/leads/lead_score_badge.dart';
import 'package:neetiflow/presentation/widgets/leads/timeline_widget.dart';

import '../../../data/repositories/leads_repository.dart';
import '../../../domain/entities/timeline_event.dart';

class LeadDetailsPage extends StatefulWidget {
  final Lead lead;
  final String organizationId;

  const LeadDetailsPage({
    super.key,
    required this.lead,
    required this.organizationId,
  });

  @override
  State<LeadDetailsPage> createState() => _LeadDetailsPageState();
}

class _LeadDetailsPageState extends State<LeadDetailsPage> {
  late final LeadsRepository _leadsRepository;
  late final Stream<List<TimelineEvent>> _timelineStream;

  @override
  void initState() {
    super.initState();
    _leadsRepository = RepositoryProvider.of<LeadsRepository>(context);
    _timelineStream = _leadsRepository.getTimelineEvents(
      widget.organizationId,
      widget.lead.id,
    );
    context.read<CustomFieldsBloc>().add(LoadCustomFields());
    context.read<EmployeesBloc>().add(LoadEmployees(widget.organizationId));
  }

  @override
  void dispose() {
    if (mounted) {
      context.read<LeadsBloc>().add(DeselectLead(leadId: widget.lead.id));
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = LeadsBloc(
          leadsRepository: _leadsRepository,
          organizationId: widget.organizationId,
        );
        bloc.add(const LoadLeads());
        bloc.add(SelectLead(leadId: widget.lead.id));
        return bloc;
      },
      child: BlocBuilder<LeadsBloc, LeadsState>(
        builder: (context, state) {
          final currentLead = state.status == LeadsStatus.success && state.selectedLeadId == widget.lead.id
              ? state.allLeads.firstWhere((l) => l.id == widget.lead.id, orElse: () => widget.lead)
              : widget.lead;

          return Scaffold(
            appBar: AppBar(
              title: Text('${currentLead.firstName} ${currentLead.lastName}'),
              actions: [
                LeadScoreBadge(lead: currentLead),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // Navigate to edit page
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBasicInfo(currentLead),
                  const SizedBox(height: 24),
                  _buildCustomFields(currentLead),
                  const SizedBox(height: 24),
                  _buildTimelineSection(context),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBasicInfo(Lead lead) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Basic Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Name', '${lead.firstName} ${lead.lastName}'),
            _buildInfoRow('Email', lead.email),
            _buildInfoRow('Phone', lead.phone),
            _buildInfoRow('Subject', lead.subject),
            _buildInfoRow('Message', lead.message),
            _buildInfoRow('Status', lead.status.toString().split('.').last),
            _buildInfoRow('Process Status', lead.processStatus.toString().split('.').last),
            _buildInfoRow('Created At', lead.createdAt.toLocal().toString()),
            if (lead.updatedAt != null)
              _buildInfoRow('Updated At', lead.updatedAt!.toLocal().toString()),
            if (lead.metadata?['assignedEmployeeId'] != null) ...[
              const Divider(height: 32),
              const Text(
                'Assignment Information',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              BlocBuilder<EmployeesBloc, EmployeesState>(
                builder: (context, state) {
                  if (state is EmployeesLoading) {
                    return const Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  }

                  if (state is EmployeesLoaded) {
                    final assignedEmployee = state.employees.firstWhere(
                      (e) => e.id == lead.metadata!['assignedEmployeeId'],
                      orElse: () => const Employee(
                        firstName: 'Unknown',
                        lastName: 'Employee',
                        email: '',
                        role: EmployeeRole.employee,
                      ),
                    );

                    final assignedByEmployee = state.employees.firstWhere(
                      (e) => e.id == lead.metadata!['assignedByEmployeeId'],
                      orElse: () => const Employee(
                        firstName: 'Unknown',
                        lastName: 'Employee',
                        email: '',
                        role: EmployeeRole.employee,
                      ),
                    );

                    final assignedAt = DateTime.tryParse(
                      lead.metadata!['assignedAt'] ?? '',
                    );

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                              child: Text(
                                '${assignedEmployee.firstName[0]}${assignedEmployee.lastName[0]}',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${assignedEmployee.firstName} ${assignedEmployee.lastName}',
                                    style: Theme.of(context).textTheme.titleSmall,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    assignedEmployee.email,
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _showAssignmentDialog(context, lead),
                              tooltip: 'Reassign Lead',
                            ),
                          ],
                        ),
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Assigned by: ${assignedByEmployee.firstName} ${assignedByEmployee.lastName}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                            if (assignedAt != null)
                              Text(
                                assignedAt.toString(),
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                          ],
                        ),
                      ],
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showAssignmentDialog(BuildContext context, Lead lead) {
    showDialog(
      context: context,
      builder: (dialogContext) => LeadAssignmentDialog(
        lead: lead,
        leadsBloc: context.read<LeadsBloc>(),
      ),
    );
  }

  Widget _buildCustomFields(Lead lead) {
    return BlocBuilder<CustomFieldsBloc, CustomFieldsState>(
      builder: (context, state) {
        if (state is CustomFieldsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is CustomFieldsError) {
          return Text(
            'Error loading custom fields: ${state.message}',
            style: const TextStyle(color: Colors.red),
          );
        }

        if (state is CustomFieldsLoaded) {
          final activeFields =
              state.fields.where((field) => field.isActive).toList();

          if (activeFields.isEmpty) {
            return const SizedBox.shrink();
          }

          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Custom Fields',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...activeFields.map((field) {
                    final value = lead.customFields[field.name];
                    if (value == null) return const SizedBox.shrink();

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: CustomFieldWidget(
                        field: field,
                        value: value,
                        readOnly: true,
                      ),
                    );
                  }),
                ],
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildTimelineSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Timeline',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 400,
              child: StreamBuilder<List<TimelineEvent>>(
                stream: _timelineStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error loading timeline: ${snapshot.error}',
                        style: TextStyle(color: Colors.red[700]),
                      ),
                    );
                  }

                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return TimelineWidget(
                    events: snapshot.data!,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
