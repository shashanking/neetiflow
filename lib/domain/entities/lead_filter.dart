import 'package:neetiflow/domain/entities/lead.dart';

class LeadFilter {
  final LeadStatus? status;
  final ProcessStatus? processStatus;
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
    LeadStatus? status,
    ProcessStatus? processStatus,
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
      if (lead.segments == null || 
          !segments!.any((segment) => lead.segments!.contains(segment))) {
        return false;
      }
    }
    
    return true;
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status?.toString(),
      'processStatus': processStatus?.toString(),
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'searchQuery': searchQuery,
      'segments': segments,
    };
  }

  factory LeadFilter.fromJson(Map<String, dynamic> json) {
    return LeadFilter(
      status: json['status'] != null ? LeadStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
        orElse: () => LeadStatus.warm,
      ) : null,
      processStatus: json['processStatus'] != null ? ProcessStatus.values.firstWhere(
        (e) => e.toString() == json['processStatus'],
        orElse: () => ProcessStatus.fresh,
      ) : null,
      startDate: json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      searchQuery: json['searchQuery'],
      segments: json['segments'] != null ? List<String>.from(json['segments']) : null,
    );
  }
}
