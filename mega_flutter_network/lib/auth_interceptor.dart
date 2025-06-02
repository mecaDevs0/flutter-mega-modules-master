import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';

import 'database/network_database.dart';
import 'mega_dio.dart';
import 'models/auth_token.dart';
import 'models/mega_response.dart';

class AuthInterceptor extends InterceptorsWrapper {
  final String authUrl;
  final String defaultUrl;
  final String anonymousAuth;
  final MegaDio httpClient;
  final Dio dio;
  AuthToken? _token;

  AuthInterceptor(
    this.authUrl,
    this.defaultUrl,
    this.anonymousAuth,
    this.httpClient,
    this.dio,
  );

  @override
  Future onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    options.cancelToken = CancelToken();
    _token = await NetworkDatabase.loadAuthToken();
    if (!await deviceIsConnected()) {
      handler.next(options);
    }

    if (_token != null && _token?.accessToken?.isNotEmpty != null) {
      options.headers['Authorization'] = 'Bearer ${'${_token!.accessToken}'}';
    }

    handler.next(options);
  }

  @override
  Future onError(DioError err, ErrorInterceptorHandler handler) async {
    log(err.toString(), name: 'AuthInterceptor');
    if (err.response?.statusCode == HttpStatus.unauthorized) {
      getNewToken(err, handler);
    } else {
      return handler.next(err);
    }
  }

  Future<void> getNewToken(
    DioError err,
    ErrorInterceptorHandler handler,
  ) async {
    _token = await NetworkDatabase.loadAuthToken();
    if (_token != null && _token?.refreshToken == null) {
      await _reauthenticate(err, handler);
      return err.response?.data;
    }

    try {
      final response = await MegaDio.noRefresh(defaultUrl).post(
        authUrl,
        data: {
          'refreshToken': _token!.refreshToken,
        },
      );
      await _saveNewTokenRequestAgain(response, err, handler);
    } on MegaResponse catch (_) {
      _getAnonymousToken();
    }
  }

  Future<void> _reauthenticate(error, handler) async {
    final user = await NetworkDatabase.loadUser();
    if (user != null && user["document"] != null && user["password"] != null) {
      try {
        final response =
            await MegaDio.noRefresh(defaultUrl).post(authUrl, data: {
          'document': user["document"],
          'password': user["password"],
        });

        await _saveNewTokenRequestAgain(response, error, handler);
      } on MegaResponse catch (_) {
        await _getAnonymousToken();
      }
    } else {
      await _getAnonymousToken();
    }
  }

  Future<void> _getAnonymousToken() async {
    if (anonymousAuth.isNotEmpty) {
      final response = await MegaDio.noRefresh(defaultUrl).get(anonymousAuth);
      final token = AuthToken.fromJson(response.data);
      _setNewTokenInLocalStorage(token);
      await NetworkDatabase.saveLogged(false);
    }
  }

  Future<void> _saveNewTokenRequestAgain(
    MegaResponse response,
    DioError error,
    ErrorInterceptorHandler handler,
  ) async {
    final newAuthToken = AuthToken.fromJson(response.data);
    await _setNewTokenInLocalStorage(newAuthToken);
    await _requestAgainLastApiCall(error, handler);
  }

  Future<void> _setNewTokenInLocalStorage(AuthToken authToken) async {
    _token = authToken;
    await NetworkDatabase.saveAuthToken(authToken);
  }

  Future<void> _requestAgainLastApiCall(
    DioError error,
    ErrorInterceptorHandler handler,
  ) async {
    try {
      final RequestOptions options = error.requestOptions;
      final response = await dio.request(
        options.path,
        options: Options(
          method: options.method,
        ),
        data: options.data,
        queryParameters: options.queryParameters,
        onReceiveProgress: options.onReceiveProgress,
        onSendProgress: options.onSendProgress,
        cancelToken: options.cancelToken,
      );
      handler.resolve(response);
    } on DioError catch (e) {
      log(e.toString());
    }
  }

  static Future<bool> deviceIsConnected() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }
}
