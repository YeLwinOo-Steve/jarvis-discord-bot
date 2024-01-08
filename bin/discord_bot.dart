import 'package:discord_bot/jarvis.dart';

void main(){
  final bot = Jarvis();
  bot.onInit().then((_){
    bot.run();
    bot.dispose();
  });
}
