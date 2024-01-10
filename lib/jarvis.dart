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
      // if (event.message.author.username.contains('yelwinoo')) {
      //   await event.message
      //       .react(ReactionBuilder(name: '👍', id: event.message.id));
      // }
      print("before prompt ----> $lastPrompt");
      print("prompt =====> ${event.message.content}");
      print("is prompt equal ---> ${event.message.content == lastPrompt}");
      if (event.message.content != lastPrompt) {
        lastPrompt = event.message.content;
        print('after prompt -------> $lastPrompt');
        getAIChatResponse(
          event.message.content,
          onSuccess: (data) async {
            print('data >> ${data.status}');
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
