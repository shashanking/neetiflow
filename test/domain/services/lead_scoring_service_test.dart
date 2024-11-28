import 'package:flutter_test/flutter_test.dart';
import 'package:neetiflow/domain/entities/lead.dart';
import 'package:neetiflow/domain/services/lead_scoring_service.dart';

void main() {
  late LeadScoringService scoringService;

  setUp(() {
    scoringService = LeadScoringService();
  });

  group('LeadScoringService', () {
    test('calculateScore returns score between 0 and 100', () {
      final lead = Lead(
        id: '1',
        firstName: 'Test',
        lastName: 'Lead',
        email: 'test@example.com',
        phone: '1234567890',
        subject: 'Test Lead',
        message: 'Test message',
        status: LeadStatus.warm,
        processStatus: ProcessStatus.inProgress,
        createdAt: DateTime.now(),
        score: 0.0,
        scoreFactors: {
          'interactions': 5.0,
          'profileCompleteness': 80.0,
          'engagement': 60.0,
          'dealPotential': 40.0,
        },
      );

      final score = scoringService.calculateScore(lead);
      expect(score, greaterThanOrEqualTo(0));
      expect(score, lessThanOrEqualTo(100));
    });

    test('getScoreColor returns correct color based on score', () {
      expect(scoringService.getScoreColor(30), equals('red'));
      expect(scoringService.getScoreColor(50), equals('yellow'));
      expect(scoringService.getScoreColor(80), equals('green'));
    });

    test('getScoreTrend returns correct trend symbol', () {
      final lead = Lead(
        id: '1',
        firstName: 'Test',
        lastName: 'Lead',
        email: 'test@example.com',
        phone: '1234567890',
        subject: 'Test Lead',
        message: 'Test message',
        status: LeadStatus.warm,
        processStatus: ProcessStatus.inProgress,
        createdAt: DateTime.now(),
        score: 75.0,
        scoreHistory: [
          ScoreHistory(
            timestamp: DateTime.now().subtract(const Duration(days: 1)),
            score: 75.0,
            reason: 'Initial score',
          ),
        ],
      );

      final leadIncrease = lead.copyWith(
        scoreHistory: [
          ScoreHistory(
            timestamp: DateTime.now().subtract(const Duration(days: 1)),
            score: 70.0,
            reason: 'Previous score',
          ),
          ScoreHistory(
            timestamp: DateTime.now(),
            score: 75.0,
            reason: 'Score increased',
          ),
        ],
      );

      expect(scoringService.getScoreTrend(leadIncrease), equals('↑'));

      final leadNoChange = lead.copyWith(
        scoreHistory: [
          ScoreHistory(
            timestamp: DateTime.now().subtract(const Duration(days: 1)),
            score: 75.0,
            reason: 'Previous score',
          ),
          ScoreHistory(
            timestamp: DateTime.now(),
            score: 75.0,
            reason: 'No change',
          ),
        ],
      );

      expect(scoringService.getScoreTrend(leadNoChange), equals('→'));

      final leadDecrease = lead.copyWith(
        scoreHistory: [
          ScoreHistory(
            timestamp: DateTime.now().subtract(const Duration(days: 1)),
            score: 80.0,
            reason: 'Previous score',
          ),
          ScoreHistory(
            timestamp: DateTime.now(),
            score: 75.0,
            reason: 'Score decreased',
          ),
        ],
      );

      expect(scoringService.getScoreTrend(leadDecrease), equals('↓'));
    });

    test('calculateScore weights factors correctly', () {
      final lead = Lead(
        id: '1',
        firstName: 'Test',
        lastName: 'Lead',
        email: 'test@example.com',
        phone: '1234567890',
        subject: 'Test Lead',
        message: 'Test message',
        status: LeadStatus.warm,
        processStatus: ProcessStatus.inProgress,
        createdAt: DateTime.now(),
        score: 0.0,
        scoreFactors: {
          'interactions': 100.0,    // 30% weight
          'profileCompleteness': 100.0,  // 20% weight
          'engagement': 100.0,      // 25% weight
          'dealPotential': 100.0,   // 25% weight
        },
      );

      final score = scoringService.calculateScore(lead);
      expect(score, equals(100));

      final leadPartialScores = lead.copyWith(
        scoreFactors: {
          'interactions': 50.0,     // 15 points
          'profileCompleteness': 50.0,   // 10 points
          'engagement': 50.0,       // 12.5 points
          'dealPotential': 50.0,    // 12.5 points
        },
      );

      final partialScore = scoringService.calculateScore(leadPartialScores);
      expect(partialScore, equals(50));
    });
  });
}
