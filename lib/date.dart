import 'package:flutter/material.dart';
import 'package:weather/utils.dart';

class TimeBar extends StatelessWidget {
  TimeBar({super.key, required this.owmResp});

  final Map<String, dynamic> owmResp;

  @override
  Widget build(BuildContext context) {
    return Text(formattedTime(owmResp['dt']));
  }
}
