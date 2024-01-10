import 'package:discord_bot/jarvis.dart';
import 'package:discord_bot/services/chat_service.dart';

void main() {
  final bot = Jarvis(ChatServiceImpl());
  bot.onInit().then((_) {
    bot.run();
  }).onError(
    (error, stackTrace) {
      bot.dispose();
    },
  );
}
