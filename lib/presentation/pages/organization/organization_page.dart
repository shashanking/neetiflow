import 'package:flutter/material.dart';
import 'package:neetiflow/presentation/widgets/persistent_shell.dart';

class OrganizationPage extends StatelessWidget {
  const OrganizationPage({super.key});

  void _showOrganizationEditDialog(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Organization editing coming soon')),
    );
  }

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isCompact = screenWidth < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Organization'),
        automaticallyImplyLeading: !isCompact,
        leading: isCompact
            ? IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  PersistentShell.of(context)?.toggleDrawer();
                },
              )
            : null,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showOrganizationEditDialog(context),
          ),
        ],
      ),
      body: const Center(
        child: Text('Organization Page - Coming Soon'),
      ),
    );
  }
}
