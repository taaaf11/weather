import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'notifiers.dart';
import 'utils.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  SharedPreferences? prefs;

  late TextEditingController _textControllerCity;
  late TextEditingController _textControllerApiKey;
  late TextEditingController _textControllerColorSchemeSeed;

  Future<void> getSharedPrefsInst() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    _textControllerCity = TextEditingController();
    _textControllerApiKey = TextEditingController();
    _textControllerColorSchemeSeed = TextEditingController();
    super.initState();
    getSharedPrefsInst();
  }

  @override
  void dispose() {
    _textControllerCity.dispose();
    _textControllerApiKey.dispose();
    _textControllerColorSchemeSeed.dispose();
    super.dispose();
  }

  void saveCity(String data) {
    prefs!.setString('city', data);
  }

  void saveApiKey(String data) {
    prefs!.setString('apiKey', data);
  }

  void saveColorSchemeSeed(int seed) {
    prefs!.setInt('colorSchemeSeed', seed);
  }

  void saveThemeMode(Brightness mode) {
    prefs!.setString('theme_mode', themeModetoString(mode));
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var themeState = Provider.of<ThemeProvider>(context);

    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          SizedBox(
            width: width / 2,
            child: TextField(
              controller: _textControllerCity,
              textAlign: TextAlign.center,
              decoration: InputDecoration(hintText: 'City'),
              style: TextStyle(fontSize: 18),
              onChanged: (data) => saveCity(data),
            ),
          ),
          SizedBox(height: 10),
          SizedBox(
              width: width / 2,
              child: TextField(
                  controller: _textControllerApiKey,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(hintText: 'OWM Api Key'),
                  style: TextStyle(fontSize: 18),
                  onSubmitted: (data) => saveApiKey(data))),
          SizedBox(height: 60),
          ElevatedButton.icon(
            icon: Icon((themeState.curThemeMode == Brightness.dark)
                ? Icons.light_mode
                : Icons.dark_mode),
            label: Text((themeState.curThemeMode == Brightness.dark)
                ? 'Light mode'
                : 'Dark mode'),
            onPressed: () {
              setState(() {
                themeState.switchThemeMode();
                saveThemeMode(themeState.curThemeMode);
                // prefs!.setString('theme_mode', themeModetoString(themeState.curThemeMode));
              });
            },
          ),
          SizedBox(height: 10),
          SizedBox(
              width: width / 1.5,
              child: Tooltip(
                  message: 'color scheme eg #16666f',
                  child: TextField(
                    controller: _textControllerColorSchemeSeed,
                    textAlign: TextAlign.center,
                    decoration:
                        InputDecoration(hintText: 'color scheme eg #16666f'),
                    // onChanged: (value) => {
                    //   setState(() {
                    //     // if the color hex format is not correct
                    //     // correct format: #rrggbb
                    //     if (value.length < 7 || value.length > 7) {
                    //       return;
                    //     }
                    //
                    //     // in format 0x ...
                    //     var usableColor =
                    //         int.parse('0xff${value.substring(1)}');
                    //     saveColorSchemeSeed(usableColor);
                    //   }),
                    // },
                  ))),
          SizedBox(height: 10),
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              var colorSchemeSeed = _textControllerColorSchemeSeed.text;

              if (colorSchemeSeed.length < 7 || colorSchemeSeed.length > 7) {
                return;
              }
              // in format 0x ...
              var usableColor =
                  int.parse('0xff${colorSchemeSeed.substring(1)}');
              themeState.changeColorSchemeSeed(usableColor);
              saveColorSchemeSeed(usableColor);
            },
          ),
          // Text(
          //   '*Color scheme change takes effect \nonce you restart the app.',
          //   textAlign: TextAlign.center,
          // ),
          SizedBox(height: 30),
          ElevatedButton.icon(
            icon: Icon(Icons.delete),
            label: Text('Delete app data'),
            onPressed: () async {
              await delAppData();
            },
          )
        ]));
  }
}
