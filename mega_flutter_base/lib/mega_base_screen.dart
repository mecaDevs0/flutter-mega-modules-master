import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:megaleios_flutter_localization/megaleios_flutter_localization.dart';

import 'mega_base_bloc.dart';
import 'widgets/no_network_connection.dart';
import 'widgets/request_error.dart';

abstract class MegaBaseScreen extends StatefulWidget {
  const MegaBaseScreen({Key? key}) : super(key: key);
  String get screenName => this.runtimeType.toString();
  String? get screenNameLocalized => '';

  bool get hasBackAction => true;
  bool get hasTransparentToolbar => false;
  bool get hasToolbar => true;
  bool get hasFloatingActionButton => true;
  bool get safeArea => true;
  static const String screenTitleTag = 'screen_title';
}

abstract class MegaBaseScreenState<Page extends MegaBaseScreen>
    extends State<Page> {}

mixin MegaBaseScreenMixin<Page extends MegaBaseScreen>
    on MegaBaseScreenState<Page> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  List<Widget> actions = [];
  bool _hasNetworkAccess = true;
  bool _isCheckingConnection = false;

  MegaBaseBloc appBloc = Modular.get<MegaBaseBloc>();

  @override
  void initState() {
    super.initState();

    Connectivity().onConnectivityChanged.listen((result) {
      if (mounted) {
        setState(() {
          _hasNetworkAccess = result != ConnectivityResult.none;
        });
      }
    });

    appBloc.error.listen((value) {
      if (value != null && value.trim().isNotEmpty && mounted) {
        if (ModalRoute.of(context)!.isCurrent) {
          final snackBar = SnackBar(
            content: Text(
              value,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }
    });

    appBloc.message.listen((value) {
      if (value != null && value.trim().isNotEmpty && mounted) {
        if (ModalRoute.of(context)!.isCurrent) {
          final snackBar = SnackBar(
              content: Text(
                value,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Colors.white),
              ),
              backgroundColor: Colors.black);
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }
    });

    verifyConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: appBloc.hasRequestError,
      initialData: false,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!) {
          return RequestError(
            appBloc: appBloc,
          );
        }
        return StreamBuilder<bool>(
          stream: appBloc.isLoading,
          initialData: false,
          builder: (context, isLoading) {
            return StreamBuilder<bool>(
              stream: appBloc.isListenerConnectionStateOut,
              builder: (context, isListenerConnectionStateOut) {
                if (!_hasNetworkAccess && isListenerConnectionStateOut.data!) {
                  return NoNetworkConnection(
                    onTryAgain: () {
                      verifyConnectivity(showError: true);
                    },
                    isCheckingConnection: _isCheckingConnection,
                  );
                }
                if (isLoading.data!) {
                  FocusScope.of(context).requestFocus(FocusNode());
                }

                return buildScreenWithLoading(isLoading.data!);
              },
            );
          },
        );
      },
    );
  }

  Widget buildScreenWithLoading(bool isLoading) {
    return Stack(
      children: [
        buildScreen(context),
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ),
            ),
          ),
      ],
    );
  }

  Widget buildScreen(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: widget.hasToolbar ? buildAppBar() : null,
      body: widget.safeArea ? SafeArea(child: body(context)) : body(context),
      floatingActionButton:
          widget.hasFloatingActionButton ? buildFloatingActionButton() : null,
    );
  }

  Widget body(BuildContext context) => Container();

  PreferredSize buildAppBar({String? title}) {
    String screenTitle = title ?? widget.screenName;

    if (widget.screenNameLocalized != null && title == null)
      screenTitle = MegaleiosLocalizations.of(context)!
          .translate(widget.screenNameLocalized!);

    return PreferredSize(
      preferredSize: AppBar().preferredSize,
      child: Hero(
        tag: 'megaleios-app-bar',
        transitionOnUserGestures: true,
        child: AppBar(
            backgroundColor: widget.hasTransparentToolbar
                ? Colors.transparent
                : Theme.of(context).appBarTheme.backgroundColor,
            elevation: 0,
            leading: widget.hasBackAction
                ? Center(
                    child: IconButton(
                        icon: FaIcon(
                          FontAwesomeIcons.chevronLeft,
                          size: Theme.of(context).appBarTheme.iconTheme!.size,
                        ),
                        onPressed: () => Navigator.of(context).pop()))
                : Container(),
            centerTitle: true,
            title: Text(
              screenTitle,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).appBarTheme.iconTheme!.color,
                  ),
              maxLines: 1,
            ),
            actions: actions),
      ),
    );
  }

  Widget buildFloatingActionButton() => Container();

  Future<void> verifyConnectivity({bool showError = false}) async {
    _isCheckingConnection = true;
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _hasNetworkAccess = connectivityResult != ConnectivityResult.none;
      _isCheckingConnection = false;
    });
    if (showError && !_hasNetworkAccess) {
      final snackBar = SnackBar(
        content: Text(
          'Sem conexão com a internet',
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  openDrawer() {
    if (!scaffoldKey.currentState!.isDrawerOpen) {
      scaffoldKey.currentState!.openDrawer();
    }
  }
}
