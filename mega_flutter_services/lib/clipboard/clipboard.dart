import 'package:clipboard/clipboard.dart';

class MegaClipboard {
  static Future<void> copy(String text) async {
    await FlutterClipboard.copy(text);
  }

  static Future<String> paste(String text) async {
    return await FlutterClipboard.paste();
  }
}
