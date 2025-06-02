import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:bloc_pattern/src/inject.dart' as Injection;
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mega_flutter_base/mega_base_bloc.dart';
import 'package:mega_flutter_network/mega_dio.dart';

import 'sms_verification_code_bloc.dart';
import 'sms_verification_code_repository.dart';

class SmsVerificationCodeModule extends ModuleWidget {
  final Widget screen;
  final String sendSmsPath;
  final String validSmsPath;

  SmsVerificationCodeModule({
    required this.screen,
    required this.sendSmsPath,
    required this.validSmsPath,
  })  : assert(sendSmsPath.isNotEmpty),
        assert(validSmsPath.isNotEmpty);

  @override
  List<Bloc> get blocs => [
        Bloc((i) => SmsVerificationCodeBloc(
              SmsVerificationCodeModule.to.getDependency<MegaBaseBloc>(),
              SmsVerificationCodeModule.to
                  .getDependency<SmsVerificationCodeRepository>(),
            )),
      ];

  @override
  List<Dependency> get dependencies => [
        Dependency((i) => Modular.get<MegaBaseBloc>()),
        Dependency((i) => SmsVerificationCodeRepository(
              Modular.get<MegaDio>(),
              sendSmsPath: this.sendSmsPath,
              validSmsPath: this.validSmsPath,
            ))
      ];

  @override
  Widget get view => screen;

  static Injection.Inject get to =>
      Injection.Inject<SmsVerificationCodeModule>.of();
}
