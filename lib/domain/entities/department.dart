import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:neetiflow/domain/entities/role.dart';

enum DepartmentHierarchy {
  head,
  manager,
  member
}

class Department extends Equatable {
  final String? id;
  final String name;
  final String description;
  final String organizationId;
  final Map<String, Role> employeeRoles; // Maps employeeId to their role
  final List<Role> availableRoles; // Predefined roles for this department
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Department({
    this.id,
    required this.name,
    required this.description,
    required this.organizationId,
    this.employeeRoles = const {},
    this.availableRoles = const [],
    this.createdAt,
    this.updatedAt,
  });

  // Get employees with a specific role hierarchy
  List<String> getEmployeesByHierarchy(DepartmentHierarchy hierarchy) {
    return employeeRoles.entries
        .where((entry) => 
          entry.value.hierarchy == hierarchy ||
          (entry.value.hierarchy != null && 
           entry.value.hierarchy == hierarchy))
        .map((entry) => entry.key)
        .toList();
  }

  // Check if an employee has a specific role
  bool hasEmployeeRole(String employeeId, DepartmentHierarchy hierarchy) {
    final employeeRole = employeeRoles[employeeId];
    return employeeRole != null && 
           (employeeRole.hierarchy == hierarchy || 
            (employeeRole.hierarchy != null && 
             employeeRole.hierarchy == hierarchy));
  }

  // Add a role to available department roles
  Department addAvailableRole(Role role) {
    final updatedRoles = List<Role>.from(availableRoles);
    if (!updatedRoles.any((r) => r.id == role.id)) {
      updatedRoles.add(role);
    }
    return copyWith(availableRoles: updatedRoles);
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        organizationId,
        employeeRoles,
        availableRoles,
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
        (key, value) => MapEntry(key, value.toJson()),
      ),
      'availableRoles': availableRoles.map((role) => role.toJson()).toList(),
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  // Factory method to create a department from Firestore data
  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      organizationId: json['organizationId'],
      employeeRoles: (json['employeeRoles'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, Role.fromJson(value)),
          ) ??
          {},
      availableRoles: (json['availableRoles'] as List<dynamic>?)
              ?.map((roleJson) => Role.fromJson(roleJson))
              .toList() ??
          [],
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (json['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  // Copy method for immutable updates
  Department copyWith({
    String? id,
    String? name,
    String? description,
    String? organizationId,
    Map<String, Role>? employeeRoles,
    List<Role>? availableRoles,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Department(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      organizationId: organizationId ?? this.organizationId,
      employeeRoles: employeeRoles ?? this.employeeRoles,
      availableRoles: availableRoles ?? this.availableRoles,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
