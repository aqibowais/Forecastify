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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const Image(
                image: AssetImage(
                  "assets/wind.png",
                ),
                height: 30,
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
              const Image(
                image: AssetImage(
                  "assets/droplet.png",
                ),
                height: 30,
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
              const Image(
                image: AssetImage(
                  "assets/cloud.png",
                ),
                height: 30,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                '${cloud.toStringAsFixed(2)}%',
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
    );
  }
}
