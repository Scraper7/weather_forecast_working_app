import 'package:flutter/material.dart';
import 'package:flutter_weather_course/screens/location_screen.dart';

// import 'package:flutter_weather_course/screens/weather_forecast_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LocationScreen(),
    );
  }
}
