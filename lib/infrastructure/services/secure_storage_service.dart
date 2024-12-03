import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:injectable/injectable.dart';

@lazySingleton
class SecureStorageService {
  final _storage = const FlutterSecureStorage();
  final _keyEmail = 'remembered_email';
  final _keyPassword = 'remembered_password';
  final _keyRememberMe = 'remember_me';

  // Web storage fallback
  final Map<String, String> _webStorage = {};

  // Save credentials
  Future<void> saveCredentials({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    if (kIsWeb) {
      if (rememberMe) {
        _webStorage[_keyEmail] = email;
        _webStorage[_keyPassword] = password;
        _webStorage[_keyRememberMe] = rememberMe.toString();
      } else {
        await clearCredentials();
      }
    } else {
      if (rememberMe) {
        await _storage.write(key: _keyEmail, value: email);
        await _storage.write(key: _keyPassword, value: password);
        await _storage.write(key: _keyRememberMe, value: rememberMe.toString());
      } else {
        await clearCredentials();
      }
    }
  }

  // Get saved email
  Future<String?> getSavedEmail() async {
    if (kIsWeb) {
      return _webStorage[_keyEmail];
    }
    return await _storage.read(key: _keyEmail);
  }

  // Get saved password
  Future<String?> getSavedPassword() async {
    if (kIsWeb) {
      return _webStorage[_keyPassword];
    }
    return await _storage.read(key: _keyPassword);
  }

  // Get remember me status
  Future<bool> getRememberMe() async {
    if (kIsWeb) {
      return _webStorage[_keyRememberMe]?.toLowerCase() == 'true';
    }
    final value = await _storage.read(key: _keyRememberMe);
    return value?.toLowerCase() == 'true';
  }

  // Clear saved credentials
  Future<void> clearCredentials() async {
    if (kIsWeb) {
      _webStorage.clear();
    } else {
      await _storage.delete(key: _keyEmail);
      await _storage.delete(key: _keyPassword);
      await _storage.delete(key: _keyRememberMe);
    }
  }
}
