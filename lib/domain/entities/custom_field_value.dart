import 'package:equatable/equatable.dart';

class CustomFieldValue extends Equatable {
  final String fieldId;
  final dynamic value;
  final DateTime updatedAt;

  const CustomFieldValue({
    required this.fieldId,
    required this.value,
    required this.updatedAt,
  });

  CustomFieldValue copyWith({
    String? fieldId,
    dynamic value,
    DateTime? updatedAt,
  }) {
    return CustomFieldValue(
      fieldId: fieldId ?? this.fieldId,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fieldId': fieldId,
      'value': value,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory CustomFieldValue.fromJson(Map<String, dynamic> json) {
    return CustomFieldValue(
      fieldId: json['fieldId'] as String,
      value: json['value'],
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  @override
  List<Object?> get props => [fieldId, value, updatedAt];
}
