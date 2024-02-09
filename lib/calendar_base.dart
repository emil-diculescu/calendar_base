library calendar_base;

import 'package:flutter/material.dart';

typedef DateToWidgetBuilder = Widget Function(BuildContext, DateTime);
typedef IntToWidgetBuilder = Widget Function(BuildContext, int);

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

  // final double minMonthViewWidth;

  // final double maxMonthViewWidth;

  // final DateTime initialDate;

  final MaterialLocalizations localizations;

  const CalendarViewParameters(
      {super.key,
      this.dayBuilder,
      this.weekNumberBuilder,
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
class WeekNumber extends StatelessWidget {
  final DateTime date;

  const WeekNumber({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    final builder = CalendarViewParameters.of(context).weekNumberBuilder ?? _defaultWidget;
    final weekNumber = _weekNumber(CalendarViewParameters.of(context).localizations);
    return builder(context, weekNumber);
  }

  Widget _defaultWidget(BuildContext _, int weekNumber) {
    return Center(child: Text(weekNumber.toString()));
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

@visibleForTesting
class Day extends StatelessWidget {
  final DateTime date;
  const Day({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    final builder = CalendarViewParameters.of(context).dayBuilder ?? _defaultWidget;
    return builder(context, date);
  }

  Widget _defaultWidget(BuildContext _, DateTime date) {
    return Center(child: Text((date.day.toString())));
  }
}
