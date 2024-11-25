import 'package:flutter/material.dart';
import 'package:neetiflow/presentation/widgets/page_wrapper.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PageWrapper(
      title: 'Settings',
      child: Center(
        child: Text('Settings Page - Coming Soon'),
      ),
    );
  }
}
