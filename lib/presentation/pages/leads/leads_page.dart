import 'dart:html' as html;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neetiflow/domain/entities/lead.dart';
import 'package:neetiflow/domain/entities/lead_filter.dart';
import 'package:neetiflow/infrastructure/repositories/leads_repository.dart';
import 'package:neetiflow/presentation/blocs/auth/auth_bloc.dart';
import 'package:neetiflow/presentation/blocs/leads/leads_bloc.dart';
import 'package:neetiflow/presentation/blocs/leads/leads_event.dart';
import 'package:neetiflow/presentation/blocs/leads/leads_state.dart';
import 'package:neetiflow/presentation/theme/lead_status_colors.dart';
import 'package:neetiflow/presentation/widgets/leads/lead_filter_widget.dart';
import 'package:neetiflow/presentation/widgets/leads/lead_form.dart';

import '../../widgets/page_wrapper.dart';

class LeadsPage extends StatelessWidget {
  const LeadsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LeadsBloc(
        leadsRepository: LeadsRepository(),
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
  List<String> _availableSegments = [];

  @override
  void initState() {
    super.initState();
    _loadLeads();
    _loadSegments();
  }

  void _loadLeads() {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      context.read<LeadsBloc>().add(
            LoadLeads(companyId: authState.employee.companyId!),
          );
    }
  }

  void _loadSegments() {
    // TODO: Load segments from repository
    _availableSegments = ['High Value', 'New Lead', 'Follow Up', 'Hot Deal'];
  }

  Future<void> _importLeads() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result != null) {
        final authState = context.read<AuthBloc>().state;
        if (authState is Authenticated) {
          final bytes =
              kIsWeb ? result.files.first.bytes! : result.files.first.bytes!;

          context.read<LeadsBloc>().add(
                ImportLeadsFromCSV(
                  companyId: authState.employee.companyId!,
                  fileBytes: bytes,
                ),
              );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error importing leads: ${e.toString()}')),
      );
    }
  }

  Future<void> _exportLeads() async {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      context.read<LeadsBloc>().add(
            ExportLeadsToCSV(companyId: authState.employee.companyId!),
          );
    }
  }

  Future<void> _addNewLead() async {
    final authState = context.read<AuthBloc>().state;
    if (authState is! Authenticated) return;

    final firstNameController = TextEditingController();
    final lastNameController = TextEditingController();
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
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: firstNameController,
                                  decoration: const InputDecoration(
                                    labelText: 'First Name*',
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.person_outline),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextField(
                                  controller: lastNameController,
                                  decoration: const InputDecoration(
                                    labelText: 'Last Name*',
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.person_outline),
                                  ),
                                ),
                              ),
                            ],
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
                          if (firstNameController.text.isEmpty ||
                              lastNameController.text.isEmpty ||
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
                            id: '', // Will be set by Firestore
                            uid:
                                'manual-${DateTime.now().millisecondsSinceEpoch}',
                            firstName: firstNameController.text,
                            lastName: lastNameController.text,
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
                                CreateLead(
                                  companyId: authState.employee.companyId!,
                                  lead: lead,
                                ),
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
      builder: (context) => AlertDialog(
        title: const Text('Edit Lead'),
        content: SizedBox(
          width: 400,
          child: SingleChildScrollView(
            child: LeadForm(
              lead: lead,
              onSubmit: (updatedLead) {
                Navigator.of(context).pop(updatedLead);
              },
            ),
          ),
        ),
      ),
    );

    if (result != null) {
      final authState = context.read<AuthBloc>().state;
      if (authState is Authenticated) {
        context.read<LeadsBloc>().add(
              UpdateLead(
                companyId: authState.employee.companyId!,
                lead: result,
              ),
            );
      }
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
      final authState = context.read<AuthBloc>().state;
      if (authState is Authenticated) {
        context.read<LeadsBloc>().add(
              DeleteLead(
                companyId: authState.employee.companyId!,
                leadId: lead.id,
              ),
            );
      }
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
    if (state is! LeadsLoaded) return const SizedBox.shrink();

    final stats = [
      {
        'title': 'Total Leads',
        'value': state.leads.length.toString(),
        'icon': Icons.people_outline,
        'color': Theme.of(context).colorScheme.primary,
      },
      {
        'title': 'Hot Leads',
        'value': state.leads
            .where((lead) => lead.status == LeadStatus.hot)
            .length
            .toString(),
        'icon': Icons.local_fire_department_outlined,
        'color': Colors.red,
      },
      {
        'title': 'Warm Leads',
        'value': state.leads
            .where((lead) => lead.status == LeadStatus.warm)
            .length
            .toString(),
        'icon': Icons.trending_up_outlined,
        'color': Colors.orange,
      },
      {
        'title': 'Cold Leads',
        'value': state.leads
            .where((lead) => lead.status == LeadStatus.cold)
            .length
            .toString(),
        'icon': Icons.ac_unit_outlined,
        'color': Colors.blue,
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
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'All Leads',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  '${leads.length} leads',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: DataTable(
                  columnSpacing: 24,
                  horizontalMargin: 16,
                  columns: const [
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Email')),
                    DataColumn(label: Text('Phone')),
                    DataColumn(label: Text('Subject')),
                    DataColumn(label: Text('Message')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Process')),
                    DataColumn(label: Text('Created')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: leads
                      .map((lead) => _buildDataRow(context, lead))
                      .toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  DataRow _buildDataRow(BuildContext context, Lead lead) {
    final authState = context.read<AuthBloc>().state as Authenticated;
    final companyId = authState.employee.companyId!;

    return DataRow(
      cells: [
        DataCell(Text('${lead.firstName} ${lead.lastName}')),
        DataCell(Text(lead.email)),
        DataCell(Text(lead.phone)),
        DataCell(Text(lead.subject)),
        DataCell(
          Tooltip(
            message: lead.message,
            child: SizedBox(
              width: 200,
              child: Text(
                lead.message,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
        DataCell(_buildStatusChip(context, lead, lead.status, companyId)),
        DataCell(
            _buildProcessChip(context, lead, lead.processStatus, companyId)),
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

  Widget _buildStatusChip(
      BuildContext context, Lead lead, LeadStatus status, String companyId) {
    final theme = Theme.of(context);
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
      onSelected: (newStatus) {
        context.read<LeadsBloc>().add(
              UpdateLeadStatus(
                companyId: companyId,
                leadId: lead.id,
                status: newStatus,
              ),
            );
      },
    );
  }

  Widget _buildProcessChip(
      BuildContext context, Lead lead, ProcessStatus status, String companyId) {
    final theme = Theme.of(context);
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
      onSelected: (newStatus) {
        context.read<LeadsBloc>().add(
              UpdateLeadProcessStatus(
                companyId: companyId,
                leadId: lead.id,
                processStatus: newStatus,
              ),
            );
      },
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.day}/${date.month}/${date.year}';
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
    final isSmallScreen = MediaQuery.of(context).size.width < 900;
    final spacing = isSmallScreen ? 8.0 : 12.0;
    final state = context.watch<LeadsBloc>().state;
    final filter =
        state is LeadsLoaded ? state.activeFilter : const LeadFilter();

    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: [
        LeadFilterWidget(
          currentFilter: filter ?? const LeadFilter(),
          onFilterChanged: (newFilter) {
            final authState = context.read<AuthBloc>().state;
            if (authState is Authenticated) {
              context.read<LeadsBloc>().add(
                    ApplyLeadFilter(
                      companyId: authState.employee.companyId!,
                      filter: newFilter,
                    ),
                  );
            }
          },
          availableSegments: _availableSegments,
        ),
        OutlinedButton.icon(
          onPressed: _importLeads,
          icon: const Icon(Icons.upload_file),
          label: const Text('Import'),
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        OutlinedButton.icon(
          onPressed: _exportLeads,
          icon: const Icon(Icons.download),
          label: const Text('Export'),
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        FilledButton.icon(
          onPressed: _addNewLead,
          icon: const Icon(Icons.add),
          label: const Text('Add Lead'),
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth > 1200 ? 24.0 : 16.0;
    final verticalSpacing = screenWidth > 900 ? 16.0 : 12.0;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalSpacing,
      ),
      child: BlocConsumer<LeadsBloc, LeadsState>(
        listener: (context, state) {
          if (state is LeadsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          } else if (state is LeadsExportSuccess) {
            // Create a blob URL from the CSV bytes
            final blob = html.Blob([state.csvBytes]);
            final url = html.Url.createObjectUrlFromBlob(blob);

            // Clean up
            html.Url.revokeObjectUrl(url);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('CSV export completed successfully'),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is LeadsInitial ||
              state is LeadsLoading ||
              state is LeadsExporting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is LeadsLoaded) {
            if (state.filteredLeads.isEmpty) {
              return _NoLeadsWidget(
                isFiltered: state.activeFilter != const LeadFilter(),
                onClearFilter: () {
                  final authState = context.read<AuthBloc>().state;
                  if (authState is Authenticated) {
                    context.read<LeadsBloc>().add(
                          ApplyLeadFilter(
                            companyId: authState.employee.companyId!,
                            filter: const LeadFilter(),
                          ),
                        );
                  }
                },
                onAddLead: _addNewLead,
              );
            }

            return Column(
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
            );
          }

          return Center(
            child: Text(
              'Something went wrong',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
          );
        },
      ),
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
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isFiltered ? Icons.filter_list_off : Icons.inbox_outlined,
            size: 64,
            color: theme.colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            isFiltered ? 'No leads match your filter' : 'No leads yet',
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isFiltered
                ? 'Try adjusting your filter criteria'
                : 'Start by adding your first lead or import from CSV',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isFiltered)
                OutlinedButton.icon(
                  onPressed: onClearFilter,
                  icon: const Icon(Icons.filter_list_off),
                  label: const Text('Clear Filter'),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                )
              else
                FilledButton.icon(
                  onPressed: onAddLead,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Lead'),
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
