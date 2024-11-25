import 'dart:typed_data';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neetiflow/domain/entities/lead.dart';
import 'package:neetiflow/infrastructure/repositories/leads_repository.dart';

// Events
abstract class LeadsEvent extends Equatable {
  const LeadsEvent();

  @override
  List<Object?> get props => [];
}

class LoadLeads extends LeadsEvent {
  final String companyId;

  const LoadLeads(this.companyId);

  @override
  List<Object?> get props => [companyId];
}

class UpdateLeadStatus extends LeadsEvent {
  final String companyId;
  final String leadId;
  final LeadStatus? status;
  final ProcessStatus? processStatus;

  const UpdateLeadStatus(
    this.companyId,
    this.leadId, {
    this.status,
    this.processStatus,
  });

  @override
  List<Object?> get props => [companyId, leadId, status, processStatus];
}

class ImportLeadsFromCSV extends LeadsEvent {
  final String companyId;
  final Uint8List fileBytes;

  const ImportLeadsFromCSV(this.companyId, this.fileBytes);

  @override
  List<Object?> get props => [companyId, fileBytes];
}

class ExportLeadsToCSV extends LeadsEvent {
  const ExportLeadsToCSV();
}

class CreateLead extends LeadsEvent {
  final String companyId;
  final Lead lead;

  const CreateLead(this.companyId, this.lead);

  @override
  List<Object?> get props => [companyId, lead];
}

// States
abstract class LeadsState extends Equatable {
  const LeadsState();

  @override
  List<Object?> get props => [];
}

class LeadsInitial extends LeadsState {}

class LeadsLoading extends LeadsState {}

class LeadsLoaded extends LeadsState {
  final List<Lead> leads;

  const LeadsLoaded(this.leads);

  @override
  List<Object?> get props => [leads];
}

class LeadsError extends LeadsState {
  final String message;

  const LeadsError(this.message);

  @override
  List<Object?> get props => [message];
}

class LeadsExported extends LeadsState {
  final Uint8List csvBytes;

  const LeadsExported(this.csvBytes);

  @override
  List<Object?> get props => [csvBytes];
}

// Bloc
class LeadsBloc extends Bloc<LeadsEvent, LeadsState> {
  final LeadsRepository _repository;
  List<Lead> _leads = [];

  LeadsBloc({required LeadsRepository repository})
      : _repository = repository,
        super(LeadsInitial()) {
    on<LoadLeads>(_onLoadLeads);
    on<UpdateLeadStatus>(_onUpdateLeadStatus);
    on<ImportLeadsFromCSV>(_onImportLeadsFromCSV);
    on<ExportLeadsToCSV>(_onExportLeadsToCSV);
    on<CreateLead>(_onCreateLead);
  }

  Future<void> _onLoadLeads(LoadLeads event, Emitter<LeadsState> emit) async {
    try {
      emit(LeadsLoading());
      _leads = await _repository.getLeads(event.companyId);
      emit(LeadsLoaded(_leads));
    } catch (e) {
      emit(LeadsError(e.toString()));
    }
  }

  Future<void> _onUpdateLeadStatus(
    UpdateLeadStatus event,
    Emitter<LeadsState> emit,
  ) async {
    try {
      await _repository.updateLeadStatus(
        event.companyId,
        event.leadId,
        status: event.status,
        processStatus: event.processStatus,
      );

      // Reload leads to get updated data
      _leads = await _repository.getLeads(event.companyId);
      emit(LeadsLoaded(_leads));
    } catch (e) {
      emit(LeadsError(e.toString()));
    }
  }

  Future<void> _onImportLeadsFromCSV(
    ImportLeadsFromCSV event,
    Emitter<LeadsState> emit,
  ) async {
    try {
      emit(LeadsLoading());
      final leads = await _repository.importLeadsFromCSV(event.fileBytes);
      await _repository.saveImportedLeads(event.companyId, leads);
      
      // Reload leads to get updated data
      _leads = await _repository.getLeads(event.companyId);
      emit(LeadsLoaded(_leads));
    } catch (e) {
      emit(LeadsError(e.toString()));
    }
  }

  Future<void> _onExportLeadsToCSV(
    ExportLeadsToCSV event,
    Emitter<LeadsState> emit,
  ) async {
    try {
      final csvBytes = await _repository.exportLeadsToCSV(_leads);
      emit(LeadsExported(csvBytes));
      emit(LeadsLoaded(_leads)); // Restore leads state
    } catch (e) {
      emit(LeadsError(e.toString()));
    }
  }

  Future<void> _onCreateLead(
    CreateLead event,
    Emitter<LeadsState> emit,
  ) async {
    try {
      await _repository.createLead(event.companyId, event.lead);
      
      // Reload leads to get updated data
      _leads = await _repository.getLeads(event.companyId);
      emit(LeadsLoaded(_leads));
    } catch (e) {
      emit(LeadsError(e.toString()));
    }
  }
}
