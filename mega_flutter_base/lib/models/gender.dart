enum Gender { male, female, other }

extension GenderExtension on Gender {
  String get name {
    switch (this) {
      case Gender.male:
        return 'Masculino';
      case Gender.female:
        return 'Feminino';
      case Gender.other:
        return 'Outro';
      default:
        return '';
    }
  }

  int get index {
    switch (this) {
      case Gender.male:
        return 0;
      case Gender.female:
        return 1;
      case Gender.other:
        return 2;
      default:
        return 0;
    }
  }

  String get value {
    switch (this) {
      case Gender.male:
        return 'M';
      case Gender.female:
        return 'F';
      case Gender.other:
        return 'O';
      default:
        return '';
    }
  }
}

class GenderUtils {
  static Gender fromIndex(int index) {
    switch (index) {
      case 0:
        return Gender.male;
      case 1:
        return Gender.female;
      case 2:
        return Gender.other;
      default:
        return Gender.other;
    }
  }

  static Gender fromValue(String index) {
    switch (index) {
      case 'M':
        return Gender.male;
      case 'F':
        return Gender.female;
      case 'O':
        return Gender.other;
      default:
        return Gender.other;
    }
  }
}
