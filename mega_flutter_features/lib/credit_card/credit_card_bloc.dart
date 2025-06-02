import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:mega_flutter_base/utils/bloc_utils.dart';
import 'package:rxdart/rxdart.dart';

import '../models/credit_card.dart';
import 'credit_card_repository.dart';

class CreditCardBloc extends BlocBase {
  final CreditCardRepository _repository;
  CreditCard card = CreditCard();

  CreditCardBloc(this._repository);

  final _cards = BehaviorSubject<List<CreditCard>>.seeded([]);
  List<CreditCard> get cardsList => _cards.value;
  Sink<List<CreditCard>> get _cardsIn => _cards.sink;
  Stream<List<CreditCard>> get cards => _cards.stream;

  final _pop = BehaviorSubject<bool>();
  Sink<bool> get _popIn => _pop.sink;
  Stream<bool> get pop => _pop.stream;

  Future<void> saveCard() async {
    BlocUtils.load(
      action: (_) async {
        await _repository.saveCard(card);
        _popIn.add(true);
      },
      onError: (error, bloc) async {
        bloc.setError(error.message ?? 'Erro ao salvar cartão');
      },
    );
  }

  Future<void> removeCard(String id) async {
    BlocUtils.load(
      action: (_) async {
        await _repository.removeCard(id: id);
        await loadCards();
      },
      onError: (error, bloc) async {
        bloc.setError(error.message ?? 'Erro ao remover cartão');
      },
    );
  }

  Future<void> loadCards() async {
    BlocUtils.load(
      showLoadingList: true,
      action: (_) async {
        final cards = await _repository.loadCards();
        _cardsIn.add(cards);
      },
      onError: (error, bloc) async {
        bloc.setError(error.message ?? 'Erro ao carregar cartões');
      },
    );
  }
}
