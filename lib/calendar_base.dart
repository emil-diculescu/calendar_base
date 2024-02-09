library calendar_base;

import 'package:flutter/material.dart';

@visibleForTesting
class Day extends StatelessWidget {
  final DateTime date;
  const Day({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text((date.day.toString())));
  }
}
