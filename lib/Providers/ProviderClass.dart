import 'package:flutter/cupertino.dart';

class ProviderClassChange extends ChangeNotifier {
  Map<String, dynamic> mapC = {};

  void mapData(Map<String, dynamic> temp){
    mapC = temp;
    // map["default"] = "temp";
    notifyListeners();
    // print('temp ....................data is......................... $mapC');
  }

}