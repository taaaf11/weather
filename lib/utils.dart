import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

Future<void> delAppData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var keys = prefs.getKeys();
  for (final key in keys) {
    await prefs.remove(key);
  }
}

String formattedTime(secondsSinceEpoch) {
  return DateFormat('h:mm a • E, MMM d')
      .format(DateTime.fromMillisecondsSinceEpoch(secondsSinceEpoch * 1000));
}

int hexColorStringToInt(String hex) {
  if (!(hex.length < 7)) {
    // in format 0x ...
    return int.parse('0xff${hex.substring(1)}');
  } else {
    throw Exception('Bad color format.');
  }
}

// 'dark' -> Brightness.dark
// 'light' -> Brightness.light
Brightness stringToThemeMode(String _) {
  switch (_) {
    case 'light':
      return Brightness.light;
    case 'dark':
    default:
      return Brightness.dark;
  }
}

// reverse of stringToThemeMode
String themeModetoString(Brightness _) {
  switch (_) {
    case Brightness.dark:
      return 'dark';
    case Brightness.light:
      return 'light';
  }
}
