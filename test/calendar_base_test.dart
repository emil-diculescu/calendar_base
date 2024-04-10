import 'dart:math';

import 'package:calendar_base/calendar_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'all.mocks.dart';

const _localizations = DefaultMaterialLocalizations();
const _minColumnWidth = 200.0;
const _maxColumnWidth = 400.0;
const _minHorizontalSpacing = 16.0;
const _minVerticalSpacing = 16.0;
const _stubWidget = Placeholder();
const _surfaceHeight = 600.0;
final _random = Random();

MockBuilders _builders = _ConfiguredMockBuilders();

class _ConfiguredMockBuilders extends MockBuilders {
  _ConfiguredMockBuilders() {
    const placeholder = Text('');
    when(monthNameBuilder(any, any)).thenReturn(placeholder);
    when(dayBuilder(any, any)).thenReturn(placeholder);
    when(monthBackgroundBuilder(any, any, any)).thenReturn(placeholder);
    when(weekDayNameBuilder(any, any)).thenReturn(placeholder);
    when(weekNumberBuilder(any, any)).thenReturn(placeholder);
  }
}

void main() {
  group('Day tests', () {
    final DateTime testDate = _today();

    testWidgets('Displays the day by default', (widgetTester) async {
      await widgetTester.pumpWidget(_CalendarTestFrameworkWithoutBuilders(child: Day(date: testDate)));
      expect(find.text(testDate.day.toString()), findsOneWidget);
    });

    testWidgets('Calls builder, if builder is provided', (widgetTester) async {
      await widgetTester.pumpWidget(_widgetWithBuilders(Day(date: testDate)));
      verify(_builders.dayBuilder(any, testDate));
    });
  });

  group('Week number tests', () {
    const expectedWeekNumber = 6;
    final testDate = DateUtils.dateOnly(DateTime(2024, 2, 9));

    setUpAll(() => when(_builders.weekNumberBuilder(any, any)).thenReturn(_stubWidget));

    testWidgets('Displays week number by default', (widgetTester) async {
      await widgetTester.pumpWidget(_CalendarTestFrameworkWithoutBuilders(child: WeekNumber(date: testDate)));
      expect(find.text(expectedWeekNumber.toString()), findsOneWidget);
    });

    testWidgets('Calls builder, if builder is provided', (widgetTester) async {
      await widgetTester.pumpWidget(_widgetWithBuilders(WeekNumber(date: testDate)));
      verify(_builders.weekNumberBuilder(any, expectedWeekNumber));
      expect(widgetTester.widget(find.bySubtype<Placeholder>()), _stubWidget);
    });
  });

  group('Week day name tests', () {
    final testIndex = _random.nextInt(7);
    setUpAll(() {
      _builders = _ConfiguredMockBuilders();
      when(_builders.weekDayNameBuilder(any, any)).thenReturn(_stubWidget);
    });

    testWidgets('Shows week day name by default', (widgetTester) async {
      await widgetTester.pumpWidget(
          MaterialApp(home: _CalendarTestFrameworkWithoutBuilders(child: WeekDayName(dayIndex: testIndex))));
      final weekDayNames = _weekDayNames(widgetTester);
      expect(find.text(weekDayNames[testIndex]), findsAtLeast(1));
    });

    testWidgets('Calls builder, if builder is provided', (widgetTester) async {
      await widgetTester.pumpWidget(MaterialApp(home: _widgetWithBuilders(WeekDayName(dayIndex: testIndex))));
      final weekDayNames = _weekDayNames(widgetTester);
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

    testWidgets('Test month with different localization', (widgetTester) async {
      final tester = _IndividualMonthTester(widgetTester: widgetTester, year: 2024, month: 9, localeName: 'de');
      await tester.init();
      tester.testWeekNameRow();
      tester.testWeek(expectedRowNumber: 1, weekNumber: 35, startsWith: 1, endsWith: 1);
      tester.testWeek(expectedRowNumber: 2, weekNumber: 36, startsWith: 2, endsWith: 8);
      tester.testWeek(expectedRowNumber: 3, weekNumber: 37, startsWith: 9, endsWith: 15);
      tester.testWeek(expectedRowNumber: 4, weekNumber: 38, startsWith: 16, endsWith: 22);
      tester.testWeek(expectedRowNumber: 5, weekNumber: 39, startsWith: 23, endsWith: 29);
      tester.testWeek(expectedRowNumber: 6, weekNumber: 40, startsWith: 30, endsWith: 30);
      tester.testNoMoreRows(expectedRowCount: 7);
    });
  });

  group('Month name view tests', () {
    final DateTime testDate = _today();

    setUpAll(() => when(_builders.monthNameBuilder(any, any)).thenReturn(_stubWidget));

    testWidgets('Displays the month and the year by default', (widgetTester) async {
      await widgetTester.pumpWidget(_CalendarTestFrameworkWithoutBuilders(child: MonthNameView(date: testDate)));
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
      await widgetTester.pumpWidget(_CalendarTestFrameworkWithoutBuilders(child: MonthView(date: testDate)));
      expect(find.bySubtype<MonthNameView>(), findsOneWidget);
    });

    testWidgets('Displays weeks in month', (widgetTester) async {
      await widgetTester.pumpWidget(_CalendarTestFrameworkWithoutBuilders(child: MonthView(date: testDate)));
      expect(find.bySubtype<WeeksInMonthView>(), findsOneWidget);
    });

    testWidgets('Calls builder, if builder is provided', (widgetTester) async {
      final expectedChild = MonthView(date: testDate);
      await widgetTester.pumpWidget(CalendarViewParameters(
          initialDate: DateTime.now(),
          localizations: _localizations,
          monthBackgroundBuilder: _builders.monthBackgroundBuilder,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: expectedChild,
          )));
      verify(_builders.monthBackgroundBuilder(any, any, any));
    });
  });

  group('Calendar row testing', () {
    testWidgets('Shows one column when space is smaller than two minimum widths', (widgetTester) async {
      await _setSurfaceSize(widgetTester: widgetTester, expectedColumns: 1);
      await widgetTester.pumpWidget(const _CalendarTestFrameworkWithoutBuilders(child: CalendarRow(rowIndex: 0)));
      expect(find.bySubtype<MonthView>(), findsExactly(1));
    });

    testWidgets('Shows more columns if space is available', (widgetTester) async {
      const maxColumns = 5;
      final expectedColumns = 2 + _random.nextInt(maxColumns - 1);
      await _setSurfaceSize(widgetTester: widgetTester, expectedColumns: expectedColumns);
      await widgetTester.pumpWidget(const _CalendarTestFrameworkWithoutBuilders(child: CalendarRow(rowIndex: 0)));
      expect(find.bySubtype<MonthView>(), findsExactly(expectedColumns));
    });

    testWidgets('Shows the correct months', (widgetTester) async {
      final expectedColumns = 2 + _random.nextInt(5);
      await _setSurfaceSize(widgetTester: widgetTester, expectedColumns: expectedColumns);
      final testDate = DateTime.now();
      final row = 0 + _random.nextInt(5);
      final offset = row * expectedColumns;
      await widgetTester.pumpWidget(_CalendarTestFrameworkWithoutBuilders(child: CalendarRow(rowIndex: row)));
      for (var i = 0; i < expectedColumns; ++i) {
        expect(find.text(_localizations.formatMonthYear(DateUtils.addMonthsToMonthDate(testDate, offset + i))),
            findsOneWidget);
      }
    });
  });

  group('Calendar testing', () {
    final testDate = DateTime.now();

    testWidgets('Shows rows in correct order', (widgetTester) async {
      final expectedColumns = 1 + _random.nextInt(5);
      await _setSurfaceSize(widgetTester: widgetTester, expectedColumns: expectedColumns);
      await widgetTester.pumpWidget(_CalendarTestFrameworkWithoutBuilders(child: CalendarBase(initialDate: testDate)));
      expect(find.text(_localizations.formatMonthYear(testDate)), findsOneWidget);
      final firstMonthOnSecondRow = DateUtils.addMonthsToMonthDate(testDate, expectedColumns);
      expect(find.text(_localizations.formatMonthYear(firstMonthOnSecondRow)), findsOneWidget);
    });

    testWidgets('Uses day builder', (widgetTester) async {
      const prefix = '###';
      await widgetTester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: CalendarBase(
          dayBuilder: (context, dateTime) => Text(
            '$prefix${dateTime.day}',
          ),
        ),
      ));
      expect(find.textContaining(prefix), findsAtLeastNWidgets(29));
    });

    testWidgets('Uses month name builder', (widgetTester) async {
      const prefix = '###';
      await widgetTester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: CalendarBase(
          monthNameBuilder: (context, dateTime) => const Text(
            prefix,
          ),
        ),
      ));
      expect(find.textContaining(prefix), findsAtLeastNWidgets(1));
    });

    testWidgets('Uses month background builder', (widgetTester) async {
      await widgetTester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: CalendarBase(
            monthBackgroundBuilder: (context, dateTime, child) => Card(child: child),
          ),
        ),
      );
    });

    test('Returns key from date', () {
      final date = _today();
      final expected = Key('${date.day}${date.month}${date.year}');
      expect(CalendarBase.dateAsKey(date), expected);
    });

    testWidgets('Day widgets have the date as key', (widgetTester) async {
      await widgetTester.pumpWidget(_CalendarTestFrameworkWithoutBuilders(child: CalendarBase()));
      expect(find.byKey(CalendarBase.dateAsKey(testDate)), findsOneWidget);
    });

    testWidgets('Can scroll back to current day', (widgetTester) async {
      final calendar = CalendarBase();
      final target = _localizations.formatMonthYear(DateTime.now());
      await widgetTester.pumpWidget(_CalendarTestFrameworkWithoutBuilders(child: calendar));
      await widgetTester.pumpAndSettle();
      await widgetTester.fling(find.byType(CalendarBase), const Offset(0, -400), 1600);
      await widgetTester.pumpAndSettle();
      expect(find.text(target), findsNothing);
      calendar.scrollToCurrentDay();
      await widgetTester.pumpAndSettle();
      expect(find.text(target), findsOneWidget);
    });
  });
}

class _IndividualMonthTester {
  final WidgetTester widgetTester;

  final int year;

  final int month;

  final String localeName;

  final List<TableRow> rows = <TableRow>[];

  _IndividualMonthTester({required this.widgetTester, required this.year, required this.month, this.localeName = 'en'});

  Future<void> init() async {
    await widgetTester.pumpWidget(MaterialApp(localizationsDelegates: const [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate
    ], supportedLocales: [
      Locale(localeName)
    ], home: _CalendarTestFrameworkWithoutBuilders(child: WeeksInMonthView(date: DateTime(year, month, 1)))));
    final widget = widgetTester.widget<Table>(find.bySubtype<Table>());
    rows.addAll(widget.children);
  }

  void testWeekNameRow() {
    final expected = [''];
    expected.addAll(_weekDayNames(widgetTester));
    _testRow(rowNumber: 0, expected: expected);
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

DateTime _today() {
  return DateUtils.dateOnly(DateTime.now());
}

Widget _widgetWithBuilders(Widget child) {
  return CalendarViewParameters(
      initialDate: DateTime.now(),
      dayBuilder: _builders.dayBuilder,
      weekNumberBuilder: _builders.weekNumberBuilder,
      weekDayNameBuilder: _builders.weekDayNameBuilder,
      monthNameBuilder: _builders.monthNameBuilder,
      monthBackgroundBuilder: _builders.monthBackgroundBuilder,
      localizations: _localizations,
      minMonthViewWidth: _minColumnWidth,
      maxMonthViewWidth: _maxColumnWidth,
      minHorizontalSpacing: _minHorizontalSpacing,
      minVerticalSpacing: _minVerticalSpacing,
      child: Directionality(textDirection: TextDirection.ltr, child: child));
}

double _enoughWidthFor({required int columns}) {
  return (_minColumnWidth + _minHorizontalSpacing) * (columns + 1) + _minHorizontalSpacing - 1;
}

Future<void> _setSurfaceSize({required WidgetTester widgetTester, required int expectedColumns}) =>
    widgetTester.binding.setSurfaceSize(Size(_enoughWidthFor(columns: expectedColumns), _surfaceHeight));

List<String> _weekDayNames(WidgetTester widgetTester) {
  final context = widgetTester.element(find.byType(CalendarViewParameters));
  final localizations = MaterialLocalizations.of(context);
  final result = <String>[];
  for (var i = localizations.firstDayOfWeekIndex; i < 7; ++i) {
    result.add(localizations.narrowWeekdays[i]);
  }
  for (var i = 0; i < localizations.firstDayOfWeekIndex; ++i) {
    result.add(localizations.narrowWeekdays[i]);
  }
  return result;
}

class _CalendarTestFrameworkWithoutBuilders extends StatelessWidget {
  final Widget child;

  const _CalendarTestFrameworkWithoutBuilders({required this.child});

  @override
  Widget build(BuildContext context) {
    return CalendarViewParameters(
        initialDate: DateTime.now(),
        localizations: Localizations.of(context, MaterialLocalizations) ?? _localizations,
        minMonthViewWidth: _minColumnWidth,
        maxMonthViewWidth: _maxColumnWidth,
        minHorizontalSpacing: _minHorizontalSpacing,
        minVerticalSpacing: _minVerticalSpacing,
        child: Directionality(textDirection: TextDirection.ltr, child: child));
  }
}
