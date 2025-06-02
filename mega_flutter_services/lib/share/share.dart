import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:share_plus/share_plus.dart';

class MegaShare {
  static void share({required String text}) {
    Share.share(text);
  }

  static void subject({required String text, String? subject = null}) {
    Share.share(text, subject: subject);
  }

  static Future<void> shareFiles({
    required List<String> paths,
    List<String>? mimeTypes = null,
    String? subject = null,
    String? text = null,
    Rect? sharePositionOrigin = null,
  }) async {
    await Share.shareXFiles(
      _getXFiles(paths),
      subject: subject,
      text: text,
      sharePositionOrigin: sharePositionOrigin,
    );
  }

  static List<XFile> _getXFiles(List<String> paths) {
    return paths.map((e) => XFile(e)).toList();
  }
}
