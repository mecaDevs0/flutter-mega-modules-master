import 'package:flutter/cupertino.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:megaleios_flutter_localization/megaleios_flutter_localization.dart';
import 'package:strings/strings.dart';

import '../extensions/string_extensions.dart';

class Formats {
  //MASKS
  static get accountBankFormatter => MaskTextInputFormatter(
      mask: '##########', filter: {"#": RegExp(r'[0-9]')});

  static get agencyBankFormatter =>
      MaskTextInputFormatter(mask: '#####', filter: {"#": RegExp(r'[0-9]')});

  static get cardNumberFormatter => MaskTextInputFormatter(
      mask: '#### #### #### ####', filter: {"#": RegExp(r'[0-9]')});

  static get carTarget => MaskTextInputFormatter(
      mask: '#######', filter: {"#": RegExp(r'[A-Za-z0-9]')});

  static get cardValidFormatter =>
      MaskTextInputFormatter(mask: '##/####', filter: {"#": RegExp(r'[0-9]')});

  static get cardSecurityCodeFormatter =>
      MaskTextInputFormatter(mask: '####', filter: {"#": RegExp(r'[0-9]')});

  static MaskTextInputFormatter get cepMaskFormatter => MaskTextInputFormatter(
      mask: '#####-###', filter: {"#": RegExp(r'[0-9]')});

  static get cellMaskFormatter => MaskTextInputFormatter(
      mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});

  static get cnpjMaskFormatter => MaskTextInputFormatter(
      mask: '##.###.###/####-##', filter: {"#": RegExp(r'[0-9]')});

  static get codeMaskFormatter =>
      MaskTextInputFormatter(mask: '######', filter: {"#": RegExp(r'[0-9]')});

  static MaskTextInputFormatter get cpfMaskFormatter => MaskTextInputFormatter(
      mask: '###.###.###-##', filter: {"#": RegExp(r'[0-9]')});

  static get dateMaskFormatter => MaskTextInputFormatter(
      mask: '##/##/####', filter: {"#": RegExp(r'[0-9]')});

  static get yearMaskFormatter =>
      MaskTextInputFormatter(mask: '####', filter: {"#": RegExp(r'[0-9]')});

  static get digitVerificationFormatter =>
      MaskTextInputFormatter(mask: '#', filter: {"#": RegExp(r'[0-9azAZ]')});

  static get hourMaskFormatter =>
      MaskTextInputFormatter(mask: '##:##', filter: {"#": RegExp(r'[0-9]')});

  static get verificationSmsMaskFormatter =>
      MaskTextInputFormatter(mask: '#####', filter: {"#": RegExp(r'[0-9]')});

  static get phoneMaskFormatter => MaskTextInputFormatter(
      mask: '(##) ####-####', filter: {"#": RegExp(r'[0-9]')});

  static get numberStreetFormatter =>
      MaskTextInputFormatter(mask: '########', filter: {"#": RegExp(r'[0-9]')});

  //DATE
  static DateFormat get dateFormat => DateFormat('dd/MM/yyyy');

  static DateFormat get notificationDateFormat =>
      DateFormat("EEEE, dd 'de' MMMM");

  //MONEY
  static MoneyMaskedTextController get moneyController =>
      MoneyMaskedTextController(leftSymbol: 'R\$ ');

  static MoneyMaskedTextController get moneyControllerNoSymbolDecimal =>
      MoneyMaskedTextController();

  static String formatMoney({
    double? value,
    String placeholder = '-',
  }) {
    if (value == null) {
      return placeholder;
    }

    return NumberFormat.currency(
      locale: 'pt_BR',
      decimalDigits: 2,
      symbol: 'R\$',
    ).format(value);
  }

  static String formatMoneyNoSymbol(
    BuildContext context, {
    double? value,
    String placeholder = '-',
  }) {
    if (value == null) {
      return placeholder;
    }
    final locale = MegaleiosLocalizations.of(context)!.locale.toLanguageTag();

    return NumberFormat.currency(
      locale: locale,
      decimalDigits: 2,
      symbol: '',
    ).format(value);
  }

  static String formatNumber(
    NumberFormat format,
    double? value, {
    String placeHolder = '-',
  }) {
    return value != null ? format.format(value) : placeHolder;
  }

  static String formatDate(
    BuildContext context, {
    String? format,
    DateTime? value,
    String defaultValue = '',
    String? locale,
    bool seconds = false,
  }) {
    if (value == null) {
      return defaultValue;
    }
    final formatLocale = DateFormat(
      format,
      locale ?? MegaleiosLocalizations.of(context)!.locale.toLanguageTag(),
    );
    return formatLocale.format(value).capitalize;
  }

  static String formatDateMillis(
    DateFormat format,
    int? value, {
    String defaultValue = '',
  }) {
    if (value == null) {
      return defaultValue;
    }
    final formatLocale = DateFormat(format.pattern, Intl.defaultLocale);
    return capitalize(
        formatLocale.format(DateTime.fromMillisecondsSinceEpoch(value)));
  }

  static String format(MaskTextInputFormatter formatter, String value,
      {String defaultValue = ''}) {
    if (value.isEmpty) {
      return defaultValue;
    }
    formatter.formatEditUpdate(
        const TextEditingValue(), TextEditingValue(text: value));
    return formatter.getMaskedText();
  }
}
