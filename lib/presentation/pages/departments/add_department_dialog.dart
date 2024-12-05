import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neetiflow/domain/entities/department.dart';
import 'package:neetiflow/presentation/blocs/departments/departments_bloc.dart';

class AddDepartmentDialog extends StatefulWidget {
  final String organizationId;

  const AddDepartmentDialog({
    super.key, 
    required this.organizationId
  });

  @override
  State<AddDepartmentDialog> createState() => _AddDepartmentDialogState();
}

class _AddDepartmentDialogState extends State<AddDepartmentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitDepartment() {
    if (_formKey.currentState!.validate()) {
      final department = Department(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        organizationId: widget.organizationId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      context.read<DepartmentsBloc>().add(AddDepartment(department));
      Navigator.of(context).pop(department);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DepartmentsBloc, DepartmentsState>(
      listener: (context, state) {
        if (state is DepartmentOperationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: AlertDialog(
        title: const Text('Create New Department'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Department Name',
                  hintText: 'Enter department name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a department name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Enter department description',
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _submitDepartment,
            child: const Text('Create Department'),
          ),
        ],
      ),
    );
  }
}
