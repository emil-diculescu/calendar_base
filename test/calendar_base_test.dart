import 'package:calendar_base/calendar_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Day tests', () {
    testWidgets('Displays the day by default', (widgetTester) async {
      final date = DateUtils.dateOnly(DateTime.now());
      await _initWidgetWithDirectionality(widgetTester, Day(date: date));
      expect(find.text(date.day.toString()), findsOneWidget);
    });
  });
}

Future<void> _initWidgetWithDirectionality(WidgetTester widgetTester, Widget child) async {
  return widgetTester.pumpWidget(Directionality(textDirection: TextDirection.ltr, child: child));
}
