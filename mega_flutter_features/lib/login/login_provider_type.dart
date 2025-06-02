enum LoginProviderType {
  password,
  facebook,
  apple,
  google,
}

extension LoginProviderTypeExtension on LoginProviderType {
  int get index {
    switch (this) {
      case LoginProviderType.password:
        return 0;
      case LoginProviderType.facebook:
        return 1;
      case LoginProviderType.apple:
        return 2;
      case LoginProviderType.google:
        return 3;
      default:
        return 0;
    }
  }
}
