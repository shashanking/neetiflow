import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:neetiflow/presentation/blocs/leads/leads_bloc.dart';
import 'package:neetiflow/presentation/blocs/leads/leads_event.dart';
import 'package:neetiflow/presentation/blocs/leads/leads_state.dart';
import 'package:neetiflow/domain/entities/lead.dart';
import 'package:neetiflow/infrastructure/repositories/leads_repository.dart';
import 'package:neetiflow/presentation/blocs/auth/auth_bloc.dart';
import 'package:neetiflow/presentation/theme/lead_status_colors.dart';
import 'package:neetiflow/presentation/utils/responsive_utils.dart';
import 'package:neetiflow/presentation/widgets/page_wrapper.dart';

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
  @override
  void initState() {
    super.initState();
    _loadLeads();
  }

  void _loadLeads() {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      context.read<LeadsBloc>().add(
            LoadLeads(companyId: authState.employee.companyId!),
          );
    }
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
          final bytes = kIsWeb
              ? result.files.first.bytes!
              : result.files.first.bytes!;

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
                                      final color = LeadStatusColors.getLeadStatusColor(status);
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
                                      final color = LeadStatusColors.getProcessStatusColor(status);
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
                                        setState(() => selectedProcessStatus = value);
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
                                content: Text('Please fill all required fields'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                            return;
                          }

                          final lead = Lead(
                            id: '', // Will be set by Firestore
                            uid: 'manual-${DateTime.now().millisecondsSinceEpoch}',
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

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: Theme.of(context).dividerColor.withOpacity(0.1),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(icon, color: color, size: 16),
                ),
                const SizedBox(width: 8),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context, LeadsState state) {
    if (state is! LeadsLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              context,
              'Total Leads',
              state.leads.length.toString(),
              Icons.people_outline,
              Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildStatCard(
              context,
              'Hot Leads',
              state.leads.where((lead) => lead.status == LeadStatus.hot).length.toString(),
              Icons.local_fire_department_outlined,
              Colors.red,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildStatCard(
              context,
              'Warm Leads',
              state.leads.where((lead) => lead.status == LeadStatus.warm).length.toString(),
              Icons.trending_up_outlined,
              Colors.orange,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildStatCard(
              context,
              'Cold Leads',
              state.leads.where((lead) => lead.status == LeadStatus.cold).length.toString(),
              Icons.ac_unit_outlined,
              Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final isSmallScreen = ResponsiveUtils.isSmallScreen(context);

    return isSmallScreen
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Leads Management',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
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
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              _buildActionButtons(context),
            ],
          );
  }

  Widget _buildActionButtons(BuildContext context) {
    final isSmallScreen = ResponsiveUtils.isSmallScreen(context);
    final spacing = isSmallScreen ? 8.0 : 12.0;

    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: [
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

  Widget _buildLeadsTable(BuildContext context, LeadsState state) {
    if (state is! LeadsLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    final isSmallScreen = ResponsiveUtils.isSmallScreen(context);
    final padding = ResponsiveUtils.getPadding(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width - (padding * 2),
        ),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
            child: DataTable(
              columnSpacing: isSmallScreen ? 16.0 : 24.0,
              horizontalMargin: isSmallScreen ? 12.0 : 16.0,
              columns: [
                DataColumn(
                  label: Text(
                    'Name',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                if (!isSmallScreen) DataColumn(
                  label: Text(
                    'Email',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                if (!isSmallScreen) DataColumn(
                  label: Text(
                    'Phone',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Subject',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Status',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Process',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                if (!isSmallScreen) DataColumn(
                  label: Text(
                    'Created',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Actions',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
              rows: state.leads.map((lead) => _buildDataRow(context, lead)).toList(),
            ),
          ),
        ),
      ),
    );
  }

  DataRow _buildDataRow(BuildContext context, Lead lead) {
    final isSmallScreen = ResponsiveUtils.isSmallScreen(context);
    final authState = context.read<AuthBloc>().state;
    // ignore: prefer_const_constructors
    if (authState is! Authenticated) return DataRow(cells: []);

    return DataRow(
      cells: [
        DataCell(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${lead.firstName} ${lead.lastName}'),
              if (isSmallScreen) Text(
                lead.email,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        if (!isSmallScreen) DataCell(
          SelectableText(lead.email),
        ),
        if (!isSmallScreen) DataCell(
          SelectableText(lead.phone),
        ),
        DataCell(
          Tooltip(
            message: lead.message,
            child: Text(
              lead.subject,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        DataCell(_buildStatusChip(context, lead, lead.status, authState.employee.companyId!)),
        DataCell(_buildProcessChip(context, lead, lead.processStatus, authState.employee.companyId!)),
        if (!isSmallScreen) DataCell(Text(_formatDate(lead.createdAt))),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 20),
                onPressed: () {
                  // TODO: Implement edit functionality
                },
                tooltip: 'Edit Lead',
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 20),
                onPressed: () {
                  // TODO: Implement delete functionality
                },
                tooltip: 'Delete Lead',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(BuildContext context, Lead lead, LeadStatus status, String companyId) {
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

  Widget _buildProcessChip(BuildContext context, Lead lead, ProcessStatus status, String companyId) {
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

  @override
  Widget build(BuildContext context) {
    final padding = ResponsiveUtils.getPadding(context);

    return PageWrapper(
      title: 'Leads',
      child: SingleChildScrollView(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            SizedBox(height: padding),
            BlocBuilder<LeadsBloc, LeadsState>(
              builder: (context, state) => _buildStatsGrid(context, state),
            ),
            SizedBox(height: padding),
            BlocBuilder<LeadsBloc, LeadsState>(
              builder: (context, state) => _buildLeadsTable(context, state),
            ),
          ],
        ),
      ),
    );
  }
}