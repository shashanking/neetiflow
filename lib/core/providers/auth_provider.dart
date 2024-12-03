import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:neetiflow/domain/entities/organization.dart';
import 'package:neetiflow/domain/repositories/auth_repository.dart';

abstract class AuthService {
  AuthService(this._authRepository);

  final AuthRepository _authRepository;

  Future<Organization?> getCurrentOrganization();
  Future<bool> isAuthenticated();
  Future<String?> getOrganizationId();
  Future<dynamic> getCurrentUser();
}

@Environment(Environment.prod)
class AuthServiceImpl implements AuthService {
  @override
  final AuthRepository _authRepository;
  final FirebaseFirestore _firestore;

  AuthServiceImpl(
    this._authRepository,
    @Named('firestore') this._firestore,
  );

  @override
  Future<Organization?> getCurrentOrganization() async {
    try {
      final user = await _authRepository.getCurrentUser();
      if (user == null) {
        return null;
      }

      final userDoc = await _firestore.collection('users').doc(user.uid).get();

      if (!userDoc.exists) {
        return null;
      }

      final organizationId = userDoc.data()?['organizationId'] as String?;
      if (organizationId == null) {
        return null;
      }

      final orgDoc = await _firestore
          .collection('organizations')
          .doc(organizationId)
          .get();

      if (!orgDoc.exists) {
        return null;
      }

      return Organization.fromJson(orgDoc.data()!);
    } catch (e) {
      debugPrint('Error getting current organization: $e');
      return null;
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    final user = await _authRepository.getCurrentUser();
    return user != null;
  }

  @override
  Future<String?> getOrganizationId() async {
    try {
      print('🔐 Retrieving Organization ID from Auth Service');
      
      final user = await _authRepository.getCurrentUser();
      print('👤 Current User: ${user?.uid}');
      
      if (user == null) {
        print('❌ No authenticated user found');
        return null;
      }

      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      print('📄 User Document Exists: ${userDoc.exists}');

      if (!userDoc.exists) {
        print('❌ User document not found');
        return null;
      }

      final userData = userDoc.data();
      print('📋 User Document Data: $userData');

      final organizationId = userData?['organizationId'] as String?;
      print('🏢 Retrieved Organization ID: $organizationId');

      if (organizationId == null || organizationId.isEmpty) {
        print('❌ No organization ID found in user document');
        return null;
      }

      // Optional: Verify organization document exists
      final orgDoc = await _firestore.collection('organizations').doc(organizationId).get();
      print('🏢 Organization Document Exists: ${orgDoc.exists}');
      
      if (!orgDoc.exists) {
        print('❌ Organization document not found');
        return null;
      }

      return organizationId;
    } catch (e) {
      print('❌ Error getting organization ID: $e');
      debugPrint('Error getting organization ID: $e');
      return null;
    }
  }

  @override
  Future<dynamic> getCurrentUser() async {
    return _authRepository.getCurrentUser();
  }
}
