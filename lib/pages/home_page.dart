// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:ui';

import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:forecastify/components/modal_bottom_sheet.dart';
import 'package:forecastify/components/reusbale_tile.dart';
import 'package:forecastify/components/weatherstates_sheet.dart';
import 'package:forecastify/model/weathermanager.dart';
import 'package:forecastify/pages/detail_screen.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final WeatherManager weathermanager = WeatherManager();
  Map<String, dynamic> weatherData = {};
  List hourlyWeatherForecast = [];
  List dailyWeatherForecast = [];

  late final AnimationController _controller =
      AnimationController(duration: const Duration(seconds: 1), vsync: this)
        ..repeat();

  bool _isRefreshing = false;

  Future<void> _refreshData() async {
    setState(() {
      _isRefreshing = true;
    });

    await Future.delayed(Duration(seconds: 2));
    // After the operation is complete, update the UI
    setState(() {
      _isRefreshing = false;
    });
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      try {
        weatherData =
            await weathermanager.fetchWeatherData(weathermanager.location);
        dailyWeatherForecast = weatherData["forecast"]["forecastday"];
        hourlyWeatherForecast = dailyWeatherForecast[0]["hour"];
        setState(() {});
      } catch (e) {
        CircularProgressIndicator();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: const Color(0xff5842A9),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: Padding(
            padding: EdgeInsets.all(10.0),
            child: CircleAvatar(
              radius: 20,
              child: Icon(Icons.person),
            ),
          ),
          actions: [
            CustomBottomSheet(
              onChanged: (location) async {
                try {
                  weatherData = await weathermanager.fetchWeatherData(location);
                  dailyWeatherForecast = weatherData["forecast"]["forecastday"];
                  hourlyWeatherForecast = dailyWeatherForecast[0]["hour"];
                  setState(() {});
                } catch (e) {
                  CircularProgressIndicator();
                }
              },
            ),
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      backgroundColor: Colors.transparent,
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 3),
                        child: Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white
                                .withOpacity(0.3), // Semi-transparent white
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.4),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(
                                color: Color(0xff331c71),
                              ),
                              SizedBox(width: 20),
                              Text(
                                "Refreshing...",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
                _refreshData();
              },
              icon: _isRefreshing
                  ? CircularProgressIndicator()
                  : Icon(
                      Icons.refresh,
                      color: Colors.white,
                      size: 30,
                    ),
            ),
          ],
        ),
        body: weatherData.isNotEmpty
            ? SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: size.width,
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
                                weathermanager.getShortLocationName(
                                    weatherData['location']['name']),
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: size.height * 0.008,
                          ),
                          Text(
                            weatherData.isNotEmpty
                                ? weatherData['current']['condition']['text']
                                : "",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                          weatherData.isNotEmpty
                              ? Stack(
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
                                          '${(weatherData["current"]["temp_c"] as double).toInt()}\u00B0',
                                          style: TextStyle(
                                            fontSize: 100,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : CircularProgressIndicator(),
                          Text(
                            weatherData.isNotEmpty
                                ? DateFormat('EEEE,  d MMMM yyyy').format(
                                    DateTime.parse(
                                      weatherData["location"]["localtime"]
                                          .substring(0, 10),
                                    ),
                                  )
                                : "",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          WeatherStates(
                              humidity: weatherData.isNotEmpty
                                  ? weatherData["current"]["humidity"].toInt()
                                  : 0,
                              cloud: weatherData.isNotEmpty
                                  ? weatherData["current"]["cloud"].toInt()
                                  : 0,
                              windspeed: weatherData.isNotEmpty
                                  ? weatherData["current"]["wind_kph"].toInt()
                                  : 0),
                          SizedBox(
                            height: size.height * 0.025,
                          ),
                          Padding(
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
                                Ink(
                                  width: 100,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Color(0xff331c71),
                                    borderRadius: BorderRadius.circular(60),
                                  ),
                                  child: InkWell(
                                    onTap: () => Navigator.push(
                                      (context),
                                      MaterialPageRoute(
                                        builder: (context) => DetailScreen(
                                          dailyWeatherForecast:
                                              dailyWeatherForecast,
                                        ),
                                      ),
                                    ),
                                    borderRadius: BorderRadius.circular(60),
                                    splashColor:
                                        Colors.deepPurple.withOpacity(0.3),
                                    highlightColor:
                                        Colors.deepPurple.withOpacity(0.1),
                                    child: Center(
                                      child: Text(
                                        'Forecasts',
                                        style: TextStyle(
                                            fontSize: 17, color: Colors.blue),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          SizedBox(
                            height: 125,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                physics: BouncingScrollPhysics(),
                                itemCount: hourlyWeatherForecast.length,
                                itemBuilder: (BuildContext context, int index) {
                                  String currentTime = DateFormat('HH:mm:ss')
                                      .format(DateTime.now());
                                  String currentHour =
                                      currentTime.substring(0, 2);
                                  String forcasteTime =
                                      hourlyWeatherForecast[index]['time']
                                          .substring(11, 16);
                                  String forcasteHour =
                                      hourlyWeatherForecast[index]['time']
                                          .substring(11, 13);
                                  String forecastWeatherName =
                                      hourlyWeatherForecast[index]['condition']
                                          ["text"];
                                  String forcastIcon =
                                      "${forecastWeatherName.replaceAll(" ", "").toLowerCase()}.png";
                                  String forecastTemp =
                                      hourlyWeatherForecast[index]['temp_c']
                                          .round()
                                          .toString();
                                  // Check if the image exists in the assets
                                  bool isImageExists = false;
                                  try {
                                    Image.asset('assets/$forcastIcon')
                                        .image
                                        .resolve(ImageConfiguration())
                                        .addListener(
                                      ImageStreamListener((info, _) {
                                        isImageExists = true;
                                      }),
                                    );
                                  } catch (e) {
                                    isImageExists = false;
                                  }
                                  return ReusableTile(
                                    currentHour: currentHour,
                                    forcastHour: forcasteHour,
                                    forcastIcon: forcastIcon,
                                    forcastTemp: forecastTemp,
                                    forcastTime: forcasteTime,
                                    isImageExists: isImageExists,
                                  );
                                }),
                          )
                        ],
                      ),
                    ),
                  ],
                ))
            : Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ));
  }
}
