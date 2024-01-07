import 'dart:io';

import 'package:nyxx/nyxx.dart';

void main() async {
  final client = await Nyxx.connectGateway(
    "MTE5MDIxNDYzMzA2MDA0NDgxMA.GgKAfd.KRMm2k4kxYgwQAhEXUeZQAUK3Iq1Ymy5cJPD_0",
    GatewayIntents.allUnprivileged,
    options: GatewayClientOptions(plugins: [logging, cliIntegration]),
  );
  final user = await client.users.fetchCurrentUser();

  client.onReady.listen((event) {
    print("event -----> ${event.sessionId}");
    client.updatePresence(
      PresenceBuilder(
        since: DateTime.now(),
        activities: [
          ActivityBuilder(name: "text", type: ActivityType.custom),
        ],
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
