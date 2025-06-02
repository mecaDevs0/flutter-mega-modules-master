// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mega_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MegaResponse _$MegaResponseFromJson(Map<String, dynamic> json) => MegaResponse(
      data: json['data'],
      erro: json['erro'] as bool?,
      errors: json['errors'],
      message: json['message'] as String?,
      statusCode: json['statusCode'] as int?,
    );

Map<String, dynamic> _$MegaResponseToJson(MegaResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
      'erro': instance.erro,
      'errors': instance.errors,
      'message': instance.message,
      'statusCode': instance.statusCode,
    };
