import 'package:http/http.dart' as http;

class DevHelp {

  void sendMessageToTelegram(String message) async {
    String tt = "This is from --- Letter $message";
    String devChatId = "telegram chat id .....";
    String userBot = "bot7109:telegram bot api";
    String devURL = "https://api.telegram.org/$userBot/sendMessage";

    try {
      final response = await http.post(
        Uri.parse(devURL),
        body: {
          "chat_id": devChatId,
          "text": tt,
        },
      );

    } catch (e) {
      print("Error occurred: $e");
    }
  }
}