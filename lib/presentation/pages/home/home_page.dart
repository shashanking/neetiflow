import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neetiflow/presentation/blocs/auth/auth_bloc.dart';
import 'package:neetiflow/presentation/pages/auth/login_page.dart';
import 'package:neetiflow/presentation/pages/leads/leads_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth >= 1200;

    final drawerContent = NavigationDrawer(
      selectedIndex: 0,
      onDestinationSelected: (index) {
        switch (index) {
          case 0: // Dashboard
            if (!isLargeScreen) {
              Navigator.pop(context);
            }
            break;
          case 1: // Employees
            if (!isLargeScreen) {
              Navigator.pop(context);
            }
            // TODO: Navigate to employees page
            break;
          case 2: // Organization
            if (!isLargeScreen) {
              Navigator.pop(context);
            }
            // TODO: Navigate to organization page
            break;
          case 3: // Leads
            if (!isLargeScreen) {
              Navigator.pop(context);
            }
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const LeadsPage()),
            );
            break;
          case 4: // Settings
            if (!isLargeScreen) {
              Navigator.pop(context);
            }
            // TODO: Navigate to settings page
            break;
          case 5: // Help
            if (!isLargeScreen) {
              Navigator.pop(context);
            }
            // TODO: Navigate to help page
            break;
        }
      },
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
          child: Text(
            'Menu',
            style: theme.textTheme.titleSmall,
          ),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.dashboard),
          label: Text('Dashboard'),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.people),
          label: Text('Employees'),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.business),
          label: Text('Organization'),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.contacts),
          label: Text('Leads'),
        ),
        const Divider(indent: 28, endIndent: 28),
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
          child: Text(
            'Preferences',
            style: theme.textTheme.titleSmall,
          ),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.settings),
          label: Text('Settings'),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.help),
          label: Text('Help'),
        ),
        const Spacer(),
        BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is Authenticated) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: theme.colorScheme.primary,
                      child: Text(
                        state.employee.name[0].toUpperCase(),
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            state.employee.name,
                            style: theme.textTheme.titleSmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'ID: ${state.employee.id?.substring(0, 8) ?? 'N/A'}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.primary,
                                fontFamily: 'monospace',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.logout),
                      onPressed: () {
                        context.read<AuthBloc>().add(SignOutRequested());
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => const LoginPage()),
                        );
                      },
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );

    final mainContent = SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is Authenticated) {
                  return Text(
                    '${state.employee.companyName} Dashboard',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }
                return Text(
                  'Dashboard',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            GridView.count(
              crossAxisCount: isLargeScreen ? 4 : 2,
              shrinkWrap: true,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _DashboardCard(
                  icon: Icons.people,
                  title: 'Employees',
                  subtitle: 'Manage your team',
                  onTap: () {
                    // TODO: Navigate to employees page
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
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const LeadsPage()),
                    );
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

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: isLargeScreen
          ? null
          : AppBar(
              title: const Text('NeetiFlow'),
              centerTitle: true,
            ),
      drawer: isLargeScreen ? null : drawerContent,
      body: isLargeScreen
          ? Row(
              children: [
                SizedBox(
                  width: 280,
                  child: drawerContent,
                ),
                Expanded(child: mainContent),
              ],
            )
          : mainContent,
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
