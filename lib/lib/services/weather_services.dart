import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;

class WeatherServices {
  static String apiKey = "e61b4ab38a5c4e9286b185545241103";
  String location = "Pakistan"; //default
  String weathericon = "assets/wind.png";
  int temperature = 0;
  int windspeed = 0;
  int humidity = 0;
  int cloud = 0;
  String currentDate = "";

  List hourlyWeatherForecasts = [];
  List dailyWeatherForecasts = [];

  String currentWeatherStatus = "";

  String searchWeatherApi =
      "http://api.weatherapi.com/v1/forecast.json?key=$apiKey&days=7&q=";

  Future<Map<String, dynamic>> fetchWeatherData(String searchtext) async {
    try {
      var searchResult =
          await http.get(Uri.parse(searchWeatherApi + searchtext));
      if (searchResult.statusCode == 200) {
        final weatherData =
            Map<String, dynamic>.from(jsonDecode(searchResult.body));
        // var locationData = weatherData["location"];
        // var currentData = weatherData["current"];
        return weatherData;
      } else {
        throw Exception("Error");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
