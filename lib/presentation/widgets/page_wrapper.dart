import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neetiflow/presentation/blocs/auth/auth_bloc.dart';
import 'package:neetiflow/presentation/pages/auth/login_page.dart';
import 'package:neetiflow/presentation/pages/leads/leads_page.dart';

import '../pages/home/home_page.dart';

class PageWrapper extends StatelessWidget {
  final Widget child;
  final String title;
  final bool showBackButton;

  const PageWrapper({
    super.key,
    required this.child,
    required this.title,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth >= 1200;

    final drawerContent = NavigationDrawer(
      selectedIndex: _getSelectedIndex(title),
      onDestinationSelected: (index) {
        if (!isLargeScreen) {
          Navigator.pop(context);
        }
        _handleNavigation(context, index);
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isLargeScreen || showBackButton)
            AppBar(
              title: Text(title),
              centerTitle: !showBackButton,
              automaticallyImplyLeading: showBackButton,
            ),
          Expanded(child: child),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      drawer: isLargeScreen ? null : drawerContent,
      body: isLargeScreen
          ? Row(
              children: [
                Container(
                  width: 280,
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: drawerContent,
                ),
                Expanded(
                  child: SizedBox(
                    height: double.infinity,
                    child: mainContent,
                  ),
                ),
              ],
            )
          : mainContent,
    );
  }

  int _getSelectedIndex(String title) {
    switch (title.toLowerCase()) {
      case 'dashboard':
        return 0;
      case 'employees':
        return 1;
      case 'organization':
        return 2;
      case 'leads':
        return 3;
      case 'settings':
        return 6;
      case 'help':
        return 7;
      default:
        return 0;
    }
  }

  void _handleNavigation(BuildContext context, int index) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) {
        switch (index) {
          case 0: // Dashboard
            return const HomePage();
          case 1: // Employees
            // TODO: Navigate to employees page
            return const SizedBox.shrink();
          case 2: // Organization
            // TODO: Navigate to organization page
            return const SizedBox.shrink();
          case 3: // Leads
            return const LeadsPage();
          case 6: // Settings
            // TODO: Navigate to settings page
            return const SizedBox.shrink();
          case 7: // Help
            // TODO: Navigate to help page
            return const SizedBox.shrink();
          default:
            return const SizedBox.shrink();
        }
      }),
    );
  }
}
