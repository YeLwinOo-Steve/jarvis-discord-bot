import 'package:discord_bot/interface/jarvis_interface.dart';
import 'package:discord_bot/services/chat_service.dart';
import 'package:nyxx/nyxx.dart';

import 'configs/bot_key.dart';
import 'mixins/log_mixin.dart';
import 'mixins/state_mixin.dart';
import 'models/chat.dart';

class Jarvis with StateMixin, LogMixin implements JarvisInterface {
  Jarvis(this.service);
  ChatService service;
  late NyxxGateway client;
  @override
  void dispose() {
    client.close();
    infoLog('connection closed!');
  }

  @override
  Future<void> onInit() async {
    try {
      infoLog('connecting...');
      client = await Nyxx.connectGateway(TOKEN, GatewayIntents.allUnprivileged,
          options: GatewayClientOptions(plugins: [Logging(), cliIntegration]));
      infoLog('connected successfully!');
    } catch (ex, stacktrace) {
      errorLog('Exception occurred $ex');
      errorLog(stacktrace.toString());
    }
  }

  @override
  Future<void> run() async {
    final user = await client.users.fetchCurrentUser();
    client.onReady.listen((event) {
      client.updatePresence(
        PresenceBuilder(
          status: CurrentUserStatus.online,
          isAfk: true,
        ),
      );
      infoLog('JARVIS comes online!');
    });

    client.onMessageCreate.listen((event) async {
      checkAuthor(event.message.author.username.toLowerCase());
      if (!isLastAuthorBot && isBotMentioned(event.mentions)) {
        infoLog('waiting for JARVIS response ...');
        getAIChatResponse(
          event.message.content,
          onSuccess: (data) async {
            isLastAuthorBot = true;
            infoLog('JARVIS response received!');
            await event.message.channel.sendMessage(MessageBuilder(
              content: data.output,
              replyId: event.message.id,
            ));
          },
          onError: (message) async {
            errorLog('JARVIS error -> $message');
            await event.message.channel.sendMessage(MessageBuilder(
              content: 'ERROR ------------> $message',
              replyId: event.message.id,
            ));
          },
        );
      }
    });
  }

  @override
  bool isBotMentioned(List<User> users) {
    for (User user in users) {
      if (user.isBot) return true;
    }
    return false;
  }

  @override
  void checkAuthor(String author) {
    if (author != 'jarvis') {
      isLastAuthorBot = false;
    }
  }

  @override
  void getAIChatResponse(
    String prompt, {
    required Function(Chat) onSuccess,
    required Function(String) onError,
  }) {
    service.chat(
      prompt: prompt,
      onSuccess: (data) => onSuccess(Chat.fromJson(data)),
      onError: onError,
    );
  }
}
