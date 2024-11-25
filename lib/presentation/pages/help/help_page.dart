import 'package:flutter/material.dart';
import 'package:neetiflow/presentation/widgets/page_wrapper.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PageWrapper(
      title: 'Help',
      child: Center(
        child: Text('Help Page - Coming Soon'),
      ),
    );
  }
}
