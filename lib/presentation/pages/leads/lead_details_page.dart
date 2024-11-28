import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neetiflow/domain/entities/lead.dart';
import 'package:neetiflow/presentation/blocs/custom_fields/custom_fields_bloc.dart';
import 'package:neetiflow/presentation/widgets/custom_fields/custom_field_widget.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.lead.firstName} ${widget.lead.lastName}'),
        actions: [
          LeadScoreBadge(lead: widget.lead),
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
            _buildBasicInfo(),
            const SizedBox(height: 24),
            _buildCustomFields(),
            const SizedBox(height: 24),
            _buildTimelineSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfo() {
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
            _buildInfoRow('Name', '${widget.lead.firstName} ${widget.lead.lastName}'),
            _buildInfoRow('Email', widget.lead.email),
            _buildInfoRow('Phone', widget.lead.phone),
            _buildInfoRow('Subject', widget.lead.subject),
            _buildInfoRow('Message', widget.lead.message),
            _buildInfoRow(
                'Status', widget.lead.status.toString().split('.').last),
            _buildInfoRow('Process Status',
                widget.lead.processStatus.toString().split('.').last),
            _buildInfoRow(
                'Created At', widget.lead.createdAt.toLocal().toString()),
            if (widget.lead.updatedAt != null)
              _buildInfoRow(
                  'Updated At', widget.lead.updatedAt!.toLocal().toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomFields() {
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
                    final value = widget.lead.customFields[field.name];
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
