import 'dart:convert'; // added import for jsonDecode

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'custom_field_value.dart';
import 'timeline_event.dart';

enum LeadStatus { warm, cold, hot }

enum ProcessStatus { fresh, inProgress, completed, rejected }

class Lead extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final String subject;
  final String message;
  final LeadStatus status;
  final ProcessStatus processStatus;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final Map<String, dynamic>? metadata;
  final List<String>? segments;
  final double score; // Overall lead score (0-100)
  final Map<String, double>? scoreFactors; // Individual factor scores
  final List<ScoreHistory>? scoreHistory; // Track score changes over time
  final Map<String, CustomFieldValue> customFields;
  final List<TimelineEvent> timelineEvents;

  const Lead({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.subject,
    required this.message,
    required this.status,
    required this.processStatus,
    required this.createdAt,
    this.updatedAt,
    this.metadata,
    this.segments,
    this.score = 0.0,
    this.scoreFactors,
    this.scoreHistory,
    this.customFields = const {},
    this.timelineEvents = const [],
  });

  factory Lead.fromJson(Map<String, dynamic> json) {
    // Handle different timestamp formats
    DateTime parseTimestamp(dynamic timestamp) {
      if (timestamp == null) return DateTime.now();
      if (timestamp is Timestamp) return timestamp.toDate();
      if (timestamp is String) return DateTime.parse(timestamp);
      if (timestamp is int) {
        return DateTime.fromMillisecondsSinceEpoch(timestamp);
      }
      return DateTime.now();
    }

    return Lead(
      id: json['id'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      email: json['email'] as String? ?? '',
      subject: json['subject'] as String? ?? '',
      message: json['message'] as String? ?? '',
      status: _parseLeadStatus(json['status']),
      processStatus: _parseProcessStatus(json['processStatus']),
      createdAt: parseTimestamp(json['createdAt']),
      updatedAt: json['updatedAt'] != null ? parseTimestamp(json['updatedAt']) : null,
      metadata: json['metadata'] as Map<String, dynamic>?,
      segments: json['segments'] != null
          ? List<String>.from(json['segments'] as List)
          : null,
      score: (json['score'] as num?)?.toDouble() ?? 0.0,
      scoreFactors: (json['scoreFactors'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(key, (value as num).toDouble()),
      ),
      scoreHistory: (json['scoreHistory'] as List<dynamic>?)
          ?.map((e) => ScoreHistory.fromJson(e as Map<String, dynamic>))
          .toList(),
      customFields: (json['customFields'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(
              key,
              CustomFieldValue.fromJson(value as Map<String, dynamic>),
            ),
          ) ??
          {},
      timelineEvents: (json['timelineEvents'] as List<dynamic>?)
          ?.map((e) => TimelineEvent.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'email': email,
      'subject': subject,
      'message': message,
      'status': status.toString().split('.').last,
      'processStatus': processStatus.toString().split('.').last,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt?.toIso8601String(),
      'metadata': metadata,
      'segments': segments,
      'score': score,
      'scoreFactors': scoreFactors,
      'scoreHistory': scoreHistory?.map((h) => h.toJson()).toList(),
      'customFields': customFields.map(
        (key, value) => MapEntry(key, value.toJson()),
      ),
      'timelineEvents': timelineEvents.map((event) => event.toJson()).toList(),
    };
  }

  factory Lead.fromCSV(List<String> row,
      {Map<String, int> headers = const {}}) {
    String getValue(String key) {
      // Try both with and without spaces
      var index = headers[key.toLowerCase()];
      index ??= headers[key.toLowerCase().replaceAll(' ', '')];
      if (index == null) throw Exception('Column $key not found in CSV');
      return row[index];
    }

    return Lead(
      id: getValue('id'),
      firstName: getValue('first name'),
      lastName: getValue('last name'),
      phone: getValue('phone'),
      email: getValue('email'),
      subject: getValue('subject'),
      message: getValue('msg'),
      status: _parseLeadStatus(getValue('status')),
      processStatus: _parseProcessStatus(getValue('process status')),
      createdAt: DateTime.parse(getValue('created at')),
      updatedAt: getValue('updated at') != ''
          ? DateTime.parse(getValue('updated at'))
          : null,
      metadata: _parseMetadata(getValue('metadata')),
      segments: _parseSegments(getValue('segments')),
      score: double.parse(getValue('score')),
      scoreFactors: _parseScoreFactors(getValue('score factors')),
      scoreHistory: _parseScoreHistory(getValue('score history')),
      customFields: const {}, // Initialize customFields as an empty map
      timelineEvents: const [], // Initialize timelineEvents as an empty list
    );
  }

  static LeadStatus _parseLeadStatus(dynamic status) {
    if (status == null) return LeadStatus.cold;
    final statusStr = status.toString().toLowerCase();
    return LeadStatus.values.firstWhere(
      (e) => e.toString().split('.').last.toLowerCase() == statusStr,
      orElse: () => LeadStatus.cold,
    );
  }

  static ProcessStatus _parseProcessStatus(dynamic status) {
    if (status == null) return ProcessStatus.fresh;
    final statusStr = status.toString().toLowerCase();
    return ProcessStatus.values.firstWhere(
      (e) => e.toString().split('.').last.toLowerCase() == statusStr,
      orElse: () => ProcessStatus.fresh,
    );
  }

  static Map<String, dynamic>? _parseMetadata(String metadata) {
    try {
      if (metadata.isEmpty) return null;
      return Map<String, dynamic>.from(
        jsonDecode(metadata),
      );
    } catch (e) {
      return null;
    }
  }

  static List<String>? _parseSegments(String segments) {
    try {
      if (segments.isEmpty) return null;
      return List<String>.from(
        jsonDecode(segments),
      );
    } catch (e) {
      return null;
    }
  }

  static Map<String, double>? _parseScoreFactors(String scoreFactors) {
    try {
      if (scoreFactors.isEmpty) return null;
      return Map<String, double>.from(
        jsonDecode(scoreFactors),
      );
    } catch (e) {
      return null;
    }
  }

  static List<ScoreHistory>? _parseScoreHistory(String scoreHistory) {
    try {
      if (scoreHistory.isEmpty) return null;
      return List<ScoreHistory>.from(
        jsonDecode(scoreHistory).map((e) => ScoreHistory.fromJson(e)),
      );
    } catch (e) {
      return null;
    }
  }

  Lead copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? phone,
    String? email,
    String? subject,
    String? message,
    LeadStatus? status,
    ProcessStatus? processStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
    List<String>? segments,
    double? score,
    Map<String, double>? scoreFactors,
    List<ScoreHistory>? scoreHistory,
    Map<String, CustomFieldValue>? customFields,
    List<TimelineEvent>? timelineEvents,
  }) {
    return Lead(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      subject: subject ?? this.subject,
      message: message ?? this.message,
      status: status ?? this.status,
      processStatus: processStatus ?? this.processStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      metadata: metadata ?? this.metadata,
      segments: segments ?? this.segments,
      score: score ?? this.score,
      scoreFactors: scoreFactors ?? this.scoreFactors,
      scoreHistory: scoreHistory ?? this.scoreHistory,
      customFields: customFields ?? this.customFields,
      timelineEvents: timelineEvents ?? this.timelineEvents,
    );
  }

  String get fullName => '$firstName $lastName';

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        phone,
        email,
        subject,
        message,
        status,
        processStatus,
        createdAt,
        updatedAt,
        metadata,
        segments,
        score,
        scoreFactors,
        scoreHistory,
        customFields,
        timelineEvents,
      ];
}

class ScoreHistory {
  final DateTime timestamp;
  final double score;
  final String reason;

  ScoreHistory({
    required this.timestamp,
    required this.score,
    required this.reason,
  });

  factory ScoreHistory.fromJson(Map<String, dynamic> json) => ScoreHistory(
        timestamp: DateTime.parse(json['timestamp'] as String),
        score: (json['score'] as num).toDouble(),
        reason: json['reason'] as String,
      );

  Map<String, dynamic> toJson() => {
        'timestamp': timestamp.toIso8601String(),
        'score': score,
        'reason': reason,
      };
}
