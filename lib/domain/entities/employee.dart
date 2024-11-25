import 'package:cloud_firestore/cloud_firestore.dart';

enum EmployeeRole { admin, manager, employee }

class Employee {
  final String? id;
  final String? companyId;
  final String name;
  final String phone;
  final String email;
  final String? address;
  final EmployeeRole role;
  final DateTime? joiningDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? photoUrl;
  final bool isActive;

  Employee({
    this.id,
    this.companyId,
    required this.name,
    required this.phone,
    required this.email,
    this.address,
    required this.role,
    this.joiningDate,
    this.createdAt,
    this.updatedAt,
    this.photoUrl,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'companyId': companyId,
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
    };
  }

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'] as String?,
      companyId: json['companyId'] as String?,
      name: json['name'] as String,
      phone: json['phone'] as String,
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
    );
  }

  Employee copyWith({
    String? id,
    String? companyId,
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
  }) {
    return Employee(
      id: id ?? this.id,
      companyId: companyId ?? this.companyId,
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
    );
  }

  static String generateEmployeeId(String companyId) {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString().substring(8);
    return '$companyId-EMP$timestamp';
  }
}
