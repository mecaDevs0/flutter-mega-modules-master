import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'database/network_database.dart';
import 'mega_dio.dart';
import 'models/auth_token.dart';
import 'models/mega_response.dart';
import 'request_retirer.dart';

class AuthorizationInterceptor extends InterceptorsWrapper {
  final String authUrl;
  final String defaultUrl;
  final String anonymousAuth;
  final MegaDio httpClient;
  final Dio dio;
  AuthToken? _token;

  AuthorizationInterceptor(
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

    //REVALIDATE TOKEN
    if (_token?.expiresIn != null) {
      final timeExpire =
          DateTime.fromMillisecondsSinceEpoch(_token!.expiresIn!);
      final timeExpireRefresh = timeExpire.add(const Duration(minutes: 115));

      if (timeExpire.isBefore(DateTime.now().add(const Duration(minutes: 1)))) {
        if (!timeExpireRefresh.isBefore(DateTime.now())) {
          try {
            await Future.delayed(const Duration(seconds: 1));
            _token = await _refreshToken(_token!);
          } on MegaResponse catch (_) {
            if (anonymousAuth.isNotEmpty) {
              _token = await _anonymousAuth(options);
            }
          }

          if (_token!.accessToken != null) {
            await NetworkDatabase.saveAuthToken(_token!);
          } else {
            await _anonymousAuth(options);
            // Reauthenticate
            await _reauthenticate();
            // Modular.to.pop();
            // Modular.to.pushNamedAndRemoveUntil('/home', (route) => false);
          }
        } else {
          await _unauthorized(options);
        }
      }
    } else {
      await _anonymousAuth(options);
    }

    if (_token?.accessToken != null && _token!.accessToken != null) {
      options.headers.remove('Authorization');
      options.headers.putIfAbsent(
        'Authorization',
        () => 'bearer ${_token!.accessToken!}',
      );
      options.headers.putIfAbsent('expires', () => _token!.expires!);
    }

    handler.next(options);
  }

  @override
  Future onError(DioError err, ErrorInterceptorHandler handler) async {
    final responseCompleter = Completer();
    if (err.response?.statusCode == HttpStatus.unauthorized) {
      await Future.delayed(const Duration(seconds: 1));
      _refreshToken(_token!).then((token) async {
        if (token.accessToken != null) {
          responseCompleter.complete(
            RequestRetirer(dio: dio).scheduleRequestRetry(err.requestOptions),
          );
        } else {
          await _anonymousAuth(err.requestOptions);
          Modular.to.pop();
          Modular.to.pushNamedAndRemoveUntil('/home', (route) => false);
          handler.next(err);
        }
      });
    } else {
      handler.next(err);
    }

    return responseCompleter.future;
  }

  void printWrapped(String text) {
    final pattern = RegExp('.{1,800}');
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
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

  Future<AuthToken?> _anonymousAuth(RequestOptions options) async {
    if (anonymousAuth.isNotEmpty) {
      final response = await MegaDio.noRefresh(
        defaultUrl,
      ).get(anonymousAuth);

      final token = AuthToken.fromJson(response.data);
      await NetworkDatabase.saveAuthToken(token);
      await NetworkDatabase.saveLogged(false);
      return token;
    } else {
      await _unauthorized(options);
      return null;
    }
  }

  Future<AuthToken?> _reauthenticate() async {
    final Map<dynamic, dynamic>? user = await NetworkDatabase.loadUser();
    if (user!["document"] != null && user["password"] != null) {
      try {
        final response =
            await MegaDio.noRefresh(defaultUrl).post(authUrl, data: {
          'document': user["document"],
          'password': user["password"],
        });

        final newToken = AuthToken.fromJson(response.data);
        await NetworkDatabase.saveAuthToken(newToken);

        return newToken;
      } on MegaResponse catch (_) {
        return AuthToken();
      }
    } else {
      Modular.to.pop();
      Modular.to.pushNamedAndRemoveUntil('/home', (route) => false);
    }
    return null;
  }

  Future<AuthToken> _refreshToken(AuthToken token) async {
    try {
      final response = await MegaDio.noRefresh(defaultUrl)
          .post(authUrl, data: {'refreshToken': token.refreshToken});

      final newToken = AuthToken.fromJson(response.data);
      await NetworkDatabase.saveAuthToken(newToken);

      return newToken;
    } on MegaResponse catch (_) {
      return AuthToken();
    }
  }

  Future<void> _unauthorized(RequestOptions options) async {
    options.cancelToken!.cancel();
    await NetworkDatabase.clean();
  }
}
