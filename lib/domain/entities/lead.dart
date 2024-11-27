import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert'; // added import for jsonDecode

enum LeadStatus { warm, cold, hot }
enum ProcessStatus { fresh, inProgress, completed, rejected }

class Lead {
  final String id;
  final String uid;
  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final String subject;
  final String message;
  final LeadStatus status;
  final ProcessStatus processStatus;
  final DateTime createdAt;
  final Map<String, dynamic>? metadata;
  final List<String>? segments;

  Lead({
    required this.id,
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.subject,
    required this.message,
    required this.status,
    required this.processStatus,
    required this.createdAt,
    this.metadata,
    this.segments,
  });

  factory Lead.fromJson(Map<String, dynamic> json) {
    return Lead(
      id: json['id'] as String,
      uid: json['uid'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      subject: json['subject'] as String,
      message: json['message'] as String,
      status: _parseLeadStatus(json['status'] as String),
      processStatus: _parseProcessStatus(json['processStatus'] as String),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      metadata: json['metadata'] as Map<String, dynamic>?,
      segments: (json['segments'] as List<dynamic>?)?.cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'email': email,
      'subject': subject,
      'message': message,
      'status': status.toString().split('.').last,
      'processStatus': processStatus.toString().split('.').last,
      'createdAt': Timestamp.fromDate(createdAt),
      'metadata': metadata,
      'segments': segments,
    };
  }

  factory Lead.fromCSV(List<String> row, {Map<String, int> headers = const {}}) {
    String getValue(String key) {
      final index = headers[key.toLowerCase().replaceAll(' ', '')];
      if (index == null) throw Exception('Column $key not found in CSV');
      return row[index];
    }

    return Lead(
      id: getValue('id'),
      uid: getValue('uid'),
      firstName: getValue('first name'),
      lastName: getValue('last name'),
      phone: getValue('phone'),
      email: getValue('email'),
      subject: getValue('subject'),
      message: getValue('msg'),
      status: _parseLeadStatus(getValue('status')),
      processStatus: _parseProcessStatus(getValue('process status')),
      createdAt: DateTime.parse(getValue('created at')),
      metadata: _parseMetadata(getValue('metadata')),
      segments: _parseSegments(getValue('segments')),
    );
  }

  static LeadStatus _parseLeadStatus(String status) {
    return LeadStatus.values.firstWhere(
      (e) => e.toString().split('.').last.toLowerCase() == status.toLowerCase(),
      orElse: () => LeadStatus.cold,
    );
  }

  static ProcessStatus _parseProcessStatus(String status) {
    return ProcessStatus.values.firstWhere(
      (e) => e.toString().split('.').last.toLowerCase() == status.toLowerCase(),
      orElse: () => ProcessStatus.fresh,
    );
  }

  static Map<String, dynamic>? _parseMetadata(String metadata) {
    try {
      if (metadata.isEmpty) return null;
      return Map<String, dynamic>.from(
        jsonDecode(metadata),
      );
    } catch (e) {
      return null;
    }
  }

  static List<String>? _parseSegments(String segments) {
    try {
      if (segments.isEmpty) return null;
      return List<String>.from(
        jsonDecode(segments),
      );
    } catch (e) {
      return null;
    }
  }

  Lead copyWith({
    String? id,
    String? uid,
    String? firstName,
    String? lastName,
    String? phone,
    String? email,
    String? subject,
    String? message,
    LeadStatus? status,
    ProcessStatus? processStatus,
    DateTime? createdAt,
    Map<String, dynamic>? metadata,
    List<String>? segments,
  }) {
    return Lead(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      subject: subject ?? this.subject,
      message: message ?? this.message,
      status: status ?? this.status,
      processStatus: processStatus ?? this.processStatus,
      createdAt: createdAt ?? this.createdAt,
      metadata: metadata ?? this.metadata,
      segments: segments ?? this.segments,
    );
  }

  String get fullName => '$firstName $lastName';
}
