import 'package:flutter/material.dart';
import 'package:neetiflow/domain/entities/client.dart';
import 'package:neetiflow/domain/services/client_service.dart';
import 'package:neetiflow/injection.dart';

class ClientSelector extends StatefulWidget {
  final Function(Client) onSelected;
  final ClientType? filterType;

  const ClientSelector({
    Key? key,
    required this.onSelected,
    this.filterType,
  }) : super(key: key);

  @override
  State<ClientSelector> createState() => _ClientSelectorState();
}

class _ClientSelectorState extends State<ClientSelector> {
  final TextEditingController _searchController = TextEditingController();
  final ClientService _clientService = getIt<ClientService>();
  List<Client> _searchResults = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    
    // Initial search with filter
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _onSearchChanged();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _onSearchChanged() async {
    final query = _searchController.text.trim();
    setState(() {
      _isLoading = true;
    });

    try {
      final results = await _clientService.searchClients(
        query: query,
        type: widget.filterType,
        limit: 10,
      );

      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _searchResults = [];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Client',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),

        // Selected Client Display
        // if (_selectedClient != null) ...[
        //   Card(
        //     child: ListTile(
        //       title: Text(_selectedClient!.name),
        //       subtitle: Text(_selectedClient!.email),
        //       trailing: IconButton(
        //         icon: const Icon(Icons.close),
        //         onPressed: () {
        //           setState(() {
        //             _selectedClient = null;
        //           });
        //         },
        //       ),
        //     ),
        //   ),
        //   const SizedBox(height: 8),
        // ],

        // Client Search
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            labelText: widget.filterType != null 
                ? '${widget.filterType!.name.capitalize()} Clients' 
                : 'Search Clients',
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : null,
          ),
        ),

        // Search Results
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          )
        else if (_searchResults.isNotEmpty)
          Expanded(
            child: Card(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final client = _searchResults[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _getClientTypeColor(client.type),
                      child: Text(client.name[0].toUpperCase()),
                    ),
                    title: Text(client.name),
                    subtitle: Text(client.type.toString().split('.').last.capitalize()),
                    onTap: () => widget.onSelected(client),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }

  Color _getClientTypeColor(ClientType type) {
    switch (type) {
      case ClientType.company:
        return Colors.blue.shade700;
      case ClientType.individual:
        return Colors.green.shade700;
      case ClientType.government:
        return Colors.orange.shade700;
    }
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
