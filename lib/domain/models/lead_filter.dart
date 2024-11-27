import 'package:equatable/equatable.dart';

class LeadFilter extends Equatable {
  final String? searchTerm;
  final String? status;
  final String? processStatus;

  const LeadFilter({
    this.searchTerm,
    this.status,
    this.processStatus,
  });

  LeadFilter copyWith({
    String? searchTerm,
    String? status,
    String? processStatus,
  }) {
    return LeadFilter(
      searchTerm: searchTerm ?? this.searchTerm,
      status: status ?? this.status,
      processStatus: processStatus ?? this.processStatus,
    );
  }

  @override
  List<Object?> get props => [searchTerm, status, processStatus];
}
