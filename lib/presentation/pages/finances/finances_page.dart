import 'package:flutter/material.dart';
import 'package:neetiflow/presentation/widgets/persistent_shell.dart';

class FinancesPage extends StatelessWidget {
  const FinancesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isCompact = screenWidth < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Finances'),
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
            onPressed: () => _showFinanceEntryDialog(context),
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
                  'Financial Management',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Expanded(
            child: Center(
              child: Text('Financial Management Coming Soon'),
            ),
          ),
        ],
      ),
    );
  }

  void _showFinanceEntryDialog(BuildContext context) {
    // TODO: implement finance entry dialog
  }
}
