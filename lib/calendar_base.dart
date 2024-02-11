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

  final DateToWidgetBuilder? monthNameBuilder;

  // final double minMonthViewWidth;

  // final double maxMonthViewWidth;

  // final DateTime initialDate;

  final MaterialLocalizations localizations;

  const CalendarViewParameters(
      {super.key,
      this.dayBuilder,
      this.weekNumberBuilder,
      this.weekDayNameBuilder,
      this.monthNameBuilder,
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
class MonthNameView extends StatelessWidget {
  final DateTime date;

  const MonthNameView({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    final builder = CalendarViewParameters.of(context).monthNameBuilder;
    if (builder != null) {
      return builder(context, date);
    } else {
      return _CenteredText(text: CalendarViewParameters.of(context).localizations.formatMonthYear(date));
    }
  }
}

@visibleForTesting
class WeeksInMonthView extends StatelessWidget {
  final DateTime displayDate;

  const WeeksInMonthView(this.displayDate, {super.key});

  @override
  Widget build(BuildContext context) {
    final generator = _RowGenerator(context: context, displayDate: displayDate);
    return Table(
      children: generator.rows,
    );
  }
}

class _RowGenerator {
  final List<TableRow> _children = <TableRow>[];
  final BuildContext context;
  final DateTime displayDate;
  late final CalendarViewParameters _parameters;
  late final int _firstDayOffset;
  late final int _firstRegularDay;
  late final int _daysOnFirstRow;
  late final int _daysInCurrentMonth;
  late final int _remainingDaysInMonth;
  late final int _daysOnLastRow;
  late final int _lastRegularDay;

  late final List<TableRow> rows = _generateRows();

  _RowGenerator({required this.context, required this.displayDate})
      : _parameters = CalendarViewParameters.of(context),
        _daysInCurrentMonth = DateUtils.getDaysInMonth(displayDate.year, displayDate.month) {
    _firstDayOffset = DateUtils.firstDayOffset(displayDate.year, displayDate.month, _parameters.localizations);
    _firstRegularDay = 7 - _firstDayOffset + 1;
    _daysOnFirstRow = 7 - _firstDayOffset;
    _remainingDaysInMonth = _daysInCurrentMonth - _daysOnFirstRow;
    _daysOnLastRow = _remainingDaysInMonth % 7;
    _lastRegularDay = _daysInCurrentMonth - _daysOnLastRow;
  }

  List<TableRow> _generateRows() {
    _addDayOfWeekNames();
    _addFirstWeekOfMonth();
    _addFullWeeks();
    if (_isLastWeekIncomplete()) _addDaysOfLastWeek();
    return _children;
  }

  void _addDayOfWeekNames() {
    final start = _parameters.localizations.firstDayOfWeekIndex;
    final currentRow = <Widget>[];
    currentRow.add(const _Empty());
    for (var i = start; i < 7; ++i) {
      currentRow.add(WeekDayName(dayIndex: i));
    }
    for (var i = 0; i < start; ++i) {
      currentRow.add(WeekDayName(dayIndex: i));
    }
    _children.add(TableRow(children: currentRow));
  }

  void _addFirstWeekOfMonth() {
    final currentRow = <Widget>[];
    currentRow.add(WeekNumber(date: displayDate.copyWith(day: 1)));
    for (var i = 1; i <= _firstDayOffset; ++i) {
      currentRow.add(const _Empty());
    }
    for (var i = _firstDayOffset; i < 7; ++i) {
      currentRow.add(Day(date: displayDate.copyWith(day: 1 + i - _firstDayOffset)));
    }
    _children.add(TableRow(children: currentRow));
  }

  void _addFullWeeks() {
    var currentDay = _firstRegularDay;
    var currentRow = _newFullWeekRow(currentDay);
    while (_isBeforeLastRegularDay(currentDay)) {
      currentRow.add(Day(date: displayDate.copyWith(day: currentDay)));
      ++currentDay;
      if (_shouldStartNewFullWeekRow(currentDay)) {
        _storeFullWeekRow(currentRow);
        currentRow = _newFullWeekRow(currentDay);
      }
    }
    currentRow.add(Day(date: displayDate.copyWith(day: _lastRegularDay)));
    _storeFullWeekRow(currentRow);
  }

  List<Widget> _newFullWeekRow(int day) {
    final result = <Widget>[];
    result.add(WeekNumber(date: displayDate.copyWith(day: day)));
    return result;
  }

  bool _isBeforeLastRegularDay(int day) {
    return day < _lastRegularDay;
  }

  bool _shouldStartNewFullWeekRow(int day) {
    return (day - _firstRegularDay) % 7 == 0;
  }

  void _storeFullWeekRow(List<Widget> row) {
    _children.add(TableRow(children: row));
  }

  bool _isLastWeekIncomplete() => _daysOnLastRow != 0;

  void _addDaysOfLastWeek() {
    final currentRow = <Widget>[];
    currentRow.add(WeekNumber(date: displayDate.copyWith(day: _daysInCurrentMonth)));
    for (var i = _daysInCurrentMonth - _daysOnLastRow + 1; i <= _daysInCurrentMonth; ++i) {
      currentRow.add(Day(date: displayDate.copyWith(day: i)));
    }
    for (var i = _daysOnLastRow; i < 7; ++i) {
      currentRow.add(const _Empty());
    }
    _children.add(TableRow(children: currentRow));
  }
}

class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) {
    return const Text('');
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
      return _CenteredText(text: weekNumber.toString());
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
      return _CenteredText(text: date.day.toString());
    }
  }
}
