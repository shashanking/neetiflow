part of 'leads_bloc.dart';

enum LeadsStatus { initial, loading, success, failure }

class LeadsState extends Equatable {
  final LeadsStatus status;
  final List<Lead> allLeads;
  final List<Lead> filteredLeads;
  final LeadFilter filter;
  final Set<String> selectedLeadIds;
  final String? errorMessage;
  final Uint8List? csvExportBytes;
  final String? sortColumn;
  final bool sortAscending;
  final List<String> segments;

  const LeadsState({
    this.status = LeadsStatus.initial,
    this.allLeads = const [],
    this.filteredLeads = const [],
    this.filter = const LeadFilter(),
    this.selectedLeadIds = const {},
    this.errorMessage,
    this.csvExportBytes,
    this.sortColumn,
    this.sortAscending = true,
    this.segments = const [],
  });

  LeadsState copyWith({
    LeadsStatus? status,
    List<Lead>? allLeads,
    List<Lead>? filteredLeads,
    LeadFilter? filter,
    Set<String>? selectedLeadIds,
    String? errorMessage,
    Uint8List? csvExportBytes,
    String? sortColumn,
    bool? sortAscending,
    List<String>? segments,
  }) {
    return LeadsState(
      status: status ?? this.status,
      allLeads: allLeads ?? this.allLeads,
      filteredLeads: filteredLeads ?? this.filteredLeads,
      filter: filter ?? this.filter,
      selectedLeadIds: selectedLeadIds ?? this.selectedLeadIds,
      errorMessage: errorMessage ?? this.errorMessage,
      csvExportBytes: csvExportBytes ?? this.csvExportBytes,
      sortColumn: sortColumn ?? this.sortColumn,
      sortAscending: sortAscending ?? this.sortAscending,
      segments: segments ?? this.segments,
    );
  }

  @override
  List<Object?> get props => [
        status,
        allLeads,
        filteredLeads,
        filter,
        selectedLeadIds,
        errorMessage,
        csvExportBytes,
        sortColumn,
        sortAscending,
        segments,
      ];

  factory LeadsState.initial() => const LeadsState();
  
  factory LeadsState.loading() => const LeadsState(status: LeadsStatus.loading);
  
  factory LeadsState.error(String message) => LeadsState(errorMessage: message);
  
  factory LeadsState.loaded({
    required List<Lead> leads,
    List<Lead>? filteredLeads,
    LeadFilter? filter,
  }) =>
      LeadsState(
        status: LeadsStatus.success,
        allLeads: leads,
        filteredLeads: filteredLeads ?? leads,
        filter: filter ?? const LeadFilter(),
      );
  
  factory LeadsState.success({Uint8List? csvBytes}) => LeadsState(csvExportBytes: csvBytes);
}
