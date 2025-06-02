import 'package:bloc_pattern/bloc_pattern.dart';
// ignore: implementation_imports
import 'package:bloc_pattern/src/inject.dart' as Injection;
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mega_flutter_base/mega_base_bloc.dart';

import 'notifications_bloc.dart';
import 'notifications_repository.dart';

class NotificationsModule extends ModuleWidget {
  final Widget screen;
  final String? loadPath;
  final String? setReadPath;
  final String? removePath;

  NotificationsModule({
    required this.screen,
    this.loadPath,
    this.setReadPath,
    this.removePath,
  });

  @override
  List<Bloc> get blocs => [
        Bloc((i) => NotificationsBloc(
              NotificationsModule.to.getDependency<NotificationsRepository>(),
            )),
      ];

  @override
  List<Dependency> get dependencies => [
        Dependency((i) => Modular.get<MegaBaseBloc>()),
        Dependency((i) => NotificationsRepository(
              loadPath: loadPath,
              setReadPath: setReadPath,
              removePath: removePath,
            )),
      ];

  @override
  Widget get view => screen;

  static Injection.Inject get to => Injection.Inject<NotificationsModule>.of();
}
