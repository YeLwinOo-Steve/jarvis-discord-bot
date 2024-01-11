import 'package:logger/logger.dart';

mixin LogMixin {
  final logger = Logger();

  get infoLog => logger.i;
  get debugLog => logger.d;
  get errorLog => logger.e;
}
