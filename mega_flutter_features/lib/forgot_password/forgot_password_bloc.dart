import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:mega_flutter_base/utils/bloc_utils.dart';

import 'forgot_password_repository.dart';

class ForgotPasswordBloc extends BlocBase {
  final ForgotPasswordRepository _repository;

  ForgotPasswordBloc(this._repository);

  Future<bool> forgotPassword({required String email}) async {
    bool hasError = false;
    await BlocUtils.load(
      action: (bloc) async {
        await _repository.forgotPassword(email);
      },
      onError: (e, appBloc) {
        appBloc.setError(e.message ?? "Erro ao enviar email");
        hasError = true;
      },
    );
    return hasError;
  }

  Future<bool> getMaskedInfo(String cpfCnpj) async {
    bool hasError = false;
    await BlocUtils.load(
      action: (bloc) async {
        final response = await _repository
            .getMaskedInfo(cpfCnpj.replaceAll(".", "").replaceAll("-", ""));
        final Map valueMap = jsonDecode(response.toString());
        print(response);
        if (valueMap["email"] != "") {
          bloc.setMessage("Verifique seu email: ${valueMap["email"]}");
        } else if (valueMap["phone"] != "") {
          bloc.setMessage("Verifique seu celular: ${valueMap["phone"]}");
        }
      },
      onError: (e, appBloc) {
        appBloc.setError(e.message ?? 'Erro ao enviar email');
        hasError = true;
      },
    );
    return hasError;
  }
}
