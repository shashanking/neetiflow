import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:neetiflow/infrastructure/repositories/firebase_employees_repository.dart';

// Events
abstract class EmployeeStatusEvent extends Equatable {
  const EmployeeStatusEvent();

  @override
  List<Object?> get props => [];
}

class UpdateEmployeeStatus extends EmployeeStatusEvent {
  final String employeeId;
  final String companyId;
  final bool isActive;

  const UpdateEmployeeStatus({
    required this.employeeId,
    required this.companyId,
    required this.isActive,
  });

  @override
  List<Object?> get props => [employeeId, companyId, isActive];
}

// States
abstract class EmployeeStatusState extends Equatable {
  const EmployeeStatusState();

  @override
  List<Object?> get props => [];
}

class EmployeeStatusInitial extends EmployeeStatusState {}

class EmployeeStatusUpdating extends EmployeeStatusState {}

class EmployeeStatusUpdateSuccess extends EmployeeStatusState {}

class EmployeeStatusUpdateFailure extends EmployeeStatusState {
  final String error;

  const EmployeeStatusUpdateFailure(this.error);

  @override
  List<Object?> get props => [error];
}

// Bloc
class EmployeeStatusBloc extends Bloc<EmployeeStatusEvent, EmployeeStatusState> {
  final FirebaseEmployeesRepository _employeesRepository;

  EmployeeStatusBloc({
    required FirebaseEmployeesRepository employeesRepository,
  })  : _employeesRepository = employeesRepository,
        super(EmployeeStatusInitial()) {
    on<UpdateEmployeeStatus>(_onUpdateEmployeeStatus);
  }

  Future<void> _onUpdateEmployeeStatus(
    UpdateEmployeeStatus event,
    Emitter<EmployeeStatusState> emit,
  ) async {
    emit(EmployeeStatusUpdating());
    try {
      await _employeesRepository.updateEmployeeStatus(
        event.employeeId,
        event.companyId,
        event.isActive,
      );
      emit(EmployeeStatusUpdateSuccess());
    } catch (e) {
      emit(EmployeeStatusUpdateFailure(e.toString()));
    }
  }
}
