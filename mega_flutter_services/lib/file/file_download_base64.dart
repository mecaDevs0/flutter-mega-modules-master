import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class MegaDownload {
  static Future<String> saveToDownloadFolder(
      String responseFile, String fileName) async {
    String filePath = "";
    final Uint8List bytes = base64.decode(responseFile);
    String downloadsDirectory = "";
    try {
      downloadsDirectory = (await getApplicationDocumentsDirectory()).path;
    } on PlatformException {
      print('Could not get the downloads directory');
    }
    final File file = new File('$downloadsDirectory/$fileName');
    filePath = file.path;
    file.writeAsBytesSync(bytes);

    return filePath;
  }
}
