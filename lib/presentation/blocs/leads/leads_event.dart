import 'package:equatable/equatable.dart';
import 'package:neetiflow/domain/entities/lead.dart';
import 'dart:typed_data';

abstract class LeadsEvent extends Equatable {
  const LeadsEvent();

  @override
  List<Object?> get props => [];
}

class LoadLeads extends LeadsEvent {
  final String companyId;

  const LoadLeads({required this.companyId});

  @override
  List<Object?> get props => [companyId];
}

class UpdateLeadStatus extends LeadsEvent {
  final String companyId;
  final String leadId;
  final LeadStatus status;

  const UpdateLeadStatus({
    required this.companyId,
    required this.leadId,
    required this.status,
  });

  @override
  List<Object?> get props => [companyId, leadId, status];
}

class UpdateLeadProcessStatus extends LeadsEvent {
  final String companyId;
  final String leadId;
  final ProcessStatus processStatus;

  const UpdateLeadProcessStatus({
    required this.companyId,
    required this.leadId,
    required this.processStatus,
  });

  @override
  List<Object?> get props => [companyId, leadId, processStatus];
}

class ImportLeadsFromCSV extends LeadsEvent {
  final String companyId;
  final Uint8List fileBytes;

  const ImportLeadsFromCSV({
    required this.companyId,
    required this.fileBytes,
  });

  @override
  List<Object?> get props => [companyId, fileBytes];
}

class ExportLeadsToCSV extends LeadsEvent {
  final String? companyId;

  const ExportLeadsToCSV({this.companyId});

  @override
  List<Object?> get props => [companyId];
}

class CreateLead extends LeadsEvent {
  final String companyId;
  final Lead lead;

  const CreateLead({
    required this.companyId,
    required this.lead,
  });

  @override
  List<Object?> get props => [companyId, lead];
}
