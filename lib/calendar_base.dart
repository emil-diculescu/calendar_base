library calendar_base;

import 'package:flutter/material.dart';

typedef DateToWidgetBuilder = Widget Function(BuildContext, DateTime);
typedef IntToWidgetBuilder = Widget Function(BuildContext, int);
typedef StringToWidgetBuilder = Widget Function(BuildContext, String);

@visibleForTesting
class CalendarViewParameters extends InheritedWidget {
  static CalendarViewParameters? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CalendarViewParameters>();
  }

  static CalendarViewParameters of(BuildContext context) {
    return maybeOf(context)!;
  }

  final DateToWidgetBuilder? dayBuilder;

  final IntToWidgetBuilder? weekNumberBuilder;

  final StringToWidgetBuilder? weekDayNameBuilder;

  // final double minMonthViewWidth;

  // final double maxMonthViewWidth;

  // final DateTime initialDate;

  final MaterialLocalizations localizations;

  const CalendarViewParameters(
      {super.key,
      this.dayBuilder,
      this.weekNumberBuilder,
      this.weekDayNameBuilder,
      // required this.minMonthViewWidth,
      // required this.maxMonthViewWidth,
      // required this.initialDate,
      required this.localizations,
      required super.child});

  @override
  bool updateShouldNotify(covariant CalendarViewParameters oldWidget) {
    return false;
  }
}

@visibleForTesting
class WeekDayName extends StatelessWidget {
  final int dayIndex;

  const WeekDayName({required this.dayIndex, super.key}) : assert(dayIndex >= 0 && dayIndex < 7);

  @override
  Widget build(BuildContext context) {
    final weekDayName = CalendarViewParameters.of(context).localizations.narrowWeekdays[dayIndex];
    final builder = CalendarViewParameters.of(context).weekDayNameBuilder;
    if (builder != null) {
      return builder(context, weekDayName);
    } else {
      return _CenteredText(text: weekDayName);
    }
  }
}

class _CenteredText extends StatelessWidget {
  final String text;

  const _CenteredText({required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
      text,
    ));
  }
}

@visibleForTesting
class WeekNumber extends StatelessWidget {
  final DateTime date;

  const WeekNumber({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    final weekNumber = _weekNumber(CalendarViewParameters.of(context).localizations);
    final builder = CalendarViewParameters.of(context).weekNumberBuilder;
    if (builder != null) {
      return builder(context, weekNumber);
    } else {
      return _DefaultWeekNumber(weekNumber: weekNumber);
    }
  }

  int _weekNumber(MaterialLocalizations localizations) {
    final target = DateTime.utc(date.year, date.month, date.day);
    final firstOfJanuaryOffset = DateUtils.firstDayOffset(date.year, 1, localizations);
    final reference = DateTime.utc(date.year, 1, 1).subtract(Duration(days: firstOfJanuaryOffset));
    final difference = target.difference(reference).inDays;
    final weekNumber = (difference / 7).floor() + 1;
    assert(weekNumber > 0 && weekNumber <= 53);
    return weekNumber;
  }
}

class _DefaultWeekNumber extends StatelessWidget {
  final int weekNumber;

  const _DefaultWeekNumber({required this.weekNumber});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(weekNumber.toString()));
  }
}

@visibleForTesting
class Day extends StatelessWidget {
  final DateTime date;
  const Day({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    final builder = CalendarViewParameters.of(context).dayBuilder;
    if (builder != null) {
      return builder(context, date);
    } else {
      return _DefaultDay(day: date.day);
    }
  }
}

class _DefaultDay extends StatelessWidget {
  final int day;

  const _DefaultDay({required this.day});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text((day.toString())));
  }
}
