import 'package:flutter/material.dart';
import 'package:neetiflow/domain/entities/lead.dart';
import 'package:neetiflow/domain/entities/lead_filter.dart';

import '../../theme/lead_status_colors.dart';

class LeadFilterWidget extends StatelessWidget {
  final LeadFilter currentFilter;
  final Function(LeadFilter) onFilterChanged;
  final List<String> availableSegments;

  const LeadFilterWidget({
    super.key,
    required this.currentFilter,
    required this.onFilterChanged,
    required this.availableSegments,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Stack(
        children: [
          const Icon(Icons.filter_list),
          if (_hasActiveFilters)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
      tooltip: 'Filter Leads',
      style: IconButton.styleFrom(
        backgroundColor: _hasActiveFilters 
            ? Theme.of(context).colorScheme.primaryContainer
            : null,
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => _FilterDialog(
            currentFilter: currentFilter,
            onFilterChanged: onFilterChanged,
            availableSegments: availableSegments,
          ),
        );
      },
    );
  }

  bool get _hasActiveFilters =>
      currentFilter.searchQuery != null ||
      currentFilter.status != null ||
      currentFilter.processStatus != null ||
      (currentFilter.segments?.isNotEmpty ?? false) ||
      currentFilter.startDate != null ||
      currentFilter.endDate != null;
}

class _FilterDialog extends StatefulWidget {
  final LeadFilter currentFilter;
  final Function(LeadFilter) onFilterChanged;
  final List<String> availableSegments;

  const _FilterDialog({
    required this.currentFilter,
    required this.onFilterChanged,
    required this.availableSegments,
  });

  @override
  State<_FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<_FilterDialog> {
  late LeadFilter _filter;
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _filter = widget.currentFilter;
    _searchController = TextEditingController(text: _filter.searchQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _updateFilter(LeadFilter newFilter) {
    setState(() => _filter = newFilter);
    widget.onFilterChanged(newFilter);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Filter Leads',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                    tooltip: 'Close',
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSearchField(theme),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildFilterDropdown<LeadStatus>(
                              title: 'Lead Status',
                              icon: Icons.flag_outlined,
                              value: _filter.status,
                              items: LeadStatus.values,
                              getLabel: (status) => status.toString().split('.').last,
                              getColor: LeadStatusColors.getLeadStatusColor,
                              onChanged: (status) {
                                _updateFilter(_filter.copyWith(status: status));
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildFilterDropdown<ProcessStatus>(
                              title: 'Process',
                              icon: Icons.pending_actions_outlined,
                              value: _filter.processStatus,
                              items: ProcessStatus.values,
                              getLabel: (status) => status.toString().split('.').last,
                              getColor: LeadStatusColors.getProcessStatusColor,
                              onChanged: (status) {
                                _updateFilter(_filter.copyWith(processStatus: status));
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildDateRangeFilter(theme),
                      if (widget.availableSegments.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _buildSegmentsSection(theme),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      _searchController.clear();
                      _updateFilter(const LeadFilter());
                    },
                    child: const Text('Clear All'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.check),
                    label: const Text('Apply'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField(ThemeData theme) {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search leads...',
        prefixIcon: Icon(Icons.search, size: 20, color: theme.colorScheme.primary),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear, size: 18),
                onPressed: () {
                  _searchController.clear();
                  _updateFilter(_filter.copyWith(searchQuery: null));
                },
              )
            : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      onChanged: (value) {
        _updateFilter(_filter.copyWith(searchQuery: value.isEmpty ? null : value));
      },
    );
  }

  Widget _buildFilterDropdown<T>({
    required String title,
    required IconData icon,
    required T? value,
    required List<T> items,
    required String Function(T) getLabel,
    required Color Function(T) getColor,
    required void Function(T?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          value: value,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          items: [
            const DropdownMenuItem(value: null, child: Text('All')),
            ...items.map((item) => DropdownMenuItem(
                  value: item,
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: getColor(item),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(getLabel(item)),
                    ],
                  ),
                )),
          ],
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildDateRangeFilter(ThemeData theme) {
    String getFormattedDate(DateTime? date) {
      if (date == null) return 'Select';
      return '${date.day}/${date.month}/${date.year}';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.date_range, size: 16, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(width: 8),
            Text(
              'Date Range',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _filter.startDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: _filter.endDate ?? DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    _updateFilter(_filter.copyWith(startDate: date));
                  }
                },
                icon: const Icon(Icons.calendar_today, size: 16),
                label: Text(getFormattedDate(_filter.startDate)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _filter.endDate ?? DateTime.now(),
                    firstDate: _filter.startDate ?? DateTime(2000),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    _updateFilter(_filter.copyWith(endDate: date));
                  }
                },
                icon: const Icon(Icons.calendar_today, size: 16),
                label: Text(getFormattedDate(_filter.endDate)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSegmentsSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.segment, size: 16, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(width: 8),
            Text(
              'Segments',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.help_outline, size: 16),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('About Segments'),
                    content: const Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Segments help you organize and filter leads based on specific categories.'),
                        SizedBox(height: 16),
                        Text('• First assign segments when creating/editing leads'),
                        Text('• Then use these chips to filter leads by segment'),
                        Text('• Select multiple segments to see matching leads'),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Got it'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: widget.availableSegments.map((segment) {
            final isSelected = (_filter.segments ?? []).contains(segment);
            return FilterChip(
              label: Text(segment),
              selected: isSelected,
              onSelected: (selected) {
                final segments = List<String>.from(_filter.segments ?? []);
                if (selected) {
                  segments.add(segment);
                } else {
                  segments.remove(segment);
                }
                _updateFilter(_filter.copyWith(segments: segments));
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
