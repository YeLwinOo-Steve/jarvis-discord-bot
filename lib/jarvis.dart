import 'package:discord_bot/interface/jarvis_interface.dart';
import 'package:nyxx/nyxx.dart' hide logging;
import 'package:nyxx/src/plugin/logging.dart' show Logging;

import 'configs/bot_key.dart';

class Jarvis implements JarvisInterface {
  late NyxxGateway client;
  @override
  void dispose() {
    // client.close();
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
      print("event -----> ${event.sessionId}");
      client.updatePresence(
        PresenceBuilder(
          status: CurrentUserStatus.online,
          isAfk: true,
        ),
      );
    });

    print("user is ${user.username}");
    client.onMessageCreate.listen((event) async {
      print("----> mesage content ${event.message.author.username}");
      if (event.message.author.username == 'yelwinoo') {
        await event.message.channel.sendMessage(MessageBuilder(
          content: 'Hello there! How are you? How may I assist you, Sir?',
          replyId: event.message.id,
        ));
      } else if (event.mentions.contains(user)) {
        await event.message.channel.sendMessage(MessageBuilder(
          content: 'I love you!',
          replyId: event.message.id,
        ));
      }
    });
  }
}
