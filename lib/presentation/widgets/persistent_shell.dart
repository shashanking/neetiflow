import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neetiflow/presentation/blocs/auth/auth_bloc.dart';
import 'package:neetiflow/presentation/pages/auth/login_page.dart';
import 'package:neetiflow/presentation/pages/leads/leads_page.dart';
import 'package:neetiflow/presentation/pages/clients/clients_page.dart';
import 'package:neetiflow/presentation/pages/operations/operations_page.dart';
import 'package:neetiflow/presentation/pages/finances/finances_page.dart';
import 'package:neetiflow/presentation/pages/employees/employees_page.dart';
import 'package:neetiflow/presentation/pages/organization/organization_page.dart';
import 'package:neetiflow/presentation/pages/settings/settings_page.dart';
import 'package:neetiflow/presentation/pages/help/help_page.dart';
import 'dart:math' as math;

class PersistentShell extends StatefulWidget {
  const PersistentShell({super.key});

  static PersistentShellState? of(BuildContext context) {
    return context.findAncestorStateOfType<PersistentShellState>();
  }

  @override
  State<PersistentShell> createState() => PersistentShellState();
}

class PersistentShellState extends State<PersistentShell> {
  int _selectedIndex = 0;
  Widget? _customPage;

  void setCustomPage(Widget page) {
    setState(() {
      _customPage = page;
    });
  }

  void clearCustomPage() {
    setState(() {
      _customPage = null;
    });
  }

  List<NavigationDrawerDestination> buildNavigationItems(ThemeData theme) {
    return [
      NavigationDrawerDestination(
        icon: const Icon(Icons.contacts_outlined),
        selectedIcon: Icon(Icons.contacts, color: theme.colorScheme.primary),
        label: Text(
          'Leads',
          style: TextStyle(
            color: _selectedIndex == 0 ? theme.colorScheme.primary : theme.colorScheme.onSurface,
          ),
        ),
      ),
      NavigationDrawerDestination(
        icon: const Icon(Icons.business_center_outlined),
        selectedIcon: Icon(Icons.business_center, color: theme.colorScheme.primary),
        label: Text(
          'Clients',
          style: TextStyle(
            color: _selectedIndex == 1 ? theme.colorScheme.primary : theme.colorScheme.onSurface,
          ),
        ),
      ),
      NavigationDrawerDestination(
        icon: const Icon(Icons.engineering_outlined),
        selectedIcon: Icon(Icons.engineering, color: theme.colorScheme.primary),
        label: Text(
          'Operations',
          style: TextStyle(
            color: _selectedIndex == 2 ? theme.colorScheme.primary : theme.colorScheme.onSurface,
          ),
        ),
      ),
      NavigationDrawerDestination(
        icon: const Icon(Icons.account_balance_wallet_outlined),
        selectedIcon: Icon(Icons.account_balance_wallet, color: theme.colorScheme.primary),
        label: Text(
          'Finances',
          style: TextStyle(
            color: _selectedIndex == 3 ? theme.colorScheme.primary : theme.colorScheme.onSurface,
          ),
        ),
      ),
      NavigationDrawerDestination(
        icon: const Icon(Icons.people_outline),
        selectedIcon: Icon(Icons.people, color: theme.colorScheme.primary),
        label: Text(
          'Employees',
          style: TextStyle(
            color: _selectedIndex == 4 ? theme.colorScheme.primary : theme.colorScheme.onSurface,
          ),
        ),
      ),
      NavigationDrawerDestination(
        icon: const Icon(Icons.business_outlined),
        selectedIcon: Icon(Icons.business, color: theme.colorScheme.primary),
        label: Text(
          'Organization',
          style: TextStyle(
            color: _selectedIndex == 5 ? theme.colorScheme.primary : theme.colorScheme.onSurface,
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth >= 1200;

    final drawerContent = Column(
      children: [
        // Navigation Items
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  theme.colorScheme.primary.withOpacity(0.05),
                  theme.colorScheme.primary.withOpacity(0.02),
                ],
              ),
            ),
            child: NavigationDrawer(
              selectedIndex: _selectedIndex,
              elevation: 0,
              backgroundColor: Colors.transparent,
              indicatorColor: theme.colorScheme.primary.withOpacity(0.1),
              onDestinationSelected: (index) {
                if (!isLargeScreen) {
                  Navigator.pop(context);
                }
                setState(() {
                  _selectedIndex = index;
                  _customPage = null;
                });
              },
              children: [
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.business,
                          color: theme.colorScheme.primary,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'NeetiFlow',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                ...buildNavigationItems(theme),
              ],
            ),
          ),
        ),

        // Preferences Section
        Container(
          margin: const EdgeInsets.only(top: 1),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
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
              _AnimatedListTile(
                leading: Icons.settings_outlined,
                title: 'Settings',
                isSelected: _selectedIndex == 6,
                onTap: () => setState(() => _selectedIndex = 6),
                theme: theme,
              ),
              _AnimatedListTile(
                leading: Icons.help_outline,
                title: 'Help',
                isSelected: _selectedIndex == 7,
                onTap: () => setState(() => _selectedIndex = 7),
                theme: theme,
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),

        // User Profile Section
        Container(
          margin: const EdgeInsets.only(top: 1),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
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
                      Hero(
                        tag: 'profile_avatar',
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                theme.colorScheme.primary,
                                theme.colorScheme.primary.withOpacity(0.8),
                              ],
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.transparent,
                            child: Text(
                              state.employee.name.isNotEmpty
                                  ? state.employee.name[0].toUpperCase()
                                  : 'U',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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
                                gradient: LinearGradient(
                                  colors: [
                                    theme.colorScheme.primary.withOpacity(0.1),
                                    theme.colorScheme.primary.withOpacity(0.05),
                                  ],
                                ),
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
                      _AnimatedIconButton(
                        icon: Icons.logout,
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
                        theme: theme,
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
      if (_customPage != null) {
        return _customPage!;
      }

      switch (_selectedIndex) {
        case 0:
          return const LeadsPage();
        case 1:
          return const ClientsPage();
        case 2:
          return const OperationsPage();
        case 3:
          return const FinancesPage();
        case 4:
          return const EmployeesPage();
        case 5:
          return const OrganizationPage();
        case 6:
          return const SettingsPage();
        case 7:
          return const HelpPage();
        default:
          return const LeadsPage();
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

class _AnimatedListTile extends StatelessWidget {
  final IconData leading;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  final ThemeData theme;

  const _AnimatedListTile({
    required this.leading,
    required this.title,
    required this.isSelected,
    required this.onTap,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: isSelected ? theme.colorScheme.primary.withOpacity(0.1) : Colors.transparent,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                children: [
                  Icon(
                    leading,
                    color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface,
                        fontWeight: isSelected ? FontWeight.w500 : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final ThemeData theme;

  const _AnimatedIconButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: theme.colorScheme.primary.withOpacity(0.1),
        ),
        child: IconButton(
          icon: Icon(icon, size: 20),
          tooltip: tooltip,
          onPressed: onPressed,
          style: IconButton.styleFrom(
            foregroundColor: theme.colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}
