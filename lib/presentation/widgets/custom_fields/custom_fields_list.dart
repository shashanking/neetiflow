import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neetiflow/domain/entities/custom_field.dart';
import 'package:neetiflow/presentation/blocs/custom_fields/custom_fields_bloc.dart';
import 'package:neetiflow/presentation/widgets/custom_fields/custom_field_form.dart';

class CustomFieldsList extends StatelessWidget {
  final void Function(BuildContext, {CustomField? field}) onEditField;
  final void Function(BuildContext, CustomField) onDeleteField;

  const CustomFieldsList({
    super.key, 
    required this.onEditField, 
    required this.onDeleteField,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomFieldsBloc, CustomFieldsState>(
      builder: (context, state) {
        // Add detailed logging to understand state
        debugPrint('CustomFieldsList state: $state');

        if (state is CustomFieldsLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is CustomFieldsError) {
          return Center(
            child: Text(
              'Error loading custom fields: ${state.message}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (state is CustomFieldsLoaded) {
          // Add logging for loaded fields
          debugPrint('Loaded fields count: ${state.fields.length}');

          if (state.fields.isEmpty) {
            return const Center(
              child: Text(
                'No custom fields found. Click + to add a new field.',
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView.builder(
            itemCount: state.fields.length,
            itemBuilder: (context, index) {
              final field = state.fields[index];
              return CustomFieldListItem(
                field: field,
                onEdit: () => onEditField(context, field: field),
                onDelete: () => onDeleteField(context, field),
              );
            },
          );
        }

        return const Center(
          child: Text('Initialize custom fields'),
        );
      },
    );
  }
}

class CustomFieldListItem extends StatelessWidget {
  final CustomField field;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CustomFieldListItem({
    super.key,
    required this.field,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(field.name),
        subtitle: Text('Type: ${field.type.toString().split('.').last}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
