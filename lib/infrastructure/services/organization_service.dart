import 'package:injectable/injectable.dart';
import 'package:neetiflow/domain/entities/organization.dart';
import 'package:neetiflow/domain/repositories/organization_repository.dart';
import 'package:neetiflow/core/providers/auth_provider.dart';

@lazySingleton
class OrganizationService {
  final OrganizationRepository _repository;
  final AuthService _authService;
  Organization? _currentOrganization;

  OrganizationService(this._repository, this._authService);

  Organization? get currentOrganization => _currentOrganization;

  Future<void> initializeDefaultOrganization() async {
    if (_currentOrganization != null) return;
    
    final organizationId = await _authService.getOrganizationId();
    if (organizationId == null) {
      throw Exception('No organization ID found in auth service');
    }

    final organization = await _repository.getOrganization(organizationId);
    if (organization == null) {
      throw Exception('Organization not found: $organizationId');
    }

    _currentOrganization = organization;
  }

  Future<void> setCurrentOrganization(String organizationId) async {
    final organization = await _repository.getOrganization(organizationId);
    if (organization == null) {
      throw Exception('Organization not found: $organizationId');
    }
    _currentOrganization = organization;
  }

  Future<void> clearCurrentOrganization() async {
    _currentOrganization = null;
  }

  Future<String> getCurrentOrganizationId() async {
    try {
      print('🏢 Retrieving Current Organization ID');
      
      // Check if current organization is already set
      if (_currentOrganization?.id?.isNotEmpty ?? false) {
        print('✅ Using existing organization: ${_currentOrganization!.id}');
        return _currentOrganization!.id!;
      }

      // Try to initialize default organization
      print('🔍 Initializing Default Organization');
      await initializeDefaultOrganization();
      
      // Check again after initialization
      if (_currentOrganization?.id?.isNotEmpty ?? false) {
        print('✅ Initialized organization: ${_currentOrganization!.id}');
        return _currentOrganization!.id!;
      }

      // Fallback to auth service
      final organizationId = await _authService.getOrganizationId();
      print('🔑 Auth Service Organization ID: $organizationId');
      
      if (organizationId == null || organizationId.isEmpty) {
        print('❌ No valid organization ID found');
        throw Exception('No valid organization ID found');
      }

      // Verify organization exists
      final organization = await _repository.getOrganization(organizationId);
      if (organization == null) {
        print('❌ Organization not found: $organizationId');
        throw Exception('Organization not found: $organizationId');
      }

      // Set and return organization ID
      _currentOrganization = organization;
      print('✅ Successfully retrieved organization ID: ${organization.id}');
      return organization.id!;
    } catch (e) {
      print('❌ Error in getCurrentOrganizationId: $e');
      throw Exception('Failed to get organization ID: $e');
    }
  }

  Future<dynamic> getCurrentUser() async {
    return _authService.getCurrentUser();
  }
}
