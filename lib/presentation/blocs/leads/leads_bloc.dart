import 'dart:async';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neetiflow/data/repositories/leads_repository.dart';
import 'package:neetiflow/domain/entities/lead.dart';
import 'package:neetiflow/domain/models/lead_filter.dart';

import '../../../domain/entities/timeline_event.dart';

part 'leads_event.dart';
part 'leads_state.dart';

class LeadsBloc extends Bloc<LeadsEvent, LeadsState> {
  final LeadsRepository _leadsRepository;
  final String _organizationId;
  StreamSubscription<List<Lead>>? _leadsSubscription;
  StreamSubscription<List<TimelineEvent>>? _timelineSubscription;
  StreamSubscription<List<TimelineEvent>>? _allTimelineSubscription;

  LeadsBloc({
    required LeadsRepository leadsRepository,
    required String organizationId,
  })  : _leadsRepository = leadsRepository,
        _organizationId = organizationId,
        super(const LeadsState()) {
    on<LoadLeads>(_onLoadLeads);
    on<UpdateLeadStatus>(_onUpdateLeadStatus);
    on<UpdateLeadProcessStatus>(_onUpdateLeadProcessStatus);
    on<DeleteLead>(_onDeleteLead);
    on<BulkDeleteLeads>(_onBulkDeleteLeads);
    on<BulkUpdateLeadsStatus>(_onBulkUpdateLeadsStatus);
    on<BulkUpdateLeadsProcessStatus>(_onBulkUpdateLeadsProcessStatus);
    on<ImportLeadsFromCSV>(_onImportLeadsFromCSV);
    on<ExportLeadsToCSV>(_onExportLeadsToCSV);
    on<FilterLeads>(_onFilterLeads);
    on<SelectLead>(_onSelectLead);
    on<DeselectLead>(_onDeselectLead);
    on<SelectAllLeads>(_onSelectAllLeads);
    on<DeselectAllLeads>(_onDeselectAllLeads);
    on<SortLeads>(_onSortLeads);
    on<AddLead>(_onAddLead);
    on<UpdateLead>(_onUpdateLead);
    on<LoadSegments>(_onLoadSegments);
    on<SubscribeToTimelineEvents>(_onSubscribeToTimelineEvents);
    on<UnsubscribeFromTimelineEvents>(_onUnsubscribeFromTimelineEvents);
    on<_TimelineEventsUpdated>(_onTimelineEventsUpdated);
    on<_LeadsLoadedEvent>(_handleLeadsLoaded);
    on<_LeadsErrorEvent>(_handleLeadsError);
  }

  @override
  Future<void> close() {
    _leadsSubscription?.cancel();
    _timelineSubscription?.cancel();
    _allTimelineSubscription?.cancel();
    return super.close();
  }

  Future<void> _onLoadLeads(LoadLeads event, Emitter<LeadsState> emit) async {
    try {
      emit(state.copyWith(status: LeadsStatus.loading));
      final leadsStream = _leadsRepository.getLeads(_organizationId);

      await emit.forEach<List<Lead>>(
        leadsStream,
        onData: (leads) {
          final filteredLeads =
              _applyFilter(leads, state.filter);

          return state.copyWith(
            status: LeadsStatus.success,
            allLeads: leads,
            filteredLeads: filteredLeads,
          );
        },
        onError: (error, stackTrace) {
          if (!isClosed) {
            add(_LeadsErrorEvent(error.toString()));
          }
          return state;
        },
      );
    } catch (e) {
      if (!isClosed) {
        add(_LeadsErrorEvent(e.toString()));
      }
    }
  }

  void _handleLeadsLoaded(_LeadsLoadedEvent event, Emitter<LeadsState> emit) {
    emit(state.copyWith(
      status: LeadsStatus.success,
      allLeads: event.allLeads,
      filteredLeads: event.filteredLeads,
    ));
  }

  void _handleLeadsError(_LeadsErrorEvent event, Emitter<LeadsState> emit) {
    emit(state.copyWith(
      status: LeadsStatus.failure,
      errorMessage: event.errorMessage,
    ));
  }

  Future<void> _onDeleteLead(
    DeleteLead event,
    Emitter<LeadsState> emit,
  ) async {
    try {
      await _leadsRepository.deleteLead(_organizationId, event.leadId);

      // Reload leads to reflect the deletion
      add(const LoadLeads());
    } catch (error) {
      if (!isClosed) {
        add(_LeadsErrorEvent(error.toString()));
      }
    }
  }

  Future<void> _onBulkDeleteLeads(
    BulkDeleteLeads event,
    Emitter<LeadsState> emit,
  ) async {
    try {
      await _leadsRepository.bulkDeleteLeads(
        organizationId: _organizationId,
        leadIds: event.leadIds.toSet(),
      );

      // Reload leads to reflect the deletion
      add(const LoadLeads());
    } catch (error) {
      if (!isClosed) {
        add(_LeadsErrorEvent(error.toString()));
      }
    }
  }

  Future<void> _onUpdateLeadStatus(
    UpdateLeadStatus event,
    Emitter<LeadsState> emit,
  ) async {
    try {
      // First update the status in the database
      await _leadsRepository.bulkUpdateLeadsStatus(
        organizationId: _organizationId,
        leadIds: {event.lead.id},
        status: event.status,
      );

      // Then save timeline event if provided
      if (event.timelineEvent != null) {
        await _leadsRepository.addTimelineEvent(
          _organizationId,
          event.timelineEvent!,
        );
      }

      // Create updated lead with new status
      final updatedLead = event.lead.copyWith(
        status: LeadStatus.values.firstWhere(
          (s) =>
              s.toString().split('.').last.toLowerCase() ==
              event.status.toLowerCase(),
          orElse: () => LeadStatus.cold,
        ),
      );

      // Update local state
      final updatedLeads = state.allLeads.map((lead) {
        return lead.id == event.lead.id ? updatedLead : lead;
      }).toList();

      emit(state.copyWith(
        status: LeadsStatus.success,
        allLeads: updatedLeads,
        filteredLeads: _applyFilter(updatedLeads, state.filter),
      ));
    } catch (e) {
      emit(state.copyWith(
        status: LeadsStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onUpdateLeadProcessStatus(
    UpdateLeadProcessStatus event,
    Emitter<LeadsState> emit,
  ) async {
    try {
      // First update the process status in the database
      await _leadsRepository.bulkUpdateLeadsProcessStatus(
        organizationId: _organizationId,
        leadIds: {event.lead.id},
        status: event.status.toString().split('.').last,
      );

      // Then save timeline event if provided
      if (event.timelineEvent != null) {
        await _leadsRepository.addTimelineEvent(
          _organizationId,
          event.timelineEvent!,
        );
      }

      // Create updated lead with new process status
      final updatedLead = event.lead.copyWith(
        processStatus: event.status, // Directly use the provided ProcessStatus enum
      );

      // Update local state
      final updatedLeads = state.allLeads.map((lead) {
        return lead.id == event.lead.id ? updatedLead : lead;
      }).toList();

      emit(state.copyWith(
        status: LeadsStatus.success,
        allLeads: updatedLeads,
        filteredLeads: _applyFilter(updatedLeads, state.filter),
      ));
    } catch (e) {
      emit(state.copyWith(
        status: LeadsStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onBulkUpdateLeadsStatus(
    BulkUpdateLeadsStatus event,
    Emitter<LeadsState> emit,
  ) async {
    try {
      // Get leads from state based on IDs
      final leadsToUpdate = state.allLeads
          .where((lead) => event.leadIds.contains(lead.id))
          .toList();

      final updatedLeads = leadsToUpdate.map((lead) {
        return lead.copyWith(
          status: LeadStatus.values.firstWhere(
            (s) =>
                s.toString().split('.').last.toLowerCase() ==
                event.status.toLowerCase(),
            orElse: () => LeadStatus.cold,
          ),
        );
      }).toList();

      await _leadsRepository.bulkUpdateLeadsStatus(
        organizationId: _organizationId,
        leadIds: event.leadIds.toSet(),
        status: event.status,
      );

      final allUpdatedLeads = state.allLeads.map((lead) {
        final matchingLead = updatedLeads.firstWhere(
          (updatedLead) => updatedLead.id == lead.id,
          orElse: () => lead,
        );
        return matchingLead;
      }).toList();

      add(_LeadsLoadedEvent(
        allLeads: allUpdatedLeads,
        filteredLeads: _applyFilter(
          allUpdatedLeads,
          state.filter,
        ),
      ));
    } catch (error) {
      if (!isClosed) {
        add(_LeadsErrorEvent(error.toString()));
      }
    }
  }

  Future<void> _onBulkUpdateLeadsProcessStatus(
    BulkUpdateLeadsProcessStatus event,
    Emitter<LeadsState> emit,
  ) async {
    try {
      // Get leads from state based on IDs
      final leadsToUpdate = state.allLeads
          .where((lead) => event.leadIds.contains(lead.id))
          .toList();

      final updatedLeads = leadsToUpdate.map((lead) {
        return lead.copyWith(
          processStatus: event.status,
        );
      }).toList();

      // First update the process status in the database
      await _leadsRepository.bulkUpdateLeadsProcessStatus(
        organizationId: _organizationId,
        leadIds: event.leadIds.toSet(),
        status: event.status.toString().split('.').last,
      );

      // Then save timeline events if provided
      if (event.timelineEvents != null) {
        for (final timelineEvent in event.timelineEvents!) {
          await _leadsRepository.addTimelineEvent(
            _organizationId,
            timelineEvent,
          );
        }
      }

      // Update local state
      final allUpdatedLeads = state.allLeads.map((lead) {
        final matchingLead = updatedLeads.firstWhere(
          (updatedLead) => updatedLead.id == lead.id,
          orElse: () => lead,
        );
        return matchingLead;
      }).toList();

      emit(state.copyWith(
        status: LeadsStatus.success,
        allLeads: allUpdatedLeads,
        filteredLeads: _applyFilter(allUpdatedLeads, state.filter),
      ));
    } catch (e) {
      emit(state.copyWith(
        status: LeadsStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onImportLeadsFromCSV(
    ImportLeadsFromCSV event,
    Emitter<LeadsState> emit,
  ) async {
    try {
      emit(state.copyWith(status: LeadsStatus.loading));
      final leads = await _leadsRepository.importLeadsFromCSV(
        Uint8List.fromList(event.bytes),
      );

      // Create all leads in Firestore
      for (final lead in leads) {
        await _leadsRepository.createLead(_organizationId, lead);
      }

      // Reload leads to reflect the import
      add(const LoadLeads());
    } catch (error) {
      if (!isClosed) {
        add(_LeadsErrorEvent(error.toString()));
      }
    }
  }

  Future<void> _onExportLeadsToCSV(
    ExportLeadsToCSV event,
    Emitter<LeadsState> emit,
  ) async {
    try {
      emit(state.copyWith(status: LeadsStatus.loading));
      final bytes = await _leadsRepository.exportLeadsToCSV(state.filteredLeads);
      emit(state.copyWith(
        status: LeadsStatus.success,
        exportedCsvBytes: bytes,
      ));
    } catch (error) {
      if (!isClosed) {
        add(_LeadsErrorEvent(error.toString()));
      }
    }
  }

  void _onFilterLeads(FilterLeads event, Emitter<LeadsState> emit) {
    final filter = event.filter;
    final leads = _applyFilter(state.allLeads, filter);
    emit(state.copyWith(
      filteredLeads: leads,
      filter: filter,
    ));
  }

  void _onSelectLead(SelectLead event, Emitter<LeadsState> emit) {
    final selectedLeadIds = Set<String>.from(state.selectedLeadIds)
      ..add(event.leadId);
    emit(state.copyWith(selectedLeadIds: selectedLeadIds));
  }

  void _onDeselectLead(DeselectLead event, Emitter<LeadsState> emit) {
    final selectedLeadIds = Set<String>.from(state.selectedLeadIds)
      ..remove(event.leadId);
    emit(state.copyWith(selectedLeadIds: selectedLeadIds));
  }

  void _onSelectAllLeads(SelectAllLeads event, Emitter<LeadsState> emit) {
    final selectedLeadIds = Set<String>.from(event.leadIds);
    emit(state.copyWith(selectedLeadIds: selectedLeadIds));
  }

  void _onDeselectAllLeads(DeselectAllLeads event, Emitter<LeadsState> emit) {
    emit(state.copyWith(selectedLeadIds: const {}));
  }

  void _onSortLeads(
    SortLeads event,
    Emitter<LeadsState> emit,
  ) {
    final sortedLeads = _applySort(event.leads, event.column, event.ascending);
    emit(state.copyWith(
      filteredLeads: sortedLeads,
    ));
  }

  Future<void> _onAddLead(AddLead event, Emitter<LeadsState> emit) async {
    try {
      await _leadsRepository.createLead(_organizationId, event.lead);

      add(_LeadsLoadedEvent(
        allLeads: [...state.allLeads, event.lead],
        filteredLeads: _applyFilter(
          [...state.filteredLeads, event.lead],
          state.filter,
        ),
      ));
    } catch (e) {
      add(_LeadsErrorEvent(e.toString()));
    }
  }

  Future<void> _onUpdateLead(UpdateLead event, Emitter<LeadsState> emit) async {
    try {
      await _leadsRepository.updateLead(_organizationId, event.lead);

      final updatedLeads = state.allLeads.map((lead) {
        return lead.id == event.lead.id ? event.lead : lead;
      }).toList();

      add(_LeadsLoadedEvent(
        allLeads: updatedLeads,
        filteredLeads: _applyFilter(
          updatedLeads,
          state.filter,
        ),
      ));
    } catch (e) {
      add(_LeadsErrorEvent(e.toString()));
    }
  }

  Future<void> _onSubscribeToTimelineEvents(
    SubscribeToTimelineEvents event,
    Emitter<LeadsState> emit,
  ) async {
    _timelineSubscription?.cancel();
    _allTimelineSubscription?.cancel();

    // Subscribe to selected lead's timeline
    _timelineSubscription = _leadsRepository
        .getTimelineEvents(_organizationId, event.leadId)
        .listen(
          (events) => add(_TimelineEventsUpdated(
            events: events,
            leadId: event.leadId,
          )),
        );
  }

  void _onUnsubscribeFromTimelineEvents(
    UnsubscribeFromTimelineEvents event,
    Emitter<LeadsState> emit,
  ) {
    _timelineSubscription?.cancel();
    _allTimelineSubscription?.cancel();
    _timelineSubscription = null;
    _allTimelineSubscription = null;
    emit(state.copyWith(selectedLeadTimelineEvents: []));
  }

  void _onTimelineEventsUpdated(
    _TimelineEventsUpdated event,
    Emitter<LeadsState> emit,
  ) {
    // Sort events by timestamp in descending order (newest first)
    final sortedEvents = List<TimelineEvent>.from(event.events)
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

    emit(state.copyWith(
      selectedLeadTimelineEvents: sortedEvents,
      selectedLeadId: event.leadId,
    ));
  }

  List<Lead> _applySort(List<Lead> leads, String column, bool ascending) {
    final sortedLeads = List<Lead>.from(leads);
    sortedLeads.sort((a, b) {
      var compareResult = 0;
      switch (column) {
        case 'name':
          compareResult = _getLeadName(a).compareTo(_getLeadName(b));
          break;
        case 'email':
          compareResult = (a.email).compareTo(b.email);
          break;
        case 'phone':
          compareResult = (a.phone).compareTo(b.phone);
          break;
        case 'status':
          compareResult = a.status.toString().compareTo(b.status.toString());
          break;
        case 'processStatus':
          compareResult =
              a.processStatus.toString().compareTo(b.processStatus.toString());
          break;
        case 'createdAt':
          compareResult = a.createdAt.compareTo(b.createdAt);
          break;
        default:
          compareResult = 0;
      }
      return ascending ? compareResult : -compareResult;
    });
    return sortedLeads;
  }

  String _getLeadName(Lead lead) {
    return '${lead.firstName} ${lead.lastName}'.trim();
  }

  List<Lead> _applyFilter(List<Lead> leads, LeadFilter filter) {
    if (leads.isEmpty) return leads;

    var filteredLeads = List<Lead>.from(leads);

    if (filter.searchTerm != null && filter.searchTerm!.isNotEmpty) {
      final searchTerm = filter.searchTerm!.toLowerCase();
      filteredLeads = filteredLeads.where((lead) {
        return _getLeadName(lead).toLowerCase().contains(searchTerm) ||
            lead.email.toLowerCase().contains(searchTerm) ||
            lead.phone.toLowerCase().contains(searchTerm) ||
            lead.subject.toLowerCase().contains(searchTerm);
      }).toList();
    }

    if (filter.status != null && filter.status!.isNotEmpty) {
      filteredLeads = filteredLeads.where((lead) {
        return lead.status.toString().split('.').last.toLowerCase() ==
            filter.status!.toLowerCase();
      }).toList();
    }

    if (filter.processStatus != null && filter.processStatus!.isNotEmpty) {
      filteredLeads = filteredLeads.where((lead) {
        return lead.processStatus.toString().split('.').last.toLowerCase() ==
            filter.processStatus!.toLowerCase();
      }).toList();
    }

    return filteredLeads;
  }

  void _onLoadSegments(LoadSegments event, Emitter<LeadsState> emit) {
    emit(state.copyWith(segments: event.segments));
  }
}

class _LeadsLoadedEvent extends LeadsEvent {
  final List<Lead> allLeads;
  final List<Lead> filteredLeads;

  _LeadsLoadedEvent({
    required this.allLeads,
    required this.filteredLeads,
  });
}

class _LeadsErrorEvent extends LeadsEvent {
  final String errorMessage;

  _LeadsErrorEvent(this.errorMessage);
}

class _TimelineEventsUpdated extends LeadsEvent {
  final List<TimelineEvent> events;
  final String leadId;

  _TimelineEventsUpdated({
    required this.events,
    required this.leadId,
  });
}
