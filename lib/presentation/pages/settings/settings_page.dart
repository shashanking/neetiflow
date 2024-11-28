import 'package:flutter/material.dart';
import 'package:neetiflow/presentation/widgets/persistent_shell.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  void _resetToDefaults(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reset to defaults coming soon')),
    );
  }

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isCompact = screenWidth < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
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
            icon: const Icon(Icons.restore),
            onPressed: () => _resetToDefaults(context),
          ),
        ],
      ),
      body: const Center(
        child: Text('Settings Page - Coming Soon'),
      ),
    );
  }
}
