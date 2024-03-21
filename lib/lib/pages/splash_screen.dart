// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:forecastify/pages/home_page.dart';
// import 'package:lottie/lottie.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen>
//     with TickerProviderStateMixin {
//   late final AnimationController _controller =
//       AnimationController(duration: const Duration(seconds: 1), vsync: this)
//         ..repeat();

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();

//     Timer(
//       const Duration(seconds: 3),
//       () => Navigator.of(context).pushReplacement(
//         MaterialPageRoute(builder: (context) => const HomePage()),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//           child: Container(
//         width: MediaQuery.sizeOf(context).width,
//         height: MediaQuery.sizeOf(context).height,
//         decoration: const BoxDecoration(
//             gradient: LinearGradient(
//                 colors: [
//                   Color(0xff955cd1),
//                   Color(0xff362A84),
//                 ],
//                 begin: Alignment.bottomCenter,
//                 end: Alignment.topCenter,
//                 stops: [0.4, 0.85])),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Lottie.asset(
//               'assets/thunder.json',
//               controller: _controller,
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             const Text(
//               'Weather',
//               style: TextStyle(
//                   fontSize: 30,
//                   letterSpacing: 1,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.white),
//             ),
//             const Text(
//               'FORECASTIFY',
//               style: TextStyle(
//                 fontSize: 30,
//                 fontWeight: FontWeight.w900,
//                 letterSpacing: 2,
//                 color: Colors.white,
//               ),
//             ),
//           ],
//         ),
//       )),
//     );
//   }
// }
