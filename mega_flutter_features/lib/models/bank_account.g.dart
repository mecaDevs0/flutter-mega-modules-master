// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BankAccount _$BankAccountFromJson(Map<String, dynamic> json) => BankAccount(
      accountableName: json['accountableName'] as String?,
      accountableCpf: json['accountableCpf'] as String?,
      bankAccount: json['bankAccount'] as String?,
      bankAgency: json['bankAgency'] as String?,
      bank: json['bank'] as String?,
      bankCode: json['bankCode'] as String?,
      typeAccount: json['typeAccount'] as int?,
      personType: json['personType'] as int?,
      cnpj: json['cnpj'] as String?,
      id: json['id'] as String?,
    );

Map<String, dynamic> _$BankAccountToJson(BankAccount instance) =>
    <String, dynamic>{
      'accountableName': instance.accountableName,
      'accountableCpf': instance.accountableCpf,
      'bankAccount': instance.bankAccount,
      'bankAgency': instance.bankAgency,
      'bank': instance.bank,
      'bankCode': instance.bankCode,
      'typeAccount': instance.typeAccount,
      'personType': instance.personType,
      'cnpj': instance.cnpj,
      'id': instance.id,
    };
