import 'package:diacritic/diacritic.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:ua_client_hints/ua_client_hints.dart';

class HeadersInterceptor extends InterceptorsWrapper {
  @override
  Future onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final Map<String, String> headeRUserAgentData = {};
    final UserAgentData uaData = await userAgentData();
    final name = removeDiacritics(uaData.brand);
    try {
      final headerUserAgent =
          '$name (${uaData.platform} ${uaData.platformVersion}; ${uaData.model}; ${uaData.device}; ${uaData.architecture})';
      headeRUserAgentData['User-Agent'] =
          '$headerUserAgent full-version ${uaData.package.appVersion}/${uaData.package.buildNumber}';
      options.headers.addAll(headeRUserAgentData);
    } on PlatformException {}

    options.headers.putIfAbsent('accept', () => 'application/json');

    return super.onRequest(options, handler);
  }
}
