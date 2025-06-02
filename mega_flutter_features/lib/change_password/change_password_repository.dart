import 'package:flutter_modular/flutter_modular.dart';
import 'package:mega_flutter_network/mega_dio.dart';
import 'package:mega_flutter_network/models/mega_response.dart';

class ChangePasswordRepository {
  final String changePath;
  ChangePasswordRepository({
    required this.changePath,
  }) : assert(changePath.isNotEmpty);

  Future<MegaResponse> changePass({
    required String current,
    required String newPass,
    required bool fromForgotPassword,
  }) async {
    return await Modular.get<MegaDio>().post(
      this.changePath,
      data: {
        'currentPassword': current,
        'newPassword': newPass,
        'fromForgotPassword': fromForgotPassword,
      },
    );
  }
}
