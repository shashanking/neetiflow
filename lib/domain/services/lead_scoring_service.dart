import 'package:neetiflow/domain/entities/lead.dart';

class LeadScoringService {
  static const double _interactionWeight = 0.30;
  static const double _profileWeight = 0.20;
  static const double _engagementWeight = 0.25;
  static const double _dealWeight = 0.25;

  /// Calculate the overall lead score based on various factors
  double calculateScore(Lead lead) {
    final interactionScore = _calculateInteractionScore(lead);
    final profileScore = _calculateProfileScore(lead);
    final engagementScore = _calculateEngagementScore(lead);
    final dealScore = _calculateDealScore(lead);

    final weightedScore = (interactionScore * _interactionWeight) +
        (profileScore * _profileWeight) +
        (engagementScore * _engagementWeight) +
        (dealScore * _dealWeight);

    return _normalizeScore(weightedScore);
  }

  /// Calculate interaction score based on communication history
  double _calculateInteractionScore(Lead lead) {
    double score = 0.0;
    final metadata = lead.metadata ?? {};

    // Email responses (max 25 points)
    final emailResponses = metadata['emailResponses'] as int? ?? 0;
    score += _normalizeValue(emailResponses, 10) * 25;

    // Meetings attended (max 25 points)
    final meetingsAttended = metadata['meetingsAttended'] as int? ?? 0;
    score += _normalizeValue(meetingsAttended, 5) * 25;

    // Call duration in minutes (max 25 points)
    final callDuration = metadata['callDuration'] as int? ?? 0;
    score += _normalizeValue(callDuration, 60) * 25;

    // Document views (max 25 points)
    final documentViews = metadata['documentViews'] as int? ?? 0;
    score += _normalizeValue(documentViews, 5) * 25;

    return score;
  }

  /// Calculate profile completeness score
  double _calculateProfileScore(Lead lead) {
    double score = 0.0;
    final metadata = lead.metadata ?? {};

    // Basic information completeness (max 40 points)
    score += lead.firstName.isNotEmpty ? 10 : 0;
    score += lead.lastName.isNotEmpty ? 10 : 0;
    score += lead.email.isNotEmpty ? 10 : 0;
    score += lead.phone.isNotEmpty ? 10 : 0;

    // Company information (max 30 points)
    final hasCompanyInfo = metadata['companyInfo'] as bool? ?? false;
    if (hasCompanyInfo) score += 30;

    // Additional details (max 30 points)
    final additionalFields = metadata['additionalFields'] as int? ?? 0;
    score += _normalizeValue(additionalFields, 5) * 30;

    return score;
  }

  /// Calculate engagement score based on user activity and timeline events
  double _calculateEngagementScore(Lead lead) {
    double score = 0.0;
    final metadata = lead.metadata ?? {};
    final timelineEvents = lead.timelineEvents;

    // Timeline activity frequency (max 30 points)
    if (timelineEvents.isNotEmpty) {
      final now = DateTime.now();
      final thirtyDaysAgo = now.subtract(const Duration(days: 30));
      
      // Count recent timeline events
      final recentEvents = timelineEvents.where(
        (event) => event.timestamp.isAfter(thirtyDaysAgo)
      ).length;
      score += _normalizeValue(recentEvents, 20) * 30;

      // Calculate activity diversity (max 20 points)
      final uniqueCategories = timelineEvents
          .map((e) => e.category)
          .toSet()
          .length;
      score += _normalizeValue(uniqueCategories, 5) * 20;

      // Recent activity bonus (max 25 points)
      final lastEvent = timelineEvents
          .reduce((a, b) => a.timestamp.isAfter(b.timestamp) ? a : b);
      final daysSinceLastActivity = now.difference(lastEvent.timestamp).inDays;
      score += (1 - _normalizeValue(daysSinceLastActivity, 30)) * 25;
    }

    // Communication frequency per week (max 25 points)
    final weeklyComms = metadata['weeklyComms'] as int? ?? 0;
    score += _normalizeValue(weeklyComms, 10) * 25;

    return score;
  }

  /// Calculate potential deal score
  double _calculateDealScore(Lead lead) {
    double score = 0.0;
    final metadata = lead.metadata ?? {};

    // Budget indication (max 40 points)
    final budgetScore = metadata['budgetScore'] as int? ?? 0;
    score += _normalizeValue(budgetScore, 100) * 40;

    // Decision timeline (max 30 points)
    final decisionTimelineScore = metadata['decisionTimelineScore'] as int? ?? 0;
    score += _normalizeValue(decisionTimelineScore, 100) * 30;

    // Authority level (max 30 points)
    final authorityScore = metadata['authorityScore'] as int? ?? 0;
    score += _normalizeValue(authorityScore, 100) * 30;

    return score;
  }

  /// Calculate days since last activity
  int _daysSinceLastActivity(Lead lead) {
    final metadata = lead.metadata ?? {};
    final lastActivity = metadata['lastActivityDate'] as String?;
    if (lastActivity == null) return 30; // Default to maximum if no activity

    final lastActivityDate = DateTime.parse(lastActivity);
    return DateTime.now().difference(lastActivityDate).inDays;
  }

  /// Normalize a value between 0 and 1 based on a maximum value
  double _normalizeValue(num value, num max) {
    return (value / max).clamp(0.0, 1.0);
  }

  /// Normalize final score to be between 0 and 100
  double _normalizeScore(double score) {
    return score.clamp(0.0, 100.0);
  }

  /// Get score trend (↑, ↓, →) based on history
  String getScoreTrend(Lead lead) {
    final history = lead.scoreHistory;
    if (history == null || history.length < 2) return '→';

    final currentScore = history.last.score;
    final previousScore = history[history.length - 2].score;

    if ((currentScore - previousScore).abs() < 1) return '→';
    return currentScore > previousScore ? '↑' : '↓';
  }

  /// Get color for score visualization
  String getScoreColor(double score) {
    if (score <= 40) return 'red';
    if (score <= 70) return 'yellow';
    return 'green';
  }
}
