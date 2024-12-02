import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neetiflow/domain/entities/client.dart';

import '../../blocs/clients/clients_bloc.dart';

class ClientSelector extends StatelessWidget {
  final Client? selectedClient;
  final Function(Client) onClientSelected;
  final bool showError;

  const ClientSelector({
    super.key,
    this.selectedClient,
    required this.onClientSelected,
    this.showError = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClientsBloc, ClientsState>(
      builder: (context, state) {
        if (state is ClientsInitial || state is ClientsLoading) {
          return _buildLoadingState();
        } else if (state is ClientsLoaded) {
          return _buildSelector(context, state.clients);
        } else if (state is ClientsError) {
          return _buildErrorState(state.message);
        }
        return _buildErrorState('Unexpected state');
      },
    );
  }

  Widget _buildLoadingState() {
    return const SizedBox(
      height: 56,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          message,
          style: const TextStyle(color: Colors.red),
        ),
      ),
    );
  }

  Widget _buildSelector(BuildContext context, List<Client> clients) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => ClientPickerSheet(
            clients: clients,
            selectedClient: selectedClient,
            onClientSelected: (client) {
              onClientSelected(client);
              Navigator.pop(context);
            },
          ),
        );
      },
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: showError ? Colors.red : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                selectedClient?.name ?? 'Select Client',
                style: TextStyle(
                  color: selectedClient != null
                      ? Colors.black87
                      : Colors.grey.shade600,
                ),
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: Colors.grey.shade600,
            ),
          ],
        ),
      ),
    );
  }
}

class ClientPickerSheet extends StatelessWidget {
  final List<Client> clients;
  final Client? selectedClient;
  final Function(Client) onClientSelected;

  const ClientPickerSheet({
    super.key,
    required this.clients,
    this.selectedClient,
    required this.onClientSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Select Client',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: clients.length,
              itemBuilder: (context, index) {
                final client = clients[index];
                return ListTile(
                  title: Text(client.name),
                  subtitle: Text(client.email),
                  selected: client.id == selectedClient?.id,
                  onTap: () => onClientSelected(client),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
