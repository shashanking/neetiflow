import 'package:equatable/equatable.dart';
import 'package:neetiflow/domain/entities/lead.dart';

abstract class LeadsState extends Equatable {
  const LeadsState();

  @override
  List<Object?> get props => [];
}

class LeadsInitial extends LeadsState {}

class LeadsLoading extends LeadsState {}

class LeadsLoaded extends LeadsState {
  final List<Lead> leads;

  const LeadsLoaded({required this.leads});

  @override
  List<Object?> get props => [leads];
}

class LeadsError extends LeadsState {
  final String message;

  const LeadsError({required this.message});

  @override
  List<Object?> get props => [message];
}

class LeadStatusUpdating extends LeadsState {}

class LeadStatusUpdateSuccess extends LeadsState {}

class LeadStatusUpdateError extends LeadsState {
  final String message;

  const LeadStatusUpdateError({required this.message});

  @override
  List<Object?> get props => [message];
}
