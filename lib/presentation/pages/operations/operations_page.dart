import 'package:flutter/material.dart';
import 'package:neetiflow/presentation/widgets/persistent_shell.dart';

class OperationsPage extends StatelessWidget {
  const OperationsPage({super.key});

  void _showOperationDialog(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Operation creation coming soon')),
    );
  }

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isCompact = screenWidth < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Operations'),
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
            icon: const Icon(Icons.add),
            onPressed: () => _showOperationDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                Text(
                  'Operations Management',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Expanded(
            child: Center(
              child: Text('Operations Management Coming Soon'),
            ),
          ),
        ],
      ),
    );
  }
}
