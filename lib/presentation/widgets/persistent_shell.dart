import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neetiflow/presentation/blocs/auth/auth_bloc.dart';
import 'package:neetiflow/presentation/pages/clients/clients_page.dart';
import 'package:neetiflow/presentation/pages/employees/employees_page.dart';
import 'package:neetiflow/presentation/pages/finances/finances_page.dart';
import 'package:neetiflow/presentation/pages/help/help_page.dart';
import 'package:neetiflow/presentation/pages/home/home_page.dart';
import 'package:neetiflow/presentation/pages/leads/leads_page.dart';
import 'package:neetiflow/presentation/pages/operations/operations_page.dart';
import 'package:neetiflow/presentation/pages/organization/organization_page.dart';
import 'package:neetiflow/presentation/pages/settings/settings_page.dart';

import '../../domain/entities/employee.dart';
import '../../domain/repositories/employees_repository.dart';

/// Represents a single navigation item in the drawer
class NavigationItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final int index;
  final Widget? page;

  const NavigationItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.index,
    this.page,
  });
}

/// Enhanced Navigation Drawer Configuration
class NavigationDrawerConfig {
  static List<NavigationItem> mainNavigationItems = [
    const NavigationItem(
      icon: Icons.dashboard_outlined,
      selectedIcon: Icons.dashboard,
      label: 'Dashboard',
      index: 0,
      page: HomePage(),
    ),
    const NavigationItem(
      icon: Icons.contacts_outlined,
      selectedIcon: Icons.contacts,
      label: 'Leads',
      index: 1,
      page: LeadsPage(),
    ),
    const NavigationItem(
      icon: Icons.people_outline,
      selectedIcon: Icons.people,
      label: 'Clients',
      index: 2,
      page: ClientsPage(),
    ),
    const NavigationItem(
      icon: Icons.business_center_outlined,
      selectedIcon: Icons.business_center,
      label: 'Operations',
      index: 3,
      page: OperationsPage(),
    ),
    const NavigationItem(
      icon: Icons.attach_money_outlined,
      selectedIcon: Icons.attach_money,
      label: 'Finances',
      index: 4,
      page: FinancesPage(),
    ),
    const NavigationItem(
      icon: Icons.group_outlined,
      selectedIcon: Icons.group,
      label: 'Employees',
      index: 5,
      page: EmployeesPage(),
    ),
    const NavigationItem(
      icon: Icons.corporate_fare_outlined,
      selectedIcon: Icons.corporate_fare,
      label: 'Organization',
      index: 6,
      page: OrganizationPage(),
    ),
  ];

  static List<NavigationItem> preferenceItems = [
    const NavigationItem(
      icon: Icons.settings_outlined,
      selectedIcon: Icons.settings,
      label: 'Settings',
      index: 7,
      page: SettingsPage(),
    ),
    const NavigationItem(
      icon: Icons.help_outline,
      selectedIcon: Icons.help,
      label: 'Help',
      index: 8,
      page: HelpPage(),
    ),
  ];
}

/// Custom Drawer Header
class _NeetiFlowDrawerHeader extends StatelessWidget {
  final ThemeData theme;

  const _NeetiFlowDrawerHeader({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      color: theme.colorScheme.surface,
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
    );
  }
}

/// Custom Navigation Item for Drawer
class _NeetiFlowNavigationItem extends StatelessWidget {
  final NavigationItem item;
  final bool isSelected;
  final VoidCallback onTap;
  final ThemeData theme;

  const _NeetiFlowNavigationItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Icon(
        isSelected ? item.selectedIcon : item.icon,
        color: isSelected 
          ? theme.colorScheme.primary 
          : theme.colorScheme.onSurfaceVariant,
      ),
      title: Text(
        item.label,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: isSelected 
            ? theme.colorScheme.primary 
            : theme.colorScheme.onSurfaceVariant,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

/// User Profile Section for Drawer
class _NeetiFlowUserProfile extends StatelessWidget {
  final ThemeData theme;

  const _NeetiFlowUserProfile({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        ),
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is! Authenticated) {
              return const SizedBox.shrink();
            }

            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: theme.colorScheme.surface,
                    child: Text(
                      state.employee.firstName.isNotEmpty
                          ? state.employee.firstName[0].toUpperCase()
                          : 'U',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${state.employee.firstName} ${state.employee.lastName}',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: state.employee.isOnline
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.outline,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              state.employee.isOnline ? 'Online' : 'Offline',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      state.employee.isOnline
                          ? Icons.toggle_on_outlined
                          : Icons.toggle_off_outlined,
                      color: state.employee.isOnline
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outline,
                      size: 28,
                    ),
                    onPressed: () {
                      context.read<AuthBloc>().add(
                            UpdateEmployeeOnlineStatus(
                              employee: state.employee,
                              isOnline: !state.employee.isOnline,
                            ),
                          );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () {
                      context.read<AuthBloc>().add(SignOutRequested());
                    },
                    tooltip: 'Sign Out',
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class PersistentShell extends StatefulWidget {
  final int initialIndex;

  const PersistentShell({
    super.key,
    this.initialIndex = 0,
  });

  static PersistentShellState? of(BuildContext context) {
    return context.findAncestorStateOfType<PersistentShellState>();
  }

  @override
  State<PersistentShell> createState() => PersistentShellState();
}

class PersistentShellState extends State<PersistentShell> {
  late int _selectedIndex;
  StreamSubscription<Employee>? _employeeSubscription;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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

  void toggleDrawer() {
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
      Navigator.of(context).pop();
    } else {
      _scaffoldKey.currentState?.openDrawer();
    }
  }

  List<NavigationDrawerDestination> buildNavigationItems(ThemeData theme) {
    return [
      ...NavigationDrawerConfig.mainNavigationItems.map((item) {
        return NavigationDrawerDestination(
          icon: Icon(item.icon),
          selectedIcon: Icon(item.selectedIcon, color: theme.colorScheme.primary),
          label: Text(
            item.label,
            style: TextStyle(
              color: _selectedIndex == item.index
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface,
            ),
          ),
        );
      }),
      ...NavigationDrawerConfig.preferenceItems.map((item) {
        return NavigationDrawerDestination(
          icon: Icon(item.icon),
          selectedIcon: Icon(item.selectedIcon, color: theme.colorScheme.primary),
          label: Text(
            item.label,
            style: TextStyle(
              color: _selectedIndex == item.index
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface,
            ),
          ),
        );
      }),
    ];
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  void dispose() {
    _employeeSubscription?.cancel();
    super.dispose();
  }

  void _subscribeToEmployeeUpdates(String companyId, String employeeId) {
    final employeesRepository = context.read<EmployeesRepository>();
    _employeeSubscription?.cancel();
    _employeeSubscription = employeesRepository
        .employeeStream(companyId, employeeId)
        .listen((employee) {
      if (mounted) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final isCompact = screenWidth < 600; // Mobile breakpoint

    final currentPage = _customPage ?? NavigationDrawerConfig.mainNavigationItems[_selectedIndex].page ?? const SizedBox();

    // Drawer content that will be used in both mobile and desktop layouts
    final drawerWidget = Drawer(
      backgroundColor: theme.colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drawer Header
          _NeetiFlowDrawerHeader(theme: theme),
          
          const Divider(),

          // Main Navigation Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ...NavigationDrawerConfig.mainNavigationItems.map((item) => 
                  _NeetiFlowNavigationItem(
                    item: item,
                    isSelected: _selectedIndex == item.index,
                    onTap: () {
                      setState(() {
                        _customPage = null;  // Clear the custom page
                        _selectedIndex = item.index;
                      });
                      // Only pop for mobile screens
                      if (isCompact && (_scaffoldKey.currentState?.isDrawerOpen ?? false)) {
                        Navigator.of(context).pop();
                      }
                    },
                    theme: theme,
                  )
                ),

                const Divider(),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'Preferences',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.primary.withOpacity(0.7),
                    ),
                  ),
                ),

                // Preference Items
                ...NavigationDrawerConfig.preferenceItems.map((item) => 
                  _NeetiFlowNavigationItem(
                    item: item,
                    isSelected: _selectedIndex == item.index,
                    onTap: () {
                      setState(() {
                        _customPage = null;  // Clear the custom page
                        _selectedIndex = item.index;
                      });
                      // Only pop for mobile screens
                      if (isCompact && (_scaffoldKey.currentState?.isDrawerOpen ?? false)) {
                        Navigator.of(context).pop();
                      }
                    },
                    theme: theme,
                  )
                ),
              ],
            ),
          ),

          // User Profile Section
          _NeetiFlowUserProfile(theme: theme),
        ],
      ),
    );

    // Animated page content
    final pageContent = AnimatedSwitcher(
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
        child: currentPage,
      ),
    );

    // Responsive layout
    return Scaffold(
      key: _scaffoldKey,
      // Drawer only for mobile
      drawer: isCompact ? drawerWidget : null,
      body: isCompact
          ? pageContent
          : Row(
              children: [
                // Permanent drawer for larger screens
                SizedBox(
                  width: 280,
                  child: drawerWidget,
                ),
                // Expanded content area
                Expanded(child: pageContent),
              ],
            ),
    );
  }

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;
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
              color: isSelected
                  ? theme.colorScheme.primary.withOpacity(0.1)
                  : Colors.transparent,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                children: [
                  Icon(
                    leading,
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface,
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

// ignore: unused_element
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
