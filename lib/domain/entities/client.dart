import 'package:cloud_firestore/cloud_firestore.dart';

enum ClientStatus {
  active,
  inactive,
  suspended
}

enum ClientType {
  individual,
  company,
  government
}

class Client {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final ClientType type;
  final ClientStatus status;
  final String? website;
  final String? gstin;
  final String? pan;
  final String? leadId; // Reference to the original lead
  final DateTime createdAt;
  final DateTime? lastInteractionDate;
  final Map<String, dynamic>? metadata;
  final List<String>? tags;
  final String? assignedEmployeeId;
  final double? lifetimeValue;

  Client({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.type,
    required this.status,
    this.website,
    this.gstin,
    this.pan,
    this.leadId,
    required this.createdAt,
    this.lastInteractionDate,
    this.metadata,
    this.tags,
    this.assignedEmployeeId,
    this.lifetimeValue,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
      type: ClientType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => ClientType.individual,
      ),
      status: ClientStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => ClientStatus.active,
      ),
      website: json['website'] as String?,
      gstin: json['gstin'] as String?,
      pan: json['pan'] as String?,
      leadId: json['leadId'] as String?,
      createdAt: json['createdAt'] is Timestamp 
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      lastInteractionDate: json['lastInteractionDate'] is Timestamp
          ? (json['lastInteractionDate'] as Timestamp).toDate()
          : null,
      metadata: json['metadata'] as Map<String, dynamic>?,
      tags: (json['tags'] as List<dynamic>?)?.cast<String>(),
      assignedEmployeeId: json['assignedEmployeeId'] as String?,
      lifetimeValue: (json['lifetimeValue'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'type': type.toString().split('.').last,
      'status': status.toString().split('.').last,
      'website': website,
      'gstin': gstin,
      'pan': pan,
      'leadId': leadId,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastInteractionDate': lastInteractionDate != null
          ? Timestamp.fromDate(lastInteractionDate!)
          : null,
      'metadata': metadata,
      'tags': tags,
      'assignedEmployeeId': assignedEmployeeId,
      'lifetimeValue': lifetimeValue,
    };
  }

  Client copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? address,
    ClientType? type,
    ClientStatus? status,
    String? website,
    String? gstin,
    String? pan,
    String? leadId,
    DateTime? createdAt,
    DateTime? lastInteractionDate,
    Map<String, dynamic>? metadata,
    List<String>? tags,
    String? assignedEmployeeId,
    double? lifetimeValue,
  }) {
    return Client(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      type: type ?? this.type,
      status: status ?? this.status,
      website: website ?? this.website,
      gstin: gstin ?? this.gstin,
      pan: pan ?? this.pan,
      leadId: leadId ?? this.leadId,
      createdAt: createdAt ?? this.createdAt,
      lastInteractionDate: lastInteractionDate ?? this.lastInteractionDate,
      metadata: metadata ?? this.metadata,
      tags: tags ?? this.tags,
      assignedEmployeeId: assignedEmployeeId ?? this.assignedEmployeeId,
      lifetimeValue: lifetimeValue ?? this.lifetimeValue,
    );
  }
}
