import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart' as Modular;
import 'package:mega_flutter_network/mega_dio.dart';

import 'bank_data_bloc.dart';
import 'bank_data_repository.dart';

class BankDataModule extends ModuleWidget {
  final Widget screen;

  BankDataModule({
    required this.screen,
  });

  @override
  List<Bloc> get blocs => [
        Bloc((i) => BankDataBloc(
              repository: BankDataModule.to.getDependency<BankDataRepository>(),
            )),
      ];

  @override
  List<Dependency> get dependencies => [
        Dependency((i) => BankDataRepository(
              httpClient: Modular.Modular.get<MegaDio>(),
            )),
      ];

  @override
  Widget get view => screen;

  static Inject get to => Inject<BankDataModule>.of();
}
