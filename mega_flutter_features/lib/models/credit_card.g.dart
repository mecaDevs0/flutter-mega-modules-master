// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreditCard _$CreditCardFromJson(Map<String, dynamic> json) => CreditCard(
      name: json['name'] as String?,
      number: json['number'] as String?,
      expMonth: json['expMonth'] as int?,
      expYear: json['expYear'] as int?,
      cvv: json['cvv'] as String?,
      flag: json['flag'] as String?,
      brand: json['brand'] as String?,
      id: json['id'] as String?,
    );

Map<String, dynamic> _$CreditCardToJson(CreditCard instance) =>
    <String, dynamic>{
      'name': instance.name,
      'number': instance.number,
      'expMonth': instance.expMonth,
      'expYear': instance.expYear,
      'cvv': instance.cvv,
      'flag': instance.flag,
      'brand': instance.brand,
      'id': instance.id,
    };
