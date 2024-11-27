import 'dart:async';
import 'package:neetiflow/domain/entities/lead.dart';
import 'package:neetiflow/domain/services/lead_scoring_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LeadScoreUpdateService {
  final FirebaseFirestore _firestore;
  final LeadScoringService _scoringService;
  Timer? _updateTimer;
  static const updateInterval = Duration(hours: 1);

  LeadScoreUpdateService({
    FirebaseFirestore? firestore,
    LeadScoringService? scoringService,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _scoringService = scoringService ?? LeadScoringService();

  void startPeriodicUpdates() {
    _updateTimer?.cancel();
    _updateTimer = Timer.periodic(updateInterval, (_) => updateAllLeadScores());
  }

  void stopPeriodicUpdates() {
    _updateTimer?.cancel();
    _updateTimer = null;
  }

  Future<void> updateAllLeadScores() async {
    try {
      final snapshot = await _firestore.collection('leads').get();
      
      for (final doc in snapshot.docs) {
        final lead = Lead.fromJson(doc.data());
        final updatedScore = _scoringService.calculateScore(lead);
        
        if (updatedScore != lead.score) {
          final scoreHistory = List<Map<String, dynamic>>.from(lead.scoreHistory ?? []);
          scoreHistory.add({
            'timestamp': DateTime.now().toIso8601String(),
            'oldScore': lead.score,
            'newScore': updatedScore,
            'reason': 'Automated periodic update',
          });

          await doc.reference.update({
            'score': updatedScore,
            'scoreHistory': scoreHistory,
            'lastScoreUpdate': DateTime.now().toIso8601String(),
          });
        }
      }
    } catch (e) {
      print('Error updating lead scores: $e');
    }
  }

  Future<void> updateSingleLeadScore(String leadId) async {
    try {
      final doc = await _firestore.collection('leads').doc(leadId).get();
      if (!doc.exists) return;

      final lead = Lead.fromJson(doc.data()!);
      final updatedScore = _scoringService.calculateScore(lead);

      if (updatedScore != lead.score) {
        final scoreHistory = List<Map<String, dynamic>>.from(lead.scoreHistory ?? []);
        scoreHistory.add({
          'timestamp': DateTime.now().toIso8601String(),
          'oldScore': lead.score,
          'newScore': updatedScore,
          'reason': 'Manual update',
        });

        await doc.reference.update({
          'score': updatedScore,
          'scoreHistory': scoreHistory,
          'lastScoreUpdate': DateTime.now().toIso8601String(),
        });
      }
    } catch (e) {
      print('Error updating lead score: $e');
    }
  }
}
