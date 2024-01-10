import 'package:discord_bot/interface/jarvis_interface.dart';
import 'package:discord_bot/services/chat_service.dart';
import 'package:nyxx/nyxx.dart' hide logging;
import 'package:nyxx/src/plugin/logging.dart' show Logging;

import 'configs/bot_key.dart';
import 'mixins/state_mixin.dart';
import 'models/chat.dart';

class Jarvis with StateMixin implements JarvisInterface {
  Jarvis(this.service);
  ChatService service;
  late NyxxGateway client;
  @override
  void dispose() {
    client.close();
  }

  @override
  Future<void> onInit() async {
    try {
      client = await Nyxx.connectGateway(TOKEN, GatewayIntents.allUnprivileged,
          options: GatewayClientOptions(plugins: [Logging(), cliIntegration]));
    } catch (ex, stacktrace) {
      Logging().logger.severe('Exception occurred $ex');
      Logging().logger.severe(stacktrace.toString());
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
    });

    client.onMessageCreate.listen((event) async {
      checkAuthor(event.message.author.username.toLowerCase());
      if (!isLastAuthorBot) {
        getAIChatResponse(
          event.message.content,
          onSuccess: (data) async {
            isLastAuthorBot = true;
            await event.message.channel.sendMessage(MessageBuilder(
              content: data.output,
              replyId: event.message.id,
            ));
          },
          onError: (message) async {
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
