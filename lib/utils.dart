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

class OwmProvider with ChangeNotifier {
  Map<String, dynamic>? owmResp;
  String? apiKey;

  OwmProvider({required this.apiKey, required this.owmResp});

  Future<void> update(AnimationController animationController) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String city = owmResp?['name'] ??
        prefs.getString('city'); // user has specified in the settings
    apiKey = apiKey ?? prefs.getString('apiKey'); // said already

    animationController.forward();
    owmResp = await fetchWeatherOWM(city: city, apiKey: apiKey);
    animationController.stop();
    notifyListeners();
  }
}

class ThemeProvider with ChangeNotifier {
  late Brightness _curThemeMode;
  late int _curColorSchemeSeed;

  Brightness themeMode;
  int colorSchemeSeed;

  ThemeProvider({required this.themeMode, required this.colorSchemeSeed}) {
    _curThemeMode = themeMode;
    _curColorSchemeSeed = colorSchemeSeed;
  }

  void switchThemeMode() {
    _curThemeMode =
        (_curThemeMode == Brightness.dark) ? Brightness.light : Brightness.dark;
    notifyListeners();
  }

  void changeColorSchemeSeed(int seed) {
    _curColorSchemeSeed = seed;
    notifyListeners();
  }

  void update() {
    notifyListeners();
  }

  Brightness get curThemeMode => _curThemeMode;

  int get curColorSchemeSeed => _curColorSchemeSeed;
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

int hexColorStringtoInt(String hex) {
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
