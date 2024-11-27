import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neetiflow/domain/models/lead_filter.dart';
import 'package:neetiflow/presentation/blocs/leads/leads_bloc.dart';

class LeadFilterWidget extends StatelessWidget {
  const LeadFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.filter_list),
      onPressed: () => _showFilterDialog(context),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const _FilterDialog(),
    );
  }
}

class _FilterDialog extends StatefulWidget {
  const _FilterDialog();

  @override
  State<_FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<_FilterDialog> {
  final _searchController = TextEditingController();
  String? _selectedStatus;
  String? _selectedProcessStatus;

  @override
  void initState() {
    super.initState();
    final currentFilter = context.read<LeadsBloc>().state.filter;
    _searchController.text = currentFilter.searchTerm ?? '';
    _selectedStatus = currentFilter.status;
    _selectedProcessStatus = currentFilter.processStatus;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filter Leads'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search',
                hintText: 'Search by name, email, or phone',
              ),
            ),
            const SizedBox(height: 16),
            const Text('Status'),
            DropdownButton<String>(
              value: _selectedStatus,
              isExpanded: true,
              hint: const Text('Select Status'),
              items: const [
                DropdownMenuItem(
                  value: 'new',
                  child: Text('New'),
                ),
                DropdownMenuItem(
                  value: 'contacted',
                  child: Text('Contacted'),
                ),
                DropdownMenuItem(
                  value: 'qualified',
                  child: Text('Qualified'),
                ),
                DropdownMenuItem(
                  value: 'lost',
                  child: Text('Lost'),
                ),
                DropdownMenuItem(
                  value: 'converted',
                  child: Text('Converted'),
                ),
              ],
              onChanged: (String? status) {
                setState(() {
                  _selectedStatus = status;
                });
              },
            ),
            const SizedBox(height: 16),
            const Text('Process Status'),
            DropdownButton<String>(
              value: _selectedProcessStatus,
              isExpanded: true,
              hint: const Text('Select Process Status'),
              items: const [
                DropdownMenuItem(
                  value: 'pending',
                  child: Text('Pending'),
                ),
                DropdownMenuItem(
                  value: 'in_progress',
                  child: Text('In Progress'),
                ),
                DropdownMenuItem(
                  value: 'completed',
                  child: Text('Completed'),
                ),
                DropdownMenuItem(
                  value: 'cancelled',
                  child: Text('Cancelled'),
                ),
              ],
              onChanged: (String? status) {
                setState(() {
                  _selectedProcessStatus = status;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final filter = LeadFilter(
              searchTerm: _searchController.text.trim(),
              status: _selectedStatus,
              processStatus: _selectedProcessStatus,
            );
            context.read<LeadsBloc>().add(FilterLeads(filter: filter));
            Navigator.of(context).pop();
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }
}
