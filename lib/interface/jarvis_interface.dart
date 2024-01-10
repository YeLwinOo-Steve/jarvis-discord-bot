import '../models/chat.dart';

abstract class JarvisInterface {
  void onInit();
  void run();

  void getAIChatResponse(String prompt,
      {required Function(Chat) onSuccess,
      required Function(String) onError});
  void dispose();
}
