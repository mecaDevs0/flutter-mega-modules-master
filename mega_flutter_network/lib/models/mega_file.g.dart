// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mega_file.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MegaFile _$MegaFileFromJson(Map<String, dynamic> json) => MegaFile(
      fileName: json['fileName'] as String?,
      filePath: json['filePath'] as String?,
      fileNames: (json['fileNames'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$MegaFileToJson(MegaFile instance) => <String, dynamic>{
      'fileName': instance.fileName,
      'filePath': instance.filePath,
      'fileNames': instance.fileNames,
    };
