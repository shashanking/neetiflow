import 'package:flutter/material.dart';

class PersistentShell extends StatelessWidget {
  final Widget body;
  final bool showDrawer;

  const PersistentShell({
    super.key, 
    required this.body,
    this.showDrawer = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      drawer: showDrawer ? _buildDrawer(context) : null,
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Text(
              'NeetiFlow',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: Colors.white,
                  ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Clients'),
            onTap: () {
              Navigator.of(context).pushNamed('/clients');
            },
          ),
          ListTile(
            leading: const Icon(Icons.work),
            title: const Text('Employees'),
            onTap: () {
              Navigator.of(context).pushNamed('/employees');
            },
          ),
          // Add more navigation items as needed
        ],
      ),
    );
  }
}
