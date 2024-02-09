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

    setUp(() {
      when(_builders.dayBuilder(any, any)).thenReturn(_stubWidget);
    });

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
    testWidgets('Displays week number by default', (widgetTester) async {
      const expectedWeekNumber = 6;
      final testDate = DateUtils.dateOnly(DateTime(2024, 2, 9));
      await widgetTester.pumpWidget(_widgetWithoutBuilders(WeekNumber(date: testDate)));
      expect(find.text(expectedWeekNumber.toString()), findsOneWidget);
    });
  });
}

abstract class Builders {
  Widget dayBuilder(BuildContext context, DateTime date);
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
      localizations: const DefaultMaterialLocalizations(),
      child: Directionality(textDirection: TextDirection.ltr, child: child));
}
