import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:neetiflow/application/leads/leads_bloc.dart';
import 'package:neetiflow/domain/entities/lead.dart';
import 'package:neetiflow/infrastructure/repositories/leads_repository.dart';
import 'package:neetiflow/presentation/blocs/auth/auth_bloc.dart';
import 'package:neetiflow/presentation/theme/lead_status_colors.dart';
import 'package:universal_html/html.dart' as html;

class LeadsPage extends StatelessWidget {
  const LeadsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LeadsBloc(
        repository: LeadsRepository(),
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
      context.read<LeadsBloc>().add(LoadLeads(authState.employee.companyId!));
    }
  }

  Future<void> _importLeads() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
        withData: true,
      );

      if (result != null) {
        final authState = context.read<AuthBloc>().state;
        if (authState is Authenticated) {
          final bytes = kIsWeb
              ? result.files.first.bytes!
              : result.files.first.bytes!;

          context.read<LeadsBloc>().add(
                ImportLeadsFromCSV(authState.employee.companyId!, bytes),
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
    context.read<LeadsBloc>().add(const ExportLeadsToCSV());
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
                  Expanded(
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
                            id: '',  // Will be set by Firestore
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

                          builderContext.read<LeadsBloc>().add(CreateLead(authState.employee.companyId!, lead));
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

  void _downloadCsv(Uint8List bytes) {
    if (kIsWeb) {
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', 'leads_export.csv')
        ..click();
      html.Url.revokeObjectUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth >= 1200;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Leads Management',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Track and manage your leads efficiently',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.textTheme.bodySmall?.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Action Buttons
                  Row(
                    children: [
                      OutlinedButton.icon(
                        onPressed: _importLeads,
                        icon: const Icon(Icons.upload_file),
                        label: const Text('Import'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: _exportLeads,
                        icon: const Icon(Icons.download),
                        label: const Text('Export'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      FilledButton.icon(
                        onPressed: _addNewLead,
                        icon: const Icon(Icons.add),
                        label: const Text('Add Lead'),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Stats Cards
              BlocBuilder<LeadsBloc, LeadsState>(
                builder: (context, state) {
                  if (state is LeadsLoaded) {
                    final totalLeads = state.leads.length;
                    final hotLeads = state.leads.where((lead) => lead.status == LeadStatus.hot).length;
                    final warmLeads = state.leads.where((lead) => lead.status == LeadStatus.warm).length;
                    final coldLeads = state.leads.where((lead) => lead.status == LeadStatus.cold).length;

                    return GridView.count(
                      crossAxisCount: isLargeScreen ? 4 : 2,
                      shrinkWrap: true,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: isLargeScreen ? 1.5 : 1.2,
                      children: [
                        _buildStatCard(
                          context,
                          'Total Leads',
                          totalLeads.toString(),
                          Icons.people_outline,
                          theme.colorScheme.primary,
                        ),
                        _buildStatCard(
                          context,
                          'Hot Leads',
                          hotLeads.toString(),
                          Icons.local_fire_department_outlined,
                          Colors.red,
                        ),
                        _buildStatCard(
                          context,
                          'Warm Leads',
                          warmLeads.toString(),
                          Icons.trending_up_outlined,
                          Colors.orange,
                        ),
                        _buildStatCard(
                          context,
                          'Cold Leads',
                          coldLeads.toString(),
                          Icons.ac_unit_outlined,
                          Colors.blue,
                        ),
                      ],
                    );
                  }
                  
                  // Show placeholder cards while loading
                  return GridView.count(
                    crossAxisCount: isLargeScreen ? 4 : 2,
                    shrinkWrap: true,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: isLargeScreen ? 1.5 : 1.2,
                    children: List.generate(4, (index) {
                      return Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: theme.dividerColor.withOpacity(0.2),
                          ),
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }),
                  );
                },
              ),
              const SizedBox(height: 32),
              // Leads Table
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: theme.dividerColor.withOpacity(0.2),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: BlocBuilder<LeadsBloc, LeadsState>(
                    builder: (context, state) {
                      if (state is LeadsLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (state is LeadsLoaded) {
                        return LeadsTable(leads: state.leads);
                      }
                      if (state is LeadsError) {
                        return Center(
                          child: Text(
                            'Error: ${state.message}',
                            style: TextStyle(color: theme.colorScheme.error),
                          ),
                        );
                      }
                      return const Center(
                        child: Text('No leads found'),
                      );
                    },
                  ),
                ),
              ),
            ],
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
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.dividerColor.withOpacity(0.2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 12),
            Text(
              value,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodySmall?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LeadsTable extends StatelessWidget {
  final List<Lead> leads;

  const LeadsTable({super.key, required this.leads});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (leads.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 64,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'No leads yet',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start by adding your first lead or import from CSV',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.outline,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Table Header
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Row(
            children: [
              _buildHeaderCell(theme, 'Name', flex: 2),
              _buildHeaderCell(theme, 'Contact', flex: 2),
              _buildHeaderCell(theme, 'Subject'),
              _buildHeaderCell(theme, 'Status'),
              _buildHeaderCell(theme, 'Process'),
              _buildHeaderCell(theme, 'Actions', textAlign: TextAlign.center),
            ],
          ),
        ),
        // Table Body
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: leads.length,
          separatorBuilder: (context, index) => Divider(
            color: theme.dividerColor.withOpacity(0.1),
          ),
          itemBuilder: (context, index) {
            final lead = leads[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                          child: Text(
                            lead.firstName[0].toUpperCase(),
                            style: TextStyle(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${lead.firstName} ${lead.lastName}',
                                style: theme.textTheme.titleSmall,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'Added ${_formatDate(lead.createdAt)}',
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lead.email,
                          style: theme.textTheme.bodyMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          lead.phone,
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Text(
                      lead.subject,
                      style: theme.textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Expanded(
                    child: _buildStatusChip(context, lead, lead.status),
                  ),
                  Expanded(
                    child: _buildProcessChip(context, lead, lead.processStatus),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined),
                          onPressed: () {
                            // TODO: Implement edit
                          },
                          tooltip: 'Edit Lead',
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () {
                            // TODO: Implement delete
                          },
                          tooltip: 'Delete Lead',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildHeaderCell(ThemeData theme, String text, {
    int flex = 1,
    TextAlign textAlign = TextAlign.start,
  }) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.outline,
          fontWeight: FontWeight.w500,
        ),
        textAlign: textAlign,
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context, Lead lead, LeadStatus status) {
    final theme = Theme.of(context);
    final color = LeadStatusColors.getLeadStatusColor(status);

    return PopupMenuButton<LeadStatus>(
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
            Text(
              status.toString().split('.').last,
              style: theme.textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_drop_down,
              size: 16,
              color: color,
            ),
          ],
        ),
      ),
      itemBuilder: (context) => LeadStatus.values
          .map(
            (s) => PopupMenuItem<LeadStatus>(
              value: s,
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: LeadStatusColors.getLeadStatusColor(s),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    s.toString().split('.').last,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: s == status
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface,
                      fontWeight: s == status ? FontWeight.bold : null,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
      onSelected: (newStatus) {
        final authState = context.read<AuthBloc>().state;
        if (authState is Authenticated) {
          context.read<LeadsBloc>().add(
                UpdateLeadStatus(
                  authState.employee.companyId!,
                  lead.id,
                  status: newStatus,
                ),
              );
        }
      },
    );
  }

  Widget _buildProcessChip(BuildContext context, Lead lead, ProcessStatus status) {
    final theme = Theme.of(context);
    final colors = {
      ProcessStatus.fresh: Colors.green,
      ProcessStatus.inProgress: Colors.orange,
      ProcessStatus.completed: Colors.blue,
      ProcessStatus.rejected: Colors.red,
    };
    
    final color = colors[status] ?? theme.colorScheme.primary;
    
    return PopupMenuButton<ProcessStatus>(
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
            Text(
              status.toString().split('.').last,
              style: theme.textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_drop_down,
              size: 16,
              color: color,
            ),
          ],
        ),
      ),
      itemBuilder: (context) => ProcessStatus.values
          .map(
            (s) => PopupMenuItem<ProcessStatus>(
              value: s,
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: colors[s] ?? theme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    s.toString().split('.').last,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: s == status
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface,
                      fontWeight: s == status ? FontWeight.bold : null,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
      onSelected: (newStatus) {
        final authState = context.read<AuthBloc>().state;
        if (authState is Authenticated) {
          context.read<LeadsBloc>().add(
                UpdateLeadStatus(
                  authState.employee.companyId!,
                  lead.id,
                  processStatus: newStatus,
                ),
              );
        }
      },
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.day}/${date.month}/${date.year}';
  }
}
