// ignore_for_file: unrelated_type_equality_checks

import 'package:neetiflow/domain/entities/lead.dart';

class LeadFilter {
  final LeadStatus? leadStatus;
  final ProcessStatus? processStatus;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? searchQuery;
  final List<String>? segments;

  const LeadFilter({
    this.leadStatus,
    this.processStatus,
    this.startDate,
    this.endDate,
    this.searchQuery,
    this.segments,
  });

  LeadFilter copyWith({
    LeadStatus? leadStatus,
    ProcessStatus? processStatus,
    DateTime? startDate,
    DateTime? endDate,
    String? searchQuery,
    List<String>? segments,
  }) {
    return LeadFilter(
      leadStatus: leadStatus ?? this.leadStatus,
      processStatus: processStatus ?? this.processStatus,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      searchQuery: searchQuery ?? this.searchQuery,
      segments: segments ?? this.segments,
    );
  }

  bool matches(Lead lead) {
    if (leadStatus != null && lead.status != leadStatus) return false;
    if (processStatus != null && lead.processStatus != processStatus) return false;
    if (startDate != null && lead.createdAt.isBefore(startDate!)) return false;
    if (endDate != null && lead.createdAt.isAfter(endDate!)) return false;
    if (searchQuery != null && searchQuery!.isNotEmpty) {
      final query = searchQuery!.toLowerCase();
      if (!lead.firstName.toLowerCase().contains(query) &&
          !lead.lastName.toLowerCase().contains(query) &&
          !lead.email.toLowerCase().contains(query) &&
          !lead.phone.toLowerCase().contains(query) &&
          !lead.subject.toLowerCase().contains(query) &&
          !lead.message.toLowerCase().contains(query)) {
        return false;
      }
    }
    if (segments != null && segments!.isNotEmpty) {
      if (lead.segments == null || !lead.segments!.any((s) => segments!.contains(s))) {
        return false;
      }
    }
    return true;
  }

  Map<String, dynamic> toJson() {
    return {
      'leadStatus': leadStatus,
      'processStatus': processStatus,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'searchQuery': searchQuery,
      'segments': segments,
    };
  }

  factory LeadFilter.fromJson(Map<String, dynamic> json) {
    return LeadFilter(
      leadStatus: json['leadStatus'],
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
          leadStatus == other.leadStatus &&
          processStatus == other.processStatus &&
          startDate == other.startDate &&
          endDate == other.endDate &&
          searchQuery == other.searchQuery &&
          (segments == null && other.segments == null ||
              segments != null &&
                  other.segments != null &&
                  segments!.length == other.segments!.length &&
                  segments!.every((element) => other.segments!.contains(element)));

  @override
  int get hashCode =>
      leadStatus.hashCode ^
      processStatus.hashCode ^
      startDate.hashCode ^
      endDate.hashCode ^
      searchQuery.hashCode ^
      segments.hashCode;
}
