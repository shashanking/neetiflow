import 'package:flutter/material.dart';
import 'package:neetiflow/domain/entities/lead.dart';
import 'package:neetiflow/domain/services/lead_scoring_service.dart';
import 'package:neetiflow/presentation/widgets/leads/lead_score_history_dialog.dart';

class LeadScoreBadge extends StatelessWidget {
  final Lead lead;
  final LeadScoringService _scoringService = LeadScoringService();

  LeadScoreBadge({super.key, required this.lead});

  void _showScoreHistory(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => LeadScoreHistoryDialog(lead: lead),
    );
  }

  Color _getScoreColor() {
    final colorName = _scoringService.getScoreColor(lead.score);
    switch (colorName) {
      case 'red':
        return Colors.red.shade100;
      case 'yellow':
        return Colors.amber.shade100;
      case 'green':
        return Colors.green.shade100;
      default:
        return Colors.grey.shade100;
    }
  }

  Color _getScoreTextColor() {
    final colorName = _scoringService.getScoreColor(lead.score);
    switch (colorName) {
      case 'red':
        return Colors.red.shade900;
      case 'yellow':
        return Colors.amber.shade900;
      case 'green':
        return Colors.green.shade900;
      default:
        return Colors.grey.shade900;
    }
  }

  @override
  Widget build(BuildContext context) {
    final trend = _scoringService.getScoreTrend(lead);
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showScoreHistory(context),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getScoreColor(),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                lead.score.toStringAsFixed(0),
                style: TextStyle(
                  color: _getScoreTextColor(),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                trend,
                style: TextStyle(
                  color: _getScoreTextColor(),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
