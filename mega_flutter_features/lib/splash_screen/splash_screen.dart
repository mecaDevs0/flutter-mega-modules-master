import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:mega_flutter_base/mega_base_screen.dart';
import 'package:mega_flutter_network/mega_dio.dart';

class SplashScreen extends MegaBaseScreen {
  static const routeName = '/';

  @override
  bool get hasToolbar => false;

  final Color? backgroundColor;
  final String? imagePath;
  final String? backgroundimagePath;
  final double heightRatio;
  final double widthRatio;
  final int dismissTime;
  final String? route;
  final Function(BuildContext)? onRoute;

  const SplashScreen({
    this.imagePath,
    this.route,
    this.onRoute,
    this.backgroundColor,
    this.backgroundimagePath,
    this.heightRatio = 0.3,
    this.widthRatio = 0.8,
    this.dismissTime = 1,
  })  : assert(route != null && onRoute == null ||
            onRoute != null && route == null),
        assert(heightRatio > 0 && heightRatio <= 1),
        assert(widthRatio > 0 && widthRatio <= 1);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends MegaBaseScreenState<SplashScreen>
    with MegaBaseScreenMixin {
  @override
  void initState() {
    super.initState();

    try {
      Modular.get<MegaDio>();
    } on Exception {
      print('FAILED TO LOAD DIO --- SPLASH SCREEN');
    }

    Timer(
      Duration(seconds: widget.dismissTime),
      () {
        if (widget.route != null) {
          Navigator.of(context).pushReplacementNamed(widget.route!);
        } else {
          widget.onRoute?.call(context);
        }
      },
    );
  }

  @override
  void dispose() {
    FlutterStatusbarcolor.setStatusBarColor(const Color(0xFF29224F));
    super.dispose();
  }

  @override
  Widget buildScreen(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    return Scaffold(
      body: Container(
        color: this.widget.backgroundColor ??
            Theme.of(context).colorScheme.surface,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: new DecoratedBox(
          decoration: widget.backgroundimagePath != null
              ? new BoxDecoration(
                  image: new DecorationImage(
                    image: new AssetImage(this.widget.backgroundimagePath!),
                    fit: BoxFit.fill,
                  ),
                )
              : const BoxDecoration(),
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              children: [
                const Spacer(),
                Container(),
                this.widget.imagePath != null
                    ? Image.asset(
                        this.widget.imagePath!,
                        height: MediaQuery.of(context).size.height *
                            this.widget.heightRatio,
                        width: MediaQuery.of(context).size.width *
                            this.widget.widthRatio,
                        fit: BoxFit.contain,
                      )
                    : Container(),
                const Spacer(),
                const CircularProgressIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
