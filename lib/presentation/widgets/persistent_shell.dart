import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neetiflow/presentation/blocs/auth/auth_bloc.dart';
import 'package:neetiflow/presentation/pages/auth/login_page.dart';
import 'package:neetiflow/presentation/pages/home/home_page.dart';
import 'package:neetiflow/presentation/pages/leads/leads_page.dart';
import 'package:neetiflow/presentation/pages/settings/settings_page.dart';
import 'package:neetiflow/presentation/pages/help/help_page.dart';
import 'package:neetiflow/presentation/pages/employees/employees_page.dart';
import 'package:neetiflow/presentation/pages/organization/organization_page.dart';
import 'dart:math' as math;

class PersistentShell extends StatefulWidget {
  const PersistentShell({super.key});

  @override
  State<PersistentShell> createState() => _PersistentShellState();
}

class _PersistentShellState extends State<PersistentShell> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  int _selectedIndex = 0;

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
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              if (!isLargeScreen) {
                Navigator.pop(context);
              }
              setState(() {
                _selectedIndex = index;
              });
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
                onTap: () => setState(() => _selectedIndex = 5),
              ),
              ListTile(
                leading: const Icon(Icons.help_outline),
                title: const Text('Help'),
                onTap: () => setState(() => _selectedIndex = 6),
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

    Widget getPage() {
      switch (_selectedIndex) {
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
    }

    final content = AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          )),
          child: child,
        );
      },
      child: KeyedSubtree(
        key: ValueKey<int>(_selectedIndex),
        child: getPage(),
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
                  child: content,
                ),
              ],
            )
          : content,
    );
  }
}
