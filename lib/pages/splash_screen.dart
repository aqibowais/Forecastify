import 'dart:async';

import 'package:flutter/material.dart';
import 'package:forecastify/pages/home_page.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(duration: const Duration(seconds: 1), vsync: this)
        ..repeat();

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Timer(
      const Duration(seconds: 3),
      () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomePage()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Color(0xff331c71),
                  Color(0xff5842A9),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: [0.4, 0.85])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/thunder.json',
              controller: _controller,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Weather',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            Text(
              'FORECASTIFY',
              style: Theme.of(context)
                  .textTheme
                  .displayMedium!
                  .copyWith(letterSpacing: 1),
            ),
          ],
        ),
      )),
    );
  }
}
