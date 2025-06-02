import 'package:json_annotation/json_annotation.dart';

part 'bank_account.g.dart';

@JsonSerializable()
class BankAccount {
  String? accountableName;
  String? accountableCpf;
  String? bankAccount;
  String? bankAgency;
  String? bank;
  String? bankCode;
  int? typeAccount;
  int? personType;
  String? cnpj;
  String? id;

  BankAccount({
    this.accountableName,
    this.accountableCpf,
    this.bankAccount,
    this.bankAgency,
    this.bank,
    this.bankCode,
    this.typeAccount,
    this.personType,
    this.cnpj,
    this.id,
  });

  factory BankAccount.fromJson(Map<String, dynamic> json) =>
      _$BankAccountFromJson(json);

  Map<String, dynamic> toJson() => _$BankAccountToJson(this);

  BankAccount.fromBankJson(Map<String, dynamic> json) {
    bank = json['name'];
    bankCode = json['code'];
    id = json['id'];
  }
}
