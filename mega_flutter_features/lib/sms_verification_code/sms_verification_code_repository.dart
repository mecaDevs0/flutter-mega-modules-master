import 'package:mega_flutter_network/mega_dio.dart';

class SmsVerificationCodeRepository {
  final MegaDio _dio;
  final String sendSmsPath;
  final String validSmsPath;

  SmsVerificationCodeRepository(
    this._dio, {
    required this.sendSmsPath,
    required this.validSmsPath,
  })  : assert(sendSmsPath.isNotEmpty),
        assert(validSmsPath.isNotEmpty);

  Future<void> sendSms(String cellphone) async {
    await _dio.post(this.sendSmsPath, data: {'cellPhone': cellphone});
  }

  Future<void> validCode(String code, String cellphone) async {
    await _dio.post(
      this.validSmsPath,
      data: {'code': code, 'cellPhone': cellphone},
    );
  }
}
