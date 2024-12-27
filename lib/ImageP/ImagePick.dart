import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImagePick {
  ImagePicker picker = ImagePicker();
  String base64Image = '';

  Future<String> signatureImage() async {

    File? signFile;
    XFile? sign = await picker.pickImage(source: ImageSource.gallery);

    if(sign != null) {
      signFile = File(sign.path);
      base64Image = base64Encode(signFile.readAsBytesSync());
       }
    return base64Image;
  }
}
