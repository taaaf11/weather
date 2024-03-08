import 'package:flutter/material.dart';
import 'package:weather/utils.dart';

class TimeBar extends StatelessWidget {
  TimeBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(formattedTime(DateTime.now().millisecondsSinceEpoch ~/ 1000), style: TextStyle(fontSize: 16));
  }
}
