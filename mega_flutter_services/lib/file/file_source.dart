import 'package:file_picker/file_picker.dart';

enum FileSource {
  camera,
  image,
  video,
  media,
  audio,
  custom,
  any,
}

class FilePickerSourceUtils {
  static FileType type(FileSource source) {
    switch (source) {
      case FileSource.camera:
      case FileSource.image:
        return FileType.image;
      case FileSource.video:
        return FileType.video;
      case FileSource.media:
        return FileType.media;
      case FileSource.audio:
        return FileType.audio;
      case FileSource.custom:
        return FileType.custom;
      case FileSource.any:
        return FileType.any;
      default:
        return FileType.any;
    }
  }
}
