import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neetiflow/presentation/widgets/persistent_shell.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  PackageInfo? _packageInfo;

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to clipboard')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final isCompact = screenWidth < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('About NeetiFlow'),
        automaticallyImplyLeading: !isCompact,
        leading: isCompact
            ? IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  PersistentShell.of(context)?.toggleDrawer();
                },
              )
            : null,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // App Logo and Name
              Hero(
                tag: 'app_logo',
                child: Material(
                  color: Colors.transparent,
                  child: CircleAvatar(
                    radius: 80,
                    backgroundColor: colorScheme.primaryContainer,
                    child: Image.asset(
                      'assets/images/six-sigma.png', 
                      width: 120, 
                      height: 120,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'NeetiFlow',
                style: theme.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
              Text(
                'Designed by Humans and AI',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: colorScheme.secondary,
                ),
              ),
              const SizedBox(height: 32),

              // App Information Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow(
                        context, 
                        icon: Icons.info_outline,
                        label: 'Version', 
                        value: _packageInfo?.version ?? 'Loading...',
                        onTap: () => _copyToClipboard(_packageInfo?.version ?? ''),
                      ),
                      const Divider(),
                      _buildInfoRow(
                        context, 
                        icon: Icons.build_outlined,
                        label: 'Build Number', 
                        value: _packageInfo?.buildNumber ?? 'Loading...',
                        onTap: () => _copyToClipboard(_packageInfo?.buildNumber ?? ''),
                      ),
                      const Divider(),
                      _buildInfoRow(
                        context, 
                        icon: Icons.code_outlined,
                        label: 'Package Name', 
                        value: _packageInfo?.packageName ?? 'Loading...',
                        onTap: () => _copyToClipboard(_packageInfo?.packageName ?? ''),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Social and Support Links
              Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: [
                  _buildSocialButton(
                    context,
                    icon: Icons.web,
                    label: 'Website',
                    onPressed: () => _launchURL('https://neetiflow.com'),
                  ),
                  _buildSocialButton(
                    context,
                    icon: Icons.email_outlined,
                    label: 'Support',
                    onPressed: () => _launchURL('mailto:support@neetiflow.com'),
                  ),
                  _buildSocialButton(
                    context,
                    icon: Icons.privacy_tip_outlined,
                    label: 'Privacy Policy',
                    onPressed: () => _launchURL('https://neetiflow.com/privacy'),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // AI Collaboration Note
              Text(
                'Crafted with ❤️ by Humans\nPowered by Artificial Intelligence',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 32),
              _buildFooter(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListTile(
      leading: Icon(icon, color: colorScheme.secondary),
      title: Text(
        label,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: Text(
        value,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface,
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildSocialButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ElevatedButton.icon(
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        foregroundColor: colorScheme.onPrimary,
        backgroundColor: colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: onPressed,
    );
  }

  Widget _buildFooter(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            ' ${DateTime.now().year} NeetiFlow',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Designed with passion by Humans & AI',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant.withOpacity(0.8),
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildFooterLink(
                context, 
                text: 'Privacy Policy', 
                onTap: () => _launchURL('https://neetiflow.com/privacy'),
              ),
              const SizedBox(width: 16),
              _buildFooterLink(
                context, 
                text: 'Terms of Service', 
                onTap: () => _launchURL('https://neetiflow.com/terms'),
              ),
              const SizedBox(width: 16),
              _buildFooterLink(
                context, 
                text: 'Contact', 
                onTap: () => _launchURL('mailto:support@neetiflow.com'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooterLink(
    BuildContext context, {
    required String text,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: theme.textTheme.bodySmall?.copyWith(
          color: colorScheme.primary,
          decoration: TextDecoration.underline,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
