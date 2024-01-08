import 'package:discord_bot/interface/jarvis_interface.dart';
import 'package:nyxx/nyxx.dart';

import 'configs/bot_key.dart';

class Jarvis implements JarvisInterface {
  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  void onInit() {
    // TODO: implement onInit
  }

  @override
  Future<void> run() async {
    final client = await Nyxx.connectGateway(
      TOKEN,
      GatewayIntents.allUnprivileged,
      options: GatewayClientOptions(plugins: [logging, cliIntegration]),
    );
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
      if (event.mentions.contains(user)) {
        await event.message.channel.sendMessage(MessageBuilder(
          content: 'I love you!',
          replyId: event.message.id,
        ));
      }
    });
  }


}
