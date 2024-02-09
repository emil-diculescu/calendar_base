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
