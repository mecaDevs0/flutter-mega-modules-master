import 'package:flutter_modular/flutter_modular.dart';

import 'models/base_endpoints.dart';

enum Environment { prod, hom, dev, custom }

extension EnvironmentExtensions on Environment {
  String get base {
    return Modular.get<BaseEndpoints>().fromEnv(this);
  }

  String get name {
    switch (this) {
      case Environment.prod:
        return 'PROD';
      case Environment.hom:
        return 'HOM';
      case Environment.dev:
        return 'DEV';
      case Environment.custom:
        return 'CUSTOM';
      default:
        return '';
    }
  }

  int get index {
    switch (this) {
      case Environment.prod:
        return 0;
      case Environment.hom:
        return 1;
      case Environment.dev:
        return 2;
      case Environment.custom:
        return 3;
      default:
        return 0;
    }
  }

  String get abbreviation {
    switch (this) {
      case Environment.prod:
        return 'P';
      case Environment.hom:
        return 'H';
      case Environment.dev:
        return 'D';
      case Environment.custom:
        return 'C';
      default:
        return '';
    }
  }

  String get api {
    return '${this.base}/api/v1';
  }

  String get file {
    return '${this.base}/content/files/';
  }

  String get images {
    return '${this.base}/content/upload/';
  }

  String get upload {
    return '/File/Upload';
  }

  String get uploads {
    return '/File/Uploads';
  }
}

class EnvironmentUtils {
  static Environment from(int index) {
    switch (index) {
      case 0:
        return Environment.prod;
      case 1:
        return Environment.hom;
      case 2:
        return Environment.dev;
      case 3:
        return Environment.custom;
      default:
        return Environment.prod;
    }
  }
}
