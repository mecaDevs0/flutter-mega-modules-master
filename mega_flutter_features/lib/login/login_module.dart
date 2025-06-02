import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:bloc_pattern/src/inject.dart' as Injection;
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mega_flutter_base/mega_base_bloc.dart';
import 'package:mega_flutter_network/mega_dio.dart';

import 'login_bloc.dart';
import 'login_repository.dart';

class LoginModule extends ModuleWidget {
  final Widget screen;
  final String loginPath;

  LoginModule({
    required this.screen,
    required this.loginPath,
  });

  @override
  List<Bloc> get blocs => [
        Bloc((i) => LoginBloc(
              LoginModule.to.getDependency<MegaBaseBloc>(),
              LoginModule.to.getDependency<LoginRepository>(),
            )),
      ];

  @override
  List<Dependency> get dependencies => [
        Dependency((i) => Modular.get<MegaBaseBloc>()),
        Dependency((i) => LoginRepository(
              MegaDio.noRefresh(
                Modular.get<MegaDio>().baseUrl,
              ),
              loginPath: loginPath,
            ))
      ];

  @override
  Widget get view => screen;

  static Injection.Inject get to => Injection.Inject<LoginModule>.of();
}
