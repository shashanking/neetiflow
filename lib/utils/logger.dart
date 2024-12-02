import 'package:logger/logger.dart';

final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 2,
    errorMethodCount: 8,
    lineLength: 120,
    colors: true,
    printEmojis: true,
    printTime: true,
  ),
  level: Level.debug,
);

// Custom log levels for better organization
extension LoggerExtension on Logger {
  void startup(String message) {
    i('🚀 STARTUP: $message');
  }

  void api(String message) {
    i('🌐 API: $message');
  }

  void database(String message) {
    i('💾 DB: $message');
  }

  void auth(String message) {
    i('🔐 AUTH: $message');
  }

  void navigation(String message) {
    d('🧭 NAV: $message');
  }

  void ui(String message) {
    d('💫 UI: $message');
  }

  void analytics(String message) {
    i('📊 ANALYTICS: $message');
  }

  void security(String message) {
    w('🛡️ SECURITY: $message');
  }

  void performance(String message) {
    i('⚡ PERF: $message');
  }

  void crash(String message, {dynamic error, StackTrace? stackTrace}) {
    e('💥 CRASH: $message', error: error, stackTrace: stackTrace);
  }
}
