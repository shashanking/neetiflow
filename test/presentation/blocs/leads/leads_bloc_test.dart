import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:neetiflow/domain/entities/lead.dart';
import 'package:neetiflow/domain/entities/lead_filter.dart';
import 'package:neetiflow/infrastructure/repositories/leads_repository.dart';
import 'package:neetiflow/presentation/blocs/leads/leads_bloc.dart';
import 'package:neetiflow/presentation/blocs/leads/leads_event.dart';
import 'package:neetiflow/presentation/blocs/leads/leads_state.dart';

class MockLeadsRepository extends Mock implements LeadsRepository {}

void main() {
  group('LeadsBloc', () {
    late LeadsBloc leadsBloc;
    late MockLeadsRepository mockLeadsRepository;

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

    setUp(() {
      mockLeadsRepository = MockLeadsRepository();
      leadsBloc = LeadsBloc(leadsRepository: mockLeadsRepository);
    });

    tearDown(() {
      leadsBloc.close();
    });

    test('initial state should be LeadsInitial', () {
      expect(leadsBloc.state, isA<LeadsInitial>());
    });

    blocTest<LeadsBloc, LeadsState>(
      'emits [LeadsLoading, LeadsLoaded] when LoadLeads is added',
      build: () {
        when(mockLeadsRepository.getLeads('company1'))
            .thenAnswer((_) async => List<Lead>.from(testLeads));
        return leadsBloc;
      },
      act: (bloc) => bloc.add(const LoadLeads(companyId: 'company1')),
      expect: () => [
        isA<LeadsLoading>(),
        isA<LeadsLoaded>().having(
          (state) => state.leads,
          'leads',
          equals(testLeads),
        ),
      ],
    );

    blocTest<LeadsBloc, LeadsState>(
      'emits filtered leads when ApplyLeadFilter is added',
      build: () {
        when(mockLeadsRepository.getLeads('company1'))
            .thenAnswer((_) async => List<Lead>.from(testLeads));
        return leadsBloc;
      },
      seed: () => LeadsLoaded(
        leads: List<Lead>.from(testLeads),
        filteredLeads: List<Lead>.from(testLeads),
      ),
      act: (bloc) => bloc.add(
        const ApplyLeadFilter(
          companyId: 'company1',
          filter: LeadFilter(status: LeadStatus.hot),
        ),
      ),
      expect: () => [
        isA<LeadsLoaded>().having(
          (state) => state.filteredLeads.length,
          'filtered leads count',
          1,
        ),
      ],
    );

    blocTest<LeadsBloc, LeadsState>(
      'emits all leads when filter is cleared',
      build: () {
        when(mockLeadsRepository.getLeads('company1'))
            .thenAnswer((_) async => List<Lead>.from(testLeads));
        return leadsBloc;
      },
      seed: () => LeadsLoaded(
        leads: List<Lead>.from(testLeads),
        filteredLeads: [testLeads.first],
        activeFilter: const LeadFilter(status: LeadStatus.hot),
      ),
      act: (bloc) => bloc.add(
        const ApplyLeadFilter(
          companyId: 'company1',
          filter: LeadFilter(),
        ),
      ),
      expect: () => [
        isA<LeadsLoaded>().having(
          (state) => state.filteredLeads.length,
          'filtered leads count',
          testLeads.length,
        ),
      ],
    );

    blocTest<LeadsBloc, LeadsState>(
      'maintains filter when updating lead status',
      build: () {
        when(mockLeadsRepository.updateLeadStatus(
          companyId: 'company1',
          leadId: '1',
          status: LeadStatus.cold,
        )).thenAnswer((_) async {});
        when(mockLeadsRepository.getLeads('company1'))
            .thenAnswer((_) async => List<Lead>.from(testLeads));
        return leadsBloc;
      },
      seed: () => LeadsLoaded(
        leads: List<Lead>.from(testLeads),
        filteredLeads: [testLeads.first],
        activeFilter: const LeadFilter(status: LeadStatus.hot),
      ),
      act: (bloc) => bloc.add(
        const UpdateLeadStatus(
          companyId: 'company1',
          leadId: '1',
          status: LeadStatus.cold,
        ),
      ),
      expect: () => [
        isA<LeadStatusUpdating>(),
        isA<LeadsLoaded>().having(
          (state) => state.activeFilter?.status,
          'active filter status',
          LeadStatus.hot,
        ),
      ],
    );

    blocTest<LeadsBloc, LeadsState>(
      'exports leads to CSV',
      build: () {
        when(mockLeadsRepository.exportLeadsToCSV(
          List<Lead>.from(testLeads),
          companyId: 'company1',
        )).thenAnswer((_) async => Uint8List(0));
        return leadsBloc;
      },
      seed: () => LeadsLoaded(
        leads: List<Lead>.from(testLeads),
        filteredLeads: List<Lead>.from(testLeads),
      ),
      act: (bloc) => bloc.add(
        const ExportLeadsToCSV(companyId: 'company1'),
      ),
      expect: () => [
        isA<LeadsExporting>(),
        isA<LeadsExportSuccess>(),
        isA<LeadsLoaded>(),
      ],
    );
  });
}
