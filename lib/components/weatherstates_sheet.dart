import 'package:flutter/material.dart';

class WeatherStates extends StatelessWidget {
  final int windspeed, humidity, cloud;

  WeatherStates({
    Key? key,
    required this.humidity,
    required this.cloud,
    required this.windspeed,
  }) : super(key: key);

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
                  image: const AssetImage("assets/wind.png"),
                  height: size.height * 0.05,
                ),
                const SizedBox(height: 10),
                Text(
                  '$windspeed KM/h',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  'Wind Speed',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.white,
                      ),
                ),
              ],
            ),
            Column(
              children: [
                Image(
                  image: const AssetImage("assets/droplet.png"),
                  height: size.height * 0.05,
                ),
                const SizedBox(height: 10),
                Text(
                  '$humidity%',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  'Humidity',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.white,
                      ),
                ),
              ],
            ),
            Column(
              children: [
                Image(
                  image: const AssetImage("assets/cloud.png"),
                  height: size.height * 0.05,
                ),
                const SizedBox(height: 10),
                Text(
                  cloud.toString(),
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  'Cloud',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.white,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
