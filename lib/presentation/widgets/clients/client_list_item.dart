import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:neetiflow/domain/entities/client.dart';
import 'package:neetiflow/presentation/pages/clients/client_details_page.dart';

class ClientListItem extends StatelessWidget {
  final Client client;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final ValueChanged<ClientStatus> onStatusChange;
  final VoidCallback? onTap;

  const ClientListItem({
    super.key,
    required this.client,
    required this.onEdit,
    required this.onDelete,
    required this.onStatusChange,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAvatar(context),
                  const SizedBox(width: 16),
                  Expanded(
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
                                    client.fullName,
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  if (client.organizationName != null && 
                                      client.organizationName!.isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      client.organizationName!,
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            _buildStatusChip(context),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 16,
                          runSpacing: 8,
                          children: [
                            _buildInfoChip(
                              context,
                              Icons.business,
                              client.type.toString().split('.').last.toUpperCase(),
                            ),
                            _buildInfoChip(
                              context,
                              Icons.domain,
                              client.domain.toString().split('.').last.toUpperCase(),
                            ),
                            if (client.projects.isNotEmpty)
                              _buildInfoChip(
                                context,
                                Icons.folder,
                                '${client.projects.length} Projects',
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 16,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              client.rating.toStringAsFixed(1),
                              style: theme.textTheme.bodyMedium,
                            ),
                            const SizedBox(width: 16),
                            Icon(
                              Icons.calendar_today,
                              size: 16,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Joined ${DateFormat('MMM d, y').format(client.joiningDate)}',
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        if (client.lastInteractionDate != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Last interaction: ${DateFormat('MMM d, y').format(client.lastInteractionDate!)}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '₹${NumberFormat('#,##,###').format(client.lifetimeValue)}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      Text(
                        'Lifetime Value',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    return CircleAvatar(
      radius: 24,
      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      child: Text(
        client.fullName.substring(0, 1).toUpperCase(),
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context) {
    final statusColors = {
      ClientStatus.active: Colors.green,
      ClientStatus.inactive: Colors.grey,
      ClientStatus.suspended: Colors.red,
    };

    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Change Status'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: ClientStatus.values.map((status) {
                return ListTile(
                  title: Text(status.toString().split('.').last.toUpperCase()),
                  leading: CircleAvatar(
                    radius: 4,
                    backgroundColor: statusColors[status],
                  ),
                  onTap: () {
                    onStatusChange(status);
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
      child: Container(
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
              radius: 3,
              backgroundColor: statusColors[client.status],
            ),
            const SizedBox(width: 6),
            Text(
              client.status.toString().split('.').last.toUpperCase(),
              style: TextStyle(
                color: statusColors[client.status],
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}