import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:weather/weatherpage.dart';
import 'package:weather/settingspage.dart';
import 'package:provider/provider.dart';

import 'package:weather/utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences.setPrefix('taaaf_weather_app_flutter');
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String? city = prefs.getString('city');
  String? apiKey = prefs.getString('apiKey');

  Map<String, dynamic>? owmResp =
      await fetchWeatherOWM(city: city, apiKey: apiKey);

  runApp(MyApp(apiKey: apiKey, owmResp: owmResp));
}

class MyApp extends StatelessWidget {
  final Map<String, dynamic>? owmResp;
  final String? apiKey;

  MyApp({super.key, required this.apiKey, required this.owmResp});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => OwmProvider(apiKey: apiKey, owmResp: owmResp),
        child: MaterialApp(
          title: 'Weather',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.deepOrange, brightness: Brightness.dark),
            fontFamily: 'Comfortaa',
            useMaterial3: true,
          ),
          home: MyHomePage(title: 'Weather', apiKey: apiKey, owmResp: owmResp),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage(
      {super.key,
      required this.title,
      required this.apiKey,
      required this.owmResp});

  final String title;
  final String? apiKey;
  final Map<String, dynamic>? owmResp;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  var selectedPage = 0;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 5000));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<OwmProvider>(context);

    Widget? page;
    switch (selectedPage) {
      case 0:
        page = WeatherPage(apiKey: widget.apiKey, owmResp: widget.owmResp);
      case 1:
        page = SettingsPage();
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
          actions: [
            RotationTransition(
                turns:
                    Tween(begin: 0.0, end: -1.0).animate(_animationController),
                child: IconButton(
                    onPressed: () {
                      state.update(_animationController);
                    },
                    icon: Icon(Icons.sync)))
          ],
        ),
        drawer: NavigationDrawer(
          selectedIndex: selectedPage,
          onDestinationSelected: (value) => setState(() {
            selectedPage = value;
          }),
          children: [
            NavigationDrawerDestination(
                icon: Icon(Icons.home), label: Text('Home')),
            NavigationDrawerDestination(
                icon: Icon(Icons.settings), label: Text('Settings'))
          ],
        ),
        body: page);
  }
}
