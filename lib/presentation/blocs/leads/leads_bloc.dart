import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  }

  Future<void> _onLoadLeads(LoadLeads event, Emitter<LeadsState> emit) async {
    emit(LeadsLoading());
    try {
      final leads = await _leadsRepository.getLeads(event.companyId);
      emit(LeadsLoaded(leads: leads));
    } catch (e) {
      emit(LeadsError(message: e.toString()));
    }
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
        event.companyId,
        event.leadId,
        status: event.status,
      );
      
      // Reload leads to get updated data
      final leads = await _leadsRepository.getLeads(event.companyId);
      emit(LeadsLoaded(leads: leads));
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
        event.companyId,
        event.leadId,
        processStatus: event.processStatus,
      );
      
      // Reload leads to get updated data
      final leads = await _leadsRepository.getLeads(event.companyId);
      emit(LeadsLoaded(leads: leads));
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
      emit(LeadsLoaded(leads: updatedLeads));
    } catch (e) {
      emit(LeadsError(message: 'Error importing leads: ${e.toString()}'));
    }
  }

  Future<void> _onExportLeadsToCSV(
    ExportLeadsToCSV event,
    Emitter<LeadsState> emit,
  ) async {
    if (event.companyId == null) {
      emit(const LeadsError(message: 'Company ID is required for export'));
      return;
    }
    
    try {
      await _leadsRepository.exportLeadsToCSV(event.companyId!);
    } catch (e) {
      emit(LeadsError(message: 'Error exporting leads: ${e.toString()}'));
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
      emit(LeadsLoaded(leads: leads));
    } catch (e) {
      emit(LeadsError(message: 'Error creating lead: ${e.toString()}'));
    }
  }
}
