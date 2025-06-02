import 'package:hive/hive.dart';

@HiveType(typeId: 4)
enum BankAccountType {
  @HiveField(0)
  currentAccount,
  @HiveField(1)
  savingsAccount
}

extension BankAccountTypeExtension on BankAccountType {
  String get name {
    switch (this) {
      case BankAccountType.currentAccount:
        return 'Conta Corrente';
      case BankAccountType.savingsAccount:
        return 'Conta Poupança';
      default:
        return '';
    }
  }

  static BankAccountType fromIndex(int index) {
    switch (index) {
      case 0:
        return BankAccountType.currentAccount;
      case 1:
        return BankAccountType.savingsAccount;
      default:
        return BankAccountType.currentAccount;
    }
  }
}
