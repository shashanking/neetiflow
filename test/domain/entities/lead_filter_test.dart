import 'package:flutter_test/flutter_test.dart';
import 'package:neetiflow/domain/entities/lead.dart';
import 'package:neetiflow/domain/entities/lead_filter.dart';

void main() {
  group('LeadFilter', () {
    final testLeads = [
      Lead(
        uid: '1',
        id: '1',
        firstName: 'John',
        lastName: 'Doe',
        email: 'john@example.com',
        phone: '1234567890',
        subject: 'Product Inquiry',
        message: 'Interested in your product',
        status: LeadStatus.hot,
        processStatus: ProcessStatus.fresh,
        segments: ['VIP', 'New'],
        createdAt: DateTime(2023, 1, 1),
      ),
      Lead(
        uid: '2',
        id: '2',
        firstName: 'Jane',
        lastName: 'Smith',
        email: 'jane@example.com',
        phone: '0987654321',
        subject: 'Service Request',
        message: 'Need assistance',
        status: LeadStatus.cold,
        processStatus: ProcessStatus.inProgress,
        segments: ['Regular'],
        createdAt: DateTime(2023, 2, 1),
      ),
    ];

    test('should filter by search query - name match', () {
      const filter = LeadFilter(searchQuery: 'John');
      final filtered = testLeads.where((lead) => filter.matches(lead)).toList();
      expect(filtered.length, 1);
      expect(filtered.first.firstName, 'John');
    });

    test('should filter by search query - email match', () {
      const filter = LeadFilter(searchQuery: 'jane@example');
      final filtered = testLeads.where((lead) => filter.matches(lead)).toList();
      expect(filtered.length, 1);
      expect(filtered.first.email, 'jane@example.com');
    });

    test('should filter by search query - phone match', () {
      const filter = LeadFilter(searchQuery: '123456');
      final filtered = testLeads.where((lead) => filter.matches(lead)).toList();
      expect(filtered.length, 1);
      expect(filtered.first.phone, '1234567890');
    });

    test('should filter by search query - subject match', () {
      const filter = LeadFilter(searchQuery: 'Product');
      final filtered = testLeads.where((lead) => filter.matches(lead)).toList();
      expect(filtered.length, 1);
      expect(filtered.first.subject, 'Product Inquiry');
    });

    test('should filter by search query - message match', () {
      const filter = LeadFilter(searchQuery: 'assistance');
      final filtered = testLeads.where((lead) => filter.matches(lead)).toList();
      expect(filtered.length, 1);
      expect(filtered.first.message, 'Need assistance');
    });

    test('should filter by lead status', () {
      const filter = LeadFilter(status: LeadStatus.hot);
      final filtered = testLeads.where((lead) => filter.matches(lead)).toList();
      expect(filtered.length, 1);
      expect(filtered.first.status, LeadStatus.hot);
    });

    test('should filter by process status', () {
      const filter = LeadFilter(processStatus: ProcessStatus.inProgress);
      final filtered = testLeads.where((lead) => filter.matches(lead)).toList();
      expect(filtered.length, 1);
      expect(filtered.first.processStatus, ProcessStatus.inProgress);
    });

    test('should filter by date range', () {
      final filter = LeadFilter(
        startDate: DateTime(2023, 1, 15),
        endDate: DateTime(2023, 2, 15),
      );
      final filtered = testLeads.where((lead) => filter.matches(lead)).toList();
      expect(filtered.length, 1);
      expect(filtered.first.firstName, 'Jane');
    });

    test('should filter by segments', () {
      const filter = LeadFilter(segments: ['VIP']);
      final filtered = testLeads.where((lead) => filter.matches(lead)).toList();
      expect(filtered.length, 1);
      expect(filtered.first.segments, contains('VIP'));
    });

    test('should combine multiple filters', () {
      final filter = LeadFilter(
        status: LeadStatus.hot,
        segments: ['VIP'],
        startDate: DateTime(2023, 1, 1),
        endDate: DateTime(2023, 1, 31),
      );
      final filtered = testLeads.where((lead) => filter.matches(lead)).toList();
      expect(filtered.length, 1);
      expect(filtered.first.firstName, 'John');
    });

    test('should return all leads when no filters are applied', () {
      const filter = LeadFilter();
      final filtered = testLeads.where((lead) => filter.matches(lead)).toList();
      expect(filtered.length, testLeads.length);
    });
  });
}
