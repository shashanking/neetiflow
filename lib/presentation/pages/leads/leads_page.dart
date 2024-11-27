import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neetiflow/data/repositories/leads_repository.dart';
import 'package:neetiflow/domain/entities/lead.dart';
import 'package:neetiflow/domain/models/lead_filter.dart';
import 'package:neetiflow/presentation/blocs/auth/auth_bloc.dart';
import 'package:neetiflow/presentation/blocs/leads/leads_bloc.dart';
import 'package:neetiflow/presentation/theme/lead_status_colors.dart';
import 'package:neetiflow/presentation/widgets/leads/lead_filter_widget.dart';
import 'package:neetiflow/presentation/widgets/leads/lead_form.dart';

class LeadsPage extends StatelessWidget {
  const LeadsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    if (authState is! Authenticated) {
      return const Center(child: Text('Please login to view leads'));
    }

    return BlocProvider(
      create: (context) => LeadsBloc(
        leadsRepository: LeadsRepositoryImpl(),
        companyId: authState.employee.companyId!,
      ),
      child: const LeadsView(),
    );
  }
}

class LeadsView extends StatefulWidget {
  const LeadsView({super.key});

  @override
  State<LeadsView> createState() => _LeadsViewState();
}

class _LeadsViewState extends State<LeadsView> {
  @override
  void initState() {
    super.initState();
    _loadLeads();
    _loadSegments();
  }

  void _loadLeads() {
    context.read<LeadsBloc>().add(const LoadLeads());
  }

  void _loadSegments() {
    // TODO: Load segments from repository
    final segments = ['High Value', 'New Lead', 'Follow Up', 'Hot Deal'];
    context.read<LeadsBloc>().add(LoadSegments(segments: segments));
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

  Future<void> _addNewLead() async {
    final authState = context.read<AuthBloc>().state;
    if (authState is! Authenticated) return;

    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final emailController = TextEditingController();
    final subjectController = TextEditingController();
    final messageController = TextEditingController();
    var selectedStatus = LeadStatus.hot;
    var selectedProcessStatus = ProcessStatus.fresh;

    final leadsBloc = context.read<LeadsBloc>();

    await showDialog(
      context: context,
      builder: (dialogContext) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: leadsBloc),
        ],
        child: Builder(
          builder: (builderContext) => Dialog(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.person_add, size: 24),
                      const SizedBox(width: 8),
                      const Text(
                        'Add New Lead',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(dialogContext),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Contact Information',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              labelText: 'Name*',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.person_outline),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: phoneController,
                                  decoration: const InputDecoration(
                                    labelText: 'Phone*',
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.phone),
                                  ),
                                  keyboardType: TextInputType.phone,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextField(
                                  controller: emailController,
                                  decoration: const InputDecoration(
                                    labelText: 'Email*',
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.email),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Lead Details',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: subjectController,
                            decoration: const InputDecoration(
                              labelText: 'Subject*',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.subject),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: messageController,
                            decoration: const InputDecoration(
                              labelText: 'Message',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.message),
                              alignLabelWithHint: true,
                            ),
                            maxLines: 3,
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Status Information',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          StatefulBuilder(
                            builder: (context, setState) => Row(
                              children: [
                                Expanded(
                                  child: DropdownButtonFormField<LeadStatus>(
                                    value: selectedStatus,
                                    decoration: const InputDecoration(
                                      labelText: 'Lead Status',
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.thermostat),
                                    ),
                                    items: LeadStatus.values.map((status) {
                                      final color =
                                          LeadStatusColors.getLeadStatusColor(
                                              status);
                                      return DropdownMenuItem(
                                        value: status,
                                        child: Text(
                                          status.toString().split('.').last,
                                          style: TextStyle(color: color),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() => selectedStatus = value);
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: DropdownButtonFormField<ProcessStatus>(
                                    value: selectedProcessStatus,
                                    decoration: const InputDecoration(
                                      labelText: 'Process Status',
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.pending_actions),
                                    ),
                                    items: ProcessStatus.values.map((status) {
                                      final color = LeadStatusColors
                                          .getProcessStatusColor(status);
                                      return DropdownMenuItem(
                                        value: status,
                                        child: Text(
                                          status.toString().split('.').last,
                                          style: TextStyle(color: color),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() =>
                                            selectedProcessStatus = value);
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: () => Navigator.pop(dialogContext),
                        icon: const Icon(Icons.close),
                        label: const Text('Cancel'),
                      ),
                      const SizedBox(width: 16),
                      FilledButton.icon(
                        onPressed: () {
                          if (nameController.text.isEmpty ||
                              phoneController.text.isEmpty ||
                              emailController.text.isEmpty ||
                              subjectController.text.isEmpty) {
                            ScaffoldMessenger.of(builderContext).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Please fill all required fields'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                            return;
                          }

                          final lead = Lead(
                            id: '',
                            uid: '',
                            firstName: nameController.text,
                            lastName: nameController.text.isEmpty
                                ? ''
                                : '',
                            phone: phoneController.text,
                            email: emailController.text,
                            subject: subjectController.text,
                            message: messageController.text,
                            status: selectedStatus,
                            processStatus: selectedProcessStatus,
                            createdAt: DateTime.now(),
                            metadata: {},
                            segments: ['manual-leads', ''],
                          );

                          builderContext.read<LeadsBloc>().add(
                                AddLead(lead: lead),
                              );
                          Navigator.pop(dialogContext);
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Add Lead'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _editLead(Lead lead) async {
    final result = await showDialog<Lead>(
      context: context,
      builder: (context) => LeadForm(
        lead: lead,
        onSubmit: (updatedLead) {
          Navigator.of(context).pop(updatedLead);
        },
      ),
    );

    if (result != null) {
      context.read<LeadsBloc>().add(
            UpdateLead(lead: result),
          );
      Navigator.pop(context);
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
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    value,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                  ),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context, LeadsState state) {
    if (state.status != LeadsStatus.success) return const SizedBox.shrink();

    // Helper function to count leads with a specific status
    int _countLeadsByStatus(List<Lead> leads, LeadStatus status) {
      return leads.where((lead) => lead.status == status).length;
    }

    // Helper function to count leads with a specific process status
    int _countLeadsByProcessStatus(List<Lead> leads, ProcessStatus processStatus) {
      return leads.where((lead) => lead.processStatus == processStatus).length;
    }

    final stats = [
      {
        'title': 'Total Leads',
        'value': state.filteredLeads.length.toString(),
        'icon': Icons.people_outline,
        'color': Theme.of(context).colorScheme.primary,
      },
      {
        'title': 'Hot Leads',
        'value': _countLeadsByStatus(state.filteredLeads, LeadStatus.hot).toString(),
        'icon': Icons.local_fire_department_outlined,
        'color': Colors.red,
      },
      {
        'title': 'Warm Leads',
        'value': _countLeadsByStatus(state.filteredLeads, LeadStatus.warm).toString(),
        'icon': Icons.trending_up_outlined,
        'color': Colors.orange,
      },
      {
        'title': 'Cold Leads',
        'value': _countLeadsByStatus(state.filteredLeads, LeadStatus.cold).toString(),
        'icon': Icons.ac_unit_outlined,
        'color': Colors.blue,
      },
      {
        'title': 'Fresh Leads',
        'value': _countLeadsByProcessStatus(state.filteredLeads, ProcessStatus.fresh).toString(),
        'icon': Icons.fiber_new_outlined,
        'color': Colors.green,
      },
      {
        'title': 'In Progress Leads',
        'value': _countLeadsByProcessStatus(state.filteredLeads, ProcessStatus.inProgress).toString(),
        'icon': Icons.pending_outlined,
        'color': Colors.amber,
      },
    ];

    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      itemCount: stats.length,
      separatorBuilder: (context, index) => const SizedBox(width: 8),
      itemBuilder: (context, index) {
        final stat = stats[index];
        return SizedBox(
          width: 200,
          child: _buildStatCard(
            context,
            stat['title'] as String,
            stat['value'] as String,
            stat['icon'] as IconData,
            stat['color'] as Color,
          ),
        );
      },
    );
  }

  Widget _buildLeadsTable(BuildContext context, List<Lead> leads) {
    final theme = Theme.of(context);
    final state = context.watch<LeadsBloc>().state;
    final hasSelection = state.selectedLeadIds.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (hasSelection) ...[
          Container(
            padding: const EdgeInsets.all(16),
            color: theme.colorScheme.primary.withOpacity(0.1),
            child: Row(
              children: [
                Text(
                  '${state.selectedLeadIds.length} leads selected',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(width: 16),
                FilledButton.icon(
                  icon: const Icon(Icons.delete),
                  label: const Text('Delete Selected'),
                  onPressed: () => _bulkDeleteLeads(state.selectedLeadIds.toList()),
                ),
                const SizedBox(width: 8),
                PopupMenuButton<LeadStatus>(
                  tooltip: 'Change status for selected leads',
                  child: FilledButton.icon(
                    icon: const Icon(Icons.flag),
                    label: const Text('Change Status'),
                    onPressed: null,
                  ),
                  itemBuilder: (context) => LeadStatus.values
                      .map(
                        (status) => PopupMenuItem(
                          value: status,
                          child: Row(
                            children: [
                              Icon(
                                Icons.circle,
                                size: 12,
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
                    state.selectedLeadIds.toList(),
                    status.toString(),
                  ),
                ),
                const SizedBox(width: 8),
                PopupMenuButton<ProcessStatus>(
                  tooltip: 'Change process status for selected leads',
                  child: FilledButton.icon(
                    icon: const Icon(Icons.sync),
                    label: const Text('Change Process'),
                    onPressed: null,
                  ),
                  itemBuilder: (context) => ProcessStatus.values
                      .map(
                        (status) => PopupMenuItem(
                          value: status,
                          child: Text(status.toString().split('.').last),
                        ),
                      )
                      .toList(),
                  onSelected: (status) => _bulkUpdateLeadsProcessStatus(
                    state.selectedLeadIds.toList(),
                    status.toString(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
        Card(
          elevation: 1,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width - 48,
              ),
              child: DataTable(
                showCheckboxColumn: true,
                sortColumnIndex: state.sortColumn != null
                    ? _getColumnIndex(state.sortColumn!)
                    : null,
                sortAscending: state.sortAscending,
                columns: [
                  DataColumn(
                    label: const Text('Name'),
                    onSort: (index, ascending) => _onSort(index, ascending),
                  ),
                  DataColumn(
                    label: const Text('Email'),
                    onSort: (index, ascending) => _onSort(index, ascending),
                  ),
                  DataColumn(
                    label: const Text('Phone'),
                    onSort: (index, ascending) => _onSort(index, ascending),
                  ),
                  DataColumn(
                    label: const Text('Status'),
                    onSort: (index, ascending) => _onSort(index, ascending),
                  ),
                  DataColumn(
                    label: const Text('Process'),
                    onSort: (index, ascending) => _onSort(index, ascending),
                  ),
                  DataColumn(
                    label: const Text('Created'),
                    onSort: (index, ascending) => _onSort(index, ascending),
                  ),
                  const DataColumn(label: Text('Actions')),
                ],
                rows: _getSortedLeads(leads, state.sortColumn, state.sortAscending)
                    .map((lead) => _buildDataRow(context, lead))
                    .toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  int _getColumnIndex(String column) {
    switch (column) {
      case 'name':
        return 0;
      case 'email':
        return 1;
      case 'phone':
        return 2;
      case 'status':
        return 3;
      case 'processStatus':
        return 4;
      case 'createdAt':
        return 5;
      default:
        return 0;
    }
  }

  void _onSort(int columnIndex, bool ascending) {
    final leadsBloc = context.read<LeadsBloc>();
    final state = leadsBloc.state;
    
    final column = _getColumnName(columnIndex);
    final sortedLeads = _getSortedLeads(state.filteredLeads, column, ascending);

    leadsBloc.add(SortLeads(
      leads: sortedLeads,
      column: column,
      ascending: ascending,
    ));
  }

  String _getColumnName(int index) {
    switch (index) {
      case 0:
        return 'name';
      case 1:
        return 'email';
      case 2:
        return 'phone';
      case 3:
        return 'status';
      case 4:
        return 'processStatus';
      case 5:
        return 'createdAt';
      default:
        return '';
    }
  }

  List<Lead> _getSortedLeads(List<Lead> leads, String? column, bool ascending) {
    if (leads.isEmpty) return leads;

    final sortedLeads = List<Lead>.from(leads);
    sortedLeads.sort((a, b) {
      int compare = 0;
      switch (column) {
        case 'name':
          compare = _getLeadName(a).compareTo(_getLeadName(b));
          break;
        case 'email':
          compare = a.email.compareTo(b.email);
          break;
        case 'phone':
          compare = a.phone.compareTo(b.phone);
          break;
        case 'status':
          compare = a.status.toString().compareTo(b.status.toString());
          break;
        case 'processStatus':
          compare = a.processStatus.toString().compareTo(b.processStatus.toString());
          break;
        case 'createdAt':
          compare = a.createdAt.compareTo(b.createdAt);
          break;
        default:
          compare = 0;
      }
      return ascending ? compare : -compare;
    });

    return sortedLeads;
  }

  DataRow _buildDataRow(BuildContext context, Lead lead) {
    final state = context.watch<LeadsBloc>().state;
    final isSelected = state.selectedLeadIds.contains(lead.id);

    return DataRow(
      cells: [
        DataCell(
          Checkbox(
            value: isSelected,
            onChanged: (bool? value) {
              if (value == true) {
                context.read<LeadsBloc>().add(SelectLead(leadId: lead.id));
              } else {
                context.read<LeadsBloc>().add(DeselectLead(leadId: lead.id));
              }
            },
          ),
        ),
        DataCell(Text('${lead.firstName} ${lead.lastName}')),
        DataCell(Text(lead.email)),
        DataCell(Text(lead.phone)),
        DataCell(_buildStatusChip(context, lead)),
        DataCell(_buildProcessChip(context, lead)),
        DataCell(Text(_formatDate(lead.createdAt))),
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
          ],
        )),
      ],
    );
  }

  Future<void> _bulkDeleteLeads(List<String> leadIds) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Selected Leads'),
        content: Text(
            'Are you sure you want to delete ${leadIds.length} selected leads?'),
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
              leadIds: leadIds.toList(),
            ),
          );
    }
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
      List<String> leadIds, String status) {
    context.read<LeadsBloc>().add(
          BulkUpdateLeadsProcessStatus(
            leadIds: leadIds.toList(),
            status: status,
          ),
        );
  }

  Widget _buildStatusChip(BuildContext context, Lead lead) {
    final theme = Theme.of(context);
    final status = LeadStatus.values.firstWhere(
      (s) => s.toString() == lead.status,
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
      (s) => s.toString() == lead.processStatus,
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
              child: Text(status.toString().split('.').last),
            ),
          )
          .toList(),
      onSelected: (newStatus) => _updateLeadProcessStatus(lead, newStatus),
    );
  }

  void _updateLeadStatus(Lead lead, LeadStatus newStatus) {
    context.read<LeadsBloc>().add(UpdateLeadStatus(
      lead: lead,
      status: newStatus.toString().split('.').last,
    ));
  }

  void _updateLeadProcessStatus(Lead lead, ProcessStatus newProcessStatus) {
    context.read<LeadsBloc>().add(UpdateLeadProcessStatus(
      lead: lead,
      status: newProcessStatus,
    ));
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.day}/${date.month}/${date.year}';
  }

  String _getLeadName(Lead lead) {
    return '${lead.firstName} ${lead.lastName}'.trim();
  }

  Widget _buildHeader(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 900;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isSmallScreen
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Leads Management',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                  const SizedBox(height: 16),
                  _buildActionButtons(context),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Leads Management',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                  _buildActionButtons(context),
                ],
              ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final spacing = 8.0;
    final state = context.watch<LeadsBloc>().state;

    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: [
        const LeadFilterWidget(),
        OutlinedButton.icon(
          onPressed: _importLeads,
          icon: const Icon(Icons.upload_file),
          label: const Text('Import'),
        ),
        OutlinedButton.icon(
          onPressed: _exportLeads,
          icon: const Icon(Icons.download),
          label: const Text('Export'),
        ),
        FilledButton.icon(
          onPressed: _addNewLead,
          icon: const Icon(Icons.add),
          label: const Text('Add Lead'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth > 1200 ? 24.0 : 16.0;
    final verticalSpacing = screenWidth > 900 ? 16.0 : 12.0;

    return BlocBuilder<LeadsBloc, LeadsState>(
      builder: (context, state) {
        if (state.status == LeadsStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == LeadsStatus.failure) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.errorMessage ?? 'An error occurred'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadLeads,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state.filteredLeads.isEmpty) {
          return _NoLeadsWidget(
            isFiltered: state.filter != const LeadFilter(),
            onClearFilter: () {
              context.read<LeadsBloc>().add(
                    FilterLeads(filter: const LeadFilter()),
                  );
            },
            onAddLead: _addNewLead,
          );
        }

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalSpacing,
          ),
          child: Column(
            children: [
              _buildHeader(context),
              SizedBox(height: verticalSpacing),
              SizedBox(
                height: 80,
                child: _buildStatsGrid(context, state),
              ),
              SizedBox(height: verticalSpacing),
              Expanded(
                child: _buildLeadsTable(context, state.filteredLeads),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _NoLeadsWidget extends StatelessWidget {
  final bool isFiltered;
  final VoidCallback onClearFilter;
  final VoidCallback onAddLead;

  const _NoLeadsWidget({
    required this.isFiltered,
    required this.onClearFilter,
    required this.onAddLead,
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
            isFiltered ? 'No leads match your filter' : 'No leads yet',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            isFiltered
                ? 'Try adjusting your filter settings'
                : 'Start by adding your first lead',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
          ),
          const SizedBox(height: 24),
          if (isFiltered)
            FilledButton.icon(
              onPressed: onClearFilter,
              icon: const Icon(Icons.filter_alt_off),
              label: const Text('Clear Filter'),
            )
          else
            FilledButton.icon(
              onPressed: onAddLead,
              icon: const Icon(Icons.add),
              label: const Text('Add Lead'),
            ),
        ],
      ),
    );
  }
}
