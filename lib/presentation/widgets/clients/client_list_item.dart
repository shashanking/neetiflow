import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:neetiflow/domain/entities/client.dart';

class ClientListItem extends StatelessWidget {
  final Client client;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final ValueChanged<ClientStatus> onStatusChange;

  const ClientListItem({
    super.key,
    required this.client,
    required this.onEdit,
    required this.onDelete,
    required this.onStatusChange,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        client.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        client.type.toString().split('.').last,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(),
                const SizedBox(width: 8),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                        onEdit();
                        break;
                      case 'delete':
                        onDelete();
                        break;
                      case 'status_active':
                        onStatusChange(ClientStatus.active);
                        break;
                      case 'status_inactive':
                        onStatusChange(ClientStatus.inactive);
                        break;
                      case 'status_suspended':
                        onStatusChange(ClientStatus.suspended);
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                    const PopupMenuDivider(),
                    const PopupMenuItem(
                      value: 'status_active',
                      child: Text('Set Active'),
                    ),
                    const PopupMenuItem(
                      value: 'status_inactive',
                      child: Text('Set Inactive'),
                    ),
                    const PopupMenuItem(
                      value: 'status_suspended',
                      child: Text('Set Suspended'),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildInfoColumn(
                    context,
                    'Contact',
                    [
                      _buildInfoRow(Icons.email, client.email),
                      const SizedBox(height: 4),
                      _buildInfoRow(Icons.phone, client.phone),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInfoColumn(
                    context,
                    'Details',
                    [
                      if (client.website != null)
                        _buildInfoRow(Icons.language, client.website!),
                      if (client.gstin != null) ...[
                        const SizedBox(height: 4),
                        _buildInfoRow(Icons.business, 'GSTIN: ${client.gstin}'),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInfoColumn(
                    context,
                    'Value',
                    [
                      if (client.lifetimeValue != null)
                        _buildInfoRow(
                          Icons.monetization_on,
                          NumberFormat.currency(
                            symbol: '₹',
                            decimalDigits: 0,
                          ).format(client.lifetimeValue),
                        ),
                      const SizedBox(height: 4),
                      _buildInfoRow(
                        Icons.calendar_today,
                        'Since ${DateFormat.yMMMd().format(client.createdAt)}',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip() {
    Color chipColor;
    String statusText = client.status.toString().split('.').last;
    
    switch (client.status) {
      case ClientStatus.active:
        chipColor = Colors.green;
        break;
      case ClientStatus.inactive:
        chipColor = Colors.grey;
        break;
      case ClientStatus.suspended:
        chipColor = Colors.red;
        break;
    }

    return Chip(
      label: Text(
        statusText,
        style: TextStyle(
          color: chipColor.computeLuminance() > 0.5 ? Colors.black : Colors.white,
        ),
      ),
      backgroundColor: chipColor.withOpacity(0.2),
      side: BorderSide(color: chipColor),
    );
  }

  Widget _buildInfoColumn(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Colors.grey[600],
              ),
        ),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: Colors.grey[800]),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}