import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/settingspage.dart';
import 'package:weather/utils.dart';
import 'package:weather/weatherpage.dart';

import 'notifiers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences.setPrefix('taaaf_weather_app_flutter');
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String? city = prefs.getString('city');
  String? apiKey = prefs.getString('apiKey');

  Brightness themeMode =
      stringToThemeMode(prefs.getString('theme_mode') ?? 'dark');
  int colorSchemeSeed = prefs.getInt('colorSchemeSeed') ?? 0xff01666f;

  Map<String, dynamic>? owmResp =
      await fetchWeatherOWM(city: city, apiKey: apiKey);

  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider<OwmProvider>(
            create: (context) => OwmProvider(apiKey: apiKey, owmResp: owmResp)),
        ChangeNotifierProvider<ThemeProvider>(
            create: (context) => ThemeProvider(
                themeMode: themeMode, colorSchemeSeed: colorSchemeSeed))
      ],
      child: MyApp(
        apiKey: apiKey,
        owmResp: owmResp,
        themeMode: themeMode,
        colorSchemeSeed: colorSchemeSeed,
      )));
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  Map<String, dynamic>? owmResp;
  String? apiKey;
  Brightness themeMode;
  int colorSchemeSeed;

  MyApp(
      {super.key,
      required this.apiKey,
      required this.owmResp,
      required this.themeMode,
      required this.colorSchemeSeed});

  @override
  Widget build(BuildContext context) {
    var themeState = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Weather',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Color(themeState.curColorSchemeSeed),
            brightness: themeState.curThemeMode),
        fontFamily: 'Comfortaa',
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'Weather', apiKey: apiKey, owmResp: owmResp),
    );
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
              turns: Tween(begin: 0.0, end: -1.0).animate(_animationController),
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 250),
                opacity: (selectedPage == 0) ? 1 : 0,
                child: IconButton(
                  onPressed: () {
                    state.update(_animationController);
                  },
                  icon: Icon(Icons.sync),
                ),
              ),
            )
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
