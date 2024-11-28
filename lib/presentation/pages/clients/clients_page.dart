import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neetiflow/domain/entities/client.dart';
import 'package:neetiflow/domain/repositories/auth_repository.dart';
import 'package:neetiflow/domain/repositories/employees_repository.dart';
import 'package:neetiflow/presentation/blocs/clients/clients_bloc.dart';
import 'package:neetiflow/presentation/widgets/clients/client_list_item.dart';
import 'package:neetiflow/presentation/widgets/clients/client_form.dart';
import 'package:neetiflow/presentation/widgets/common/search_bar.dart';

import '../../widgets/persistent_shell.dart';
import 'client_details_page.dart';

class ClientsPage extends StatelessWidget {
  const ClientsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = ClientsBloc(
          authRepository: context.read<AuthRepository>(),
          employeesRepository: context.read<EmployeesRepository>(),
        );
        // Delay loading clients to avoid UI freeze
        Future.microtask(() => bloc.add(LoadClients()));
        return bloc;
      },
      child: const ClientsView(),
    );
  }
}

class ClientsView extends StatelessWidget {
  const ClientsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Client Management',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddClientDialog(context),
                icon: const Icon(Icons.add),
                label: const Text('Add Client'),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            children: [
              Expanded(
                child: CustomSearchBar(
                  onChanged: (query) {
                    context.read<ClientsBloc>().add(SearchClients(query));
                  },
                  hintText: 'Search clients...',
                ),
              ),
              const SizedBox(width: 16),
              PopupMenuButton<ClientStatus>(
                onSelected: (status) {
                  context.read<ClientsBloc>().add(FilterClientsByStatus(status));
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: ClientStatus.active,
                    child: Text('Active Clients'),
                  ),
                  const PopupMenuItem(
                    value: ClientStatus.inactive,
                    child: Text('Inactive Clients'),
                  ),
                  const PopupMenuItem(
                    value: ClientStatus.suspended,
                    child: Text('Suspended Clients'),
                  ),
                ],
                child: Chip(
                  label: const Text('Filter Status'),
                  deleteIcon: const Icon(Icons.arrow_drop_down),
                  onDeleted: () {},
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: BlocBuilder<ClientsBloc, ClientsState>(
            builder: (context, state) {
              if (state is ClientsInitial) {
                return const Center(child: Text('Loading clients...'));
              }
              if (state is ClientsLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is ClientsLoaded) {
                if (state.filteredClients.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No clients found',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton.icon(
                          onPressed: () => _showAddClientDialog(context),
                          icon: const Icon(Icons.add),
                          label: const Text('Add New Client'),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: state.filteredClients.length,
                  itemBuilder: (context, index) {
                    final client = state.filteredClients[index];
                    return ClientListItem(
                      client: client,
                      onTap: () => _navigateToClientDetails(context, client),
                    );
                  },
                );
              }
              if (state is ClientsError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error: ${state.message}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          context.read<ClientsBloc>().add(LoadClients());
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ],
    );
  }

  void _showAddClientDialog(BuildContext context) {
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
                Navigator.of(dialogContext).pop(); // Close dialog on success
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Client added successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
                // Navigate to client details page
                final newClient = state.clients.last; // Get the newly added client
                _navigateToClientDetails(context, newClient);
              }
            },
          ),
        ],
        child: Dialog(
          child: ClientForm(
            onSubmit: (client) {
              context.read<ClientsBloc>().add(AddClient(client));
            },
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Client client) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocListener<ClientsBloc, ClientsState>(
        listenWhen: (previous, current) => current is ClientsError,
        listener: (context, state) {
          if (state is ClientsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: AlertDialog(
          title: const Text('Delete Client'),
          content: Text(
            'Are you sure you want to delete ${client.fullName}' +
            (client.organizationName != null ? ' (${client.organizationName})' : '') +
            '?'
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Close dialog immediately
                Navigator.of(dialogContext).pop();
                // Then delete client and show success message
                context.read<ClientsBloc>().add(DeleteClient(client.id));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Client deleted successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToClientDetails(BuildContext context, Client client) {
    final state = PersistentShell.of(context);
    if (state != null) {
      state.setCustomPage(
        ClientDetailsPage(client: client)
      );
    } else {
      // Fallback navigation if PersistentShell is not available
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ClientDetailsPage(client: client),
        ),
      );
    }
  }
}
