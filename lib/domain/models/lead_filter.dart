import 'package:equatable/equatable.dart';

import '../entities/lead.dart';

class LeadFilter extends Equatable {
  final String? searchTerm;
  final String? status;
  final String? processStatus;
  final int? minScore;
  final int? maxScore;

  const LeadFilter({
    this.searchTerm,
    this.status,
    this.processStatus,
    this.minScore,
    this.maxScore,
  });

  LeadFilter copyWith({
    String? searchTerm,
    String? status,
    String? processStatus,
    int? minScore,
    int? maxScore,
  }) {
    return LeadFilter(
      searchTerm: searchTerm ?? this.searchTerm,
      status: status ?? this.status,
      processStatus: processStatus ?? this.processStatus,
      minScore: minScore ?? this.minScore,
      maxScore: maxScore ?? this.maxScore,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'searchTerm': searchTerm,
      'status': status,
      'processStatus': processStatus,
      'minScore': minScore,
      'maxScore': maxScore,
    };
  }

  factory LeadFilter.fromJson(Map<String, dynamic> json) {
    return LeadFilter(
      searchTerm: json['searchTerm'] as String?,
      status: json['status'] as String?,
      processStatus: json['processStatus'] as String?,
      minScore: json['minScore'] as int?,
      maxScore: json['maxScore'] as int?,
    );
  }

  bool matches(Lead lead) {
    if (searchTerm != null && searchTerm!.isNotEmpty) {
      final term = searchTerm!.toLowerCase();
      if (!lead.firstName.toLowerCase().contains(term) &&
          !lead.lastName.toLowerCase().contains(term) &&
          !lead.email.toLowerCase().contains(term) &&
          !lead.phone.toLowerCase().contains(term)) {
        return false;
      }
    }

    if (status != null && lead.status != status) {
      return false;
    }

    if (processStatus != null && lead.processStatus != processStatus) {
      return false;
    }

    if (minScore != null && lead.score < minScore!) {
      return false;
    }

    if (maxScore != null && lead.score > maxScore!) {
      return false;
    }

    return true;
  }

  @override
  List<Object?> get props => [searchTerm, status, processStatus, minScore, maxScore];
}
