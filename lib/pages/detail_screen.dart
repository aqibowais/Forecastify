import 'package:flutter/material.dart';
import 'package:forecastify/components/Refresher.dart';
import 'package:forecastify/main.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class DetailScreen extends StatefulWidget {
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
  bool _isRefreshing = false;
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    setState(() {
      _isRefreshing = true;
    });

    await Future.delayed(Duration(seconds: 2));

    Navigator.of(context).pop();

    setState(() {
      _isRefreshing = false;
    });
  }

  Map getWeatherForcast(int index) {
    var weatherdata = widget.dailyWeatherForecast;
    int windSpeed = weatherdata[index]["day"]["maxwind_kph"].toInt();
    int humidity = weatherdata[index]["day"]["avghumidity"].toInt();
    int cloud = weatherdata[index]["day"]["daily_chance_of_rain"].toInt();
    int minTemp = weatherdata[index]["day"]["mintemp_c"].toInt();
    int maxTemp = weatherdata[index]["day"]["maxtemp_c"].toInt();
    var forecastDate = DateFormat("EEEE, d MMMM")
        .format(DateTime.parse(weatherdata[index]["date"]));
    String weatherName = weatherdata[index]["day"]["condition"]["text"];
    String weatherIcon = "${weatherName.replaceAll(" ", "").toLowerCase()}.png";

    return {
      'maxWindSpeed': windSpeed,
      'avgHumidity': humidity,
      'chanceOfRain': cloud,
      'forecastDate': forecastDate,
      'weatherName': weatherName,
      'weatherIcon': weatherIcon,
      'minTemperature': minTemp,
      'maxTemperature': maxTemp,
    };
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

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
            child: Center(
              child: IconButton(
                onPressed: () => navigatorKey.currentState!.pop(),
                icon: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.white,
                  size: 23,
                ),
              ),
            ),
          ),
        ),
        title: Text(
          "7 Days",
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
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
              child: Center(
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
                        ),
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
            SizedBox(height: 15),
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
                            left: 20,
                            right: 0,
                            top: 5,
                            bottom: 0,
                            child: Center(
                              child: Text(
                                '${(getWeatherForcast(0)["maxTemperature"])}\u00B0',
                                style: Theme.of(context)
                                    .textTheme
                                    .displayLarge!
                                    .copyWith(
                                      fontSize: 90,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Today",
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: Colors.white,
                                      fontSize: 17,
                                    ),
                          ),
                          Text(
                            getWeatherForcast(0)["weatherName"].length > 15
                                ? "Rain With Thunder"
                                : getWeatherForcast(0)["weatherName"],
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 7),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Image(
                              image: AssetImage("assets/wind.png"),
                              height: size.height * 0.05,
                            ),
                            SizedBox(height: 10),
                            Text(
                              '${getWeatherForcast(0)["maxWindSpeed"]}KM/h',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                            ),
                            Text(
                              'Wind Speed',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Image(
                              image: AssetImage("assets/droplet.png"),
                              height: size.height * 0.05,
                            ),
                            SizedBox(height: 10),
                            Text(
                              '${getWeatherForcast(0)["avgHumidity"]}%',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                            ),
                            Text(
                              'Humidity',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Image(
                              image: AssetImage("assets/cloud.png"),
                              height: size.height * 0.05,
                            ),
                            SizedBox(height: 10),
                            Text(
                              getWeatherForcast(0)["chanceOfRain"].toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                            ),
                            Text(
                              'Cloud',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: widget.dailyWeatherForecast.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 17),
                    child: Card(
                      color: Color(0xff5842A9),
                      elevation: 3.0,
                      margin: const EdgeInsets.only(bottom: 20),
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
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 17,
                                      ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "${getWeatherForcast(index)["minTemperature"].toString()}\u00B0",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                            color: Colors.white70,
                                            fontSize: 30,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      "${getWeatherForcast(index)["maxTemperature"].toString()}\u00B0",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                            color: Colors.white,
                                            fontSize: 30,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
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
                                    SizedBox(width: 5),
                                    Text(
                                      getWeatherForcast(index)["weatherName"],
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                            fontSize: 18,
                                            color: Colors.grey,
                                          ),
                                    ),
                                    SizedBox(width: 5),
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
            ),
          ],
        ),
      ),
    );
  }
}
