enum PixType { cpf, cnpj, email, phone }

extension PixTypeExtension on PixType {
  String get name {
    switch (this) {
      case PixType.cpf:
        return 'CPF';
      case PixType.cnpj:
        return 'CNPJ';
      case PixType.email:
        return 'E-mail';
      case PixType.phone:
        return 'Telefone';
      default:
        return '';
    }
  }
}
