import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:neetiflow/data/repositories/custom_fields_repository.dart';
import 'package:neetiflow/domain/entities/custom_field.dart';

// Events
abstract class CustomFieldsEvent extends Equatable {
  const CustomFieldsEvent();

  @override
  List<Object> get props => [];
}

class LoadCustomFields extends CustomFieldsEvent {}

class AddCustomField extends CustomFieldsEvent {
  final CustomField field;

  const AddCustomField({required this.field});

  @override
  List<Object> get props => [field];
}

class UpdateCustomField extends CustomFieldsEvent {
  final CustomField field;

  const UpdateCustomField({required this.field});

  @override
  List<Object> get props => [field];
}

class DeleteCustomField extends CustomFieldsEvent {
  final String fieldId;

  const DeleteCustomField({required this.fieldId});

  @override
  List<Object> get props => [fieldId];
}

// States
abstract class CustomFieldsState extends Equatable {
  const CustomFieldsState();

  @override
  List<Object> get props => [];
}

class CustomFieldsInitial extends CustomFieldsState {}

class CustomFieldsLoading extends CustomFieldsState {}

class CustomFieldsLoaded extends CustomFieldsState {
  final List<CustomField> fields;

  const CustomFieldsLoaded({required this.fields});

  @override
  List<Object> get props => [fields];
}

class CustomFieldsError extends CustomFieldsState {
  final String message;

  const CustomFieldsError({required this.message});

  @override
  List<Object> get props => [message];
}

// Bloc
class CustomFieldsBloc extends Bloc<CustomFieldsEvent, CustomFieldsState> {
  final CustomFieldsRepository repository;

  CustomFieldsBloc({required this.repository}) : super(CustomFieldsInitial()) {
    on<LoadCustomFields>(_onLoadCustomFields);
    on<AddCustomField>(_onAddCustomField);
    on<UpdateCustomField>(_onUpdateCustomField);
    on<DeleteCustomField>(_onDeleteCustomField);
  }

  Future<void> _onLoadCustomFields(
    LoadCustomFields event,
    Emitter<CustomFieldsState> emit,
  ) async {
    try {
      emit(CustomFieldsLoading());
      debugPrint('[CustomFieldsBloc] Attempting to load custom fields');

      final fields = await repository.getCustomFields();
      
      debugPrint('[CustomFieldsBloc] Map (${fields.length} items)');
      
      if (fields.isEmpty) {
        emit(const CustomFieldsLoaded(fields: []));
      } else {
        emit(CustomFieldsLoaded(fields: fields));
      }
      
      debugPrint('[CustomFieldsBloc] Loaded custom fields');
      debugPrint('[CustomFieldsBloc] Map (${fields.length} items)');
    } catch (e, stackTrace) {
      debugPrint('[CustomFieldsBloc] Error loading custom fields: $e');
      debugPrint('[CustomFieldsBloc] Stacktrace: $stackTrace');
      emit(CustomFieldsError(message: e.toString()));
    }
  }

  Future<void> _onAddCustomField(
    AddCustomField event,
    Emitter<CustomFieldsState> emit,
  ) async {
    try {
      final updatedFields = await repository.getCustomFields();
      await repository.addCustomField(event.field);
      emit(CustomFieldsLoaded(fields: updatedFields));
    } catch (e) {
      emit(CustomFieldsError(message: 'Failed to add custom field: $e'));
    }
  }

  Future<void> _onUpdateCustomField(
    UpdateCustomField event,
    Emitter<CustomFieldsState> emit,
  ) async {
    try {
      final updatedFields = await repository.getCustomFields();
      await repository.updateCustomField(event.field);
      emit(CustomFieldsLoaded(fields: updatedFields));
    } catch (e) {
      emit(CustomFieldsError(message: 'Failed to update custom field: $e'));
    }
  }

  Future<void> _onDeleteCustomField(
    DeleteCustomField event,
    Emitter<CustomFieldsState> emit,
  ) async {
    try {
      final updatedFields = await repository.getCustomFields();
      await repository.deleteCustomField(event.fieldId);
      emit(CustomFieldsLoaded(fields: updatedFields));
    } catch (e) {
      emit(CustomFieldsError(message: 'Failed to delete custom field: $e'));
    }
  }
}
