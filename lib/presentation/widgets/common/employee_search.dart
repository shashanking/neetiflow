import 'package:flutter/material.dart';
import 'package:neetiflow/domain/entities/employee.dart';
import 'package:neetiflow/injection.dart';

import '../../../domain/services/employee_search_service.dart';

class EmployeeSearch extends StatefulWidget {
  final void Function(Employee employee) onEmployeeSelected;
  final List<String>? excludeIds;

  const EmployeeSearch({
    Key? key,
    required this.onEmployeeSelected,
    this.excludeIds,
  }) : super(key: key);

  @override
  State<EmployeeSearch> createState() => _EmployeeSearchState();
}

class _EmployeeSearchState extends State<EmployeeSearch> {
  final TextEditingController _searchController = TextEditingController();
  final EmployeeSearchService _searchService = getIt<EmployeeSearchService>();
  List<Employee> _searchResults = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _onSearchChanged() async {
    if (_searchController.text.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final results = await _searchService.searchEmployees(
        query: _searchController.text,
        isActive: true,
      );

      if (widget.excludeIds != null) {
        _searchResults = results.where((e) => !widget.excludeIds!.contains(e.id)).toList();
      } else {
        _searchResults = results;
      }
    } catch (e) {
      // Handle error
      _searchResults = [];
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            labelText: 'Search Employees',
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : null,
          ),
        ),
        if (_searchResults.isNotEmpty) ...[
          const SizedBox(height: 8),
          Card(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final employee = _searchResults[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: employee.photoUrl != null
                        ? NetworkImage(employee.photoUrl!)
                        : null,
                    child: employee.photoUrl == null
                        ? Text(employee.firstName[0])
                        : null,
                  ),
                  title: Text('${employee.firstName} ${employee.lastName}'),
                  subtitle: Text(employee.departmentId ?? 'No Department'),
                  onTap: () => widget.onEmployeeSelected(employee),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}
