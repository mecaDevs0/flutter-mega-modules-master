import '../environment.dart';

class BaseEndpoints {
  final String prod;
  final String hom;
  final String dev;
  final String auth;
  final String? custom;

  BaseEndpoints({
    required this.prod,
    required this.hom,
    required this.dev,
    required this.auth,
    this.custom,
  });

  String fromEnv(Environment env) {
    switch (env) {
      case Environment.prod:
        return prod;
      case Environment.hom:
        return hom;
      case Environment.dev:
        return dev;
      case Environment.custom:
        return custom ?? '';
      default:
        return prod;
    }
  }
}
