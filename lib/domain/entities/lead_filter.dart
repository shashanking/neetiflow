// ignore_for_file: unrelated_type_equality_checks

import 'package:neetiflow/domain/entities/lead.dart';

class LeadFilter {
  final String? status;
  final String? processStatus;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? searchQuery;
  final List<String>? segments;

  const LeadFilter({
    this.status,
    this.processStatus,
    this.startDate,
    this.endDate,
    this.searchQuery,
    this.segments,
  });

  LeadFilter copyWith({
    String? status,
    String? processStatus,
    DateTime? startDate,
    DateTime? endDate,
    String? searchQuery,
    List<String>? segments,
  }) {
    return LeadFilter(
      status: status ?? this.status,
      processStatus: processStatus ?? this.processStatus,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      searchQuery: searchQuery ?? this.searchQuery,
      segments: segments ?? this.segments,
    );
  }

  bool matches(Lead lead) {
    if (status != null && lead.status != status) return false;
    if (processStatus != null && lead.processStatus != processStatus) return false;
    
    if (startDate != null && lead.createdAt.isBefore(startDate!)) return false;
    if (endDate != null && lead.createdAt.isAfter(endDate!)) return false;
    
    if (searchQuery != null && searchQuery!.isNotEmpty) {
      final query = searchQuery!.toLowerCase();
      return lead.firstName.toLowerCase().contains(query) ||
          lead.lastName.toLowerCase().contains(query) ||
          lead.email.toLowerCase().contains(query) ||
          lead.phone.toLowerCase().contains(query) ||
          lead.subject.toLowerCase().contains(query) ||
          lead.message.toLowerCase().contains(query);
    }
    
    if (segments != null && segments!.isNotEmpty) {
      if (lead.segments == null || 
          !segments!.any((segment) => lead.segments!.contains(segment))) {
        return false;
      }
    }
    
    return true;
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'processStatus': processStatus,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'searchQuery': searchQuery,
      'segments': segments,
    };
  }

  factory LeadFilter.fromJson(Map<String, dynamic> json) {
    return LeadFilter(
      status: json['status'],
      processStatus: json['processStatus'],
      startDate: json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      searchQuery: json['searchQuery'],
      segments: json['segments'] != null ? List<String>.from(json['segments']) : null,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LeadFilter &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          processStatus == other.processStatus &&
          startDate == other.startDate &&
          endDate == other.endDate &&
          searchQuery == other.searchQuery &&
          segments == other.segments;

  @override
  int get hashCode =>
      status.hashCode ^
      processStatus.hashCode ^
      startDate.hashCode ^
      endDate.hashCode ^
      searchQuery.hashCode ^
      segments.hashCode;
}
