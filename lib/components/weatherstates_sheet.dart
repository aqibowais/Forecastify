import 'package:flutter/material.dart';

// ignore: must_be_immutable
class WeatherStates extends StatelessWidget {
  int windspeed, humidity, cloud;
  WeatherStates(
      {super.key,
      required this.humidity,
      required this.cloud,
      required this.windspeed});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.85,
      height: size.height * 0.2,
      decoration: BoxDecoration(
        color: const Color(0xff331c71),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 30),
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
                  '$windspeed KM/h',
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
                  '$humidity%',
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
                  cloud.toString(),
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
    );
  }
}
