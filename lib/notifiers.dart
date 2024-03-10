import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'utils.dart';

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
  late int _curColorSchemeSeed;
  late bool _isDark;

  int colorSchemeSeed;
  bool isDark;

  ThemeProvider({required this.isDark, required this.colorSchemeSeed}) {
    _isDark = isDark;
    _curColorSchemeSeed = colorSchemeSeed;
  }

  void switchThemeMode() {
    _isDark = !_isDark;
    notifyListeners();
  }

  void changeColorSchemeSeed(int seed) {
    _curColorSchemeSeed = seed;
    notifyListeners();
  }

  bool get isDarkThemeMode => _isDark;
  int get curColorSchemeSeed => _curColorSchemeSeed;
}
