import 'dart:convert';
import 'dart:developer';

import 'package:flutter_weather_course/models/weather_forecast_daily.dart';
import 'package:flutter_weather_course/utilities/constans.dart';
import 'package:flutter_weather_course/utilities/location.dart';
import 'package:http/http.dart' as http;

class WeatherApi {
  Future<WeatherForecast> fetchWeatherForecast(
      {String? cityName, bool? isCity}) async {
    Location location = Location();

    try {
      await location.getCurrentLocation();

      // Проверка значений широты и долготы
      if (location.latitude == null || location.longitude == null) {
        throw Exception('Failed to get location coordinates');
      }

      Map<String, String>? parameters;

      if (isCity == true) {
        var queryParameters = {
          'APPID': Constans.WEATHER_APP_ID,
          'units': 'metric',
          'q': cityName!,
        };
        parameters = queryParameters.cast<String, String>();
      } else {
        var queryParameters = {
          'APPID': Constans.WEATHER_APP_ID,
          'units': 'metric',
          'lat': location.latitude.toString(),
          'lon': location.longitude.toString(),
        };
        parameters = queryParameters;
      }

      var uri = Uri.https(Constans.WEATHER_BASE_URL_DOMAIN,
          Constans.WEATHER_FORECAST_PATH, parameters);

      log('request: ${uri.toString()}');

      var response = await http.get(uri);

      print('response: ${response.body}');

      if (response.statusCode == 200) {
        return WeatherForecast.fromJson(json.decode(response.body));
      } else {
        throw Exception('Error response');
      }
    } catch (e) {
      log('Error fetching weather data: $e');
      throw Exception('Failed to get weather data: $e');
    }
  }
}
