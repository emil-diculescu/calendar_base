import 'dart:math';

import 'package:calendar_base/calendar_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'calendar_base_test.mocks.dart';

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
    testWidgets('Test month starting on Sunday', (widgetTester) async {
      final tester = _IndividualMonthTester(widgetTester: widgetTester, year: 2024, month: 9);
      await tester.init();
      tester.testRow(rowNumber: 0, expected: ['', 'S', 'M', 'T', 'W', 'T', 'F', 'S']);
      tester.testWeek(expectedRowNumber: 1, weekNumber: 36, startsWith: 1, endsWith: 7);
      tester.testWeek(expectedRowNumber: 2, weekNumber: 37, startsWith: 8, endsWith: 14);
      tester.testWeek(expectedRowNumber: 3, weekNumber: 38, startsWith: 15, endsWith: 21);
      tester.testWeek(expectedRowNumber: 4, weekNumber: 39, startsWith: 22, endsWith: 28);
      tester.testWeek(expectedRowNumber: 5, weekNumber: 40, startsWith: 29, endsWith: 30);
      tester.testNoMoreRows(expectedRowCount: 6);
    });
  });
}

abstract class Builders {
  Widget dayBuilder(BuildContext context, DateTime date);

  Widget weekNumberBuilder(BuildContext context, int weekNumber);

  Widget weekDayNameBuilder(BuildContext context, String weekDayName);
}

DateTime _today() {
  return DateUtils.dateOnly(DateTime.now());
}

Widget _widgetWithoutBuilders(Widget child) {
  return CalendarViewParameters(
      localizations: const DefaultMaterialLocalizations(),
      child: Directionality(textDirection: TextDirection.ltr, child: child));
}

Widget _widgetWithBuilders(Widget child) {
  return CalendarViewParameters(
      dayBuilder: _builders.dayBuilder,
      weekNumberBuilder: _builders.weekNumberBuilder,
      weekDayNameBuilder: _builders.weekDayNameBuilder,
      localizations: const DefaultMaterialLocalizations(),
      child: Directionality(textDirection: TextDirection.ltr, child: child));
}

class _IndividualMonthTester {
  final WidgetTester widgetTester;

  final int year;

  final int month;

  final List<TableRow> rows = <TableRow>[];

  _IndividualMonthTester({required this.widgetTester, required this.year, required this.month});

  Future<void> init() async {
    await widgetTester.pumpWidget(_widgetWithoutBuilders(WeeksInMonthView(DateTime(year, month, 1))));
    final widget = widgetTester.widget<Table>(find.bySubtype<Table>());
    rows.addAll(widget.children);
  }

  void testRow({required int rowNumber, required List<String> expected}) {
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
    return testRow(rowNumber: expectedRowNumber, expected: expected);
  }

  void _padWithEmpty(List<String> expected, int daysInWeek) {
    expected.addAll(List.filled(7 - daysInWeek, ''));
  }

  void testNoMoreRows({required int expectedRowCount}) {
    expect(rows.length, expectedRowCount);
  }
}
