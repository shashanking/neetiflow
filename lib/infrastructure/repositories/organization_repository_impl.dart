import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:neetiflow/domain/entities/organization.dart';
import 'package:neetiflow/domain/repositories/organization_repository.dart';

@Injectable(as: OrganizationRepository)
class OrganizationRepositoryImpl implements OrganizationRepository {
  final FirebaseFirestore _firestore;
  final String _collection = 'organizations';

  OrganizationRepositoryImpl(@Named('firestore') this._firestore);

  CollectionReference<Map<String, dynamic>> get _organizationsRef =>
      _firestore.collection(_collection);

  @override
  Future<Organization?> getOrganization(String id) async {
    final doc = await _organizationsRef.doc(id).get();
    if (!doc.exists) return null;
    return Organization(
      id: doc.id,
      name: doc.data()!['name'] as String,
      logo: doc.data()!['logo'] as String?,
      address: doc.data()!['address'] as String,
      phone: doc.data()!['phone'] as String,
      email: doc.data()!['email'] as String,
      website: doc.data()!['website'] as String?,
      pan: doc.data()!['pan'] as String?,
      gstin: doc.data()!['gstin'] as String?,
      bankDetails: doc.data()!['bankDetails'] != null
          ? BankDetails.fromJson(
              Map<String, dynamic>.from(doc.data()!['bankDetails'] as Map))
          : null,
      employeeCount: doc.data()!['employeeCount'] as int? ?? 0,
      createdAt: (doc.data()!['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (doc.data()!['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  @override
  Future<List<Organization>> getOrganizations() async {
    final snapshot = await _organizationsRef.get();
    return snapshot.docs.map((doc) {
      return Organization(
        id: doc.id,
        name: doc.data()['name'] as String,
        logo: doc.data()['logo'] as String?,
        address: doc.data()['address'] as String,
        phone: doc.data()['phone'] as String,
        email: doc.data()['email'] as String,
        website: doc.data()['website'] as String?,
        pan: doc.data()['pan'] as String?,
        gstin: doc.data()['gstin'] as String?,
        bankDetails: doc.data()['bankDetails'] != null
            ? BankDetails.fromJson(
                Map<String, dynamic>.from(doc.data()['bankDetails'] as Map))
            : null,
        employeeCount: doc.data()['employeeCount'] as int? ?? 0,
        createdAt: (doc.data()['createdAt'] as Timestamp?)?.toDate(),
        updatedAt: (doc.data()['updatedAt'] as Timestamp?)?.toDate(),
      );
    }).toList();
  }

  @override
  Future<Organization> createOrganization(Organization organization) async {
    final docRef = _organizationsRef.doc();
    final now = DateTime.now();
    final data = {
      'name': organization.name,
      'logo': organization.logo,
      'address': organization.address,
      'phone': organization.phone,
      'email': organization.email,
      'website': organization.website,
      'pan': organization.pan,
      'gstin': organization.gstin,
      'bankDetails': organization.bankDetails?.toJson(),
      'employeeCount': organization.employeeCount,
      'createdAt': now,
      'updatedAt': now,
    };
    await docRef.set(data);
    return organization.copyWith(id: docRef.id, createdAt: now, updatedAt: now);
  }

  @override
  Future<Organization> updateOrganization(Organization organization) async {
    if (organization.id == null) {
      throw Exception('Organization ID cannot be null');
    }
    final now = DateTime.now();
    final data = {
      'name': organization.name,
      'logo': organization.logo,
      'address': organization.address,
      'phone': organization.phone,
      'email': organization.email,
      'website': organization.website,
      'pan': organization.pan,
      'gstin': organization.gstin,
      'bankDetails': organization.bankDetails?.toJson(),
      'employeeCount': organization.employeeCount,
      'updatedAt': now,
    };
    await _organizationsRef.doc(organization.id).update(data);
    return organization.copyWith(updatedAt: now);
  }

  @override
  Future<void> deleteOrganization(String id) async {
    await _organizationsRef.doc(id).delete();
  }
}
