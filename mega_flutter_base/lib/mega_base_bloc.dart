import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';

class MegaBaseBloc extends BlocBase {
  final _isLoading = BehaviorSubject<bool>();
  Sink<bool> get _isLoadingIn => _isLoading.sink;
  Stream<bool> get isLoading => _isLoading.stream;

  final _isLoadingList = BehaviorSubject<bool>.seeded(false);
  Sink<bool> get _isLoadingListIn => _isLoadingList.sink;
  Stream<bool> get isLoadingList => _isLoadingList.stream;

  final _isListenerConnectionState = BehaviorSubject<bool>.seeded(true);
  Sink<bool> get _isListenerConnectionStateIn =>
      _isListenerConnectionState.sink;
  Stream<bool> get isListenerConnectionStateOut =>
      _isListenerConnectionState.stream;

  final _error = BehaviorSubject<String?>();
  Sink<String?> get _errorIn => _error.sink;
  Stream<String?> get error => _error.stream;

  final _message = BehaviorSubject<String?>();
  Sink<String?> get _messageIn => _message.sink;
  Stream<String?> get message => _message.stream;

  final _isShowModalVersion = BehaviorSubject<bool>.seeded(false);
  Sink<bool> get _isShowModalVersionIn => _isShowModalVersion.sink;
  Stream<bool> get isShowModalVersion => _isShowModalVersion.stream;

  final _hasRequestError = BehaviorSubject<bool>.seeded(false);
  Sink<bool> get _hasRequestErrorIn => _hasRequestError.sink;
  Stream<bool> get hasRequestError => _hasRequestError.stream;
  bool get hasRequestErrorValue => _hasRequestError.value;

  final _clearPreviousConfig = BehaviorSubject<bool>.seeded(false);
  Sink<bool> get _clearPreviousConfigIn => _clearPreviousConfig.sink;
  Stream<bool> get clearPreviousConfigOut => _clearPreviousConfig.stream;
  bool get isClearPreviousConfig => _clearPreviousConfig.value;

  String versionMessage = '';

  void setLoading(bool loading, {bool list = false}) {
    if (list) {
      _isLoadingListIn.add(loading);
    } else {
      _isLoadingIn.add(loading);
    }
  }

  void setHasRequestError(bool value) {
    _hasRequestErrorIn.add(value);
  }

  void resetLoading() {
    _isLoadingListIn.add(false);
    _isLoadingIn.add(false);
  }

  void setIsListenerConnectionState(bool value) {
    _isListenerConnectionStateIn.add(value);
  }

  void setError(String error) {
    resetLoading();

    _errorIn.add(error);
    _errorIn.add(null);
  }

  void showModalVersion() {
    if (!_isShowModalVersion.value) {
      _isShowModalVersionIn.add(true);
    }
  }

  void hideModalVersion() {
    _isShowModalVersionIn.add(false);
  }

  void setMessage(String message) {
    resetLoading();
    _messageIn.add(message);
    _messageIn.add(null);
  }

  void clearPreviousConfig(bool value) {
    _clearPreviousConfigIn.add(value);
  }

  @override
  void dispose() {
    _isLoading.close();
    _isLoadingList.close();
    _error.close();
    _message.close();
    _isShowModalVersion.close();
    super.dispose();
  }
}
