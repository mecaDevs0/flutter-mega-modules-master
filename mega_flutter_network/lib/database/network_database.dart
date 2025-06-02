import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../environment.dart';
import '../mega_dio.dart';
import '../models/auth_token.dart';

class NetworkDatabase {
  static const _envBox = 'networkEnvironment';
  static const _loginBox = 'loginType';
  static const _pushBox = 'networkPush';
  static const _authBox = 'networkAuth';
  static const _networkTimeOut = 'networkTimeOut';

  static Future<void> configure() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init('${appDocumentDir.path}/hive');
    Hive.registerAdapter(AuthTokenAdapter());
  }

  static saveEnvironment(Environment environment, {String? url}) async {
    final Box box = await Hive.openBox(_envBox);
    await box.clear();
    box.put('environment', environment.index);
    if (url != null) {
      box.put('url', url);
    }

    if (environment != Environment.custom) {
      Modular.get<MegaDio>().changeUrl(environment.api);
    } else {
      Modular.get<MegaDio>().changeUrl(url!);
    }
  }

  static Future<Environment> loadEnvironment() async {
    final Box box = await Hive.openBox(_envBox);
    return EnvironmentUtils.from(box.get('environment') ?? 0);
  }

  static Future<String> loadEnvironmentUrl() async {
    final Box box = await Hive.openBox(_envBox);
    return box.get('url') ?? Environment.prod.base;
  }

  static saveNotificationUserID(String id) async {
    final Box box = await Hive.openBox(_pushBox);
    box.put('userId', id);
  }

  static Future<String> loadNotificationUserID() async {
    final Box box = await Hive.openBox(_pushBox);
    return box.get('userId');
  }

  static saveUser(String document, String password) async {
    final Box box = await Hive.openBox(_authBox);
    await box.clear();
    box.put('document', document);
    box.put('password', password);
  }

  static Future<Map?> loadUser() async {
    final Box box = await Hive.openBox(_authBox);
    final Map user = {};
    if (box.containsKey("document") && box.containsKey("password")) {
      user.addAll({"document": box.get('document')});
      user.addAll({"password": box.get('password')});
      return user;
    }
    return null;
  }

  static saveAuthToken(AuthToken token) async {
    token.expiresIn = DateFormat('dd/MM/yyyy HH:mm:ss')
        .parse(token.expires!)
        .millisecondsSinceEpoch;
    final Box box = await Hive.openBox(_authBox);
    await box.clear();
    box.put('token', token);
  }

  static Future<AuthToken?> loadAuthToken() async {
    final Box box = await Hive.openBox(_authBox);
    if (box.isNotEmpty) {
      return box.get('token');
    }
    return null;
  }

  static saveLogged(bool logged) async {
    final Box box = await Hive.openBox(_loginBox);
    box.put('logged', logged);
  }

  static Future<bool> isLogged() async {
    final Box box = await Hive.openBox(_loginBox);
    return box.get('logged') ?? false;
  }

  static Future<bool> isAuthenticated() async {
    return await loadAuthToken().then((token) async {
      if (token?.accessToken != null && token?.refreshToken != null) {
        final timeExpire =
            DateTime.fromMillisecondsSinceEpoch(token!.expiresIn! * 1000);
        final timeExpireRefresh = timeExpire.add(const Duration(minutes: 115));

        if (timeExpireRefresh.isAfter(DateTime.now())) {
          return true;
        }
      }

      await clean();
      return false;
    });
  }

  static Future<void> clean() async {
    final box = await Hive.openBox(_authBox);
    final loginBox = await Hive.openBox(_loginBox);
    await box.clear();
    await loginBox.clear();
  }

  static saveTimeoutError(bool timeoutError) async {
    final Box box = await Hive.openBox(_networkTimeOut);
    box.put('networkTimeOut', timeoutError);
  }

  static Future<bool> loadTimeoutError() async {
    final Box box = await Hive.openBox(_networkTimeOut);
    return box.get('networkTimeOut') ?? false;
  }

  static Future<void> cleanTimeoutError() async {
    final box = await Hive.openBox(_networkTimeOut);
    await box.clear();
  }
}
