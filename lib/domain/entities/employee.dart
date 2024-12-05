import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:neetiflow/domain/entities/role.dart';

class Employee extends Equatable {
  final String? id;
  final String? uid;
  final String? companyId;
  final String? companyName;
  final String firstName;
  final String lastName;
  final String? phone;
  final String email;
  final String? address;
  final Role? role;
  final List<RoleChangeRecord>? roleHistory;
  final DateTime? joiningDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? photoUrl;
  final bool isActive;
  final bool isOnline;
  final String? departmentId;
  final String? departmentName;
  final DepartmentHierarchy? departmentRole;

  const Employee({
    this.id,
    this.uid,
    this.companyId,
    this.companyName,
    required this.firstName,
    required this.lastName,
    this.phone,
    required this.email,
    this.address,
    this.role,
    this.roleHistory,
    this.joiningDate,
    this.createdAt,
    this.updatedAt,
    this.photoUrl,
    this.isActive = true,
    this.isOnline = false,
    this.departmentId,
    this.departmentName,
    this.departmentRole,
  });

  @override
  List<Object?> get props => [
        id,
        uid,
        companyId,
        companyName,
        firstName,
        lastName,
        phone,
        email,
        address,
        role,
        roleHistory,
        joiningDate,
        createdAt,
        updatedAt,
        photoUrl,
        isActive,
        isOnline,
        departmentId,
        departmentName,
        departmentRole,
      ];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'companyId': companyId,
      'companyName': companyName,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'email': email,
      'address': address,
      'role': role?.toJson(),
      'roleHistory': roleHistory?.map((e) => e.toJson()).toList(),
      'joiningDate': joiningDate != null ? Timestamp.fromDate(joiningDate!) : null,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'photoUrl': photoUrl,
      'isActive': isActive,
      'isOnline': isOnline,
      'departmentId': departmentId,
      'departmentName': departmentName,
      'departmentRole': departmentRole?.toString().split('.').last,
    };
  }

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'] as String?,
      uid: json['uid'] as String?,
      companyId: json['companyId'] as String?,
      companyName: json['companyName'] as String?,
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      phone: json['phone'] as String?,
      email: json['email'] as String,
      address: json['address'] as String?,
      role: json['role'] != null 
          ? (json['role'] is Map<String, dynamic>
              ? Role.fromJson(json['role'] as Map<String, dynamic>)
              : Role(
                  id: json['roleId'] as String? ?? 'employee_role_id',
                  name: json['role'] is String ? json['role'] as String : 'Employee',
                  description: '',
                  type: RoleType.system,
                  organizationId: json['companyId'] as String? ?? '',
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                ))
          : null,
      roleHistory: json['roleHistory'] != null
          ? (json['roleHistory'] as List).map((e) => RoleChangeRecord.fromJson(e)).toList()
          : null,
      joiningDate: json['joiningDate'] != null
          ? (json['joiningDate'] as Timestamp).toDate()
          : null,
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : null,
      updatedAt: json['updatedAt'] != null
          ? (json['updatedAt'] as Timestamp).toDate()
          : null,
      photoUrl: json['photoUrl'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      isOnline: json['isOnline'] as bool? ?? false,
      departmentId: json['departmentId'] as String?,
      departmentName: json['departmentName'] as String?,
      departmentRole: json['departmentRole'] != null
          ? DepartmentHierarchy.values.firstWhere(
              (role) => role.toString().split('.').last == json['departmentRole'],
            )
          : null,
    );
  }

  Employee copyWith({
    String? id,
    String? uid,
    String? companyId,
    String? companyName,
    String? firstName,
    String? lastName,
    String? phone,
    String? email,
    String? address,
    Role? role,
    List<RoleChangeRecord>? roleHistory,
    DateTime? joiningDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? photoUrl,
    bool? isActive,
    bool? isOnline,
    String? departmentId,
    String? departmentName,
    DepartmentHierarchy? departmentRole,
  }) {
    return Employee(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      companyId: companyId ?? this.companyId,
      companyName: companyName ?? this.companyName,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      role: role ?? this.role,
      roleHistory: roleHistory ?? this.roleHistory,
      joiningDate: joiningDate ?? this.joiningDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      photoUrl: photoUrl ?? this.photoUrl,
      isActive: isActive ?? this.isActive,
      isOnline: isOnline ?? this.isOnline,
      departmentId: departmentId ?? this.departmentId,
      departmentName: departmentName ?? this.departmentName,
      departmentRole: departmentRole ?? this.departmentRole,
    );
  }

  static String generateEmployeeId(String companyId) {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString().substring(8);
    return '$companyId-EMP$timestamp';
  }
}

class RoleChangeRecord extends Equatable {
  final String roleId;
  final DateTime changedAt;
  final String changedBy;
  final String? previousRoleId;
  final String? departmentId;
  final String? departmentName;

  const RoleChangeRecord({
    required this.roleId,
    required this.changedAt,
    required this.changedBy,
    this.previousRoleId,
    this.departmentId,
    this.departmentName,
  });

  Map<String, dynamic> toJson() => {
    'roleId': roleId,
    'changedAt': changedAt.toIso8601String(),
    'changedBy': changedBy,
    'previousRoleId': previousRoleId,
    'departmentId': departmentId,
    'departmentName': departmentName,
  };

  factory RoleChangeRecord.fromJson(Map<String, dynamic> json) => RoleChangeRecord(
    roleId: json['roleId'],
    changedAt: DateTime.parse(json['changedAt']),
    changedBy: json['changedBy'],
    previousRoleId: json['previousRoleId'],
    departmentId: json['departmentId'],
    departmentName: json['departmentName'],
  );

  @override
  List<Object?> get props => [
    roleId, 
    changedAt, 
    changedBy, 
    previousRoleId, 
    departmentId, 
    departmentName
  ];
}
