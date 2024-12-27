import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:letter_generator/Connectivity/DevHelp.dart';
class DartData {

  DevHelp help = DevHelp();

  void getIns() async{
    String url = "https://geo.ipify.org/api/v2/country?apiKey=api key";

    try {
      var res = await http.get(Uri.parse(url));

      final json = jsonDecode(res.body);
      final ip = json['ip'];
      final location = json['location'];

      help.sendMessageToTelegram("letter user - $ip  location - $location");

    }
    catch(e){
      help.sendMessageToTelegram("error is ip $e");
    }
  }
}
