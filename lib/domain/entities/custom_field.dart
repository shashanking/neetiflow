import 'package:equatable/equatable.dart';

enum CustomFieldType {
  text,
  number,
  date,
  dropdown,
  checkbox,
  url,
  email,
  phone,
  currency,
  textarea
}

class CustomFieldValidation extends Equatable {
  final bool required;
  final String? regex;
  final String? minValue;
  final String? maxValue;
  final List<String>? allowedValues;

  const CustomFieldValidation({
    this.required = false,
    this.regex,
    this.minValue,
    this.maxValue,
    this.allowedValues,
  });

  Map<String, dynamic> toJson() {
    return {
      'required': required,
      'regex': regex,
      'minValue': minValue,
      'maxValue': maxValue,
      'allowedValues': allowedValues,
    };
  }

  factory CustomFieldValidation.fromJson(Map<String, dynamic> json) {
    return CustomFieldValidation(
      required: json['required'] as bool? ?? false,
      regex: json['regex'] as String?,
      minValue: json['minValue'] as String?,
      maxValue: json['maxValue'] as String?,
      allowedValues: (json['allowedValues'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );
  }

  @override
  List<Object?> get props => [required, regex, minValue, maxValue, allowedValues];
}

class CustomField extends Equatable {
  final String id;
  final String name;
  final String label;
  final CustomFieldType type;
  final CustomFieldValidation validation;
  final String? description;
  final String? placeholder;
  final bool isActive;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const CustomField({
    required this.id,
    required this.name,
    required this.label,
    required this.type,
    this.validation = const CustomFieldValidation(),
    this.description,
    this.placeholder,
    this.isActive = true,
    this.metadata,
    required this.createdAt,
    this.updatedAt,
  });

  CustomField copyWith({
    String? id,
    String? name,
    String? label,
    CustomFieldType? type,
    CustomFieldValidation? validation,
    String? description,
    String? placeholder,
    bool? isActive,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CustomField(
      id: id ?? this.id,
      name: name ?? this.name,
      label: label ?? this.label,
      type: type ?? this.type,
      validation: validation ?? this.validation,
      description: description ?? this.description,
      placeholder: placeholder ?? this.placeholder,
      isActive: isActive ?? this.isActive,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'label': label,
      'type': type.toString().split('.').last,
      'validation': validation.toJson(),
      'description': description,
      'placeholder': placeholder,
      'isActive': isActive,
      'metadata': metadata,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory CustomField.fromJson(Map<String, dynamic> json) {
    return CustomField(
      id: json['id'] as String,
      name: json['name'] as String,
      label: json['label'] as String,
      type: CustomFieldType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
      ),
      validation: CustomFieldValidation.fromJson(
        json['validation'] as Map<String, dynamic>,
      ),
      description: json['description'] as String?,
      placeholder: json['placeholder'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        label,
        type,
        validation,
        description,
        placeholder,
        isActive,
        metadata,
        createdAt,
        updatedAt,
      ];
}
