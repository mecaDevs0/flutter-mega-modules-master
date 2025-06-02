import 'package:bloc_pattern/bloc_pattern.dart';
// ignore: implementation_imports
import 'package:bloc_pattern/src/inject.dart' as Injection;
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mega_flutter_base/mega_base_bloc.dart';
import 'package:mega_flutter_network/mega_dio.dart';
import 'package:mega_flutter_network/models/base_endpoints.dart';

import 'forgot_password_bloc.dart';
import 'forgot_password_repository.dart';

class ForgotPasswordModule extends ModuleWidget {
  final Widget screen;
  final String forgotPassPath;
  final String maskedInfoPath;
  final String propBody;

  ForgotPasswordModule({
    required this.screen,
    required this.forgotPassPath,
    required this.maskedInfoPath,
    this.propBody = 'document',
  }) : assert(forgotPassPath.isNotEmpty);

  @override
  List<Bloc> get blocs => [
        Bloc((i) => ForgotPasswordBloc(
              ForgotPasswordModule.to.getDependency<ForgotPasswordRepository>(),
            )),
      ];

  @override
  List<Dependency> get dependencies => [
        Dependency((i) => Modular.get<MegaBaseBloc>()),
        Dependency((i) => ForgotPasswordRepository(
            MegaDio.noRefresh(
              Modular.get<BaseEndpoints>().prod,
            ),
            forgotPassPath: this.forgotPassPath,
            maskedInfoPath: this.maskedInfoPath,
            forgotPassKey: propBody))
      ];

  @override
  Widget get view => screen;

  static Injection.Inject get to => Injection.Inject<ForgotPasswordModule>.of();
}
