import 'dart:math';

import 'package:calendar_base/calendar_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'calendar_base_test.mocks.dart';

const _localizations = DefaultMaterialLocalizations();
const _minColumnWidth = 200.0;
const _maxColumnWidth = 400.0;
const _minHorizontalSpacing = 16.0;
const _minVerticalSpacing = 16.0;
const _stubWidget = Placeholder();
final MockBuilders _builders = MockBuilders();

@GenerateNiceMocks([MockSpec<Builders>()])
void main() {
  group('Day tests', () {
    final DateTime testDate = _today();

    setUpAll(() => when(_builders.dayBuilder(any, any)).thenReturn(_stubWidget));

    testWidgets('Displays the day by default', (widgetTester) async {
      await widgetTester.pumpWidget(_widgetWithoutBuilders(Day(date: testDate)));
      expect(find.text(testDate.day.toString()), findsOneWidget);
    });

    testWidgets('Calls builder, if builder is provided', (widgetTester) async {
      await widgetTester.pumpWidget(_widgetWithBuilders(Day(date: testDate)));
      verify(_builders.dayBuilder(any, testDate));
      expect(widgetTester.widget(find.bySubtype<Placeholder>()), _stubWidget);
    });
  });

  group('Week number tests', () {
    const expectedWeekNumber = 6;
    final testDate = DateUtils.dateOnly(DateTime(2024, 2, 9));

    setUpAll(() => when(_builders.weekNumberBuilder(any, any)).thenReturn(_stubWidget));

    testWidgets('Displays week number by default', (widgetTester) async {
      await widgetTester.pumpWidget(_widgetWithoutBuilders(WeekNumber(date: testDate)));
      expect(find.text(expectedWeekNumber.toString()), findsOneWidget);
    });

    testWidgets('Calls builder, if builder is provided', (widgetTester) async {
      await widgetTester.pumpWidget(_widgetWithBuilders(WeekNumber(date: testDate)));
      verify(_builders.weekNumberBuilder(any, expectedWeekNumber));
      expect(widgetTester.widget(find.bySubtype<Placeholder>()), _stubWidget);
    });
  });

  group('Week day name tests', () {
    const weekDayNames = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    final random = Random();
    final testIndex = random.nextInt(weekDayNames.length);

    setUpAll(() => when(_builders.weekDayNameBuilder(any, any)).thenReturn(_stubWidget));

    testWidgets('Shows week day name by default', (widgetTester) async {
      await widgetTester.pumpWidget(_widgetWithoutBuilders(WeekDayName(dayIndex: testIndex)));
      expect(find.text(weekDayNames[testIndex]), findsAtLeast(1));
    });

    testWidgets('Calls builder, if builder is provided', (widgetTester) async {
      await widgetTester.pumpWidget(_widgetWithBuilders(WeekDayName(dayIndex: testIndex)));
      verify(_builders.weekDayNameBuilder(any, weekDayNames[testIndex]));
      expect(widgetTester.widget(find.bySubtype<Placeholder>()), _stubWidget);
    });
  });

  group('Week display test for separate month view', () {
    testWidgets('Test month starting on first day of the week', (widgetTester) async {
      final tester = _IndividualMonthTester(widgetTester: widgetTester, year: 2024, month: 9);
      await tester.init();
      tester.testWeekNameRow();
      tester.testWeek(expectedRowNumber: 1, weekNumber: 36, startsWith: 1, endsWith: 7);
      tester.testWeek(expectedRowNumber: 2, weekNumber: 37, startsWith: 8, endsWith: 14);
      tester.testWeek(expectedRowNumber: 3, weekNumber: 38, startsWith: 15, endsWith: 21);
      tester.testWeek(expectedRowNumber: 4, weekNumber: 39, startsWith: 22, endsWith: 28);
      tester.testWeek(expectedRowNumber: 5, weekNumber: 40, startsWith: 29, endsWith: 30);
      tester.testNoMoreRows(expectedRowCount: 6);
    });

    testWidgets('Test month ending on the last day of the week', (widgetTester) async {
      final tester = _IndividualMonthTester(widgetTester: widgetTester, year: 2024, month: 8);
      await tester.init();
      tester.testWeekNameRow();
      tester.testWeek(expectedRowNumber: 1, weekNumber: 31, startsWith: 1, endsWith: 3);
      tester.testWeek(expectedRowNumber: 2, weekNumber: 32, startsWith: 4, endsWith: 10);
      tester.testWeek(expectedRowNumber: 3, weekNumber: 33, startsWith: 11, endsWith: 17);
      tester.testWeek(expectedRowNumber: 4, weekNumber: 34, startsWith: 18, endsWith: 24);
      tester.testWeek(expectedRowNumber: 5, weekNumber: 35, startsWith: 25, endsWith: 31);
      tester.testNoMoreRows(expectedRowCount: 6);
    });

    testWidgets('Test month that start and end during the week', (widgetTester) async {
      final tester = _IndividualMonthTester(widgetTester: widgetTester, year: 2024, month: 6);
      await tester.init();
      tester.testWeekNameRow();
      tester.testWeek(expectedRowNumber: 1, weekNumber: 22, startsWith: 1, endsWith: 1);
      tester.testWeek(expectedRowNumber: 2, weekNumber: 23, startsWith: 2, endsWith: 8);
      tester.testWeek(expectedRowNumber: 3, weekNumber: 24, startsWith: 9, endsWith: 15);
      tester.testWeek(expectedRowNumber: 4, weekNumber: 25, startsWith: 16, endsWith: 22);
      tester.testWeek(expectedRowNumber: 5, weekNumber: 26, startsWith: 23, endsWith: 29);
      tester.testWeek(expectedRowNumber: 6, weekNumber: 27, startsWith: 30, endsWith: 30);
      tester.testNoMoreRows(expectedRowCount: 7);
    });
  });

  group('Month name view tests', () {
    final DateTime testDate = _today();

    setUpAll(() => when(_builders.monthNameBuilder(any, any)).thenReturn(_stubWidget));

    testWidgets('Displays the month and the year by default', (widgetTester) async {
      await widgetTester.pumpWidget(_widgetWithoutBuilders(MonthNameView(date: testDate)));
      expect(find.text(_localizations.formatMonthYear(testDate)), findsOneWidget);
    });

    testWidgets('Calls builder, if builder is provided', (widgetTester) async {
      await widgetTester.pumpWidget(_widgetWithBuilders(MonthNameView(date: testDate)));
      verify(_builders.monthNameBuilder(any, testDate));
      expect(widgetTester.widget(find.bySubtype<Placeholder>()), _stubWidget);
    });
  });

  group('Month view (separated months) tests', () {
    final DateTime testDate = DateTime.now();

    testWidgets('Displays month name', (widgetTester) async {
      await widgetTester.pumpWidget(_widgetWithoutBuilders(MonthView(date: testDate)));
      expect(find.bySubtype<MonthNameView>(), findsOneWidget);
    });

    testWidgets('Displays weeks in month', (widgetTester) async {
      await widgetTester.pumpWidget(_widgetWithoutBuilders(MonthView(date: testDate)));
      expect(find.bySubtype<WeeksInMonthView>(), findsOneWidget);
    });
  });

  group('Calendar row testing', () {
    double enoughWidthFor({required int columns}) {
      return (_minColumnWidth + _minHorizontalSpacing) * (columns + 1) + _minHorizontalSpacing - 1;
    }

    testWidgets('Shows one column when space is smaller than two minimum widths', (widgetTester) async {
      await widgetTester.pumpWidget(await _constrainedWidget(
          widgetTester: widgetTester,
          width: enoughWidthFor(columns: 1),
          child: _widgetWithoutBuilders(const CalendarRow(rowIndex: 0))));
      expect(find.bySubtype<MonthView>(), findsExactly(1));
    });

    testWidgets('Shows more columns if space is available', (widgetTester) async {
      const maxColumns = 5;
      final expectedColumns = 2 + Random().nextInt(maxColumns - 1);
      await widgetTester.pumpWidget(await _constrainedWidget(
          widgetTester: widgetTester,
          width: enoughWidthFor(columns: expectedColumns),
          child: _widgetWithoutBuilders(const CalendarRow(rowIndex: 0))));
      expect(find.bySubtype<MonthView>(), findsExactly(expectedColumns));
    });
  });
}

abstract class Builders {
  Widget dayBuilder(BuildContext context, DateTime date);

  Widget weekNumberBuilder(BuildContext context, int weekNumber);

  Widget weekDayNameBuilder(BuildContext context, String weekDayName);

  Widget monthNameBuilder(BuildContext context, DateTime date);
}

DateTime _today() {
  return DateUtils.dateOnly(DateTime.now());
}

Widget _widgetWithoutBuilders(Widget child) {
  return CalendarViewParameters(
      localizations: _localizations,
      minMonthViewWidth: _minColumnWidth,
      maxMonthViewWidth: _maxColumnWidth,
      minHorizontalSpacing: _minHorizontalSpacing,
      minVerticalSpacing: _minVerticalSpacing,
      child: Directionality(textDirection: TextDirection.ltr, child: child));
}

Widget _widgetWithBuilders(Widget child) {
  return CalendarViewParameters(
      dayBuilder: _builders.dayBuilder,
      weekNumberBuilder: _builders.weekNumberBuilder,
      weekDayNameBuilder: _builders.weekDayNameBuilder,
      monthNameBuilder: _builders.monthNameBuilder,
      localizations: _localizations,
      minMonthViewWidth: _minColumnWidth,
      maxMonthViewWidth: _maxColumnWidth,
      minHorizontalSpacing: _minHorizontalSpacing,
      minVerticalSpacing: _minVerticalSpacing,
      child: Directionality(textDirection: TextDirection.ltr, child: child));
}

class _IndividualMonthTester {
  final WidgetTester widgetTester;

  final int year;

  final int month;

  final List<TableRow> rows = <TableRow>[];

  _IndividualMonthTester({required this.widgetTester, required this.year, required this.month});

  Future<void> init() async {
    await widgetTester.pumpWidget(_widgetWithoutBuilders(WeeksInMonthView(date: DateTime(year, month, 1))));
    final widget = widgetTester.widget<Table>(find.bySubtype<Table>());
    rows.addAll(widget.children);
  }

  void testWeekNameRow() {
    _testRow(rowNumber: 0, expected: ['', 'S', 'M', 'T', 'W', 'T', 'F', 'S']);
  }

  void _testRow({required int rowNumber, required List<String> expected}) {
    assert(rowNumber >= 0 && rowNumber < rows.length, 'Row number: $rowNumber');
    final row = rows[rowNumber].children;
    expect(row.length, expected.length, reason: 'The actual and expected lists have different lengths');
    for (var i = 0; i < row.length; ++i) {
      expect(_textFrom(row[i]), expected[i], reason: 'The values do not match at position $i');
    }
  }

  String _textFrom(Widget widget) {
    final finder = find.descendant(of: find.byWidget(widget), matching: find.bySubtype<Text>());
    final textWidget = widgetTester.widget<Text>(finder.first);
    return textWidget.data!.trim();
  }

  void testWeek(
      {required int expectedRowNumber, required int weekNumber, required int startsWith, required int endsWith}) {
    assert(weekNumber >= 1 && weekNumber <= 53);
    assert(startsWith >= 1 && startsWith <= endsWith);
    assert(endsWith >= startsWith && endsWith <= 31);
    final expected = <String>[];
    expected.add(weekNumber.toString());
    final daysInWeek = endsWith - startsWith + 1;
    final isNotFullWeek = daysInWeek != 6;
    final isFirstWeekOfMonth = startsWith == 1;
    if (isNotFullWeek && isFirstWeekOfMonth) {
      _padWithEmpty(expected, daysInWeek);
    }
    for (var i = startsWith; i <= endsWith; ++i) {
      expected.add(i.toString());
    }
    if (isNotFullWeek && !isFirstWeekOfMonth) {
      _padWithEmpty(expected, daysInWeek);
    }
    return _testRow(rowNumber: expectedRowNumber, expected: expected);
  }

  void _padWithEmpty(List<String> expected, int daysInWeek) {
    expected.addAll(List.filled(7 - daysInWeek, ''));
  }

  void testNoMoreRows({required int expectedRowCount}) {
    expect(rows.length, expectedRowCount);
  }
}

Future<Widget> _constrainedWidget({required WidgetTester widgetTester, required width, required Widget child}) async {
  await widgetTester.binding.setSurfaceSize(Size(width, 600));
  return ConstrainedBox(
    constraints: BoxConstraints(
      minWidth: width,
      maxWidth: width,
    ),
    child: child,
  );
}
