import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neetiflow/data/repositories/custom_fields_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:neetiflow/domain/entities/custom_field.dart';
import 'package:neetiflow/presentation/blocs/custom_fields/custom_fields_bloc.dart';
import 'package:neetiflow/presentation/widgets/custom_fields/custom_field_form.dart';
import 'package:neetiflow/presentation/widgets/custom_fields/custom_fields_list.dart';

import '../../blocs/auth/auth_bloc.dart';

class CustomFieldsPage extends StatefulWidget {
  const CustomFieldsPage({super.key});

  @override
  CustomFieldsPageState createState() => CustomFieldsPageState();
}

class CustomFieldsPageState extends State<CustomFieldsPage> {
  late CustomFieldsBloc _customFieldsBloc;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    String organizationId = '';
    
    if (authState is Authenticated) {
      organizationId = authState.employee.companyId ?? '';
    }

    // Create repository and bloc
    final repository = CustomFieldsRepository(organizationId: organizationId);

    _customFieldsBloc = GetIt.instance<CustomFieldsBloc>()
      ..add(LoadCustomFields());
  }

  @override
  void dispose() {
    _customFieldsBloc.close();
    super.dispose();
  }

  void _showCustomFieldForm(BuildContext context, {CustomField? field}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: CustomFieldForm(
          field: field,
          onSave: (newField) {
            if (field == null) {
              _customFieldsBloc.add(AddCustomField(field: newField));
            } else {
              _customFieldsBloc.add(UpdateCustomField(field: newField));
            }
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, CustomField field) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Custom Field'),
        content: Text(
          'Are you sure you want to delete the custom field "${field.name}"? '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _customFieldsBloc.add(DeleteCustomField(fieldId: field.id));
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _customFieldsBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Custom Fields'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _showCustomFieldForm(context),
              tooltip: 'Add Custom Field',
            ),
          ],
        ),
        body: BlocBuilder<CustomFieldsBloc, CustomFieldsState>(
          bloc: _customFieldsBloc,
          builder: (context, state) {
            // Add detailed logging
            debugPrint('CustomFieldsPage state: $state');

            if (state is CustomFieldsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is CustomFieldsError) {
              return Center(
                child: Text(
                  'Error: ${state.message}',
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

              return CustomFieldsList(
                onEditField: _showCustomFieldForm,
                onDeleteField: _showDeleteConfirmation,
              );
            }

            return const Center(
              child: Text('Initialize custom fields'),
            );
          },
        ),
      ),
    );
  }
}
