import 'package:flutter_modular/flutter_modular.dart';
import 'package:mega_flutter_network/mega_dio.dart';
import 'package:mega_flutter_network/models/mega_response.dart';

import '../models/credit_card.dart';

class CreditCardRepository {
  final String? savePath;
  final String? loadPath;
  final String? removePath;

  CreditCardRepository({
    this.savePath,
    this.loadPath,
    this.removePath,
  });

  Future<List<CreditCard>> loadCards() async {
    if (this.loadPath == null || this.loadPath!.isEmpty) {
      throw UnimplementedError();
    }

    final response = await Modular.get<MegaDio>().get(this.loadPath!);
    return (response.data as List).map((e) => CreditCard.fromJson(e)).toList();
  }

  Future<MegaResponse> saveCard(CreditCard card) async {
    if (this.savePath == null || this.savePath!.isEmpty) {
      throw UnimplementedError();
    }

    return await Modular.get<MegaDio>()
        .post(this.savePath!, data: card.toJson());
  }

  Future<MegaResponse> removeCard({required String id}) async {
    if (this.removePath == null || this.removePath!.isEmpty) {
      throw UnimplementedError();
    }

    return await Modular.get<MegaDio>().post('${this.removePath}$id');
  }
}
