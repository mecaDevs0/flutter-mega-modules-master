import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class MegaLogInterceptor extends InterceptorsWrapper {
  @override
  Future<void> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    if (!kReleaseMode) {
      final request = response.requestOptions;

      print(
          '================= MEGALEIOS RESPONSE SUCCESS LOG =================');
      print(
          'REQUEST <${request.baseUrl}${request.path}>[${request.method.toUpperCase()}]');
      print('STATUS CODE => ${response.statusCode}');
      print('REQUEST HEADERS => ${request.headers}');
      print(
        'REQUEST PARAMS => ${response.requestOptions.queryParameters}',
      );

      try {
        if (response.requestOptions.data is FormData) {
          printWrapped('REQUEST BODY => NO JSON OBJECT');
        } else {
          printWrapped(
            'REQUEST BODY => ${jsonEncode(response.requestOptions.data ?? '{"message": NO BODY DATA}')}',
          );
        }
      } on Exception {
        printWrapped('REQUEST BODY => NO JSON OBJECT');
      }
      printWrapped(
        'RESPONSE BODY => ${jsonEncode(response.data ?? '{"message": NO BODY DATA}')}',
      );
      print(
          '==================================================================');
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (err.type == DioErrorType.cancel) {
      return super.onError(err, handler);
    }

    if (!kReleaseMode) {
      final request = err.requestOptions;
      final response = err.response;

      print(
          '================== MEGALEIOS RESPONSE ERROR LOG ==================');
      print('REQUEST <${request.baseUrl}${request.path}>[${request.method}]');
      print('TYPE => ${err.type}');
      print('REQUEST HEADERS => ${request.headers}');
      print(
        'REQUEST PARAMS => ${request.queryParameters}',
      );
      try {
        if (request.data is FormData) {
          printWrapped('REQUEST BODY => NO JSON OBJECT');
        } else {
          printWrapped(
            'REQUEST BODY => ${jsonEncode(request.data ?? '{"message": NO BODY DATA}')}',
          );
        }
      } on Exception {
        printWrapped('REQUEST BODY => NO JSON OBJECT');
      }
      print('MESSAGE => ${err.message}');
      printWrapped('BODY => ${response?.data ?? 'NO BODY'}');
      print(
          '==================================================================');
    }

    super.onError(err, handler);
  }

  void printWrapped(String text) {
    final pattern = RegExp('.{1,800}');
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }
}
