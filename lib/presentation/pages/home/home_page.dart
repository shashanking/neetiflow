import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neetiflow/presentation/blocs/auth/auth_bloc.dart';
import 'package:neetiflow/presentation/widgets/persistent_shell.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isCompact = screenWidth < 600; // Mobile breakpoint
    final isLargeScreen = screenWidth >= 1200;

    // If it's a large screen, return the content without an AppBar
    if (!isCompact) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dashboard',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            GridView.count(
              crossAxisCount: isLargeScreen ? 4 : 2,
              shrinkWrap: true,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _DashboardCard(
                  icon: Icons.people,
                  title: 'Employees',
                  subtitle: 'Manage your team',
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => const PersistentShell(
                          initialIndex: 5,
                        ),
                      ),
                    );
                  },
                ),
                _DashboardCard(
                  icon: Icons.business,
                  title: 'Organization',
                  subtitle: 'Company details',
                  onTap: () {
                    // TODO: Navigate to organization page
                  },
                ),
                _DashboardCard(
                  icon: Icons.contacts,
                  title: 'Leads',
                  subtitle: 'Manage leads',
                  onTap: () {
                    // TODO: Update navigation once navigation service is implemented
                  },
                ),
                _DashboardCard(
                  icon: Icons.analytics,
                  title: 'Analytics',
                  subtitle: 'View insights',
                  onTap: () {
                    // TODO: Navigate to analytics page
                  },
                ),
              ],
            ),
          ],
        ),
      );
    }

    // Mobile/Compact view with AppBar
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            final persistentShell = PersistentShell.of(context);
            persistentShell?.toggleDrawer();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _DashboardCard(
                  icon: Icons.people,
                  title: 'Employees',
                  subtitle: 'Manage your team',
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => const PersistentShell(
                          initialIndex: 5,
                        ),
                      ),
                    );
                  },
                ),
                _DashboardCard(
                  icon: Icons.business,
                  title: 'Organization',
                  subtitle: 'Company details',
                  onTap: () {
                    // TODO: Navigate to organization page
                  },
                ),
                _DashboardCard(
                  icon: Icons.contacts,
                  title: 'Leads',
                  subtitle: 'Manage leads',
                  onTap: () {
                    // TODO: Update navigation once navigation service is implemented
                  },
                ),
                _DashboardCard(
                  icon: Icons.analytics,
                  title: 'Analytics',
                  subtitle: 'View insights',
                  onTap: () {
                    // TODO: Navigate to analytics page
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
