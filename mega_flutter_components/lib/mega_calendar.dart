import 'package:flutter/material.dart';
import 'package:megaleios_flutter_localization/megaleios_flutter_localization.dart';
import 'package:table_calendar/table_calendar.dart';

class MegaCalendar extends StatefulWidget {
  final DateTime? initialDay;
  final DateTime? minDay;
  final DateTime? maxDay;
  final HeaderStyle? headerStyle;
  final CalendarStyle? calendarStyles;
  final DaysOfWeekStyle? daysOfWeekStyle;
  final CalendarFormat format;
  final Set<int>? daysConfigured;
  final Function(DateTime)? onDaySelected;
  final Function(DateTime)? onMonthChanged;

  const MegaCalendar({
    this.initialDay,
    this.minDay,
    this.maxDay,
    this.headerStyle,
    this.calendarStyles,
    this.daysOfWeekStyle,
    this.format = CalendarFormat.week,
    this.daysConfigured,
    this.onDaySelected,
    this.onMonthChanged,
  });

  @override
  _MegaCalendarState createState() => _MegaCalendarState();
}

class _MegaCalendarState extends State<MegaCalendar> {
  int _lastMonth = 0;

  @override
  Widget build(BuildContext context) {
    final header = widget.headerStyle;
    final calendar = widget.calendarStyles;
    final days = widget.daysOfWeekStyle;

    return TableCalendar(
      firstDay: widget.initialDay ?? DateTime.now(),
      focusedDay: widget.minDay ?? DateTime.now(),
      lastDay: widget.maxDay!,
      locale: MegaleiosLocalizations.of(context)!.locale.toLanguageTag(),
      startingDayOfWeek: StartingDayOfWeek.monday,
      availableGestures: AvailableGestures.horizontalSwipe,
      calendarFormat: widget.format,
      headerStyle: header ?? const HeaderStyle(),
      calendarStyle: calendar ?? const CalendarStyle(),
      daysOfWeekStyle: days ?? const DaysOfWeekStyle(),
      rowHeight: 40,
      selectedDayPredicate: (day) {
        return isSameDay(widget.initialDay, day);
      },
      onPageChanged: (focusedDay) {
        if (widget.onMonthChanged != null) {
          widget.onMonthChanged!(focusedDay);
        }
        if (widget.onMonthChanged != null && _lastMonth != focusedDay.month) {
          if (focusedDay.month == DateTime.now().month) {
            widget.onMonthChanged!(DateTime.now());
          } else {
            final initMonth = DateTime(focusedDay.year, focusedDay.month);
            widget.onMonthChanged!(initMonth);
          }
        }
        _lastMonth = focusedDay.month;
      },
      onDaySelected: (selectedDay, focusedDay) {
        if (widget.onDaySelected != null) {
          widget.onDaySelected!(selectedDay);
        }
      },
    );
  }
}
