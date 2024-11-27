import 'package:equatable/equatable.dart';

enum LeadStatus { warm, cold, hot }
enum ProcessStatus { fresh, inProgress, completed, rejected }

class LeadModel extends Equatable {
  final String? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? company;
  final LeadStatus status;
  final ProcessStatus processStatus;
  final DateTime createdAt;

  const LeadModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.company,
    required this.status,
    required this.processStatus,
    required this.createdAt,
  });

  LeadModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? company,
    LeadStatus? status,
    ProcessStatus? processStatus,
    DateTime? createdAt,
  }) {
    return LeadModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      company: company ?? this.company,
      status: status ?? this.status,
      processStatus: processStatus ?? this.processStatus,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (company != null) 'company': company,
      'status': status.toString().split('.').last,
      'processStatus': processStatus.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory LeadModel.fromJson(Map<String, dynamic> json) {
    return LeadModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      company: json['company'] as String?,
      status: LeadStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
      ),
      processStatus: ProcessStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['processStatus'],
      ),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LeadModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          email == other.email &&
          phone == other.phone &&
          company == other.company &&
          status == other.status &&
          processStatus == other.processStatus &&
          createdAt == other.createdAt;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      email.hashCode ^
      phone.hashCode ^
      company.hashCode ^
      status.hashCode ^
      processStatus.hashCode ^
      createdAt.hashCode;

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        phone,
        company,
        status,
        processStatus,
        createdAt,
      ];
}
