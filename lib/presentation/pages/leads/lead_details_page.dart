import 'package:flutter/material.dart';
import 'package:neetiflow/domain/entities/lead.dart';
import 'package:neetiflow/presentation/widgets/leads/timeline_widget.dart';
import 'package:neetiflow/presentation/widgets/leads/lead_score_badge.dart';

class LeadDetailsPage extends StatelessWidget {
  final Lead lead;

  const LeadDetailsPage({Key? key, required this.lead}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${lead.firstName} ${lead.lastName}'),
        actions: [
          LeadScoreBadge(lead: lead),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoSection(context),
            const SizedBox(height: 24),
            _buildTimelineSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lead Information',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Name', '${lead.firstName} ${lead.lastName}'),
            _buildInfoRow('Email', lead.email),
            _buildInfoRow('Phone', lead.phone),
            _buildInfoRow('Subject', lead.subject),
            _buildInfoRow('Message', lead.message),
            _buildInfoRow('Status', lead.status.toString().split('.').last),
            _buildInfoRow('Process Status', lead.processStatus.toString().split('.').last),
            _buildInfoRow('Created At', _formatDate(lead.createdAt)),
            if (lead.score > 0) _buildInfoRow('Score', lead.score.toString()),
          ],
        ),
      ),
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
              height: 400, // Adjust height as needed
              child: TimelineWidget(
                events: lead.timelineEvents ?? [],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
  }
}
