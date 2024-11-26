import 'package:cloud_firestore/cloud_firestore.dart';

class Organization {
  final String? id;
  final String name;
  final String? logo;
  final String address;
  final String phone;
  final String email;
  final String? website;
  final String? pan;
  final String? gstin;
  final BankDetails? bankDetails;
  final int employeeCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Organization({
    this.id,
    required this.name,
    this.logo,
    required this.address,
    required this.phone,
    required this.email,
    this.website,
    this.pan,
    this.gstin,
    this.bankDetails,
    this.employeeCount = 0,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logo': logo,
      'address': address,
      'phone': phone,
      'email': email,
      'website': website,
      'pan': pan,
      'gstin': gstin,
      'bankDetails': bankDetails?.toJson(),
      'employeeCount': employeeCount,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
      id: json['id'] as String?,
      name: json['name'] as String,
      logo: json['logo'] as String?,
      address: json['address'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      website: json['website'] as String?,
      pan: json['pan'] as String?,
      gstin: json['gstin'] as String?,
      bankDetails: json['bankDetails'] != null
          ? BankDetails.fromJson(json['bankDetails'] as Map<String, dynamic>)
          : null,
      employeeCount: json['employeeCount'] as int? ?? 0,
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : null,
      updatedAt: json['updatedAt'] != null
          ? (json['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Organization copyWith({
    String? id,
    String? name,
    String? logo,
    String? address,
    String? phone,
    String? email,
    String? website,
    String? pan,
    String? gstin,
    BankDetails? bankDetails,
    int? employeeCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Organization(
      id: id ?? this.id,
      name: name ?? this.name,
      logo: logo ?? this.logo,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      website: website ?? this.website,
      pan: pan ?? this.pan,
      gstin: gstin ?? this.gstin,
      bankDetails: bankDetails ?? this.bankDetails,
      employeeCount: employeeCount ?? this.employeeCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class BankDetails {
  final String bankName;
  final String accountNumber;
  final String ifscCode;
  final String? branchName;
  final String? accountHolderName;

  BankDetails({
    required this.bankName,
    required this.accountNumber,
    required this.ifscCode,
    this.branchName,
    this.accountHolderName,
  });

  Map<String, dynamic> toJson() {
    return {
      'bankName': bankName,
      'accountNumber': accountNumber,
      'ifscCode': ifscCode,
      'branchName': branchName,
      'accountHolderName': accountHolderName,
    };
  }

  factory BankDetails.fromJson(Map<String, dynamic> json) {
    return BankDetails(
      bankName: json['bankName'] as String,
      accountNumber: json['accountNumber'] as String,
      ifscCode: json['ifscCode'] as String,
      branchName: json['branchName'] as String?,
      accountHolderName: json['accountHolderName'] as String?,
    );
  }

  BankDetails copyWith({
    String? bankName,
    String? accountNumber,
    String? ifscCode,
    String? branchName,
    String? accountHolderName,
  }) {
    return BankDetails(
      bankName: bankName ?? this.bankName,
      accountNumber: accountNumber ?? this.accountNumber,
      ifscCode: ifscCode ?? this.ifscCode,
      branchName: branchName ?? this.branchName,
      accountHolderName: accountHolderName ?? this.accountHolderName,
    );
  }
}
