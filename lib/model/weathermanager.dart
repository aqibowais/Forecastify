import 'dart:convert';

import 'package:http/http.dart' as http;

class WeatherManager {
  static String apiKey = "7001fba4a0d54e748d9114117242203";
  String location = "Pakistan"; //default
  Future<Map<String, dynamic>> fetchWeatherData(String searchtext) async {
    String searchWeatherApi =
        "https://api.weatherapi.com/v1/forecast.json?key=$apiKey%20&&days=7&q=";
    var searchResult = await http.get(Uri.parse(searchWeatherApi + searchtext));
    if (searchResult.statusCode == 200) {
      return jsonDecode(searchResult.body);
    } else {
      throw Exception('Failed to fetch weather data');
    }
  }

  String getShortLocationName(String s) {
    List<String> wordlist = s.split(' ');
    if (wordlist.isNotEmpty) {
      if (wordlist.length > 1) {
        return "${wordlist[0]} ${wordlist[1]}";
      } else {
        return wordlist[0];
      }
    } else {
      return "";
    }
  }
}
