library megaleios_flutter_localization;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MegaleiosLocalizations {
  static String? filePath;

  Locale locale;
  List<String> supportedLocales;

  MegaleiosLocalizations({
    required this.locale,
    required this.supportedLocales,
  });

  static LocalizationsDelegate<MegaleiosLocalizations> delegate(
          List<String> supportedLocales) =>
      _MegaleiosLocalizationsDelegate(supportedLocales);

  static MegaleiosLocalizations? of(BuildContext context) {
    return Localizations.of<MegaleiosLocalizations>(
        context, MegaleiosLocalizations);
  }

  Map<String, dynamic>? _localizedStrings;

  Future<bool> load() async {
    final String jsonPath = MegaleiosLocalizations.filePath != null
        ? MegaleiosLocalizations.filePath!
        : 'assets/lang/${locale.languageCode}.json';
    final String jsonString = await rootBundle.loadString(jsonPath);
    _localizedStrings = json.decode(jsonString);

    return true;
  }

  String translate(String key, {List? params}) {
    return _formatMessage(key.toString(), params);
  }

  List? translateList(String key) {
    final value = key.toString();
    final jsonKey = value.substring(value.indexOf('.') + 1);

    if (_localizedStrings!.containsKey(jsonKey)) {
      return _localizedStrings![jsonKey];
    }
    return [];
  }

  String _formatMessage(String key, List? params) {
    final jsonKey = key.substring(key.indexOf('.') + 1);

    if (_localizedStrings!.containsKey(jsonKey)) {
      String? message = _localizedStrings![jsonKey];

      if (params != null && params.isNotEmpty) {
        for (int i = 0; i < params.length; i++) {
          message = message!.replaceAll('{$i}', '${params[i]}');
        }
      }

      return message ?? '';
    }
    return '';
  }
}

class _MegaleiosLocalizationsDelegate
    extends LocalizationsDelegate<MegaleiosLocalizations> {
  final List<String> supportedLocales;

  _MegaleiosLocalizationsDelegate(this.supportedLocales);

  @override
  bool isSupported(Locale locale) {
    return supportedLocales.contains(locale.languageCode);
  }

  @override
  Future<MegaleiosLocalizations> load(Locale locale) async {
    final MegaleiosLocalizations localizations = MegaleiosLocalizations(
      locale: locale,
      supportedLocales: supportedLocales,
    );
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_MegaleiosLocalizationsDelegate old) => true;
}
