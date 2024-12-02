import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

@module
abstract class LoggerInjectableModule {
  @singleton
  Logger get logger => Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 50,
      colors: true,
      printEmojis: true,
    ),
  );
}
