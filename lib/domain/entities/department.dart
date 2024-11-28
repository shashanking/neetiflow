import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
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
          ? (json['createdAt'] as Timestamp).toDate()
          : null,
      updatedAt: json['updatedAt'] != null
          ? (json['updatedAt'] as Timestamp).toDate()
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
