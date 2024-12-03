import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:neetiflow/domain/entities/organization.dart';
import 'package:neetiflow/domain/entities/user.dart';
import 'package:neetiflow/domain/repositories/auth_repository.dart';
import 'package:neetiflow/core/providers/auth_provider.dart';

import 'secure_storage_service.dart';

@LazySingleton(as: AuthService)
@Environment(Environment.prod)
class AuthServiceImpl implements AuthService {
  final AuthRepository _authRepository;
  final SecureStorageService _secureStorageService;
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 50,
      colors: true,
      printEmojis: true,
    ),
  );

  @injectable
   AuthServiceImpl(
    this._authRepository,
    this._secureStorageService,
  );

  @override
  Future<Organization?> getCurrentOrganization() async {
    try {
      final user = await _authRepository.getCurrentUser();
      if (user == null) {
        return null;
      }

      final employee = await _authRepository.getEmployeeData(user.uid);
      if (employee.companyId == null) {
        return null;
      }

      return _authRepository.getOrganization(employee.companyId!);
    } catch (e) {
      // Log error in production
      print('Error getting current organization: $e');
      return null;
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    try {
      final user = await _authRepository.getCurrentUser();
      return user != null;
    } catch (e) {
      // Log error in production
      print('Error checking authentication status: $e');
      return false;
    }
  }

  @override
  Future<String?> getOrganizationId() async {
    try {
      _logger.d('Getting organization ID');
      final userMapping = await _getUserMapping();
      if (userMapping == null) {
        _logger.e('No user mapping found');
        return null;
      }
      
      final organizationId = userMapping['organizationId'] as String?;
      if (organizationId == null || organizationId.isEmpty) {
        _logger.e('No organization ID found in user mapping');
        return null;
      }

      _logger.d('Found organization ID: $organizationId');
      return organizationId;
    } catch (e, stackTrace) {
      _logger.e('Error getting organization ID', error: e, stackTrace: stackTrace);
      return null;
    }
  }

  @override
  Future<String?> getUserRole() async {
    try {
      final user = await _authRepository.getCurrentUser();
      if (user == null) {
        return null;
      }
      final employee = await _authRepository.getEmployeeData(user.uid);
      return employee.role.toString().split('.').last.toLowerCase();
    } catch (e) {
      print('Error getting user role: $e');
      return null;
    }
  }

  Future<User?> getCurrentUser() async {
    try {
      final firebaseUser = await _authRepository.getCurrentUser();
      if (firebaseUser == null) {
        return null;
      }

      final employee = await _authRepository.getEmployeeData(firebaseUser.uid);
      return User(
        id: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        displayName: '${employee.firstName} ${employee.lastName}',
        role: employee.role.toString().split('.').last.toUpperCase(),
        createdAt: employee.createdAt ?? DateTime.now(),
        lastLogin: DateTime.now(),
      );
    } catch (e) {
      // Log error in production
      print('Error getting current user: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> _getUserMapping() async {
    try {
      _logger.d('Getting user mapping');
      final user = await _authRepository.getCurrentUser();
      if (user == null) {
        _logger.e('No current user found');
        return null;
      }
      _logger.d('Found user: ${user.uid}');

      final employee = await _authRepository.getEmployeeData(user.uid);
      if (employee == null) {
        _logger.e('No employee data found for user: ${user.uid}');
        return null;
      }
      _logger.d('Found employee data for user: ${user.uid}');

      final mapping = {
        'userId': user.uid,
        'organizationId': employee.companyId,
        'role': employee.role,
      };
      _logger.d('Created user mapping: $mapping');
      return mapping;
    } catch (e, stackTrace) {
      _logger.e('Error getting user mapping', error: e, stackTrace: stackTrace);
      return null;
    }
  }
}
