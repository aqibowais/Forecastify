// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class DetailScreen extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final dailyWeatherForecast;
  const DetailScreen({super.key, required this.dailyWeatherForecast});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(duration: const Duration(seconds: 1), vsync: this)
        ..repeat();
  Map<String, dynamic> weatherData = {};
  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var weatherdata = widget.dailyWeatherForecast;
    //function
    Map getWeatherForcast(int index) {
      int windSpeed = weatherdata[index]["day"]["maxwind_kph"].toInt();
      int humidity = weatherdata[index]["day"]["avghumidity"].toInt();
      int cloud = weatherdata[index]["day"]["daily_chance_of_rain"].toInt();

      int minTemp = weatherdata[index]["day"]["mintemp_c"].toInt();
      int maxTemp = weatherdata[index]["day"]["maxtemp_c"].toInt();
      var forcasteDate = DateFormat("EEEE, d MMMM")
          .format(DateTime.parse(weatherdata[index]["date"]));
      String weatherName = weatherdata[index]["day"]["condition"]["text"];
      String weatherIcon =
          "${weatherName.replaceAll(" ", "").toLowerCase()}.png";
      var forecastData = {
        'maxWindSpeed': windSpeed,
        'avgHumidity': humidity,
        'chanceOfRain': cloud,
        'forecastDate': forcasteDate,
        'weatherName': weatherName,
        'weatherIcon': weatherIcon,
        'minTemperature': minTemp,
        'maxTemperature': maxTemp,
      };
      return forecastData;
    }

    //refreshing
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

    return Scaffold(
      backgroundColor: const Color(0xff331c71),
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(9.0),
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: const Color(0xff5842A9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.white,
                size: 23,
              ),
            ),
          ),
        ),
        title: Text(
          "7 Days",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(9.0),
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: const Color(0xff5842A9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Row(
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(width: 20),
                            Text("Refreshing..."),
                          ],
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
                        size: 23,
                      ),
              ),
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 15,
            ),
            Container(
              height: size.height * 0.4,
              width: size.width * 0.9,
              decoration: BoxDecoration(
                color: Color(0xff5842A9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Stack(
                        children: [
                          Opacity(
                            opacity: 0.6,
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Image(
                                image: AssetImage(
                                  "assets/${getWeatherForcast(0)["weatherIcon"]}",
                                ),
                                height: 160,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 15,
                            right: 0,
                            top: 30,
                            bottom: 0,
                            child: Center(
                              child: Text(
                                '${(getWeatherForcast(0)["maxTemperature"])}\u00B0',
                                style: TextStyle(
                                  fontSize: 90,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Today",
                            style: TextStyle(color: Colors.white, fontSize: 17),
                          ),
                          Text(
                            getWeatherForcast(0)["weatherName"].length > 15
                                ? "Rain With Thunder"
                                : getWeatherForcast(0)["weatherName"],
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Image(
                              image: const AssetImage(
                                "assets/wind.png",
                              ),
                              height: size.height * 0.05,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              '${getWeatherForcast(0)["maxWindSpeed"]}KM/h',
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const Text(
                              'Wind Speed',
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
                              image: const AssetImage(
                                "assets/droplet.png",
                              ),
                              height: size.height * 0.05,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              '${getWeatherForcast(0)["avgHumidity"]}%',
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const Text(
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
                              image: const AssetImage(
                                "assets/cloud.png",
                              ),
                              height: size.height * 0.05,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              getWeatherForcast(0)["chanceOfRain"].toString(),
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const Text(
                              'Cloud',
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
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 17),
                    child: Card(
                      color: Color(0xff5842A9),
                      elevation: 3.0,
                      margin: const EdgeInsets.only(
                        bottom: 20,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  getWeatherForcast(index)["forecastDate"],
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17),
                                ),
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "${getWeatherForcast(index)["minTemperature"].toString()}\u00B0",
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 30,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 6),
                                    Row(
                                      children: [
                                        Text(
                                          "${getWeatherForcast(index)["maxTemperature"].toString()}\u00B0",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 30,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/' +
                                          getWeatherForcast(
                                              index)["weatherIcon"],
                                      width: 30,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      getWeatherForcast(index)["weatherName"],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      getWeatherForcast(index)["chanceOfRain"]
                                              .toString() +
                                          "%",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Image.asset(
                                      'assets/lightrain.png',
                                      width: 30,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
            //ho
          ],
        ),
      ),
    );
  }
}
