import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:mega_flutter_base/mega_base_bloc.dart';
import 'package:mega_flutter_base/utils/bloc_utils.dart';
import 'package:rxdart/rxdart.dart';

import 'sms_verification_code_repository.dart';

class SmsVerificationCodeBloc extends BlocBase {
  final MegaBaseBloc _appBloc;
  final SmsVerificationCodeRepository _repository;

  SmsVerificationCodeBloc(this._appBloc, this._repository);

  final _showResend = BehaviorSubject<bool>();
  Sink<bool> get _showResendIn => _showResend.sink;
  Stream<bool> get showResend => _showResend.stream;

  final _pop = BehaviorSubject<bool>();
  Sink<bool> get _popIn => _pop.sink;
  Stream<bool> get pop => _pop.stream;

  sendSmsCode(String phone) async {
    _appBloc.setLoading(true);
    _showResendIn.add(false);

    BlocUtils.load(
      action: (_) async {
        await _repository.sendSms(phone);

        Timer(const Duration(minutes: 1), () {
          if (!_showResend.isClosed) {
            _showResendIn.add(true);
          }
        });
      },
      onError: (e, bloc) {
        bloc.setError(e.message ?? 'Erro ao enviar código');
        _showResendIn.add(true);
      },
    );
  }

  validSms({
    required String code,
    required String phone,
  }) {
    BlocUtils.load(
      action: (_) async {
        await _repository.validCode(code, phone);
        _popIn.add(true);
        _popIn.add(false);
      },
    );
  }

  @override
  void dispose() {
    _showResend.close();
    _pop.close();
    super.dispose();
  }
}
