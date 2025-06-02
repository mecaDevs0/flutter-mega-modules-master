import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:mega_flutter_base/utils/bloc_utils.dart';

import '../models/bank_account.dart';
import 'bank_data_repository.dart';

class BankDataBloc extends BlocBase {
  final BankDataRepository _repository;
  List<BankAccount> banks = [];

  BankDataBloc({
    required BankDataRepository repository,
  }) : _repository = repository;

  Future<void> loadBanks() async {
    await BlocUtils.load(action: (_) async {
      banks = await _repository.loadBanks();
    });
  }
}
