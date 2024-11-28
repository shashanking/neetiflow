import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neetiflow/domain/models/lead_filter.dart';
import 'package:neetiflow/presentation/blocs/leads/leads_bloc.dart';

class LeadFilterWidget extends StatefulWidget {
  final Function(LeadFilter) onFilterChanged;
  final LeadFilter initialFilter;

  const LeadFilterWidget({
    super.key,
    required this.onFilterChanged,
    required this.initialFilter,
  });

  @override
  State<LeadFilterWidget> createState() => _LeadFilterWidgetState();
}

class _LeadFilterWidgetState extends State<LeadFilterWidget> {
  late LeadFilter _filter;
  final _searchController = TextEditingController();
  final _minScoreController = TextEditingController();
  final _maxScoreController = TextEditingController();
  String? _selectedStatus;
  String? _selectedProcessStatus;

  @override
  void initState() {
    super.initState();
    _filter = widget.initialFilter;
    _searchController.text = _filter.searchTerm ?? '';
    _minScoreController.text = _filter.minScore?.toString() ?? '';
    _maxScoreController.text = _filter.maxScore?.toString() ?? '';
    _selectedStatus = _filter.status;
    _selectedProcessStatus = _filter.processStatus;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _minScoreController.dispose();
    _maxScoreController.dispose();
    super.dispose();
  }

  void _updateFilter() {
    widget.onFilterChanged(_filter);
  }

  void _updateScoreRange() {
    final minScore = int.tryParse(_minScoreController.text);
    final maxScore = int.tryParse(_maxScoreController.text);
    
    setState(() {
      _filter = _filter.copyWith(
        minScore: minScore,
        maxScore: maxScore,
      );
    });
    _updateFilter();
  }

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
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<LeadsBloc>(),
        child: AlertDialog(
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
                  onChanged: (value) {
                    setState(() {
                      _filter = _filter.copyWith(searchTerm: value);
                    });
                    _updateFilter();
                  },
                ),
                const SizedBox(height: 16),
                const Text('Status'),
                DropdownButton<String>(
                  value: _selectedStatus,
                  isExpanded: true,
                  hint: const Text('Select Status'),
                  items: const [
                    DropdownMenuItem(
                      value: 'warm',
                      child: Text('Warm'),
                    ),
                    DropdownMenuItem(
                      value: 'cold',
                      child: Text('Cold'),
                    ),
                    DropdownMenuItem(
                      value: 'hot',
                      child: Text('Hot'),
                    ),
                  ],
                  onChanged: (String? status) {
                    setState(() {
                      _selectedStatus = status;
                      _filter = _filter.copyWith(status: status);
                    });
                    _updateFilter();
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
                      value: 'fresh',
                      child: Text('Fresh'),
                    ),
                    DropdownMenuItem(
                      value: 'inProgress',
                      child: Text('In Progress'),
                    ),
                    DropdownMenuItem(
                      value: 'completed',
                      child: Text('Completed'),
                    ),
                    DropdownMenuItem(
                      value: 'rejected',
                      child: Text('Rejected'),
                    ),
                  ],
                  onChanged: (String? status) {
                    setState(() {
                      _selectedProcessStatus = status;
                      _filter = _filter.copyWith(processStatus: status);
                    });
                    _updateFilter();
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _minScoreController,
                        decoration: const InputDecoration(
                          labelText: 'Min Score',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (_) => _updateScoreRange(),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: _maxScoreController,
                        decoration: const InputDecoration(
                          labelText: 'Max Score',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (_) => _updateScoreRange(),
                      ),
                    ),
                  ],
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
                Navigator.of(context).pop();
              },
              child: const Text('Apply'),
            ),
          ],
        ),
      ),
    );
  }
}
