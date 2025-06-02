import 'dart:io';

import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mega_response.g.dart';

@JsonSerializable()
class MegaResponse extends Error {
  dynamic data;
  bool? erro;
  dynamic errors;
  String? message;
  int? statusCode;

  MegaResponse({
    this.data,
    this.erro,
    this.errors,
    this.message,
    this.statusCode,
  });

  factory MegaResponse.fromJson(Map<String, dynamic> json) =>
      _$MegaResponseFromJson(json);
  Map<String, dynamic> toJson() => _$MegaResponseToJson(this);

  MegaResponse.fromDioError(DioError e) {
    final errorMessage = e.message;
    final hasConnectionLost =
        errorMessage.contains('A conexão com o servidor demorou muito') ||
            errorMessage.contains('SocketException: Connection refused');
    if (e.response != null &&
        e.response!.data != null &&
        e.response!.data is Map) {
      final json = e.response!.data;
      data = json['data'];
      erro = json['erro'];
      errors = json['errors'];
      message = json['message'];
      statusCode = e.response?.statusCode ?? HttpStatus.badRequest;
    } else if (e.type == DioErrorType.connectTimeout ||
        e.type == DioErrorType.receiveTimeout ||
        e.type == DioErrorType.sendTimeout) {
      statusCode = 408;
      message = 'Tempo limite de conexão excedido!';
    } else if (hasConnectionLost) {
      statusCode = HttpStatus.requestTimeout;
      message =
          'Aconteceu um problema de conexão com nosso servidor, tenta novamente mais tarde.';
    } else {
      message = '${e.message}';
      statusCode = e.response?.statusCode ?? HttpStatus.badRequest;
    }
  }
}
