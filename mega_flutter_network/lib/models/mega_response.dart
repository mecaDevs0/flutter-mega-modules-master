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
      message = 'Tempo limite de conexão excedido! Verifique sua internet.';
    } else if (hasConnectionLost) {
      statusCode = HttpStatus.requestTimeout;
      message =
          'Aconteceu um problema de conexão com nosso servidor. Verifique sua internet e tenta novamente.';
    } else if (e.type == DioErrorType.connectionError) {
      statusCode = HttpStatus.serviceUnavailable;
      message = 'Erro de conexão com o servidor. Verifique sua internet.';
    } else if (e.response?.statusCode == 502) {
      statusCode = 502;
      message = 'Servidor temporariamente indisponível. Tente novamente em alguns minutos.';
    } else if (e.response?.statusCode == 503) {
      statusCode = 503;
      message = 'Serviço temporariamente indisponível. Tente novamente em alguns minutos.';
    } else if (e.response?.statusCode == 504) {
      statusCode = 504;
      message = 'Tempo limite do servidor. Tente novamente em alguns minutos.';
    } else {
      message = '${e.message}';
      statusCode = e.response?.statusCode ?? HttpStatus.badRequest;
    }
  }
}
