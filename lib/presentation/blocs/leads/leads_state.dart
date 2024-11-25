import 'package:equatable/equatable.dart';
import 'package:neetiflow/domain/entities/lead.dart';
import 'package:neetiflow/domain/entities/lead_filter.dart';
import 'dart:typed_data';

abstract class LeadsState extends Equatable {
  const LeadsState();

  @override
  List<Object?> get props => [];
}

class LeadsInitial extends LeadsState {}

class LeadsLoading extends LeadsState {}

class LeadsLoaded extends LeadsState {
  final List<Lead> leads;
  final List<Lead> filteredLeads;
  final LeadFilter? activeFilter;

  const LeadsLoaded({
    required this.leads,
    required this.filteredLeads,
    this.activeFilter,
  });

  @override
  List<Object?> get props => [leads, filteredLeads, activeFilter];
}

class LeadsError extends LeadsState {
  final String message;

  const LeadsError({required this.message});

  @override
  List<Object?> get props => [message];
}

class LeadStatusUpdating extends LeadsState {}

class LeadStatusUpdateError extends LeadsState {
  final String message;

  const LeadStatusUpdateError({required this.message});

  @override
  List<Object?> get props => [message];
}

class LeadsExporting extends LeadsState {}

class LeadsExportSuccess extends LeadsState {
  final Uint8List csvBytes;

  const LeadsExportSuccess({required this.csvBytes});

  @override
  List<Object?> get props => [csvBytes];
}

class LeadsExportError extends LeadsState {
  final String message;

  const LeadsExportError({required this.message});

  @override
  List<Object?> get props => [message];
}
