// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:forecastify/components/Reusbale_tile.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

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
  String location = "london"; //default
  String weathericon = "assets/wind.png";
  int temperature = 0;
  int windspeed = 0;
  int humidity = 0;
  double precep = 0.0;
  String currentDate = "";
  List hourlyWeatherForecasts = [];
  List dailyWeatherForecasts = [];

  String currentWeatherStatus = "";

  String searchWeatherApi =
      "https://api.weatherapi.com/v1/forecast.json?key=$apiKey%20&&days=7&q=";

  void fetchWeatherData(String searchtext) async {
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
            precep = ((locationData["precip_mm"].toInt()) / 0.1) * 100;
            print(currentWeather);
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
    super.initState();
    fetchWeatherData(location);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController locationController = TextEditingController();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xff5842a9),
      appBar: AppBar(
        leading: const Drawer(
          backgroundColor: Colors.transparent,
          child: Icon(
            Icons.menu,
            color: Colors.white,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('assets/aqib.png'),
            ),
          ),
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
                        IconButton(
                          onPressed: () {
                            locationController.clear();
                            showMaterialModalBottomSheet(
                              context: context,
                              builder: (context) => SingleChildScrollView(
                                controller: ModalScrollController.of(context),
                                child: Container(
                                  height: size.height * .5,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xff955cd1),
                                        Color(0xff362A84),
                                      ],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        width: 70,
                                        child: Divider(
                                          thickness: 3.5,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      TextField(
                                        onChanged: (location) =>
                                            fetchWeatherData(location),
                                        controller: locationController,
                                        autofocus: true,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.search,
                                            color: Colors.white,
                                          ),
                                          suffixIcon: IconButton(
                                            onPressed: () {
                                              locationController.clear();
                                            },
                                            icon: Icon(
                                              Icons.close,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.white,
                            size: 28,
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
                    Align(
                      alignment: Alignment.center,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 10,
                            top: 40,
                            child: Opacity(
                              opacity: 0.6,
                              child: Lottie.asset(
                                'assets/PJ7QlLsBT3.json',
                                controller: _controller,
                                height: 185,
                              ),
                            ),
                          ),
                          Text(
                            '$temperature°',
                            style: TextStyle(
                              fontSize: 120,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
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
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Image(
                                  image: AssetImage(
                                    "assets/protection.png",
                                  ),
                                  height: 30,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  '${precep.toStringAsFixed(2)}%',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'Precipitation',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                            Column(
                              children: [
                                Image(
                                  image: AssetImage(
                                    "assets/droplet.png",
                                  ),
                                  height: 30,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  '$humidity%',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'Humidity',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                            Column(
                              children: [
                                Image(
                                  image: AssetImage(
                                    "assets/wind.png",
                                  ),
                                  height: 30,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  '$windspeed KM/h',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'Wind Speed',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
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
