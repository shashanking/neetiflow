part of 'leads_bloc.dart';

/// Abstract base class for all events in the leads bloc.
abstract class LeadsEvent {
  const LeadsEvent();

  List<Object?> get props => [];
}

/// Event to load leads.
class LoadLeads extends LeadsEvent {
  const LoadLeads();
}

/// Event to update the status of a lead.
class UpdateLeadStatus extends LeadsEvent {
  final Lead lead;
  final String status;
  final TimelineEvent? timelineEvent;

  const UpdateLeadStatus({
    required this.lead,
    required this.status,
    this.timelineEvent,
  });

  @override
  List<Object?> get props => [lead, status, timelineEvent];
}

/// Event to update the process status of a lead.
class UpdateLeadProcessStatus extends LeadsEvent {
  final Lead lead;
  final ProcessStatus status;
  final TimelineEvent? timelineEvent;

  const UpdateLeadProcessStatus({
    required this.lead,
    required this.status,
    this.timelineEvent,
  });

  @override
  List<Object?> get props => [lead, status, timelineEvent];
}

/// Event to delete a lead.
class DeleteLead extends LeadsEvent {
  final String leadId;

  const DeleteLead({required this.leadId});

  @override
  List<Object> get props => [leadId];
}

/// Event to delete multiple leads.
class BulkDeleteLeads extends LeadsEvent {
  final List<String> leadIds;

  const BulkDeleteLeads({required this.leadIds});

  @override
  List<Object> get props => [leadIds];
}

/// Event to update the status of multiple leads.
class BulkUpdateLeadsStatus extends LeadsEvent {
  final List<String> leadIds;
  final String status;

  const BulkUpdateLeadsStatus({
    required this.leadIds,
    required this.status,
  });

  @override
  List<Object> get props => [leadIds, status];
}

/// Event to add a new lead
class AddLead extends LeadsEvent {
  final Lead lead;

  const AddLead({required this.lead});

  @override
  List<Object> get props => [lead];
}

/// Event to update an existing lead
class UpdateLead extends LeadsEvent {
  final Lead lead;
  final TimelineEvent? timelineEvent;

  const UpdateLead({
    required this.lead,
    this.timelineEvent,
  });

  @override
  List<Object?> get props => [lead, timelineEvent];
}

/// Event to update the process status of multiple leads.
class BulkUpdateLeadsProcessStatus extends LeadsEvent {
  final List<String> leadIds;
  final ProcessStatus status;
  final List<TimelineEvent>? timelineEvents;

  const BulkUpdateLeadsProcessStatus({
    required this.leadIds,
    required this.status,
    this.timelineEvents,
  });

  @override
  List<Object?> get props => [leadIds, status, timelineEvents];
}

/// Event to import leads from a CSV file.
class ImportLeadsFromCSV extends LeadsEvent {
  final List<int> bytes;

  const ImportLeadsFromCSV({required this.bytes});

  @override
  List<Object> get props => [bytes];
}

/// Event to export leads to a CSV file.
class ExportLeadsToCSV extends LeadsEvent {
  const ExportLeadsToCSV();
}

/// Event to filter leads.
class FilterLeads extends LeadsEvent {
  final LeadFilter filter;

  const FilterLeads({required this.filter});

  @override
  List<Object> get props => [filter];
}

/// Event to select a lead.
class SelectLead extends LeadsEvent {
  final String leadId;

  const SelectLead({required this.leadId});

  @override
  List<Object> get props => [leadId];
}

/// Event to deselect a lead.
class DeselectLead extends LeadsEvent {
  final String leadId;

  const DeselectLead({required this.leadId});

  @override
  List<Object> get props => [leadId];
}

/// Event to select all leads.
class SelectAllLeads extends LeadsEvent {
  final List<String> leadIds;

  const SelectAllLeads({required this.leadIds});

  @override
  List<Object> get props => [leadIds];
}

/// Event to deselect all leads.
class DeselectAllLeads extends LeadsEvent {
  const DeselectAllLeads();
}

/// Event to sort leads.
class SortLeads extends LeadsEvent {
  final List<Lead> leads;
  final String column;
  final bool ascending;

  const SortLeads({
    required this.leads,
    required this.column,
    required this.ascending,
  });

  @override
  List<Object> get props => [leads, column, ascending];
}

/// Event to load segments
class LoadSegments extends LeadsEvent {
  final List<String> segments;

  const LoadSegments({required this.segments});

  @override
  List<Object> get props => [segments];
}

/// Event to handle custom events
class CustomEvent extends LeadsEvent {
  final String eventType;
  final Map<String, dynamic> eventData;

  const CustomEvent({
    required this.eventType,
    required this.eventData,
  });

  @override
  List<Object> get props => [eventType, eventData];
}

/// Event to subscribe to timeline events for a specific lead
class SubscribeToTimelineEvents extends LeadsEvent {
  final String leadId;

  const SubscribeToTimelineEvents({required this.leadId});

  @override
  List<Object> get props => [leadId];
}

/// Event to unsubscribe from timeline events
class UnsubscribeFromTimelineEvents extends LeadsEvent {
  const UnsubscribeFromTimelineEvents();

  @override
  List<Object> get props => [];
}
