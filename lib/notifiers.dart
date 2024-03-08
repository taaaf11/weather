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
