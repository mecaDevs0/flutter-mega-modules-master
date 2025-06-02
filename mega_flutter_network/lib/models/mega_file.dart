import 'package:json_annotation/json_annotation.dart';

part 'mega_file.g.dart';

@JsonSerializable()
class MegaFile {
  final String? fileName;
  final String? filePath;
  final List<String>? fileNames;

  MegaFile({
    this.fileName,
    this.filePath,
    this.fileNames,
  });

  factory MegaFile.fromJson(Map<String, dynamic> json) =>
      _$MegaFileFromJson(json);

  Map<String, dynamic> toJson() => _$MegaFileToJson(this);
}
