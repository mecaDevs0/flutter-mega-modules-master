import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:bloc_pattern/src/inject.dart' as Injection;
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mega_flutter_base/mega_base_bloc.dart';

import 'credit_card_bloc.dart';
import 'credit_card_repository.dart';

class CreditCardModule extends ModuleWidget {
  final Widget screen;
  final String? savePath;
  final String? loadPath;
  final String? removePath;

  CreditCardModule({
    required this.screen,
    this.savePath,
    this.loadPath,
    this.removePath,
  });

  @override
  List<Bloc> get blocs => [
        Bloc((i) => CreditCardBloc(
              CreditCardModule.to.getDependency<CreditCardRepository>(),
            )),
      ];

  @override
  List<Dependency> get dependencies => [
        Dependency((i) => Modular.get<MegaBaseBloc>()),
        Dependency((i) => CreditCardRepository(
              savePath: savePath,
              loadPath: loadPath,
              removePath: removePath,
            ))
      ];

  @override
  Widget get view => screen;

  static Injection.Inject get to => Injection.Inject<CreditCardModule>.of();
}
