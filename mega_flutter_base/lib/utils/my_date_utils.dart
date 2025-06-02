import 'package:flutter/cupertino.dart';

import 'formats.dart';

class MyDateUtils {
  //THE STRING FORMAT MUST TO BE 00/00/0000
  static String? validate(BuildContext context, String date) {
    final dateValues = date.split('/');
    final formatValues = date.split('/');

    if (dateValues.length != formatValues.length) {
      return 'Data inválida';
    }

    if (dateValues.length >= 1) {
      final day = dateValues[0];
      final parsedDay = int.parse(day);

      if (parsedDay < 1 || parsedDay > 31) {
        return 'Data inválida';
      }
    }

    if (dateValues.length >= 2) {
      final month = dateValues[1];
      final parsedMonth = int.parse(month);

      if (parsedMonth < 1 || parsedMonth > 12) {
        return 'Data inválida';
      }
    }
    return null;
  }

  //THE STRING FORMAT MUST TO 0000
  static String? validateYear(
    BuildContext context,
    String date, {
    bool allowOlder = true,
    bool allowFuture = false,
    int olderLimit = 0,
  }) {
    if (date.length != 4) {
      return 'Data inválida';
    }

    final parsedYear = int.parse(date);

    if (parsedYear < DateTime.now().year && !allowOlder) {
      return 'Data inválida';
    }

    if (parsedYear < DateTime.now().year &&
        allowOlder &&
        parsedYear < olderLimit) {
      return 'Data inválida';
    }

    if (parsedYear > DateTime.now().year && !allowFuture) {
      return 'Data inválida';
    }

    return null;
  }

  static int initDayTimestamp(DateTime? date, {bool seconds = true}) {
    if (date == null)
      return DateTime.now().millisecondsSinceEpoch ~/ (seconds ? 1000 : 1);

    final string = Formats.dateFormat.format(date);
    final timestamp = Formats.dateFormat.parse(string);
    return timestamp.millisecondsSinceEpoch ~/ (seconds ? 1000 : 1);
  }

  static int initMonthTimestamp(DateTime? date, {bool seconds = true}) {
    DateTime? currentDate = date;
    if (date == null) {
      currentDate = DateTime.now();
    }

    final initMonth = DateTime(currentDate!.year, currentDate.month);
    return initMonth.millisecondsSinceEpoch ~/ (seconds ? 1000 : 1);
  }

  static int nextMonthTimestamp(DateTime? date, {bool seconds = true}) {
    DateTime? currentDate = date;
    if (date == null) {
      currentDate = DateTime.now();
    }

    final initMonth = DateTime(currentDate!.year,
        currentDate.month + 1 > 12 ? 1 : currentDate.month + 1);
    return initMonth.millisecondsSinceEpoch ~/ (seconds ? 1000 : 1);
  }
}
