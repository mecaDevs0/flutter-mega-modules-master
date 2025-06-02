import 'package:json_annotation/json_annotation.dart';

part 'credit_card.g.dart';

@JsonSerializable()
class CreditCard {
  String? name;
  String? number;
  int? expMonth;
  int? expYear;
  String? cvv;
  String? flag;
  String? brand;
  String? id;

  CreditCard({
    this.name,
    this.number,
    this.expMonth,
    this.expYear,
    this.cvv,
    this.flag,
    this.brand,
    this.id,
  });

  factory CreditCard.fromJson(Map<String, dynamic> json) =>
      _$CreditCardFromJson(json);

  Map<String, dynamic> toJson() => _$CreditCardToJson(this);
}
