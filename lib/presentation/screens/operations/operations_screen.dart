import 'package:flutter/material.dart';
import 'package:neetiflow/presentation/pages/operations/operations_page.dart';

class OperationsScreen extends StatefulWidget {
  const OperationsScreen({super.key});

  @override
  State<OperationsScreen> createState() => _OperationsScreenState();
}

class _OperationsScreenState extends State<OperationsScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: OperationsPage(),
      ),
    );
  }
}
