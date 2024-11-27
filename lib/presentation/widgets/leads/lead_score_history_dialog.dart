import 'package:flutter/material.dart';
import 'package:neetiflow/domain/entities/lead.dart';
import 'package:neetiflow/domain/services/lead_scoring_service.dart';
import 'package:fl_chart/fl_chart.dart';

class LeadScoreHistoryDialog extends StatelessWidget {
  final Lead lead;
  final LeadScoringService _scoringService = LeadScoringService();

  LeadScoreHistoryDialog({super.key, required this.lead});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 24),
            _buildScoreFactors(),
            const SizedBox(height: 24),
            _buildScoreHistory(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lead Score Details',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(
              'Current Score: ${lead.score.toStringAsFixed(0)}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: _getScoreColor(),
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  Widget _buildScoreFactors() {
    final factors = lead.scoreFactors ?? {};
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Score Components',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildScoreCard(
                'Interaction',
                factors['interaction'] ?? 0,
                Colors.blue,
                Icons.people,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildScoreCard(
                'Profile',
                factors['profile'] ?? 0,
                Colors.green,
                Icons.person,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildScoreCard(
                'Engagement',
                factors['engagement'] ?? 0,
                Colors.orange,
                Icons.trending_up,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildScoreCard(
                'Deal Potential',
                factors['deal'] ?? 0,
                Colors.purple,
                Icons.attach_money,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildScoreCard(
    String title,
    double score,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            score.toStringAsFixed(0),
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreHistory() {
    final history = lead.scoreHistory ?? [];
    if (history.isEmpty) {
      return const Center(
        child: Text('No score history available'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Score History',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              gridData: const FlGridData(show: false),
              titlesData: const FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              minX: 0,
              maxX: (history.length - 1).toDouble(),
              minY: 0,
              maxY: 100,
              lineBarsData: [
                LineChartBarData(
                  spots: history
                      .asMap()
                      .entries
                      .map((e) => FlSpot(
                            e.key.toDouble(),
                            e.value.score,
                          ))
                      .toList(),
                  isCurved: true,
                  color: _getScoreColor(),
                  barWidth: 2,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: true),
                  belowBarData: BarAreaData(
                    show: true,
                    color: _getScoreColor().withOpacity(0.1),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildHistoryList(history),
      ],
    );
  }

  Widget _buildHistoryList(List<ScoreHistory> history) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        itemCount: history.length,
        itemBuilder: (context, index) {
          final item = history[history.length - 1 - index];
          return ListTile(
            dense: true,
            title: Text(item.reason),
            subtitle: Text(
              _formatDate(item.timestamp),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            trailing: Text(
              item.score.toStringAsFixed(0),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
  }

  Color _getScoreColor() {
    final colorName = _scoringService.getScoreColor(lead.score);
    switch (colorName) {
      case 'red':
        return Colors.red;
      case 'yellow':
        return Colors.amber;
      case 'green':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
