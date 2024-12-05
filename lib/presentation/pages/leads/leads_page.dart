import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neetiflow/data/repositories/custom_fields_repository.dart';
import 'package:neetiflow/data/repositories/employee_timeline_repository.dart';
import 'package:neetiflow/data/repositories/leads_repository.dart';
import 'package:neetiflow/domain/entities/client.dart';
import 'package:neetiflow/domain/entities/employee.dart';
import 'package:neetiflow/domain/entities/employee_timeline_event.dart';
import 'package:neetiflow/domain/entities/lead.dart';
import 'package:neetiflow/domain/entities/timeline_event.dart';
import 'package:neetiflow/domain/models/lead_filter.dart';
import 'package:neetiflow/domain/repositories/auth_repository.dart';
import 'package:neetiflow/domain/repositories/employees_repository.dart';
import 'package:neetiflow/presentation/blocs/auth/auth_bloc.dart';
import 'package:neetiflow/presentation/blocs/clients/clients_bloc.dart';
import 'package:neetiflow/presentation/blocs/leads/leads_bloc.dart';
import 'package:neetiflow/presentation/pages/leads/lead_details_page.dart';
import 'package:neetiflow/presentation/theme/lead_status_colors.dart';
import 'package:neetiflow/presentation/widgets/clients/client_form.dart';
import 'package:neetiflow/presentation/widgets/leads/lead_assignment_dialog.dart';
import 'package:neetiflow/presentation/widgets/leads/lead_form.dart';
import 'package:neetiflow/presentation/widgets/leads/status_note_dialog.dart';
import 'package:neetiflow/presentation/widgets/leads/timeline_widget.dart';
import 'package:neetiflow/presentation/widgets/persistent_shell.dart';
import 'package:uuid/uuid.dart';

import '../../../infrastructure/repositories/firebase_clients_repository.dart';
import '../../blocs/custom_fields/custom_fields_bloc.dart';
import '../../blocs/employees/employees_bloc.dart';

class LeadsPage extends StatelessWidget {
  const LeadsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    if (authState is! Authenticated) {
      return const Center(child: Text('Please login to view leads'));
    }

    final organizationId = authState.employee.companyId!;
    final leadsRepository = LeadsRepositoryImpl();
    final customFieldsRepository = CustomFieldsRepository(
      organizationId: organizationId,
    );
    
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<LeadsRepository>.value(
          value: leadsRepository,
        ),
        RepositoryProvider<CustomFieldsRepository>.value(
          value: customFieldsRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<LeadsBloc>(
            create: (context) => LeadsBloc(
              leadsRepository: leadsRepository,
              organizationId: organizationId,
            )..add(const LoadLeads()),
          ),
          BlocProvider<ClientsBloc>(
            create: (context) => ClientsBloc(
              authRepository: context.read<AuthRepository>(),
              employeesRepository: context.read<EmployeesRepository>(),
            )..add(LoadClients()),
          ),
          BlocProvider<EmployeesBloc>(
            create: (context) => EmployeesBloc(
              employeesRepository: context.read<EmployeesRepository>(),
            )..add(LoadEmployees(organizationId)),
          ),
          BlocProvider<CustomFieldsBloc>(
            create: (context) => CustomFieldsBloc(
              repository: customFieldsRepository,
              entityType: 'leads',
              organizationId: organizationId,
            )..add(LoadCustomFields()),
          ),
        ],
        child: const LeadsView(),
      ),
    );
  }
}

class LeadsView extends StatefulWidget {
  const LeadsView({super.key});

  @override
  State<LeadsView> createState() => _LeadsViewState();
}

class _LeadsViewState extends State<LeadsView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late LeadsRepository _leadsRepository;
  StreamSubscription<List<TimelineEvent>>? _timelineSubscription;
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  Lead? _selectedLead;

  @override
  void initState() {
    super.initState();
    _loadLeads();
    _leadsRepository = RepositoryProvider.of<LeadsRepository>(context);
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    _timelineSubscription?.cancel();
    super.dispose();
  }

  void _handleTabChange() {
    if (_tabController.index == 1) {
      // Timeline tab selected
      _initializeTimelineStream();
    }
  }

  void _initializeTimelineStream() {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated && _selectedLead != null) {
      _timelineSubscription?.cancel();
      final stream = _leadsRepository.getTimelineEvents(
        authState.employee.companyId!,
        _selectedLead!.id,
      );
      
      _timelineSubscription = stream.listen(
        (events) {
          if (mounted) {
            setState(() {
              // Update your timeline state here
            });
          }
        },
        onError: (error) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error loading timeline: $error'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
      );
    }
  }

  void _selectLead(Lead? lead) {
    setState(() {
      if (_selectedLead?.id == lead?.id) {
        _selectedLead = null;
        _timelineSubscription?.cancel();
      } else {
        _selectedLead = lead;
        if (lead != null && _tabController.index == 1) {
          _initializeTimelineStream();
        }
      }
    });
  }

  void _loadLeads() {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      context.read<LeadsBloc>().add(const LoadLeads());
    }
  }

  Future<void> _importLeads() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
      withData: true,
    );

    if (result != null && result.files.single.bytes != null) {
      context
          .read<LeadsBloc>()
          .add(ImportLeadsFromCSV(bytes: result.files.single.bytes!));
    }
  }

  void _exportLeads() {
    context.read<LeadsBloc>().add(const ExportLeadsToCSV());
  }

  void _showLeadCreationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => MultiBlocProvider(
        providers: [
          BlocProvider.value(
            value: context.read<LeadsBloc>(),
          ),
          BlocProvider.value(
            value: context.read<AuthBloc>(),
          ),
          BlocProvider.value(
            value: context.read<EmployeesBloc>(),
          ),
          BlocProvider.value(
            value: context.read<CustomFieldsBloc>(),
          ),
        ],
        child: Dialog(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.9,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Create New Lead',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(dialogContext).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: LeadForm(
                    onSave: (lead) {
                      context.read<LeadsBloc>().add(AddLead(lead: lead));
                      Navigator.of(dialogContext).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _editLead(Lead lead) async {
    final result = await showDialog<Lead>(
      context: context,
      builder: (dialogContext) => MultiBlocProvider(
        providers: [
          BlocProvider.value(
            value: context.read<LeadsBloc>(),
          ),
          BlocProvider.value(
            value: context.read<AuthBloc>(),
          ),
          BlocProvider.value(
            value: context.read<EmployeesBloc>(),
          ),
          BlocProvider.value(
            value: context.read<CustomFieldsBloc>(),
          ),
        ],
        child: Dialog(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.9,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Edit Lead',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(dialogContext).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: LeadForm(
                    lead: lead,
                    onSave: (updatedLead) {
                      Navigator.of(dialogContext).pop(updatedLead);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (result != null) {
      context.read<LeadsBloc>().add(
            UpdateLead(lead: result),
          );
    }
  }

  Future<void> _deleteLead(Lead lead) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Lead'),
        content: Text(
            'Are you sure you want to delete ${lead.firstName} ${lead.lastName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      context.read<LeadsBloc>().add(
            BulkDeleteLeads(
              leadIds: [lead.id],
            ),
          );
    }
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    int count,
    IconData icon,
    Color color, {
    double? width,
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: width ?? 200,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.1),
                color.withOpacity(0.05),
              ],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(icon, color: color, size: 24),
                  Text(
                    count.toString(),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getLeadName(Lead lead) {
    return '${lead.firstName} ${lead.lastName}'.trim();
  }

  void _bulkUpdateLeadsStatus(List<String> leadIds, String status) {
    context.read<LeadsBloc>().add(
          BulkUpdateLeadsStatus(
            leadIds: leadIds.toList(),
            status: status,
          ),
        );
  }

  void _bulkUpdateLeadsProcessStatus(
      List<String> leadIds, ProcessStatus status) async {
    // Show note dialog
    final note = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatusNoteDialog(
        oldValue: 'Multiple Values',
        newValue: status.toString().split('.').last,
        title: 'Process Status',
      ),
    );

    if (note == null) return; // User cancelled

    // Create timeline events for each lead
    final timelineEvents = leadIds
        .map((leadId) => TimelineEvent(
              id: const Uuid().v4(),
              leadId: leadId,
              title: 'Process Status Changed',
              description: note,
              timestamp: DateTime.now(),
              category: 'status_change',
              metadata: {
                'old_status': 'Multiple Values',
                'new_status': status.toString().split('.').last,
                'type': 'process_status'
              },
            ))
        .toList();

    // Add bulk update event with timeline events
    context.read<LeadsBloc>().add(
          BulkUpdateLeadsProcessStatus(
            leadIds: leadIds.toList(),
            status: status,
            timelineEvents: timelineEvents,
          ),
        );
  }

  Widget _buildStatusChip(BuildContext context, Lead lead) {
    final theme = Theme.of(context);
    final status = LeadStatus.values.firstWhere(
      (s) =>
          s.toString().split('.').last.toLowerCase() ==
          lead.status.toString().split('.').last.toLowerCase(),
      orElse: () => LeadStatus.cold,
    );
    final color = LeadStatusColors.getLeadStatusColor(status);

    return PopupMenuButton<LeadStatus>(
      tooltip: 'Change lead status',
      offset: const Offset(0, 30),
      position: PopupMenuPosition.under,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.circle, size: 8, color: color),
            const SizedBox(width: 8),
            Text(
              status.toString().split('.').last,
              style: theme.textTheme.bodySmall?.copyWith(color: color),
            ),
          ],
        ),
      ),
      itemBuilder: (context) => LeadStatus.values
          .map(
            (status) => PopupMenuItem(
              value: status,
              child: Row(
                children: [
                  Icon(
                    Icons.circle,
                    size: 8,
                    color: LeadStatusColors.getLeadStatusColor(status),
                  ),
                  const SizedBox(width: 8),
                  Text(status.toString().split('.').last),
                ],
              ),
            ),
          )
          .toList(),
      onSelected: (newStatus) => _updateLeadStatus(lead, newStatus),
    );
  }

  Widget _buildProcessChip(BuildContext context, Lead lead) {
    final theme = Theme.of(context);
    final status = ProcessStatus.values.firstWhere(
      (s) =>
          s.toString().split('.').last.toLowerCase() ==
          lead.processStatus.toString().split('.').last.toLowerCase(),
      orElse: () => ProcessStatus.fresh,
    );
    final color = LeadStatusColors.getProcessStatusColor(status);

    return PopupMenuButton<ProcessStatus>(
      tooltip: 'Change process status',
      offset: const Offset(0, 30),
      position: PopupMenuPosition.under,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.circle, size: 8, color: color),
            const SizedBox(width: 8),
            Text(
              status.toString().split('.').last,
              style: theme.textTheme.bodySmall?.copyWith(color: color),
            ),
          ],
        ),
      ),
      itemBuilder: (context) => ProcessStatus.values
          .map(
            (status) => PopupMenuItem(
              value: status,
              child: Row(
                children: [
                  Icon(
                    Icons.circle,
                    size: 8,
                    color: LeadStatusColors.getProcessStatusColor(status),
                  ),
                  const SizedBox(width: 8),
                  Text(status.toString().split('.').last),
                ],
              ),
            ),
          )
          .toList(),
      onSelected: (newStatus) => _updateLeadProcessStatus(lead, newStatus),
    );
  }

  void _updateLeadStatus(Lead lead, LeadStatus newStatus) async {
    final oldStatus = lead.status;

    // Show note dialog
    final note = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatusNoteDialog(
        oldValue: oldStatus.toString().split('.').last,
        newValue: newStatus.toString().split('.').last,
        title: 'Lead Status',
      ),
    );

    if (note == null) return; // User cancelled

    final timelineEvent = TimelineEvent(
      id: const Uuid().v4(),
      leadId: lead.id,
      title: 'Lead Status Changed',
      description: note,
      timestamp: DateTime.now(),
      category: 'status_change',
      metadata: {
        'old_status': oldStatus.toString().split('.').last,
        'new_status': newStatus.toString().split('.').last,
        'type': 'lead_status'
      },
    );

    final updatedLead = lead.copyWith(
      status: newStatus,
      timelineEvents: [
        ...lead.timelineEvents,
        timelineEvent,
      ],
    );

    context.read<LeadsBloc>().add(UpdateLead(lead: updatedLead));
  }

  Future<void> _updateLeadProcessStatus(
      Lead lead, ProcessStatus newStatus) async {
    try {
      // Create timeline event
      final timelineEvent = TimelineEvent(
        id: const Uuid().v4(),
        leadId: lead.id,
        title: 'Process Status Updated',
        description: 'Process status changed to ${newStatus.name}',
        timestamp: DateTime.now(),
        category: 'status_change',
        metadata: {
          'old_status': lead.processStatus.name,
          'new_status': newStatus.name,
          'type': 'process_status'
        },
      );

      // Update lead status
      context.read<LeadsBloc>().add(UpdateLeadProcessStatus(
            lead: lead,
            status: newStatus,
            timelineEvent: timelineEvent,
          ));

      // If completed, trigger conversion
      if (newStatus == ProcessStatus.completed) {
        await convertLeadToClient(lead);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Lead process status updated successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating lead process status: $e')),
        );
      }
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: BlocBuilder<LeadsBloc, LeadsState>(
          builder: (context, state) {
            return Row(
              children: [
                const SizedBox(width: 16),
                _buildStatCard(
                  context,
                  'Total Leads',
                  state.allLeads.length,
                  Icons.people_outline,
                  Theme.of(context).colorScheme.primary,
                  width: 180,
                  onTap: () => context.read<LeadsBloc>().add(
                        const FilterLeads(filter: LeadFilter()),
                      ),
                ),
                const SizedBox(width: 8),
                ...LeadStatus.values.map((status) {
                  final count = state.allLeads
                      .where((lead) => lead.status == status)
                      .length;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: _buildStatCard(
                      context,
                      '${status.name.toUpperCase()} Leads',
                      count,
                      _getLeadStatusIcon(status),
                      _getLeadStatusColor(context, status),
                      width: 180,
                      onTap: () => context.read<LeadsBloc>().add(
                            FilterLeads(
                              filter: LeadFilter(
                                status: status.name,
                                processStatus: null,
                              ),
                            ),
                          ),
                    ),
                  );
                }),
                ...ProcessStatus.values.map((status) {
                  final count = state.allLeads
                      .where((lead) => lead.processStatus == status)
                      .length;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: _buildStatCard(
                      context,
                      status.name.toUpperCase().replaceAll('_', ' '),
                      count,
                      _getProcessStatusIcon(status),
                      _getProcessStatusColor(context, status),
                      width: 180,
                      onTap: () => context.read<LeadsBloc>().add(
                            FilterLeads(
                              filter: LeadFilter(
                                status: null,
                                processStatus: status.name,
                              ),
                            ),
                          ),
                    ),
                  );
                }),
                const SizedBox(width: 16),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildLeadsTab() {
    return BlocBuilder<LeadsBloc, LeadsState>(
      builder: (context, state) {
        if (state.status == LeadsStatus.initial) {
          _loadLeads();
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == LeadsStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == LeadsStatus.failure) {
          return Center(
            child: Text(
              state.errorMessage ?? 'Error loading leads',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
          );
        }

        if (state.filteredLeads.isEmpty) {
          return _NoLeadsWidget(
            hasFilter: state.filter != const LeadFilter(),
            onAddLead: () => _showLeadCreationDialog(context),
            onImportLeads: _importLeads,
          );
        }

        return Column(
          children: [
            _buildHeader(context),
            if (state.selectedLeadIds.isNotEmpty)
              _buildBulkActionsToolbar(context),
            Expanded(
              child: Card(
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      color: Theme.of(context)
                          .colorScheme
                          .surfaceVariant
                          .withOpacity(0.5),
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search leads...',
                                prefixIcon: const Icon(Icons.search),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                filled: true,
                                fillColor:
                                    Theme.of(context).colorScheme.surface,
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                              ),
                              controller: _searchController,
                              onChanged: (value) {
                                final currentState = context.read<LeadsBloc>().state;
                                if (currentState.status == LeadsStatus.success) {
                                  context.read<LeadsBloc>().add(
                                    FilterLeads(
                                      filter: currentState.filter.copyWith(
                                        searchTerm: value.trim(),
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          PopupMenuButton<String>(
                            icon: const Icon(Icons.filter_list),
                            tooltip: 'Filter',
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'status',
                                child: Text('Filter by Status'),
                              ),
                              const PopupMenuItem(
                                value: 'process',
                                child: Text('Filter by Process'),
                              ),
                            ],
                            onSelected: (value) {
                              // TODO: Implement filtering
                            },
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          scrollbarTheme: ScrollbarThemeData(
                            thumbColor: MaterialStateProperty.all(
                              Theme.of(context).colorScheme.primary.withOpacity(0.5),
                            ),
                            trackColor: MaterialStateProperty.all(
                              Theme.of(context).colorScheme.primary.withOpacity(0.1),
                            ),
                            trackBorderColor: MaterialStateProperty.all(
                              Theme.of(context).colorScheme.primary.withOpacity(0.1),
                            ),
                          ),
                        ),
                        child: Scrollbar(
                          controller: _scrollController,
                          thumbVisibility: true,
                          trackVisibility: true,
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: _buildLeadsTableCompact(
                                context, state.filteredLeads),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLeadsTableCompact(BuildContext context, List<Lead> leads) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: MediaQuery.of(context).size.width,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        child: DataTable(
          showCheckboxColumn: true,
          columns: const [
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Score')),
            DataColumn(label: Text('Email')),
            DataColumn(label: Text('Phone')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Process')),
            DataColumn(label: Text('Created')),
            DataColumn(label: Text('Assignment')),
            DataColumn(label: Text('Actions')),
          ],
          rows:
              leads.map((lead) => _buildCompactDataRow(context, lead)).toList(),
        ),
      ),
    );
  }

  DataRow _buildCompactDataRow(BuildContext context, Lead lead) {
    final leadsState = context.watch<LeadsBloc>().state;
    return DataRow(
      selected: leadsState.selectedLeadIds.contains(lead.id),
      onSelectChanged: (selected) {
        final leadsBloc = context.read<LeadsBloc>();
        if (selected == true) {
          leadsBloc.add(SelectLead(leadId: lead.id));
        } else {
          leadsBloc.add(DeselectLead(leadId: lead.id));
        }
      },
      cells: [
        DataCell(
          Text(_getLeadName(lead)),
          onTap: () => _navigateToLeadDetails(context, lead),
        ),
        DataCell(
          Text(lead.score.toString()),
          onTap: () => _navigateToLeadDetails(context, lead),
        ),
        DataCell(
          Text(lead.email),
          onTap: () => _navigateToLeadDetails(context, lead),
        ),
        DataCell(
          Text(lead.phone),
          onTap: () => _navigateToLeadDetails(context, lead),
        ),
        DataCell(
          _buildStatusChip(context, lead),
          onTap: () => _navigateToLeadDetails(context, lead),
        ),
        DataCell(
          _buildProcessChip(context, lead),
          onTap: () => _navigateToLeadDetails(context, lead),
        ),
        DataCell(
          Text(_formatDate(lead.createdAt)),
          onTap: () => _navigateToLeadDetails(context, lead),
        ),
        DataCell(_buildAssignmentCell(context, lead)),
        DataCell(Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () => _editLead(lead),
              tooltip: 'Edit Lead',
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteLead(lead),
              tooltip: 'Delete Lead',
            ),
            IconButton(
              icon: const Icon(Icons.info_outline, color: Colors.blue),
              onPressed: () => _navigateToLeadDetails(context, lead),
              tooltip: 'View Details',
            ),
          ],
        )),
      ],
    );
  }

  void _navigateToLeadDetails(BuildContext context, Lead lead) {
    final authState = context.read<AuthBloc>().state;
    if (authState is! Authenticated) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider<CustomFieldsBloc>(
              create: (context) => CustomFieldsBloc(
                repository: CustomFieldsRepository(
                  organizationId: authState.employee.companyId!,
                ),
                entityType: 'leads',
                organizationId: authState.employee.companyId!,
              )..add(LoadCustomFields()),
            ),
            RepositoryProvider<LeadsRepository>(
              create: (context) => LeadsRepositoryImpl(),
            ),
          ],
          child: LeadDetailsPage(
            lead: lead,
            organizationId: authState.employee.companyId!,
          ),
        ),
      ),
    );
  }

  Future<void> convertLeadToClient(Lead lead) async {
    // Get organization ID from AuthBloc
    final authState = context.read<AuthBloc>().state;
    if (authState is! Authenticated || authState.employee.companyId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: Unable to get organization ID')),
      );
      return;
    }
    final organizationId = authState.employee.companyId!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Convert Lead to Client'),
        content: const Text('Would you like to convert this lead to a client?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final now = DateTime.now();

    // Create a new client from lead data
    final client = Client(
      id: const Uuid().v4(),
      firstName: lead.firstName,
      lastName: lead.lastName,
      email: lead.email,
      phone: lead.phone,
      address: lead.metadata?['address'] ?? '',
      type: ClientType.individual,
      status: ClientStatus.active,
      domain: ClientDomain.other,
      rating: 0.0,
      organizationName:
          lead.metadata?['companyName'] ?? lead.metadata?['organization'],
      joiningDate: now,
      lastInteractionDate: now,
      projects: const [],
      lifetimeValue: 0.0,
      leadId: lead.id,
      metadata: {
        ...?lead.metadata,
        'createdAt': now.toIso8601String(),
        'updatedAt': now.toIso8601String(),
        'organizationId': organizationId,
      },
    );

    // Show client form for editing
    final editedClient = await showDialog<Client>(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: ClientForm(
              client: client,
              onSubmit: (client) => Navigator.pop(context, client),
            ),
          ),
        ),
      ),
    );

    if (editedClient == null) return;

    try {
      // Add client to database
      final clientsRepository = FirebaseClientsRepository();
      await clientsRepository.createClient(organizationId, editedClient);

      // Add to ClientsBloc state
      context.read<ClientsBloc>().add(AddClient(editedClient));

      // Update lead process status
      context.read<LeadsBloc>().add(UpdateLeadProcessStatus(
            lead: lead,
            status: ProcessStatus.completed,
            timelineEvent: TimelineEvent(
              id: const Uuid().v4(),
              leadId: lead.id,
              title: 'Lead Converted to Client',
              description: 'Lead was successfully converted to a client.',
              timestamp: now,
              category: 'conversion',
              metadata: {
                'clientId': editedClient.id,
                'type': 'lead_conversion',
                'createdAt': now.toIso8601String(),
                'organizationId': organizationId,
              },
            ),
          ));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Lead successfully converted to client')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error converting lead: $e')),
        );
      }
    }
  }

  Widget _buildAssignmentCell(BuildContext context, Lead lead) {
    final assignedEmployeeId = lead.metadata?['assignedEmployeeId'] as String?;
    if (assignedEmployeeId == null) {
      return TextButton.icon(
        onPressed: () => _showAssignmentDialog(context, lead),
        icon: const Icon(Icons.person_add),
        label: const Text('Assign'),
      );
    }

    return BlocBuilder<EmployeesBloc, EmployeesState>(
      builder: (context, state) {
        if (state is EmployeesLoading) {
          return const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          );
        }

        if (state is EmployeesLoaded) {
          final assignedEmployee = state.employees.firstWhere(
            (e) => e.id == assignedEmployeeId,
            orElse: () => const Employee(
              id: '',
              firstName: 'Unknown',
              lastName: 'Employee',
              email: '',
              isActive: true,
            ),
          );

          return PopupMenuButton<String>(
            tooltip: 'Manage Assignment',
            offset: const Offset(0, 30),
            position: PopupMenuPosition.under,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.person, size: 16),
                  const SizedBox(width: 8),
                  Text(
                      '${assignedEmployee.firstName} ${assignedEmployee.lastName}'),
                ],
              ),
            ),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'reassign',
                child: Row(
                  children: [
                    Icon(Icons.person_add),
                    SizedBox(width: 8),
                    Text('Reassign'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'unassign',
                child: Row(
                  children: [
                    Icon(Icons.person_remove),
                    SizedBox(width: 8),
                    Text('Unassign'),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              switch (value) {
                case 'reassign':
                  _showAssignmentDialog(context, lead);
                  break;
                case 'unassign':
                  _unassignLead(lead);
                  break;
              }
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  void _showAssignmentDialog(BuildContext context, Lead lead) {
    final leadsBloc = context.read<LeadsBloc>();
    showDialog(
      context: context,
      builder: (dialogContext) => MultiBlocProvider(
        providers: [
          BlocProvider.value(
            value: leadsBloc,
          ),
          BlocProvider.value(
            value: context.read<EmployeesBloc>(),
          ),
        ],
        child: LeadAssignmentDialog(
          lead: lead,
          leadsBloc: leadsBloc,
        ),
      ),
    );
  }

  void _unassignLead(Lead lead) {
    final authState = context.read<AuthBloc>().state;
    if (authState is! Authenticated) return;

    final now = DateTime.now();
    final previousAssigneeId = lead.metadata?['assignedEmployeeId'] as String?;

    // Create lead timeline event
    final leadTimelineEvent = TimelineEvent(
      id: const Uuid().v4(),
      leadId: lead.id,
      title: 'Lead Unassigned',
      description: 'Lead was unassigned',
      timestamp: now,
      category: 'assignment',
      metadata: {
        'unassignedByEmployeeId': authState.employee.id,
        'previousAssigneeId': previousAssigneeId,
        'type': 'lead_unassignment'
      },
    );

    // Create employee timeline event if there was a previous assignee
    if (previousAssigneeId != null) {
      final employeeTimelineEvent = EmployeeTimelineEvent(
        id: const Uuid().v4(),
        employeeId: previousAssigneeId,
        title: 'Lead Unassigned',
        description: 'Lead removed from assignment: ${lead.firstName} ${lead.lastName}',
        timestamp: now,
        category: 'lead_unassignment',
        metadata: {
          'leadId': lead.id,
          'leadName': '${lead.firstName} ${lead.lastName}',
          'unassignedByEmployeeId': authState.employee.id,
          'unassignedByName': '${authState.employee.firstName} ${authState.employee.lastName}',
        },
      );

      // Add employee timeline event
      final employeeTimelineRepo = context.read<EmployeeTimelineRepository>();
      employeeTimelineRepo.addTimelineEvent(
        authState.employee.companyId ?? '',
        employeeTimelineEvent,
      );
    }

    // Create a new metadata map with the assignment fields removed
    final updatedMetadata = Map<String, dynamic>.from(lead.metadata ?? {});
    updatedMetadata.remove('assignedEmployeeId');
    updatedMetadata.remove('assignedAt');
    updatedMetadata.remove('assignedByEmployeeId');
    updatedMetadata['unassignedAt'] = now.toIso8601String();
    updatedMetadata['unassignedByEmployeeId'] = authState.employee.id;

    final updatedLead = lead.copyWith(
      metadata: updatedMetadata,
    );

    context.read<LeadsBloc>().add(UpdateLead(
      lead: updatedLead,
      timelineEvent: leadTimelineEvent,
    ));
  }

  Widget _buildBulkActionsToolbar(BuildContext context) {
    final leadsBloc = context.watch<LeadsBloc>();
    final selectedCount = leadsBloc.state.selectedLeadIds.length;

    if (selectedCount == 0) return const SizedBox.shrink();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '$selectedCount ${selectedCount == 1 ? 'lead' : 'leads'} selected',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const SizedBox(width: 16),
          Tooltip(
            message: 'Delete selected leads',
            child: _buildBulkActionButton(
              context,
              'Delete',
              Icons.delete_outline,
              Theme.of(context).colorScheme.error,
              () => _confirmBulkDelete(context),
            ),
          ),
          const SizedBox(width: 8),
          _buildStatusDropdown(context),
          const SizedBox(width: 8),
          _buildProcessStatusDropdown(context),
          const SizedBox(width: 8),
          Tooltip(
            message: 'Export selected leads',
            child: IconButton(
              icon: const Icon(Icons.download),
              onPressed: () => _exportSelectedLeads(context),
            ),
          ),
          const SizedBox(width: 8),
          TextButton.icon(
            onPressed: () => leadsBloc.add(const DeselectAllLeads()),
            icon: const Icon(Icons.close),
            label: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _confirmBulkDelete(BuildContext context) {
    final leadsBloc = context.read<LeadsBloc>();
    final selectedLeadIds = leadsBloc.state.selectedLeadIds.toList();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirm Bulk Delete'),
        content: Text(
          'Are you sure you want to delete ${selectedLeadIds.length} ${selectedLeadIds.length == 1 ? 'lead' : 'leads'}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              leadsBloc.add(BulkDeleteLeads(leadIds: selectedLeadIds));
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _exportSelectedLeads(BuildContext context) async {
    final leadsBloc = context.read<LeadsBloc>();
    final selectedLeadIds = leadsBloc.state.selectedLeadIds.toList();

    try {
      final allLeads = leadsBloc.state.allLeads
          .where((lead) => selectedLeadIds.contains(lead.id))
          .toList();

      if (allLeads.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No leads selected for export')),
        );
        return;
      }

      // TODO: Implement actual export logic
      // For now, just show a placeholder
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Export Leads'),
          content: Text('Exporting ${allLeads.length} leads...'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error exporting leads: $e')),
      );
    }
  }

  Widget _buildBulkActionButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: color, size: 20),
      label: Text(label, style: TextStyle(color: color)),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  Widget _buildStatusDropdown(BuildContext context) {
    return PopupMenuButton<LeadStatus>(
      tooltip: 'Update status',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.flag_outlined, size: 20),
            SizedBox(width: 8),
            Text('Update Status'),
            Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
      itemBuilder: (context) => LeadStatus.values
          .map(
            (status) => PopupMenuItem(
              value: status,
              child: Row(
                children: [
                  Icon(
                    Icons.circle,
                    size: 8,
                    color: LeadStatusColors.getLeadStatusColor(status),
                  ),
                  const SizedBox(width: 8),
                  Text(status.toString().split('.').last),
                ],
              ),
            ),
          )
          .toList(),
      onSelected: (status) => _bulkUpdateLeadsStatus(
        context.read<LeadsBloc>().state.selectedLeadIds.toList(),
        status.toString().split('.').last,
      ),
    );
  }

  Widget _buildProcessStatusDropdown(BuildContext context) {
    return PopupMenuButton<ProcessStatus>(
      tooltip: 'Update process',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.pending_outlined, size: 20),
            SizedBox(width: 8),
            Text('Update Process'),
            Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
      itemBuilder: (context) => ProcessStatus.values
          .map(
            (status) => PopupMenuItem(
              value: status,
              child: Row(
                children: [
                  Icon(
                    Icons.circle,
                    size: 8,
                    color: LeadStatusColors.getProcessStatusColor(status),
                  ),
                  const SizedBox(width: 8),
                  Text(status.toString().split('.').last),
                ],
              ),
            ),
          )
          .toList(),
      onSelected: (status) => _bulkUpdateLeadsProcessStatus(
        context.read<LeadsBloc>().state.selectedLeadIds.toList(),
        status,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final isCompact = screenWidth < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leads'),
        leading: isCompact ? IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            PersistentShell.of(context)?.toggleDrawer();
          },
        ) : null,
        actions: [
          if (isCompact) ...[
            // Icon buttons for compact screens
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'Add Lead',
              onPressed: () => _showLeadCreationDialog(context),
            ),
            IconButton(
              icon: const Icon(Icons.upload_file),
              tooltip: 'Import Leads',
              onPressed: _importLeads,
            ),
            IconButton(
              icon: const Icon(Icons.download),
              tooltip: 'Export Leads',
              onPressed: _exportLeads,
            ),
          ] else ...[
            // Text buttons for larger screens
            TextButton.icon(
              onPressed: () => _showLeadCreationDialog(context),
              icon: const Icon(Icons.add),
              label: const Text('Add Lead'),
            ),
            const SizedBox(width: 8),
            TextButton.icon(
              onPressed: _importLeads,
              icon: const Icon(Icons.upload_file),
              label: const Text('Import'),
            ),
            const SizedBox(width: 8),
            TextButton.icon(
              onPressed: _exportLeads,
              icon: const Icon(Icons.download),
              label: const Text('Export'),
            ),
            const SizedBox(width: 16),
          ],
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Leads'),
            Tab(text: 'Timeline'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        physics:
            const NeverScrollableScrollPhysics(), // Disable swipe navigation
        children: [
          _buildLeadsTab(),
          _buildTimelineTab(),
        ],
      ),
    );
  }

  Widget _buildTimelineTab() {
    return BlocBuilder<LeadsBloc, LeadsState>(
      builder: (context, state) {
        if (state.status == LeadsStatus.initial || state.status == LeadsStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == LeadsStatus.failure) {
          return Center(
            child: Text(
              state.errorMessage ?? 'Error loading leads',
              style: TextStyle(color: Colors.red[700]),
            ),
          );
        }

        return Row(
          children: [
            // Lead selection sidebar
            SizedBox(
              width: 300,
              child: Card(
                margin: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Select Lead',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    const Divider(height: 1),
                    Expanded(
                      child: ListView.separated(
                        itemCount: state.filteredLeads.length,
                        separatorBuilder: (context, index) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final lead = state.filteredLeads[index];
                          return ListTile(
                            selected: _selectedLead?.id == lead.id,
                            title: Text(
                              '${lead.firstName} ${lead.lastName}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  lead.email.isEmpty ? 'No email' : lead.email,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    _buildStatusChip(context, lead),
                                    const SizedBox(width: 8),
                                    _buildProcessChip(context, lead),
                                  ],
                                ),
                              ],
                            ),
                            onTap: () => _selectLead(lead),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Timeline view
            Expanded(
              child: Card(
                margin: const EdgeInsets.all(8),
                child: _selectedLead == null
                    ? const Center(
                        child: Text('Please select a lead to view its timeline'),
                      )
                    : StreamBuilder<List<TimelineEvent>>(
                        stream: (context.read<AuthBloc>().state is Authenticated)
                            ? _leadsRepository.getTimelineEvents(
                                (context.read<AuthBloc>().state as Authenticated).employee.companyId!,
                                _selectedLead!.id,
                              )
                            : const Stream.empty(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            debugPrint('Timeline error: ${snapshot.error}');
                            return Center(
                              child: Text(
                                'Error loading timeline: ${snapshot.error}',
                                style: TextStyle(color: Colors.red[700]),
                              ),
                            );
                          }

                          if (!snapshot.hasData) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          final events = snapshot.data!;
                          debugPrint('Timeline events loaded: ${events.length}');
                          return TimelineWidget(
                            events: events,
                            isOverview: false,
                            height: MediaQuery.of(context).size.height - 200,
                          );
                        },
                      ),
              ),
            ),
          ],
        );
      },
    );
  }

  IconData _getLeadStatusIcon(LeadStatus status) {
    switch (status) {
      case LeadStatus.hot:
        return Icons.local_fire_department;
      case LeadStatus.warm:
        return Icons.trending_up;
      case LeadStatus.cold:
        return Icons.ac_unit;
    }
  }

  Color _getLeadStatusColor(BuildContext context, LeadStatus status) {
    switch (status) {
      case LeadStatus.hot:
        return Colors.red;
      case LeadStatus.warm:
        return Colors.orange;
      case LeadStatus.cold:
        return Colors.blue;
    }
  }

  IconData _getProcessStatusIcon(ProcessStatus status) {
    switch (status) {
      case ProcessStatus.fresh:
        return Icons.fiber_new;
      case ProcessStatus.inProgress:
        return Icons.pending_actions;
      case ProcessStatus.completed:
        return Icons.task_alt;
      case ProcessStatus.rejected:
        return Icons.cancel_outlined;
    }
  }

  Color _getProcessStatusColor(BuildContext context, ProcessStatus status) {
    switch (status) {
      case ProcessStatus.fresh:
        return Colors.green;
      case ProcessStatus.inProgress:
        return Colors.orange;
      case ProcessStatus.completed:
        return Colors.blue;
      case ProcessStatus.rejected:
        return Colors.red;
    }
  }
}

class _NoLeadsWidget extends StatelessWidget {
  final bool hasFilter;
  final VoidCallback onAddLead;
  final VoidCallback onImportLeads;

  const _NoLeadsWidget({
    required this.hasFilter,
    required this.onAddLead,
    required this.onImportLeads,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            hasFilter ? 'No leads match your filter' : 'No leads yet',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            hasFilter
                ? 'Try adjusting your filter settings'
                : 'Start by adding your first lead',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
          ),
          const SizedBox(height: 24),
          if (hasFilter)
            FilledButton.icon(
              onPressed: () => context
                  .read<LeadsBloc>()
                  .add(const FilterLeads(filter: LeadFilter())),
              icon: const Icon(Icons.filter_alt_off),
              label: const Text('Clear Filter'),
            )
          else
            FilledButton.icon(
              onPressed: onAddLead,
              icon: const Icon(Icons.add),
              label: const Text('Add Lead'),
            ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: onImportLeads,
            icon: const Icon(Icons.upload_file),
            label: const Text('Import Leads'),
          ),
        ],
      ),
    );
  }
}
