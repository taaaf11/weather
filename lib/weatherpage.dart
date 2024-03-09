import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/conditions.dart';
import 'package:weather/date.dart';
import 'package:weather/notifiers.dart';
import 'package:weather/utils.dart';

class WeatherPage extends StatefulWidget {
  WeatherPage({super.key, required this.apiKey, required this.owmResp});

  final Map<String, dynamic>? owmResp;
  final String? apiKey;

  @override
  State<WeatherPage> createState() => _WeatherPage();
}

class _WeatherPage extends State<WeatherPage> {
  @override
  Widget build(BuildContext context) {
    var state = Provider.of<OwmProvider>(context);

    if (state.owmResp == null) {
      return Center(
          child: Text(
              'City/api key or both are not specified. Please add them in the Settings.'));
    }

    if (state.owmResp!['cod'] != 200) {
      return Center(child: Text('Invalid API key...'));
    } else {
      return ChangeNotifierProvider(
        create: (context) =>
            OwmProvider(apiKey: state.apiKey, owmResp: state.owmResp),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TimeBar(),
            Temperature(owmResp: state.owmResp!),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: WindSpeed(owmResp: state.owmResp!),
                ),
                Expanded(
                  child: Humidity(owmResp: state.owmResp!),
                )
              ],
            ),
            SizedBox(height: 30),
            Text(
              'Last updated:\n${formattedTime(state.owmResp!['dt'])}',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, height: 1.8),
            )
          ],
        ),
      );
    }
  }
}
