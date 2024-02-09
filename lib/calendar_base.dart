library calendar_base;

import 'package:flutter/material.dart';

@visibleForTesting
class CalendarViewParameters extends InheritedWidget {
  static CalendarViewParameters? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CalendarViewParameters>();
  }

  static CalendarViewParameters of(BuildContext context) {
    return maybeOf(context)!;
  }

  final Widget Function(BuildContext context, DateTime date)? dayBuilder;

  // final double minMonthViewWidth;

  // final double maxMonthViewWidth;

  // final DateTime initialDate;

  final MaterialLocalizations localizations;

  const CalendarViewParameters(
      {super.key,
      this.dayBuilder,
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
    final start = DateTime.utc(date.year, date.month, date.day);
    final firstOfJanuaryOffset =
        DateUtils.firstDayOffset(date.year, 1, CalendarViewParameters.of(context).localizations);
    final end = DateTime.utc(date.year, 1, 1).subtract(Duration(days: firstOfJanuaryOffset));
    final difference = start.difference(end).inDays;
    final weeksDifference = difference / 7;
    return Center(child: Text((weeksDifference.floor() + 1).toString()));
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

  Widget _defaultWidget(BuildContext context, DateTime date) {
    return Center(child: Text((date.day.toString())));
  }
}
