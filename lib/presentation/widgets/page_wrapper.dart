import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neetiflow/presentation/blocs/auth/auth_bloc.dart';
import 'package:neetiflow/presentation/pages/auth/login_page.dart';
import 'package:neetiflow/presentation/pages/leads/leads_page.dart';
import 'package:neetiflow/presentation/pages/home/home_page.dart';
import 'package:neetiflow/presentation/pages/settings/settings_page.dart';
import 'package:neetiflow/presentation/pages/help/help_page.dart';
import 'package:neetiflow/presentation/pages/employees/employees_page.dart';
import 'package:neetiflow/presentation/pages/organization/organization_page.dart';

class PageWrapper extends StatelessWidget {
  final Widget child;
  final String title;
  final bool showBackButton;
  final List<Widget>? actions;

  const PageWrapper({
    super.key,
    required this.child,
    required this.title,
    this.showBackButton = true,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth >= 1200;

    final drawerContent = Column(
      children: [
        // Navigation Items
        Expanded(
          child: NavigationDrawer(
            selectedIndex: _getSelectedIndex(title),
            onDestinationSelected: (index) {
              if (!isLargeScreen) {
                Navigator.pop(context);
              }
              _handleNavigation(context, index);
            },
            children: const [
              NavigationDrawerDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard),
                label: Text('Dashboard'),
              ),
              NavigationDrawerDestination(
                icon: Icon(Icons.people_outline),
                selectedIcon: Icon(Icons.people),
                label: Text('Employees'),
              ),
              NavigationDrawerDestination(
                icon: Icon(Icons.business_outlined),
                selectedIcon: Icon(Icons.business),
                label: Text('Organization'),
              ),
              NavigationDrawerDestination(
                icon: Icon(Icons.contacts_outlined),
                selectedIcon: Icon(Icons.contacts),
                label: Text('Leads'),
              ),
            ],
          ),
        ),

        // Preferences Section
        Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: theme.colorScheme.primary.withOpacity(0.1),
                width: 1,
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 16, 28, 10),
                child: Text(
                  'PREFERENCES',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.settings_outlined),
                title: const Text('Settings'),
                onTap: () => _handleNavigation(context, 5),
              ),
              ListTile(
                leading: const Icon(Icons.help_outline),
                title: const Text('Help'),
                onTap: () => _handleNavigation(context, 6),
              ),
            ],
          ),
        ),

        // User Profile Section
        Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: theme.colorScheme.primary.withOpacity(0.1),
                width: 1,
              ),
            ),
          ),
          child: BlocBuilder<AuthBloc, AuthState>(
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
                          state.employee.name.isNotEmpty
                              ? state.employee.name[0].toUpperCase()
                              : 'U',
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
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
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
                                state.employee.id != null
                                    ? 'ID: ${state.employee.id!.substring(0, math.min(8, state.employee.id!.length))}'
                                    : 'Guest User',
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
                      IconButton.filledTonal(
                        icon: const Icon(Icons.logout, size: 20),
                        tooltip: 'Logout',
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Logout'),
                              content: const Text('Are you sure you want to logout?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                                FilledButton(
                                  onPressed: () {
                                    context.read<AuthBloc>().add(SignOutRequested());
                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                        builder: (_) => const LoginPage(),
                                      ),
                                      (route) => false,
                                    );
                                  },
                                  child: const Text('Logout'),
                                ),
                              ],
                            ),
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
              actions: actions,
            ),
          Expanded(child: child),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      drawer: isLargeScreen ? null : Container(
        width: 280,
        color: theme.colorScheme.primary.withOpacity(0.05),
        child: drawerContent,
      ),
      body: isLargeScreen
          ? Row(
              children: [
                Container(
                  width: 280,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.05),
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
        return 5;
      case 'help':
        return 6;
      default:
        return 0;
    }
  }

  void _handleNavigation(BuildContext context, int index) {
    final route = MaterialPageRoute(
      builder: (context) {
        switch (index) {
          case 0:
            return const HomePage();
          case 1:
            return const EmployeesPage();
          case 2:
            return const OrganizationPage();
          case 3:
            return const LeadsPage();
          case 5:
            return const SettingsPage();
          case 6:
            return const HelpPage();
          default:
            return const HomePage();
        }
      },
    );

    Navigator.of(context).pushReplacement(route);
  }
}
