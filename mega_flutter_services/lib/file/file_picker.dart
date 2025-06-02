import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:megaleios_flutter_localization/megaleios_flutter_localization.dart';
import 'package:path_provider/path_provider.dart';

import 'file_source.dart';

class MegaFilePicker {
  static Future<File?> askForFile(BuildContext context) async {
    final localizations = MegaleiosLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    final FileSource imageSource = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          localizations.translate('where_want_to_choose_the_file'),
          style: textTheme.headlineMedium,
        ),
        actions: <Widget>[
          MaterialButton(
            child: Text(localizations.translate('camera')),
            onPressed: () => Navigator.pop(context, FileSource.camera),
          ),
          MaterialButton(
            child: Text(localizations.translate('gallery')),
            onPressed: () => Navigator.pop(context, FileSource.image),
          ),
          MaterialButton(
            child: Text(localizations.translate('files')),
            onPressed: () => Navigator.pop(context, FileSource.custom),
          )
        ],
      ),
    );

    File? file;
    if (imageSource == FileSource.camera) {
      final result = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxHeight: 800,
        maxWidth: 800,
      );
      if (result != null) {
        final convertedPath = await _convertHeicToJpeg(result.path);
        file = File(convertedPath);
      }
    }
    if (imageSource == FileSource.image) {
      final result = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxHeight: 800,
        maxWidth: 800,
      );
      if (result != null) {
        final convertedPath = await _convertHeicToJpeg(result.path);
        file = File(convertedPath);
      }
    } else if (imageSource == FileSource.custom) {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'pdf', 'doc'],
      );
      if (result != null) {
        file = File(result.files.single.path!);
      }
    }

    return file;
  }

  static Future<String> _convertHeicToJpeg(String imagePath) async {
    final String imagePathLowerCase = imagePath.toLowerCase();
    String convertedImagePath = imagePath;
    if (imagePathLowerCase.contains('heic') ||
        imagePathLowerCase.contains('heif')) {
      final tmpDir = (await getTemporaryDirectory()).path;
      final target = '$tmpDir/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final result = await FlutterImageCompress.compressAndGetFile(
        imagePath,
        target,
        quality: 90,
      );

      if (result != null) {
        convertedImagePath = result.path;
      }
    }
    return convertedImagePath;
  }
}
