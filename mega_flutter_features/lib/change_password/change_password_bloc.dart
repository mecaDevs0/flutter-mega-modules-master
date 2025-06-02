import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:mega_flutter_base/utils/bloc_utils.dart';
import 'package:rxdart/rxdart.dart';

import 'change_password_repository.dart';

class ChangePasswordBloc extends BlocBase {
  final ChangePasswordRepository _repository;

  ChangePasswordBloc(this._repository);

  final _pop = BehaviorSubject<String>();
  Sink<String> get _popIn => _pop.sink;
  Stream<String> get pop => _pop.stream;

  changePassword({
    String? current,
    required String newPass,
    bool fromForgotPassword = false,
  }) {
    BlocUtils.load(
      action: (_) async {
        final response = await _repository.changePass(
          current: current ?? '',
          newPass: newPass,
          fromForgotPassword: fromForgotPassword,
        );
        _popIn.add(response.message ?? 'Erro ao alterar senha');
      },
    );
  }

  @override
  void dispose() {
    _pop.close();
    super.dispose();
  }
}
