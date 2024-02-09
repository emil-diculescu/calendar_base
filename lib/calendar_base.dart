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

  // final MaterialLocalizations localizations;

  const CalendarViewParameters(
      {super.key,
      this.dayBuilder,
      // required this.minMonthViewWidth,
      // required this.maxMonthViewWidth,
      // required this.initialDate,
      // required this.localizations,
      required super.child});

  @override
  bool updateShouldNotify(covariant CalendarViewParameters oldWidget) {
    // return minMonthViewWidth != oldWidget.minMonthViewWidth ||
    //     maxMonthViewWidth != oldWidget.maxMonthViewWidth ||
    //     !DateUtils.isSameDay(initialDate, oldWidget.initialDate) ||
    //     localizations != oldWidget.localizations;
    return false;
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
