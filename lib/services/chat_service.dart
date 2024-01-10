import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../configs/api_endpoints.dart';

typedef DMap = Map<String, dynamic>;

abstract class ChatService {
  void getWelcome({
    required Function(DMap) onSuccess,
    required Function(String) onError,
  });
  void chat({
    required String prompt,
    required Function(DMap) onSuccess,
    required Function(String) onError,
  });
}

class ChatServiceImpl extends ChatService {
  final log = Logger();
  @override
  void getWelcome(
          {required Function(DMap) onSuccess,
          required Function(String) onError}) =>
      http
          .get(Uri.parse(END_POINT_HOME))
          .then((value) => onSuccess(jsonDecode(value.body)))
          .onError((error, stackTrace) {
        log.e(error.toString(), stackTrace: stackTrace);
        onError(error.toString());
      });

  @override
  void chat({
    required String prompt,
    required Function(DMap) onSuccess,
    required Function(String) onError,
  }) =>
      http
          .get(Uri.parse("$END_POINT_CHAT?prompt=$prompt"))
          .then((value) => onSuccess(jsonDecode(value.body)))
          .onError((error, stackTrace) {
        log.e(error.toString(), stackTrace: stackTrace);
        onError(error.toString());
      });
}
