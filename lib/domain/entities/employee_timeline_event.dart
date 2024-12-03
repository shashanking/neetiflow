import 'package:equatable/equatable.dart';

/// Represents a timeline event in an employee's history
class EmployeeTimelineEvent extends Equatable {
  final String id;
  final String employeeId;
  final String title;
  final String description;
  final DateTime timestamp;
  final String category;
  final Map<String, dynamic>? metadata;

  const EmployeeTimelineEvent({
    required this.id,
    required this.employeeId,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.category,
    this.metadata,
  });

  /// Creates a copy of this EmployeeTimelineEvent with the given fields replaced with the new values.
  EmployeeTimelineEvent copyWith({
    String? id,
    String? employeeId,
    String? title,
    String? description,
    DateTime? timestamp,
    String? category,
    Map<String, dynamic>? metadata,
  }) {
    return EmployeeTimelineEvent(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      title: title ?? this.title,
      description: description ?? this.description,
      timestamp: timestamp ?? this.timestamp,
      category: category ?? this.category,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Converts this EmployeeTimelineEvent to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employeeId': employeeId,
      'title': title,
      'description': description,
      'timestamp': timestamp.toIso8601String(),
      'category': category,
      'metadata': metadata,
    };
  }

  /// Creates an EmployeeTimelineEvent from a JSON map.
  factory EmployeeTimelineEvent.fromJson(Map<String, dynamic> json) {
    return EmployeeTimelineEvent(
      id: json['id'] as String,
      employeeId: json['employeeId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      category: json['category'] as String,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  @override
  List<Object?> get props => [
        id,
        employeeId,
        title,
        description,
        timestamp,
        category,
        metadata,
      ];
}
