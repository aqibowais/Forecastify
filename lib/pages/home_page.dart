// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:forecastify/components/Refresher.dart';
import 'package:forecastify/components/modal_bottom_sheet.dart';
import 'package:forecastify/components/reusbale_tile.dart';
import 'package:forecastify/components/weatherstates_sheet.dart';
import 'package:forecastify/main.dart';
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
          padding: const EdgeInsets.all(10.0),
          child: CustomBottomSheet(
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
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Refresher();
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
                              style: Theme.of(context).textTheme.displayMedium,
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
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        SizedBox(
                          height: size.height * 0.008,
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayLarge,
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
                          style: Theme.of(context).textTheme.bodyLarge,
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
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              Ink(
                                width: 100,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Color(0xff331c71),
                                  borderRadius: BorderRadius.circular(60),
                                ),
                                child: InkWell(
                                  onTap: () => navigatorKey.currentState!.push(
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(color: Colors.blue),
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
                              String currentTime =
                                  DateFormat('HH:mm:ss').format(DateTime.now());
                              String currentHour = currentTime.substring(0, 2);
                              String forecastTime = hourlyWeatherForecast[index]
                                      ['time']
                                  .substring(11, 16);
                              String forecastHour = hourlyWeatherForecast[index]
                                      ['time']
                                  .substring(11, 13);
                              String forecastWeatherName =
                                  hourlyWeatherForecast[index]['condition']
                                      ["text"];
                              String forecastIcon =
                                  "${forecastWeatherName.replaceAll(" ", "").toLowerCase()}.png";
                              String forecastTemp = hourlyWeatherForecast[index]
                                      ['temp_c']
                                  .round()
                                  .toString();

                              // Check if the image exists in the assets
                              bool isImageExists = false;
                              try {
                                Image.asset('assets/$forecastIcon')
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
                                forcastHour: forecastHour,
                                forcastIcon: forecastIcon,
                                forcastTemp: forecastTemp,
                                forcastTime: forecastTime,
                                isImageExists: isImageExists,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
    );
  }

  void _selectImage() {}
}
