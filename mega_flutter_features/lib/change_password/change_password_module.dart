import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';

import 'change_password_bloc.dart';
import 'change_password_repository.dart';

class ChangePasswordModule extends ModuleWidget {
  final Widget screen;
  final String changePath;

  ChangePasswordModule({
    required this.screen,
    required this.changePath,
  }) : assert(changePath.isNotEmpty);

  @override
  List<Bloc> get blocs => [
        Bloc((i) => ChangePasswordBloc(
              ChangePasswordModule.to.getDependency<ChangePasswordRepository>(),
            )),
      ];

  @override
  List<Dependency> get dependencies => [
        Dependency(
            (i) => ChangePasswordRepository(changePath: this.changePath)),
      ];

  @override
  Widget get view => screen;

  static Inject get to => Inject<ChangePasswordModule>.of();
}
