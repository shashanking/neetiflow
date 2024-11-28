import 'package:equatable/equatable.dart';

class TimelineEvent extends Equatable {
  final String id;
  final String leadId;
  final String title;
  final String description;
  final DateTime timestamp;
  final String category;
  final Map<String, dynamic>? metadata;

  const TimelineEvent({
    required this.id,
    required this.leadId,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.category,
    this.metadata,
  });

  TimelineEvent copyWith({
    String? id,
    String? leadId,
    String? title,
    String? description,
    DateTime? timestamp,
    String? category,
    Map<String, dynamic>? metadata,
  }) {
    return TimelineEvent(
      id: id ?? this.id,
      leadId: leadId ?? this.leadId,
      title: title ?? this.title,
      description: description ?? this.description,
      timestamp: timestamp ?? this.timestamp,
      category: category ?? this.category,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'leadId': leadId,
      'title': title,
      'description': description,
      'timestamp': timestamp.toIso8601String(),
      'category': category,
      'metadata': metadata,
    };
  }

  factory TimelineEvent.fromJson(Map<String, dynamic> json) {
    return TimelineEvent(
      id: json['id'] as String,
      leadId: json['leadId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      category: json['category'] as String,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  @override
  List<Object?> get props => [id, leadId, title, description, timestamp, category, metadata];
}
