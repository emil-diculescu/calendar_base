import 'package:calendar_base/calendar_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Day tests', () {
    testWidgets('Displays the day by default', (widgetTester) async {
      final date = DateUtils.dateOnly(DateTime.now());
      await widgetTester.pumpWidget(_widgetWithDirectionality(Day(date: date)));
      expect(find.text(date.day.toString()), findsOneWidget);
    });

    testWidgets('Calls builder, if builder is provided', (widgetTester) async {});
  });
}

Widget _widgetWithDirectionality(Widget child) {
  return Directionality(textDirection: TextDirection.ltr, child: child);
}
