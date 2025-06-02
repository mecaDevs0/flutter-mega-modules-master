enum AccountType { currentAccount, savingsAccount, paymentAccount }

extension AccountTypeExtension on AccountType {
  String get name {
    switch (this) {
      case AccountType.currentAccount:
        return 'Conta corrente';
      case AccountType.savingsAccount:
        return 'Conta poupança';
      case AccountType.paymentAccount:
        return 'Conta pagamento';
      default:
        return '';
    }
  }
}
