import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

Future<Map<String, dynamic>?> fetchWeatherOWM(
    {String? city, String? apiKey}) async {
  if (city == null || apiKey == null) {
    return null;
  }

  var uri = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?q=$city&units=metric&appid=$apiKey');
  var response = await http.get(uri);

  return jsonDecode(response.body);
}

class OwmProvider with ChangeNotifier {
  Map<String, dynamic>? owmResp;
  final String? apiKey;
  double turns = 20;
  int seconds = 20;

  OwmProvider({required this.apiKey, required this.owmResp});

  Future<void> update(AnimationController animationController) async {
    animationController.forward();
    owmResp = await fetchWeatherOWM(city: owmResp!['name'], apiKey: apiKey);
    animationController.stop();
    notifyListeners();
  }
}

String formattedTime(secondsSinceEpoch) {
  return DateFormat('h:mm a • E, MMM d')
      .format(DateTime.fromMillisecondsSinceEpoch(secondsSinceEpoch * 1000));
}
