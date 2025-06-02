import 'dart:convert';
import 'dart:math';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mega_flutter_base/mega_base_bloc.dart';
import 'package:mega_flutter_base/utils/bloc_utils.dart';
import 'package:mega_flutter_base/utils/formats.dart';
import 'package:mega_flutter_network/models/mega_response.dart';
import 'package:mega_flutter_services/google_signin/google_signin.dart';
import 'package:mega_flutter_services/google_signin/google_user.dart';
import 'package:megaleios_flutter_localization/megaleios_flutter_localization.dart';
import 'package:rxdart/subjects.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'login_provider_type.dart';
import 'login_repository.dart';

class LoginBloc extends BlocBase {
  final MegaBaseBloc _appBloc;
  final LoginRepository _repository;
  late LocalAuthentication auth;
  final storage = const FlutterSecureStorage();

  LoginBloc(this._appBloc, this._repository) {
    auth = LocalAuthentication();
    storage.read(key: 'authenticated').then(
      (value) async {
        if (value != null && value == 'true') {
          await callLocalAuth();
        }
      },
    );
  }
  final _pop = BehaviorSubject<bool>();
  Sink<bool> get _popIn => _pop.sink;
  Stream<bool> get pop => _pop.stream;

  Future<void> authenticate({
    required String document,
    required String password,
  }) async {
    BlocUtils.load(action: (_) async {
      String doc = Formats.cpfMaskFormatter.unmaskText(document);
      doc = Formats.cnpjMaskFormatter.unmaskText(document);
      await _repository.authenticate(doc, password);
      final isAuthenticated = await storage.read(key: 'authenticated');
      if (isAuthenticated != null && isAuthenticated == 'true') {
        await storage.write(key: 'doc', value: doc);
        await storage.write(key: 'password', value: password);
        await storage.write(key: 'authenticated', value: 'true');
      }
      await localAuth(
        doc: doc,
        password: password,
      );
      _popIn.add(true);
    }, onError: (e, bloc) async {
      bloc.setError(e.message ?? 'Erro ao autenticar');
    });
  }

  Future<void> localAuth({
    required String doc,
    required String password,
  }) async {
    final value = await storage.read(key: 'authenticated');
    if (value != null && value == 'true') {
      return;
    }
    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    final bool canAuthenticate =
        canAuthenticateWithBiometrics || await auth.isDeviceSupported();
    if (!canAuthenticate) {
      return;
    }
    final List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();
    if (availableBiometrics.isEmpty) {
      return;
    }
    final authenticated = await auth.authenticate(
      localizedReason: "Autentique-se para acessar o app",
      options: const AuthenticationOptions(
        stickyAuth: true,
      ),
    );
    if (authenticated) {
      await storage.write(key: 'doc', value: doc);
      await storage.write(key: 'password', value: password);
      await storage.write(key: 'authenticated', value: 'true');
    }
  }

  Future<void> callLocalAuth() async {
    try {
      final authenticated = await auth.authenticate(
        localizedReason: "Autentique-se para acessar o app",
        options: const AuthenticationOptions(
          stickyAuth: true,
        ),
      );
      if (authenticated) {
        final document = await storage.read(key: 'doc');
        final password = await storage.read(key: 'password');
        await authenticate(document: document!, password: password!);
      }
    } on Exception catch (_) {
      await storage.write(key: 'authenticated', value: 'false');
    }
  }

  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> authenticateByEmail({
    required String email,
    required String password,
  }) async {
    BlocUtils.load(action: (_) async {
      await _repository.authenticateByEmail(email, password);
      _popIn.add(true);
    }, onError: (e, bloc) async {
      bloc.setError(e.message ?? 'Erro ao autenticar');
    });
  }

  Future<void> appleLogin(
    BuildContext context, {
    required Function(AuthorizationCredentialAppleID) onUserNotFound,
  }) async {
    _appBloc.setLoading(true);
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);
    late AuthorizationCredentialAppleID credential;

    try {
      credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );
      await _repository.authenticateExternalLogin(
        credential.userIdentifier!,
        LoginProviderType.apple,
      );
      _popIn.add(true);
    } on Exception catch (_) {
      _appBloc.setError(
          MegaleiosLocalizations.of(context)!.translate('apple_login_error'));
    } on MegaResponse catch (_) {
      onUserNotFound(credential);
    } on Error catch (_) {
      _appBloc.setError(
          MegaleiosLocalizations.of(context)!.translate('apple_login_error'));
    } finally {
      _appBloc.setLoading(false);
    }
  }

  Future<void> googleLogin(
    BuildContext context, {
    required Function(GoogleUser) onUserNotFound,
  }) async {
    _appBloc.setLoading(true);
    late GoogleUser googleUser;
    try {
      googleUser = await MegaGoogleSignIn().signInWithGoogle();
      await _repository.authenticateExternalLogin(
        googleUser.uid,
        LoginProviderType.google,
      );
      _popIn.add(true);
    } on Exception catch (_) {
      _appBloc.setError(
          MegaleiosLocalizations.of(context)!.translate('google_login_error'));
    } on MegaResponse catch (_) {
      onUserNotFound(googleUser);
    } on Error catch (_) {
      _appBloc.setError(
          MegaleiosLocalizations.of(context)!.translate('google_login_error'));
    } finally {
      _appBloc.setLoading(false);
    }
  }

  @override
  void dispose() {
    _pop.close();
    super.dispose();
  }

  Future<bool> checkEmail(String email) async {
    bool hasEmailRegistered = false;
    if (email.isNotEmpty) {
      try {
        await _repository.checkAll(email);
      } on MegaResponse catch (_) {
        hasEmailRegistered = true;
      }
    }
    return hasEmailRegistered;
  }
}
