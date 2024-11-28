import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:neetiflow/domain/entities/client.dart';
import 'package:neetiflow/presentation/blocs/clients/clients_bloc.dart';
import 'package:neetiflow/presentation/widgets/clients/client_form.dart';
import 'package:neetiflow/presentation/widgets/persistent_shell.dart';

class ClientDetailsPage extends StatefulWidget {
  final Client client;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ClientDetailsPage({
    super.key,
    required this.client,
    this.onEdit,
    this.onDelete,
  });

  @override
  State<ClientDetailsPage> createState() => _ClientDetailsPageState();
}

class _ClientDetailsPageState extends State<ClientDetailsPage> {
  Client get client => widget.client;

  @override
  void initState() {
    super.initState();
    context.read<ClientsBloc>().add(LoadClients());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClientsBloc, ClientsState>(
      builder: (context, state) {
        if (state is ClientsLoaded) {
          final updatedClient = state.clients.firstWhere(
            (c) => c.id == client.id,
            orElse: () => client,
          );

          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  final shell = PersistentShell.of(context);
                  if (shell != null) {
                    shell.clearCustomPage();
                  }
                },
              ),
              title: Text(updatedClient.fullName),
              actions: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: widget.onEdit ?? () => _showEditDialog(context, updatedClient),
                  tooltip: 'Edit Client',
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: widget.onDelete ?? () => _showDeleteConfirmation(context),
                  tooltip: 'Delete Client',
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context, updatedClient),
                  const SizedBox(height: 32),
                  _buildContactInfo(context, updatedClient),
                  const SizedBox(height: 32),
                  _buildBusinessInfo(context, updatedClient),
                  if (updatedClient.projects.isNotEmpty) ...[
                    const SizedBox(height: 32),
                    _buildProjectsSection(context, updatedClient),
                  ],
                ],
              ),
            ),
          );
        }
        
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, Client client) {
    final theme = Theme.of(context);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                  child: Text(
                    client.fullName.substring(0, 1).toUpperCase(),
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        client.fullName,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (client.organizationName?.isNotEmpty ?? false) ...[
                        const SizedBox(height: 4),
                        Text(
                          client.organizationName!,
                          style: theme.textTheme.titleMedium,
                        ),
                      ],
                      const SizedBox(height: 8),
                      _buildStatusChip(context, client),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoItem(
                  context,
                  Icons.star,
                  'Rating',
                  '${client.rating.toStringAsFixed(1)}/5.0',
                  Colors.amber,
                ),
                _buildInfoItem(
                  context,
                  Icons.calendar_today,
                  'Client Since',
                  DateFormat('MMM d, y').format(client.joiningDate),
                  theme.colorScheme.primary,
                ),
                _buildInfoItem(
                  context,
                  Icons.currency_rupee,
                  'Lifetime Value',
                  NumberFormat('#,##,###').format(client.lifetimeValue),
                  Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, IconData icon, String label, String value, Color color) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        Icon(icon, color: color),
        const SizedBox(height: 8),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildContactInfo(BuildContext context, Client client) {
    final theme = Theme.of(context);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contact Information',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.email),
              title: Text(client.email),
              subtitle: const Text('Email'),
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: Text(client.phone),
              subtitle: const Text('Phone'),
            ),
            ListTile(
              leading: const Icon(Icons.location_on),
              title: Text(client.address),
              subtitle: const Text('Address'),
            ),
            if (client.website?.isNotEmpty ?? false) ...[
              ListTile(
                leading: const Icon(Icons.language),
                title: Text(client.website!),
                subtitle: const Text('Website'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBusinessInfo(BuildContext context, Client client) {
    final theme = Theme.of(context);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Business Information',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.business),
              title: Text(client.type.toString().split('.').last.toUpperCase()),
              subtitle: const Text('Client Type'),
            ),
            ListTile(
              leading: const Icon(Icons.domain),
              title: Text(client.domain.toString().split('.').last.toUpperCase()),
              subtitle: const Text('Domain'),
            ),
            if (client.gstin?.isNotEmpty ?? false) ...[
              ListTile(
                leading: const Icon(Icons.receipt),
                title: Text(client.gstin!),
                subtitle: const Text('GSTIN'),
              ),
            ],
            if (client.pan?.isNotEmpty ?? false) ...[
              ListTile(
                leading: const Icon(Icons.credit_card),
                title: Text(client.pan!),
                subtitle: const Text('PAN'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProjectsSection(BuildContext context, Client client) {
    final theme = Theme.of(context);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Projects',
                  style: theme.textTheme.titleLarge,
                ),
                Text(
                  '${client.projects.length} Projects',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: client.projects.length,
              itemBuilder: (context, index) {
                final project = client.projects[index];
                return ListTile(
                  title: Text(project.name),
                  subtitle: Text(project.description),
                  trailing: Text(
                    '₹${NumberFormat('#,##,###').format(project.value)}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context, Client client) {
    final statusColors = {
      ClientStatus.active: Colors.green,
      ClientStatus.inactive: Colors.grey,
      ClientStatus.suspended: Colors.red,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColors[client.status]?.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: statusColors[client.status] ?? Colors.grey,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 4,
            backgroundColor: statusColors[client.status],
          ),
          const SizedBox(width: 8),
          Text(
            client.status.toString().split('.').last.toUpperCase(),
            style: TextStyle(
              color: statusColors[client.status],
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, Client client) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => MultiBlocListener(
        listeners: [
          BlocListener<ClientsBloc, ClientsState>(
            listenWhen: (previous, current) => 
              current is ClientsError || current is ClientsLoaded,
            listener: (context, state) {
              if (state is ClientsError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              } else if (state is ClientsLoaded) {
                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Client updated successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
          ),
        ],
        child: ClientForm(
          client: client,
          onSubmit: (updatedClient) {
            context.read<ClientsBloc>().add(UpdateClient(updatedClient));
          },
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocListener<ClientsBloc, ClientsState>(
        listenWhen: (previous, current) => 
          current is ClientsError || current is ClientsLoaded,
        listener: (context, state) {
          if (state is ClientsError) {
            Navigator.of(dialogContext).pop(); // Close dialog
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is ClientsLoaded) {
            // Check if client was actually deleted
            final clientExists = state.clients.any((c) => c.id == client.id);
            if (!clientExists) {
              // Close the dialog
              Navigator.of(dialogContext).pop();
              
              // Navigate back to clients list using PersistentShell
              final shell = PersistentShell.of(context);
              if (shell != null) {
                shell.clearCustomPage();
              } else {
                // Fallback navigation if PersistentShell is not available
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
              
              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Client deleted successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          }
        },
        child: AlertDialog(
          title: const Text('Delete Client'),
          content: Text(
            'Are you sure you want to delete ${client.fullName}${client.organizationName?.isNotEmpty ?? false ? ' (${client.organizationName})' : ''}?'
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<ClientsBloc>().add(DeleteClient(client.id));
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }
}
