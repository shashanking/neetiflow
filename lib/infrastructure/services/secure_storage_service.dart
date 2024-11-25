import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class SecureStorageService {
  static const _storage = FlutterSecureStorage();
  static const _keyEmail = 'remembered_email';
  static const _keyPassword = 'remembered_password';
  static const _keyRememberMe = 'remember_me';

  // Web storage fallback
  static final Map<String, String> _webStorage = {};

  // Save credentials
  static Future<void> saveCredentials({
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
  static Future<String?> getSavedEmail() async {
    if (kIsWeb) {
      return _webStorage[_keyEmail];
    }
    return await _storage.read(key: _keyEmail);
  }

  // Get saved password
  static Future<String?> getSavedPassword() async {
    if (kIsWeb) {
      return _webStorage[_keyPassword];
    }
    return await _storage.read(key: _keyPassword);
  }

  // Get remember me status
  static Future<bool> getRememberMe() async {
    if (kIsWeb) {
      final value = _webStorage[_keyRememberMe];
      return value == 'true';
    }
    final value = await _storage.read(key: _keyRememberMe);
    return value == 'true';
  }

  // Clear saved credentials
  static Future<void> clearCredentials() async {
    if (kIsWeb) {
      _webStorage.clear();
    } else {
      await _storage.delete(key: _keyEmail);
      await _storage.delete(key: _keyPassword);
      await _storage.delete(key: _keyRememberMe);
    }
  }
}
