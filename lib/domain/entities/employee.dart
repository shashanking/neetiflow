import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:neetiflow/domain/entities/department.dart';

enum EmployeeRole { admin, manager, employee }

class Employee extends Equatable {
  final String? id;
  final String? uid;
  final String? companyId;
  final String? companyName;
  final String name;
  final String? phone;
  final String email;
  final String? address;
  final EmployeeRole role;
  final DateTime? joiningDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? photoUrl;
  final bool isActive;
  final String? departmentId;  
  final DepartmentRole? departmentRole;  

  const Employee({
    this.id,
    this.uid,
    this.companyId,
    this.companyName,
    required this.name,
    this.phone,
    required this.email,
    this.address,
    required this.role,
    this.joiningDate,
    this.createdAt,
    this.updatedAt,
    this.photoUrl,
    this.isActive = true,
    this.departmentId,  
    this.departmentRole,  
  });

  @override
  List<Object?> get props => [
        id,
        uid,
        companyId,
        companyName,
        name,
        phone,
        email,
        address,
        role,
        joiningDate,
        createdAt,
        updatedAt,
        photoUrl,
        isActive,
        departmentId,  
        departmentRole,  
      ];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'companyId': companyId,
      'companyName': companyName,
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
      'role': role.toString().split('.').last,
      'joiningDate': joiningDate != null ? Timestamp.fromDate(joiningDate!) : null,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'photoUrl': photoUrl,
      'isActive': isActive,
      'departmentId': departmentId,  
      'departmentRole': departmentRole?.toString().split('.').last,  
    };
  }

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'] as String?,
      uid: json['uid'] as String?,
      companyId: json['companyId'] as String?,
      companyName: json['companyName'] as String?,
      name: json['name'] as String,
      phone: json['phone'] as String?,
      email: json['email'] as String,
      address: json['address'] as String?,
      role: EmployeeRole.values.firstWhere(
        (e) => e.toString().split('.').last == json['role'],
        orElse: () => EmployeeRole.employee,
      ),
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
      departmentId: json['departmentId'] as String?,  
      departmentRole: json['departmentRole'] != null  
          ? DepartmentRole.values.firstWhere(
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
    String? name,
    String? phone,
    String? email,
    String? address,
    EmployeeRole? role,
    DateTime? joiningDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? photoUrl,
    bool? isActive,
    String? departmentId,  
    DepartmentRole? departmentRole,  
  }) {
    return Employee(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      companyId: companyId ?? this.companyId,
      companyName: companyName ?? this.companyName,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      role: role ?? this.role,
      joiningDate: joiningDate ?? this.joiningDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      photoUrl: photoUrl ?? this.photoUrl,
      isActive: isActive ?? this.isActive,
      departmentId: departmentId ?? this.departmentId,  
      departmentRole: departmentRole ?? this.departmentRole,  
    );
  }

  static String generateEmployeeId(String companyId) {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString().substring(8);
    return '$companyId-EMP$timestamp';
  }
}
