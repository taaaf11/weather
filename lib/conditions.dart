import 'package:flutter/material.dart';

class Humidity extends StatelessWidget {
  Humidity({super.key, required this.owmResp});

  final Map<String, dynamic> owmResp;

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('', style: TextStyle(fontFamily: 'Symbols-NF', fontSize: 20)),
          Text('${owmResp['main']['humidity']}%',
              style: TextStyle(fontSize: 20))
        ]);
  }
}

class WindSpeed extends StatefulWidget {
  WindSpeed({super.key, required this.owmResp});

  final Map<String, dynamic> owmResp;

  @override
  State<WindSpeed> createState() => _WindSpeed();
}

class _WindSpeed extends State<WindSpeed> {
  late double _speed = widget.owmResp['wind']['speed'];
  String unit = 'm/s';

  void _switchSpeedUnit() {
    setState(() {
      if (unit == 'm/s') {
        _speed *= 2.237;
        unit = 'miles/hr';
      } else if (unit == 'miles/hr') {
        _speed /= 2.237;
        unit = 'm/s';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('󰛓', style: TextStyle(fontFamily: 'Symbols-NF', fontSize: 20)),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Text(_speed.toStringAsFixed(0), style: TextStyle(fontSize: 20)),
            TextButton(
                onPressed: _switchSpeedUnit,
                style: ButtonStyle(
                    overlayColor:
                        MaterialStateProperty.all(Colors.transparent)),
                child: Text(unit, style: TextStyle(fontSize: 17))),
          ])
        ]);
  }
}

class Temperature extends StatefulWidget {
  Temperature({super.key, required this.owmResp});

  final Map<String, dynamic> owmResp;

  @override
  State<Temperature> createState() => _Temperature();
}

class _Temperature extends State<Temperature> {
  late double _temp = widget.owmResp['main']['temp'];
  late double _tempMin = widget.owmResp['main']['temp_min'];
  late double _tempMax = widget.owmResp['main']['temp_max'];

  String unit = 'C';

  void _switchTempUnit() {
    setState(() {
      if (unit == 'C') {
        _temp = (9 / 5 * _temp) + 32;
        _tempMax = (9 / 5 * _tempMax) + 32;
        _tempMin = (9 / 5 * _tempMin) + 32;

        unit = 'F';
      } else if (unit == 'F') {
        _temp = (_temp - 32) * 5 / 9;
        _tempMax = (_tempMax - 32) * 5 / 9;
        _tempMin = (_tempMin - 32) * 5 / 9;

        unit = 'C';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        Image(
            image: NetworkImage(
                "https://openweathermap.org/img/wn/${widget.owmResp["weather"][0]["icon"]}@2x.png")),
        Container(
            padding: EdgeInsets.all(10),
            child: Row(children: [
              Text(_temp.toStringAsFixed(0), style: TextStyle(fontSize: 35)),
            ])),
        TextButton(
            onPressed: _switchTempUnit,
            style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.transparent)),
            child: Text('°$unit', style: TextStyle(fontSize: 30))),
      ]),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        // Weather description short
        Text(widget.owmResp['weather'][0]['main'],
            style: TextStyle(fontSize: 25)),
      ])
    ]);
  }
}
