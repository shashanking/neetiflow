import 'package:equatable/equatable.dart';

enum DepartmentRole {
  head,
  manager,
  member
}

class Department extends Equatable {
  final String? id;
  final String name;
  final String description;
  final String organizationId;
  final Map<String, DepartmentRole> employeeRoles; // Maps employeeId to their role in the department
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Department({
    this.id,
    required this.name,
    required this.description,
    required this.organizationId,
    this.employeeRoles = const {},
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        organizationId,
        employeeRoles,
        createdAt,
        updatedAt,
      ];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'organizationId': organizationId,
      'employeeRoles': employeeRoles.map(
        (key, value) => MapEntry(key, value.toString().split('.').last),
      ),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      id: json['id'] as String?,
      name: json['name'] as String,
      description: json['description'] as String,
      organizationId: json['organizationId'] as String,
      employeeRoles: (json['employeeRoles'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(
              key,
              DepartmentRole.values.firstWhere(
                (role) => role.toString().split('.').last == value,
              ),
            ),
          ) ??
          {},
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Department copyWith({
    String? id,
    String? name,
    String? description,
    String? organizationId,
    Map<String, DepartmentRole>? employeeRoles,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Department(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      organizationId: organizationId ?? this.organizationId,
      employeeRoles: employeeRoles ?? this.employeeRoles,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
