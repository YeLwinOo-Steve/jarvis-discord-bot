import 'package:logger/logger.dart';

mixin LogMixin {
  final logger = Logger();

  void infoLog(String message) => logger.i('[JARVIS] $message');
  void debugLog(String message) => logger.d('[JARVIS] $message');
  void errorLog(String message) => logger.e('[JARVIS] $message');
}
