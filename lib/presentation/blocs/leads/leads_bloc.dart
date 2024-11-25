import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neetiflow/domain/entities/lead.dart';
import 'package:neetiflow/domain/entities/lead_filter.dart';
import 'package:neetiflow/infrastructure/repositories/leads_repository.dart';
import 'package:neetiflow/presentation/blocs/leads/leads_event.dart';
import 'package:neetiflow/presentation/blocs/leads/leads_state.dart';

class LeadsBloc extends Bloc<LeadsEvent, LeadsState> {
  final LeadsRepository _leadsRepository;

  LeadsBloc({required LeadsRepository leadsRepository})
      : _leadsRepository = leadsRepository,
        super(LeadsInitial()) {
    on<LoadLeads>(_onLoadLeads);
    on<UpdateLeadStatus>(_onUpdateLeadStatus);
    on<UpdateLeadProcessStatus>(_onUpdateLeadProcessStatus);
    on<ImportLeadsFromCSV>(_onImportLeadsFromCSV);
    on<ExportLeadsToCSV>(_onExportLeadsToCSV);
    on<CreateLead>(_onCreateLead);
    on<ApplyLeadFilter>(_onApplyLeadFilter);
    on<DeleteLead>(_onDeleteLead);
    on<UpdateLead>(_onUpdateLead);
  }

  List<Lead> _applyFilter(List<Lead> leads, LeadFilter filter) {
    return leads.where((lead) => filter.matches(lead)).toList();
  }

  Future<void> _onLoadLeads(LoadLeads event, Emitter<LeadsState> emit) async {
    emit(LeadsLoading());
    try {
      final leads = await _leadsRepository.getLeads(event.companyId);
      final currentState = state;
      final activeFilter =
          currentState is LeadsLoaded ? currentState.activeFilter : null;

      if (activeFilter != null) {
        final filteredLeads = _applyFilter(leads, activeFilter);
        emit(LeadsLoaded(
          leads: leads,
          filteredLeads: filteredLeads,
          activeFilter: activeFilter,
        ));
      } else {
        emit(LeadsLoaded(leads: leads, filteredLeads: leads));
      }
    } catch (e) {
      emit(LeadsError(message: e.toString()));
    }
  }

  Future<void> _onApplyLeadFilter(
    ApplyLeadFilter event,
    Emitter<LeadsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! LeadsLoaded) return;

    final filteredLeads = _applyFilter(currentState.leads, event.filter);
    emit(LeadsLoaded(
      leads: currentState.leads,
      filteredLeads: filteredLeads,
      activeFilter: event.filter,
    ));
  }

  Future<void> _onUpdateLeadStatus(
    UpdateLeadStatus event,
    Emitter<LeadsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! LeadsLoaded) return;

    emit(LeadStatusUpdating());
    try {
      await _leadsRepository.updateLeadStatus(
        companyId: event.companyId,
        leadId: event.leadId,
        status: event.status,
      );

      // Reload leads to get updated data
      final leads = await _leadsRepository.getLeads(event.companyId);
      final activeFilter = currentState.activeFilter;

      if (activeFilter != null) {
        final filteredLeads = _applyFilter(leads, activeFilter);
        emit(LeadsLoaded(
          leads: leads,
          filteredLeads: filteredLeads,
          activeFilter: activeFilter,
        ));
      } else {
        emit(LeadsLoaded(leads: leads, filteredLeads: leads));
      }
    } catch (e) {
      emit(LeadStatusUpdateError(message: e.toString()));
      // Revert to previous state
      emit(currentState);
    }
  }

  Future<void> _onUpdateLeadProcessStatus(
    UpdateLeadProcessStatus event,
    Emitter<LeadsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! LeadsLoaded) return;

    emit(LeadStatusUpdating());
    try {
      await _leadsRepository.updateLeadStatus(
        companyId: event.companyId,
        leadId: event.leadId,
        processStatus: event.processStatus,
      );

      // Reload leads to get updated data
      final leads = await _leadsRepository.getLeads(event.companyId);
      final activeFilter = currentState.activeFilter;

      if (activeFilter != null) {
        final filteredLeads = _applyFilter(leads, activeFilter);
        emit(LeadsLoaded(
          leads: leads,
          filteredLeads: filteredLeads,
          activeFilter: activeFilter,
        ));
      } else {
        emit(LeadsLoaded(leads: leads, filteredLeads: leads));
      }
    } catch (e) {
      emit(LeadStatusUpdateError(message: e.toString()));
      // Revert to previous state
      emit(currentState);
    }
  }

  Future<void> _onImportLeadsFromCSV(
    ImportLeadsFromCSV event,
    Emitter<LeadsState> emit,
  ) async {
    emit(LeadsLoading());
    try {
      // Parse CSV and convert to leads
      final leads = await _leadsRepository.importLeadsFromCSV(event.fileBytes);

      // Save the imported leads
      await _leadsRepository.saveImportedLeads(event.companyId, leads);

      // Reload leads to get updated data
      final updatedLeads = await _leadsRepository.getLeads(event.companyId);
      final currentState = state;
      final activeFilter =
          currentState is LeadsLoaded ? currentState.activeFilter : null;

      if (activeFilter != null) {
        final filteredLeads = _applyFilter(updatedLeads, activeFilter);
        emit(LeadsLoaded(
          leads: updatedLeads,
          filteredLeads: filteredLeads,
          activeFilter: activeFilter,
        ));
      } else {
        emit(LeadsLoaded(leads: updatedLeads, filteredLeads: updatedLeads));
      }
    } catch (e) {
      emit(LeadsError(message: 'Error importing leads: ${e.toString()}'));
    }
  }

  Future<void> _onExportLeadsToCSV(
    ExportLeadsToCSV event,
    Emitter<LeadsState> emit,
  ) async {
    print('Starting CSV export process...');
    if (event.companyId == null) {
      print('Export failed: Company ID is null');
      emit(const LeadsError(message: 'Company ID is required for export'));
      return;
    }

    final currentState = state;
    if (currentState is! LeadsLoaded) {
      print('Export failed: Current state is not LeadsLoaded');
      emit(const LeadsError(message: 'No leads loaded to export'));
      return;
    }

    try {
      // Store the current loaded state
      final loadedState = currentState;

      emit(LeadsExporting());
      // Use filteredLeads if there's an active filter, otherwise use all leads
      final leadsToExport = currentState.activeFilter != null
          ? currentState.filteredLeads
          : currentState.leads;

      print('Preparing to export ${leadsToExport.length} leads');
      print('Filter active: ${currentState.activeFilter != null}');

      if (leadsToExport.isEmpty) {
        print('Export failed: No leads to export');
        emit(const LeadsError(message: 'No leads available to export'));
        emit(loadedState); // Return to loaded state
        return;
      }

      // Debug print first lead data
      if (leadsToExport.isNotEmpty) {
        final firstLead = leadsToExport.first;
        print('Sample lead data:');
        print('  ID: ${firstLead.id}');
        print('  Name: ${firstLead.firstName} ${firstLead.lastName}');
        print('  Email: ${firstLead.email}');
        print('  Status: ${firstLead.status}');
      }

      final csvBytes = await _leadsRepository.exportLeadsToCSV(leadsToExport);
      print('CSV export completed successfully');
      emit(LeadsExportSuccess(csvBytes: csvBytes));
      // Return to the previous loaded state after successful export
      emit(loadedState);
    } catch (e, stackTrace) {
      print('Export failed with error: $e');
      print('Stack trace: $stackTrace');
      emit(LeadsError(message: 'Error exporting leads: ${e.toString()}'));
      // If we have a loaded state, return to it after error
      emit(currentState);
    }
  }

  Future<void> _onCreateLead(
    CreateLead event,
    Emitter<LeadsState> emit,
  ) async {
    emit(LeadsLoading());
    try {
      await _leadsRepository.createLead(event.companyId, event.lead);
      final leads = await _leadsRepository.getLeads(event.companyId);
      final currentState = state;
      final activeFilter =
          currentState is LeadsLoaded ? currentState.activeFilter : null;

      if (activeFilter != null) {
        final filteredLeads = _applyFilter(leads, activeFilter);
        emit(LeadsLoaded(
          leads: leads,
          filteredLeads: filteredLeads,
          activeFilter: activeFilter,
        ));
      } else {
        emit(LeadsLoaded(leads: leads, filteredLeads: leads));
      }
    } catch (e) {
      emit(LeadsError(message: 'Error creating lead: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteLead(DeleteLead event, Emitter<LeadsState> emit) async {
    final currentState = state;
    if (currentState is! LeadsLoaded) return;

    emit(LeadsLoading());
    try {
      await _leadsRepository.deleteLead(event.companyId, event.leadId);
      final leads = await _leadsRepository.getLeads(event.companyId);
      final activeFilter = currentState.activeFilter;

      if (activeFilter != null) {
        final filteredLeads = _applyFilter(leads, activeFilter);
        emit(LeadsLoaded(
          leads: leads,
          filteredLeads: filteredLeads,
          activeFilter: activeFilter,
        ));
      } else {
        emit(LeadsLoaded(leads: leads, filteredLeads: leads));
      }
    } catch (e) {
      emit(LeadsError(message: 'Error deleting lead: ${e.toString()}'));
      emit(currentState);
    }
  }

  Future<void> _onUpdateLead(UpdateLead event, Emitter<LeadsState> emit) async {
    final currentState = state;
    if (currentState is! LeadsLoaded) return;

    emit(LeadsLoading());
    try {
      await _leadsRepository.updateLead(event.companyId, event.lead);
      final leads = await _leadsRepository.getLeads(event.companyId);
      final activeFilter = currentState.activeFilter;

      if (activeFilter != null) {
        final filteredLeads = _applyFilter(leads, activeFilter);
        emit(LeadsLoaded(
          leads: leads,
          filteredLeads: filteredLeads,
          activeFilter: activeFilter,
        ));
      } else {
        emit(LeadsLoaded(leads: leads, filteredLeads: leads));
      }
    } catch (e) {
      emit(LeadsError(message: 'Error updating lead: ${e.toString()}'));
      emit(currentState);
    }
  }
}
