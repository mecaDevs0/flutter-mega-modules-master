import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mega_flutter_network/models/mega_response.dart';

import '../mega_base_bloc.dart';

class BlocUtils {
  static load({
    bool showLoading = true,
    bool showLoadingList = false,
    required Function(MegaBaseBloc) action,
    Function(MegaResponse, MegaBaseBloc)? onError,
  }) async {
    final appBloc = Modular.get<MegaBaseBloc>();
    final hasConnection = await Connectivity().checkConnectivity();

    if (showLoading && !showLoadingList) {
      appBloc.setLoading(true);
    }
    if (showLoadingList) {
      appBloc.setLoading(true, list: true);
    }

    try {
      await action(appBloc);
    } on MegaResponse catch (e) {
      if (hasConnection == ConnectivityResult.none) {
        return;
      }
      if (e.statusCode! >= 500 && e.statusCode! < 600) {
        appBloc.setHasRequestError(true);
        return;
      }
      if (e.statusCode == 412 && onError == null) {
        appBloc.versionMessage = e.message ??
            'Esta versão não pode realizar esta ação. Atualize o app e tente novamente.';
        appBloc.showModalVersion();
        return;
      }
      if (onError != null) {
        await onError(e, appBloc);
      } else {
        appBloc.setError(e.message ?? 'Erro desconhecido');
      }
    } finally {
      if (showLoading) {
        appBloc.resetLoading();
      }
    }
  }
}
