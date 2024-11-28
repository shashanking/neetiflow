import 'package:flutter/material.dart';
import 'package:neetiflow/presentation/widgets/persistent_shell.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isCompact = screenWidth < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
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
            icon: const Icon(Icons.contact_support),
            onPressed: () => _showContactSupport(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Help Center',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Welcome to NeetiFlow Help Center. Here you can find guides, tutorials, and answers to frequently asked questions.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 32),
            _buildHelpSection(
              theme,
              title: 'Quick Start Guide',
              icon: Icons.rocket_launch,
              items: [
                'Getting Started with NeetiFlow',
                'Setting Up Your Organization',
                'Managing Employees',
                'Working with Leads',
                'Understanding Reports',
              ],
            ),
            const SizedBox(height: 24),
            _buildHelpSection(
              theme,
              title: 'Frequently Asked Questions',
              icon: Icons.help_outline,
              items: [
                'How to reset my password?',
                'How to add a new employee?',
                'How to manage departments?',
                'How to track leads?',
                'How to generate reports?',
              ],
            ),
            const SizedBox(height: 24),
            _buildHelpSection(
              theme,
              title: 'Contact Support',
              icon: Icons.support_agent,
              items: [
                'Email Support',
                'Live Chat',
                'Documentation',
                'Video Tutorials',
                'Submit a Bug Report',
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showContactSupport(BuildContext context) {
    // TODO: Implement contact support functionality
  }

  Widget _buildHelpSection(
    ThemeData theme, {
    required String title,
    required IconData icon,
    required List<String> items,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 24,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: theme.textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...items.map((item) => _buildHelpItem(theme, item)),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpItem(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () {
          // TODO: Implement help item navigation
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.bodyLarge,
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
