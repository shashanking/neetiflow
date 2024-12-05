import 'package:neetiflow/domain/entities/organization.dart';

abstract class OrganizationRepository {
  Future<Organization?> getOrganization(String id);
  Future<List<Organization>> getOrganizations();
  Future<Organization> createOrganization(Organization organization);
  Future<Organization> updateOrganization(Organization organization);
  Future<void> deleteOrganization(String id);
}
