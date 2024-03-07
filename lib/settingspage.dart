import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  SharedPreferences? prefs;

  final textControllerCity = TextEditingController();
  final textControllerApiKey = TextEditingController();

  Future<void> getSharedPrefsInst() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    getSharedPrefsInst();
  }

  void setCity(String data) {
    prefs!.setString('city', data);
  }

  void setApiKey(String data) {
    prefs!.setString('apiKey', data);
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          SizedBox(
              width: width / 2,
              child: TextField(
                  controller: textControllerCity,
                  onChanged: (data) => setCity(data),
                  decoration: InputDecoration(hintText: 'City'),
                  style: TextStyle(fontSize: 18))),
          SizedBox(width: 20),
          SizedBox(
              width: width / 2,
              child: TextField(
                  controller: textControllerApiKey,
                  onSubmitted: (data) => setApiKey(data),
                  decoration: InputDecoration(hintText: 'OWM Api Key'),
                  style: TextStyle(fontSize: 18)))
        ]));
  }
}
