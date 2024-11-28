import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neetiflow/domain/entities/client.dart';
import 'package:neetiflow/domain/repositories/auth_repository.dart';
import 'package:neetiflow/domain/repositories/employees_repository.dart';
import 'package:neetiflow/presentation/blocs/clients/clients_bloc.dart';
import 'package:neetiflow/presentation/widgets/clients/client_list_item.dart';
import 'package:neetiflow/presentation/widgets/clients/client_form.dart';
import 'package:neetiflow/presentation/widgets/common/search_bar.dart';

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
                  return const Center(
                    child: Text('No clients found'),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  itemCount: state.filteredClients.length,
                  itemBuilder: (context, index) {
                    final client = state.filteredClients[index];
                    return ClientListItem(
                      client: client,
                      onEdit: () => _showEditClientDialog(context, client),
                      onDelete: () => _showDeleteConfirmation(context, client),
                      onStatusChange: (status) {
                        context.read<ClientsBloc>().add(
                              UpdateClientStatus(client.id, status),
                            );
                      },
                    );
                  },
                );
              }
              if (state is ClientsError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Error: ${state.message}',
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<ClientsBloc>().add(LoadClients());
                        },
                        child: const Text('Retry'),
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
              current is ClientsError || 
              (current is ClientsLoaded && previous is! ClientsLoaded),
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

  void _showEditClientDialog(BuildContext context, Client client) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => MultiBlocListener(
        listeners: [
          BlocListener<ClientsBloc, ClientsState>(
            listenWhen: (previous, current) => 
              current is ClientsError || 
              (current is ClientsLoaded && previous is! ClientsLoaded),
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
                    content: Text('Client updated successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
          ),
        ],
        child: Dialog(
          child: ClientForm(
            client: client,
            onSubmit: (updatedClient) {
              context.read<ClientsBloc>().add(UpdateClient(updatedClient));
            },
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Client client) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Client'),
        content: Text('Are you sure you want to delete ${client.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<ClientsBloc>().add(DeleteClient(client.id));
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
