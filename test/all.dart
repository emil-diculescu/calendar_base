import 'package:flutter/material.dart';
import 'package:mockito/annotations.dart';

@GenerateNiceMocks([MockSpec<Builders>()])
abstract class Builders {
  Widget dayBuilder(BuildContext context, DateTime date);

  Widget weekNumberBuilder(BuildContext context, int weekNumber);

  Widget weekDayNameBuilder(BuildContext context, String weekDayName);

  Widget monthNameBuilder(BuildContext context, DateTime date);

  Widget monthBackgroundBuilder(BuildContext context, DateTime date, Widget child);
}
