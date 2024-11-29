import 'package:equatable/equatable.dart';

/// Represents a timeline event in a client's history
class ClientTimelineEvent extends Equatable {
  final String id;
  final String clientId;
  final String title;
  final String description;
  final DateTime timestamp;
  final String category;
  final Map<String, dynamic>? metadata;

  const ClientTimelineEvent({
    required this.id,
    required this.clientId,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.category,
    this.metadata,
  });

  @override
  List<Object?> get props => [
        id,
        clientId,
        title,
        description,
        timestamp,
        category,
        metadata,
      ];

  /// Creates a copy of this ClientTimelineEvent with the given fields replaced with the new values.
  ClientTimelineEvent copyWith({
    String? id,
    String? clientId,
    String? title,
    String? description,
    DateTime? timestamp,
    String? category,
    Map<String, dynamic>? metadata,
  }) {
    return ClientTimelineEvent(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      title: title ?? this.title,
      description: description ?? this.description,
      timestamp: timestamp ?? this.timestamp,
      category: category ?? this.category,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Creates a ClientTimelineEvent from a JSON map.
  factory ClientTimelineEvent.fromJson(Map<String, dynamic> json) {
    return ClientTimelineEvent(
      id: json['id'] as String,
      clientId: json['clientId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      category: json['category'] as String,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  /// Converts this ClientTimelineEvent to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clientId': clientId,
      'title': title,
      'description': description,
      'timestamp': timestamp.toIso8601String(),
      'category': category,
      'metadata': metadata,
    };
  }
}
