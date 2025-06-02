import 'package:dio/dio.dart';
import 'package:mega_flutter_network/mega_dio.dart';
import 'package:mega_flutter_network/models/mega_response.dart';

class ForgotPasswordRepository {
  final MegaDio _dio;
  final String forgotPassPath;
  final String maskedInfoPath;
  final String forgotPassKey;

  ForgotPasswordRepository(
    this._dio, {
    required this.forgotPassPath,
    required this.maskedInfoPath,
    this.forgotPassKey = 'document',
  })  : assert(forgotPassPath.isNotEmpty),
        assert(forgotPassKey.isNotEmpty);

  Future<MegaResponse> forgotPassword(String value) async {
    return await _dio.post(
      forgotPassPath,
      data: {forgotPassKey: value},
    );
  }

  Future getMaskedInfo(String value) async {
    return await Dio().get(
      "${_dio.baseUrl}$maskedInfoPath/$value?masked=true",
    );
  }
}
