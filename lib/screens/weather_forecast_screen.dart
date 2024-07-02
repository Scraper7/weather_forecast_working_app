import 'package:flutter/material.dart';
import 'package:flutter_weather_course/api/weather_api.dart';
import 'package:flutter_weather_course/models/weather_forecast_daily.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_weather_course/screens/city_screen.dart';
import 'package:flutter_weather_course/widgets/body_list_view.dart';
import 'package:flutter_weather_course/widgets/city_view.dart';
import 'package:flutter_weather_course/widgets/detail_view.dart';
import 'package:flutter_weather_course/widgets/temp_view.dart';

class WeatherForecastScreen extends StatefulWidget {
  final locationWeather;
  WeatherForecastScreen({this.locationWeather});

  @override
  State<WeatherForecastScreen> createState() => _WeatherForecastScreenState();
}

class _WeatherForecastScreenState extends State<WeatherForecastScreen> {
  late Future<WeatherForecast> forecastObject;
  String _cityName = 'London';

  @override
  void initState() {
    super.initState();
    fetchWeather();

    if (widget.locationWeather != null) {
      forecastObject = WeatherApi().fetchWeatherForecast();
    }
  }

  void fetchWeather() {
    forecastObject =
        WeatherApi().fetchWeatherForecast(cityName: _cityName, isCity: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text(
          'openweathermap.org',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.my_location, color: Colors.white),
          onPressed: () {
            setState(() {
              forecastObject = WeatherApi().fetchWeatherForecast();
            });
          },
        ),
        actions: [
          IconButton(
            onPressed: () async {
              var tappedName = await Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                return CityScreen();
              }));
              if (tappedName != null) {
                setState(() {
                  _cityName = tappedName;
                  fetchWeather();
                });
              }
            },
            icon: Icon(
              Icons.location_city,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          Container(
            child: FutureBuilder<WeatherForecast>(
                future: forecastObject,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        SizedBox(height: 50),
                        CityView(snapshot: snapshot),
                        SizedBox(height: 50.0),
                        TempView(snapshot: snapshot),
                        SizedBox(
                          height: 50.0,
                        ),
                        DetailView(snapshot: snapshot),
                        SizedBox(
                          height: 50.0,
                        ),
                        BottomListView(snapshot: snapshot),
                      ],
                    );
                  } else {
                    return Center(
                      child: SpinKitDoubleBounce(
                        color: Colors.black87,
                        size: 100.0,
                      ),
                    );
                  }
                }),
          )
        ],
      ),
    );
  }
}
