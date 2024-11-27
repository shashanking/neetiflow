import 'dart:async';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neetiflow/data/repositories/leads_repository.dart';
import 'package:neetiflow/domain/entities/lead.dart';
import 'package:neetiflow/domain/models/lead_filter.dart';
import 'package:neetiflow/domain/models/lead_model.dart' as models;
import 'package:neetiflow/domain/entities/lead.dart' as entities;

part 'leads_event.dart';
part 'leads_state.dart';

class LeadsBloc extends Bloc<LeadsEvent, LeadsState> {
  final LeadsRepository _leadsRepository;
  final String _companyId;
  StreamSubscription<List<models.LeadModel>>? _leadsSubscription;

  LeadsBloc({
    required LeadsRepository leadsRepository,
    required String companyId,
  })  : _leadsRepository = leadsRepository,
        _companyId = companyId,
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
  }

  Future<void> _onLoadLeads(LoadLeads event, Emitter<LeadsState> emit) async {
    emit(state.copyWith(status: LeadsStatus.loading));
    await _leadsSubscription?.cancel();
    _leadsSubscription = _leadsRepository.getLeads(_companyId).listen(
      (leads) {
        final filteredLeads = _applyFilter(
            leads.map((lead) => _convertToEntity(lead)).toList(), state.filter);
        emit(state.copyWith(
          status: LeadsStatus.success,
          allLeads: leads.map((lead) => _convertToEntity(lead)).toList(),
          filteredLeads: filteredLeads,
        ));
      },
      onError: (error) {
        emit(state.copyWith(
          status: LeadsStatus.failure,
          errorMessage: error.toString(),
        ));
      },
    );
  }

  Future<void> _onUpdateLeadStatus(
    UpdateLeadStatus event,
    Emitter<LeadsState> emit,
  ) async {
    try {
      final model = _convertToModel(event.lead);
      final updatedModel = model.copyWith(
        status: models.LeadStatus.values.firstWhere(
          (s) =>
              s.toString().split('.').last.toLowerCase() ==
              event.status.toLowerCase(),
          orElse: () => models.LeadStatus.cold,
        ),
      );
      await _leadsRepository.updateLead(_companyId, updatedModel);
    } catch (error) {
      emit(state.copyWith(
        status: LeadsStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }

  Future<void> _onUpdateLeadProcessStatus(
    UpdateLeadProcessStatus event,
    Emitter<LeadsState> emit,
  ) async {
    try {
      final model = _convertToModel(event.lead);
      final updatedModel = model.copyWith(
        processStatus: models.ProcessStatus.values.firstWhere(
          (s) =>
              s.toString().split('.').last ==
              event.status.toString().split('.').last,
          orElse: () => models.ProcessStatus.fresh,
        ),
      );
      await _leadsRepository.updateLead(_companyId, updatedModel);
    } catch (error) {
      emit(state.copyWith(
        status: LeadsStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }

  Future<void> _onDeleteLead(
    DeleteLead event,
    Emitter<LeadsState> emit,
  ) async {
    try {
      await _leadsRepository.deleteLead(_companyId, event.leadId);
    } catch (error) {
      emit(state.copyWith(
        status: LeadsStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }

  Future<void> _onBulkDeleteLeads(
    BulkDeleteLeads event,
    Emitter<LeadsState> emit,
  ) async {
    try {
      await _leadsRepository.bulkDeleteLeads(
        companyId: _companyId,
        leadIds: event.leadIds.toSet(),
      );
      emit(state.copyWith(selectedLeadIds: const {}));
    } catch (error) {
      emit(state.copyWith(
        status: LeadsStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }

  Future<void> _onBulkUpdateLeadsStatus(
    BulkUpdateLeadsStatus event,
    Emitter<LeadsState> emit,
  ) async {
    try {
      await _leadsRepository.bulkUpdateLeadsStatus(
        companyId: _companyId,
        leadIds: event.leadIds.toSet(),
        status: event.status,
      );
    } catch (error) {
      emit(state.copyWith(
        status: LeadsStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }

  Future<void> _onBulkUpdateLeadsProcessStatus(
    BulkUpdateLeadsProcessStatus event,
    Emitter<LeadsState> emit,
  ) async {
    try {
      await _leadsRepository.bulkUpdateLeadsProcessStatus(
        companyId: _companyId,
        leadIds: event.leadIds.toSet(),
        status: event.status,
      );
    } catch (error) {
      emit(state.copyWith(
        status: LeadsStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }

  Future<void> _onImportLeadsFromCSV(
    ImportLeadsFromCSV event,
    Emitter<LeadsState> emit,
  ) async {
    try {
      emit(state.copyWith(status: LeadsStatus.loading));
      final leads = await _leadsRepository
          .importLeadsFromCSV(Uint8List.fromList(event.bytes));
      final convertedLeads = leads.map(_convertToEntity).toList();
      emit(state.copyWith(
        status: LeadsStatus.success,
        allLeads: convertedLeads,
        filteredLeads: convertedLeads,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: LeadsStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }

  Future<void> _onExportLeadsToCSV(
    ExportLeadsToCSV event,
    Emitter<LeadsState> emit,
  ) async {
    try {
      emit(state.copyWith(status: LeadsStatus.loading));
      final leads = state.filteredLeads.map(_convertToModel).toList();
      final bytes = await _leadsRepository.exportLeadsToCSV(leads);
      emit(state.copyWith(
        status: LeadsStatus.success,
        csvExportBytes: bytes,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: LeadsStatus.failure,
        errorMessage: error.toString(),
      ));
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
    final selectedLeadIds = state.filteredLeads
        .where((lead) => lead.id != null)
        .map((lead) => lead.id)
        .toSet();
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
      // Convert Lead entity to LeadModel
      final leadModel = models.LeadModel(
        id: event.lead.id,
        name: _getLeadName(event.lead),
        email: event.lead.email,
        phone: event.lead.phone,
        company: event.lead.metadata?['company'],
        status: models.LeadStatus.values.firstWhere(
          (s) => s.toString().split('.').last == event.lead.status.toString().split('.').last,
          orElse: () => models.LeadStatus.cold,
        ),
        processStatus: models.ProcessStatus.values.firstWhere(
          (s) => s.toString().split('.').last == event.lead.processStatus.toString().split('.').last,
          orElse: () => models.ProcessStatus.fresh,
        ),
        createdAt: event.lead.createdAt,
      );

      await _leadsRepository.createLead(_companyId, leadModel);
      
      // Reload leads to reflect the new addition
      add(const LoadLeads());
    } catch (e) {
      emit(state.copyWith(status: LeadsStatus.failure));
    }
  }

  Future<void> _onUpdateLead(UpdateLead event, Emitter<LeadsState> emit) async {
    try {
      // Convert Lead entity to LeadModel
      final leadModel = models.LeadModel(
        id: event.lead.id,
        name: _getLeadName(event.lead),
        email: event.lead.email,
        phone: event.lead.phone,
        company: event.lead.metadata?['company'],
        status: models.LeadStatus.values.firstWhere(
          (s) => s.toString().split('.').last == event.lead.status.toString().split('.').last,
          orElse: () => models.LeadStatus.cold,
        ),
        processStatus: models.ProcessStatus.values.firstWhere(
          (s) => s.toString().split('.').last == event.lead.processStatus.toString().split('.').last,
          orElse: () => models.ProcessStatus.fresh,
        ),
        createdAt: event.lead.createdAt,
      );

      await _leadsRepository.updateLead(_companyId, leadModel);
      
      // Reload leads to reflect the update
      add(const LoadLeads());
    } catch (e) {
      emit(state.copyWith(status: LeadsStatus.failure));
    }
  }

  List<entities.Lead> _applySort(List<entities.Lead> leads, String column, bool ascending) {
    final sortedLeads = List<entities.Lead>.from(leads);
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

  String _getLeadName(entities.Lead lead) {
    return '${lead.firstName} ${lead.lastName}'.trim();
  }

  List<entities.Lead> _applyFilter(List<entities.Lead> leads, LeadFilter filter) {
    if (leads.isEmpty) return leads;

    var filteredLeads = List<entities.Lead>.from(leads);

    // Apply search term filter
    if (filter.searchTerm != null && filter.searchTerm!.isNotEmpty) {
      final searchTerm = filter.searchTerm!.toLowerCase();
      filteredLeads = filteredLeads.where((lead) {
        return _getLeadName(lead).toLowerCase().contains(searchTerm) ||
            lead.email.toLowerCase().contains(searchTerm) ||
            lead.phone.toLowerCase().contains(searchTerm) ||
            lead.subject.toLowerCase().contains(searchTerm);
      }).toList();
    }

    // Apply status filter
    if (filter.status != null && filter.status!.isNotEmpty) {
      filteredLeads = filteredLeads.where((lead) {
        return lead.status.toString().split('.').last.toLowerCase() ==
            filter.status!.toLowerCase();
      }).toList();
    }

    // Apply process status filter
    if (filter.processStatus != null && filter.processStatus!.isNotEmpty) {
      filteredLeads = filteredLeads.where((lead) {
        return lead.processStatus.toString().split('.').last.toLowerCase() ==
            filter.processStatus!.toLowerCase();
      }).toList();
    }

    return filteredLeads;
  }

  entities.Lead _convertToEntity(models.LeadModel model) {
    final entityStatus = entities.LeadStatus.values.firstWhere(
      (s) =>
          s.toString().split('.').last ==
          model.status.toString().split('.').last,
      orElse: () => entities.LeadStatus.cold,
    );

    final entityProcessStatus = entities.ProcessStatus.values.firstWhere(
      (s) =>
          s.toString().split('.').last ==
          model.processStatus.toString().split('.').last,
      orElse: () => entities.ProcessStatus.fresh,
    );

    final nameParts = (model.name ?? '').split(' ');
    final hasLastName = nameParts.length > 1;

    return entities.Lead(
      id: model.id ?? '',
      uid: model.id ?? '',
      firstName: nameParts.isNotEmpty ? nameParts[0] : '',
      lastName: hasLastName ? nameParts.sublist(1).join(' ') : '',
      phone: model.phone ?? '',
      email: model.email ?? '',
      subject: model.company ?? '',
      message: '',
      status: entityStatus,
      processStatus: entityProcessStatus,
      createdAt: model.createdAt,
      metadata: const {},
      segments: const [],
    );
  }

  models.LeadModel _convertToModel(entities.Lead lead) {
    final modelStatus = models.LeadStatus.values.firstWhere(
      (s) =>
          s.toString().split('.').last ==
          lead.status.toString().split('.').last,
      orElse: () => models.LeadStatus.cold,
    );

    final modelProcessStatus = models.ProcessStatus.values.firstWhere(
      (s) =>
          s.toString().split('.').last ==
          lead.processStatus.toString().split('.').last,
      orElse: () => models.ProcessStatus.fresh,
    );

    return models.LeadModel(
      id: lead.id,
      name: _getLeadName(lead),
      email: lead.email,
      phone: lead.phone,
      company: lead.subject,
      status: modelStatus,
      processStatus: modelProcessStatus,
      createdAt: lead.createdAt,
    );
  }

  void _onLoadSegments(LoadSegments event, Emitter<LeadsState> emit) {
    emit(state.copyWith(segments: event.segments));
  }

  @override
  Future<void> close() {
    _leadsSubscription?.cancel();
    return super.close();
  }
}
