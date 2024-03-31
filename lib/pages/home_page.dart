// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:forecastify/components/Reusbale_tile.dart';
import 'package:forecastify/components/modal_bottom_sheet.dart';
import 'package:forecastify/components/weatherstates.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(duration: const Duration(seconds: 1), vsync: this)
        ..repeat();

  static String apiKey = "7001fba4a0d54e748d9114117242203";
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
      "https://api.weatherapi.com/v1/forecast.json?key=$apiKey%20&&days=7&q=";

  Future<void> fetchWeatherData(String searchtext) async {
    var searchResult = await http.get(Uri.parse(searchWeatherApi + searchtext));
    print(searchResult);
    if (searchResult.statusCode == 200) {
      try {
        final weatherData =
            Map<String, dynamic>.from(jsonDecode(searchResult.body));
        var locationData = weatherData["location"];
        var currentWeather = weatherData["current"];

        setState(() {
          location = getShortLocationName(locationData["name"]);
          //update time
          var parsedDate =
              DateTime.parse(locationData["localtime"].substring(0, 10));
          var newDate = DateFormat('MMMMEEEEd').format(parsedDate);
          currentDate = newDate;

          //update weatherstatus
          if (weatherData.isNotEmpty) {
            currentWeatherStatus = currentWeather['condition']['text'];
            weathericon =
                "${currentWeatherStatus.replaceAll(" ", "").toLowerCase()}.png";
            temperature = currentWeather["temp_c"].toInt();
            windspeed = currentWeather["wind_kph"].toInt();
            humidity = currentWeather["humidity"].toInt();
            cloud = (weatherData["cloud"]);
            log(cloud);
            print(weatherData.toString());
          }
        });
      } catch (e) {
        throw Exception(e.toString());
      }
    } else {
      CircularProgressIndicator();
    }
  }

  static String getShortLocationName(String s) {
    List<String> wordList = s.split(" ");
    if (wordList.isNotEmpty) {
      if (wordList.length > 1) {
        return "${wordList[0]} ${wordList[1]}";
      } else {
        return wordList[0];
      }
    } else {
      return "";
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    Future.microtask(() async {
      await fetchWeatherData(location);
    });

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xff5842a9),
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.all(10.0),
          child: CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage('assets/aqib.png'),
          ),
        ),
        actions: [
          CustomBottomSheet(
           
            onChanged: (location) => fetchWeatherData(location),
          ),
          IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: Icon(Icons.refresh),
            color: Colors.white,
            iconSize: 28,
          )
        ],
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: size.height * 0.03,
          ),
          child: SingleChildScrollView(
            child: Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: size.width,
                height: size.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: Colors.white,
                          size: 28,
                        ),
                        Text(
                          location,
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    Text(
                      currentWeatherStatus.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                    Stack(
                      children: [
                        Opacity(
                          opacity: 0.6,
                          child: Lottie.asset(
                            'assets/PJ7QlLsBT3.json',
                            controller: _controller,
                            height: 185,
                          ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: Text(
                              '$temperature°',
                              style: TextStyle(
                                fontSize: 120,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      currentDate,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    Container(
                        width: size.width * 0.85,
                        height: size.height * 0.2,
                        decoration: BoxDecoration(
                          color: const Color(0xff331c71),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: WeatherStates(
                            humidity: humidity,
                            cloud: cloud,
                            windspeed: windspeed)),
                    SizedBox(
                      height: size.height * 0.020,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Today',
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '7-Day Forecasts',
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.020,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ReusableTile(
                            image: 'assets/droplet.png',
                            time: "10 AM",
                            temp: "15",
                          ),
                          ReusableTile(
                            image: 'assets/droplet.png',
                            time: "11 AM",
                            temp: "17",
                          ),
                          ReusableTile(
                            image: 'assets/protection.png',
                            time: "12 AM",
                            temp: "17",
                          ),
                          ReusableTile(
                            image: 'assets/protection.png',
                            time: "1 PM",
                            temp: "18",
                          ),
                          ReusableTile(
                            image: 'assets/wind.png',
                            time: "2 PM",
                            temp: "18",
                          ),
                          ReusableTile(
                            image: 'assets/wind.png',
                            time: "3 PM",
                            temp: "18",
                          ),
                          ReusableTile(
                            image: 'assets/wind.png',
                            time: "4 PM",
                            temp: "18",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
