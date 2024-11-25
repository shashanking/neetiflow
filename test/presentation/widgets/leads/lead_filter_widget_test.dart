import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neetiflow/domain/entities/lead.dart';
import 'package:neetiflow/domain/entities/lead_filter.dart';
import 'package:neetiflow/presentation/widgets/leads/lead_filter_widget.dart';

void main() {
  group('LeadFilterWidget', () {
    late LeadFilter currentFilter;
    late List<String> availableSegments;
    late Function(LeadFilter) onFilterChanged;

    setUp(() {
      currentFilter = const LeadFilter();
      availableSegments = ['VIP', 'New', 'Regular'];
      onFilterChanged = (_) {};
    });

    testWidgets('shows filter button with no indicator when no filters active',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LeadFilterWidget(
              currentFilter: currentFilter,
              onFilterChanged: onFilterChanged,
              availableSegments: availableSegments,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.filter_list), findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (widget) => widget is Container && widget.constraints != null,
          description: 'Active filter indicator',
        ),
        findsNothing,
      );
    });

    testWidgets('shows filter button with indicator when filters are active',
        (tester) async {
      currentFilter = const LeadFilter(
        status: LeadStatus.hot,
        segments: ['VIP'],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LeadFilterWidget(
              currentFilter: currentFilter,
              onFilterChanged: onFilterChanged,
              availableSegments: availableSegments,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.filter_list), findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (widget) => widget is Container && widget.constraints != null,
          description: 'Active filter indicator',
        ),
        findsOneWidget,
      );
    });

    testWidgets('opens filter dialog when button is tapped', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LeadFilterWidget(
              currentFilter: currentFilter,
              onFilterChanged: onFilterChanged,
              availableSegments: availableSegments,
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.filter_list));
      await tester.pumpAndSettle();

      expect(find.text('Filter Leads'), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('search field updates filter', (tester) async {
      LeadFilter? updatedFilter;
      onFilterChanged = (filter) => updatedFilter = filter;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LeadFilterWidget(
              currentFilter: currentFilter,
              onFilterChanged: onFilterChanged,
              availableSegments: availableSegments,
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.filter_list));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'John');
      await tester.pump();

      expect(updatedFilter?.searchQuery, 'John');
    });

    testWidgets('status dropdown updates filter', (tester) async {
      LeadFilter? updatedFilter;
      onFilterChanged = (filter) => updatedFilter = filter;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LeadFilterWidget(
              currentFilter: currentFilter,
              onFilterChanged: onFilterChanged,
              availableSegments: availableSegments,
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.filter_list));
      await tester.pumpAndSettle();

      final dropdownFinder = find.byType(DropdownButtonFormField<LeadStatus>);
      expect(dropdownFinder, findsOneWidget);
      
      await tester.tap(dropdownFinder);
      await tester.pumpAndSettle();

      final hotOption = find.descendant(
        of: find.byType(DropdownButtonFormField<LeadStatus>),
        matching: find.text('Hot'),
      ).last;
      expect(hotOption, findsOneWidget);
      
      await tester.tap(hotOption);
      await tester.pumpAndSettle();

      expect(updatedFilter?.status, LeadStatus.hot);
    });

    testWidgets('process status dropdown updates filter', (tester) async {
      LeadFilter? updatedFilter;
      onFilterChanged = (filter) => updatedFilter = filter;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LeadFilterWidget(
              currentFilter: currentFilter,
              onFilterChanged: onFilterChanged,
              availableSegments: availableSegments,
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.filter_list));
      await tester.pumpAndSettle();

      final dropdownFinder = find.byType(DropdownButtonFormField<ProcessStatus>);
      expect(dropdownFinder, findsOneWidget);
      
      await tester.tap(dropdownFinder);
      await tester.pumpAndSettle();

      final inProgressOption = find.descendant(
        of: find.byType(DropdownMenu<ProcessStatus>),
        matching: find.text('In Progress'),
      );
      expect(inProgressOption, findsOneWidget);
      
      await tester.tap(inProgressOption);
      await tester.pumpAndSettle();

      expect(updatedFilter?.processStatus, ProcessStatus.inProgress);
    });

    testWidgets('segment chips update filter', (tester) async {
      LeadFilter? updatedFilter;
      onFilterChanged = (filter) => updatedFilter = filter;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LeadFilterWidget(
              currentFilter: currentFilter,
              onFilterChanged: onFilterChanged,
              availableSegments: availableSegments,
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.filter_list));
      await tester.pumpAndSettle();

      await tester.tap(find.text('VIP'));
      await tester.pump();

      expect(updatedFilter?.segments, ['VIP']);
    });

    testWidgets('date range picker updates filter', (tester) async {
      LeadFilter? updatedFilter;
      onFilterChanged = (filter) => updatedFilter = filter;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LeadFilterWidget(
              currentFilter: currentFilter,
              onFilterChanged: onFilterChanged,
              availableSegments: availableSegments,
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.filter_list));
      await tester.pumpAndSettle();

      // Find and tap first date picker button
      final dateButtons = find.byIcon(Icons.calendar_today);
      expect(dateButtons, findsNWidgets(2));
      await tester.tap(dateButtons.first);
      await tester.pumpAndSettle();

      // Tap start date
      await tester.tap(find.text('15').first);
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Find and tap second date picker button
      await tester.tap(dateButtons.last);
      await tester.pumpAndSettle();

      // Tap end date
      await tester.tap(find.text('20').first);
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(updatedFilter?.startDate?.day, 15);
      expect(updatedFilter?.endDate?.day, 20);
    });

    testWidgets('clear all button resets filter', (tester) async {
      currentFilter = const LeadFilter(
        status: LeadStatus.hot,
        segments: ['VIP'],
        searchQuery: 'John',
      );

      LeadFilter? updatedFilter;
      onFilterChanged = (filter) => updatedFilter = filter;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LeadFilterWidget(
              currentFilter: currentFilter,
              onFilterChanged: onFilterChanged,
              availableSegments: availableSegments,
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.filter_list));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Clear All'));
      await tester.pump();

      expect(updatedFilter?.status, isNull);
      expect(updatedFilter?.segments, isNull);
      expect(updatedFilter?.searchQuery, isNull);
    });
  });
}
