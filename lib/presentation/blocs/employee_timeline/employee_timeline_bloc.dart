import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:neetiflow/data/repositories/employee_timeline_repository.dart';
import 'package:neetiflow/domain/entities/employee_timeline_event.dart' as entity;

// Events
abstract class TimelineEvent extends Equatable {
  const TimelineEvent();

  @override
  List<Object> get props => [];
}

class LoadEmployeeTimeline extends TimelineEvent {
  final String employeeId;
  final String companyId;

  const LoadEmployeeTimeline({
    required this.employeeId,
    required this.companyId,
  });

  @override
  List<Object> get props => [employeeId, companyId];
}

// States
abstract class EmployeeTimelineState extends Equatable {
  const EmployeeTimelineState();

  @override
  List<Object> get props => [];
}

class EmployeeTimelineInitial extends EmployeeTimelineState {}

class EmployeeTimelineLoading extends EmployeeTimelineState {}

class EmployeeTimelineLoaded extends EmployeeTimelineState {
  final List<entity.EmployeeTimelineEvent> events;

  const EmployeeTimelineLoaded(this.events);

  @override
  List<Object> get props => [events];
}

class EmployeeTimelineError extends EmployeeTimelineState {
  final String message;

  const EmployeeTimelineError(this.message);

  @override
  List<Object> get props => [message];
}

// Bloc
class EmployeeTimelineBloc extends Bloc<TimelineEvent, EmployeeTimelineState> {
  final EmployeeTimelineRepository _repository;
  StreamSubscription? _eventsSubscription;

  EmployeeTimelineBloc(this._repository) : super(EmployeeTimelineInitial()) {
    on<LoadEmployeeTimeline>((event, emit) async {
      emit(EmployeeTimelineLoading());
      
      await _eventsSubscription?.cancel();
      _eventsSubscription = _repository
          .getTimelineEvents(event.companyId, event.employeeId)
          .listen(
            (events) => add(_TimelineEventsUpdated(events)),
            onError: (error) => add(_TimelineError(error.toString())),
          );
    });

    on<_TimelineEventsUpdated>((event, emit) {
      emit(EmployeeTimelineLoaded(event.events));
    });

    on<_TimelineError>((event, emit) {
      emit(EmployeeTimelineError(event.message));
    });
  }

  @override
  Future<void> close() {
    _eventsSubscription?.cancel();
    return super.close();
  }
}

// Private Events
class _TimelineEventsUpdated extends TimelineEvent {
  final List<entity.EmployeeTimelineEvent> events;

  const _TimelineEventsUpdated(this.events);

  @override
  List<Object> get props => [events];
}

class _TimelineError extends TimelineEvent {
  final String message;

  const _TimelineError(this.message);

  @override
  List<Object> get props => [message];
}
