import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

enum RoleType {
  system,    // For organization-wide roles
  department, // For department-specific roles
  global     // Applicable across departments
}

enum DepartmentHierarchy {
  head,
  manager,
  member,
  admin
}

class Role extends Equatable {
  final String? id;
  final String name;
  final String description;
  final RoleType type;
  final String organizationId;
  final String? departmentId; // Optional department association
  final DepartmentHierarchy hierarchy; // Hierarchical role within department
  final List<String> permissions;
  final Map<String, dynamic> additionalAttributes;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isActive; // New field for role activation status

  const Role({
    this.id,
    required this.name,
    required this.description,
    this.type = RoleType.system,
    required this.organizationId,
    this.departmentId,
    this.hierarchy = DepartmentHierarchy.member,
    this.permissions = const [],
    this.additionalAttributes = const {},
    this.createdAt,
    this.updatedAt,
    this.isActive = true, // Default to active
  });

  // Check if role has specific permission
  bool hasPermission(String permission) {
    return isActive && permissions.contains(permission);
  }

  // Get role's display name with hierarchy
  String getDisplayName() {
    return '$name (${hierarchy.name.toUpperCase()})';
  }

  // Check if role is applicable to a specific department
  bool isApplicableToDepartment(String? checkDepartmentId) {
    return isActive && (departmentId == null || departmentId == checkDepartmentId);
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        type,
        organizationId,
        departmentId,
        hierarchy,
        permissions,
        additionalAttributes,
        createdAt,
        updatedAt,
        isActive,
      ];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type.toString().split('.').last,
      'organizationId': organizationId,
      'departmentId': departmentId,
      'hierarchy': hierarchy.toString().split('.').last,
      'permissions': permissions,
      'additionalAttributes': additionalAttributes,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'isActive': isActive,
    };
  }

  // Factory method to create a role from Firestore data
  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      type: RoleType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => RoleType.system,
      ),
      organizationId: json['organizationId'],
      departmentId: json['departmentId'],
      hierarchy: DepartmentHierarchy.values.firstWhere(
        (e) => e.toString().split('.').last == json['hierarchy'],
        orElse: () => DepartmentHierarchy.member,
      ),
      permissions: List<String>.from(json['permissions'] ?? []),
      additionalAttributes: Map<String, dynamic>.from(json['additionalAttributes'] ?? {}),
      createdAt: json['createdAt'] is Timestamp 
        ? (json['createdAt'] as Timestamp).toDate() 
        : null,
      updatedAt: json['updatedAt'] is Timestamp 
        ? (json['updatedAt'] as Timestamp).toDate() 
        : null,
      isActive: json['isActive'] ?? true, // Default to true if not specified
    );
  }

  // Method to create a copy with updated isActive status
  Role copyWith({
    String? id,
    String? name,
    String? description,
    RoleType? type,
    String? organizationId,
    String? departmentId,
    DepartmentHierarchy? hierarchy,
    List<String>? permissions,
    Map<String, dynamic>? additionalAttributes,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return Role(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      organizationId: organizationId ?? this.organizationId,
      departmentId: departmentId ?? this.departmentId,
      hierarchy: hierarchy ?? this.hierarchy,
      permissions: permissions ?? this.permissions,
      additionalAttributes: additionalAttributes ?? this.additionalAttributes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }
}
