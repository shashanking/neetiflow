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

enum ClientDomain {
  marketing,
  itServices,
  fmcg,
  manufacturing,
  healthcare,
  education,
  retail,
  finance,
  realEstate,
  hospitality,
  other
}

class Project {
  final String id;
  final String name;
  final String description;
  final double value;
  final DateTime startDate;
  final DateTime? endDate;
  final String status;

  Project({
    required this.id,
    required this.name,
    required this.description,
    required this.value,
    required this.startDate,
    this.endDate,
    required this.status,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      value: (json['value'] as num).toDouble(),
      startDate: (json['startDate'] as Timestamp).toDate(),
      endDate: json['endDate'] != null 
          ? (json['endDate'] as Timestamp).toDate() 
          : null,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'value': value,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': endDate != null ? Timestamp.fromDate(endDate!) : null,
      'status': status,
    };
  }
}

class Client {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String address;
  final ClientType type;
  final ClientStatus status;
  final ClientDomain domain;
  final double rating;  // 0 to 5 stars
  
  // Organization specific fields
  final String? organizationName;  // For company type
  final String? governmentType;    // For government type (e.g., "Federal - USA", "State - California")
  
  final String? website;
  final String? gstin;
  final String? pan;
  final String? leadId;
  final DateTime joiningDate;      // When client was added
  final DateTime? lastInteractionDate;
  final Map<String, dynamic>? metadata;
  final List<String>? tags;
  final String? assignedEmployeeId;
  final List<Project> projects;    // List of projects
  final double lifetimeValue;      // Calculated from projects

  Client({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.address,
    required this.type,
    required this.status,
    required this.domain,
    required this.rating,
    this.organizationName,
    this.governmentType,
    this.website,
    this.gstin,
    this.pan,
    this.leadId,
    required this.joiningDate,
    this.lastInteractionDate,
    this.metadata,
    this.tags,
    this.assignedEmployeeId,
    required this.projects,
    required this.lifetimeValue,
  });

  String get fullName => '$firstName $lastName';

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
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
      domain: ClientDomain.values.firstWhere(
        (e) => e.toString().split('.').last == json['domain'],
        orElse: () => ClientDomain.other,
      ),
      rating: (json['rating'] as num).toDouble(),
      organizationName: json['organizationName'] as String?,
      governmentType: json['governmentType'] as String?,
      website: json['website'] as String?,
      gstin: json['gstin'] as String?,
      pan: json['pan'] as String?,
      leadId: json['leadId'] as String?,
      joiningDate: json['joiningDate'] is Timestamp 
          ? (json['joiningDate'] as Timestamp).toDate()
          : DateTime.now(),
      lastInteractionDate: json['lastInteractionDate'] is Timestamp
          ? (json['lastInteractionDate'] as Timestamp).toDate()
          : null,
      metadata: json['metadata'] as Map<String, dynamic>?,
      tags: (json['tags'] as List<dynamic>?)?.cast<String>(),
      assignedEmployeeId: json['assignedEmployeeId'] as String?,
      projects: (json['projects'] as List<dynamic>?)
          ?.map((e) => Project.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      lifetimeValue: (json['lifetimeValue'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'address': address,
      'type': type.toString().split('.').last,
      'status': status.toString().split('.').last,
      'domain': domain.toString().split('.').last,
      'rating': rating,
      'organizationName': organizationName,
      'governmentType': governmentType,
      'website': website,
      'gstin': gstin,
      'pan': pan,
      'leadId': leadId,
      'joiningDate': Timestamp.fromDate(joiningDate),
      'lastInteractionDate': lastInteractionDate != null
          ? Timestamp.fromDate(lastInteractionDate!)
          : null,
      'metadata': metadata,
      'tags': tags,
      'assignedEmployeeId': assignedEmployeeId,
      'projects': projects.map((p) => p.toJson()).toList(),
      'lifetimeValue': lifetimeValue,
    };
  }

  Client copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? address,
    ClientType? type,
    ClientStatus? status,
    ClientDomain? domain,
    double? rating,
    String? organizationName,
    String? governmentType,
    String? website,
    String? gstin,
    String? pan,
    String? leadId,
    DateTime? joiningDate,
    DateTime? lastInteractionDate,
    Map<String, dynamic>? metadata,
    List<String>? tags,
    String? assignedEmployeeId,
    List<Project>? projects,
    double? lifetimeValue,
  }) {
    return Client(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      type: type ?? this.type,
      status: status ?? this.status,
      domain: domain ?? this.domain,
      rating: rating ?? this.rating,
      organizationName: organizationName ?? this.organizationName,
      governmentType: governmentType ?? this.governmentType,
      website: website ?? this.website,
      gstin: gstin ?? this.gstin,
      pan: pan ?? this.pan,
      leadId: leadId ?? this.leadId,
      joiningDate: joiningDate ?? this.joiningDate,
      lastInteractionDate: lastInteractionDate ?? this.lastInteractionDate,
      metadata: metadata ?? this.metadata,
      tags: tags ?? this.tags,
      assignedEmployeeId: assignedEmployeeId ?? this.assignedEmployeeId,
      projects: projects ?? this.projects,
      lifetimeValue: lifetimeValue ?? this.lifetimeValue,
    );
  }
}
