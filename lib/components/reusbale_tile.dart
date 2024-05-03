import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ReusableTile extends StatefulWidget {
  String currentHour, forcastHour, forcastTime, forcastIcon, forcastTemp;
  bool isImageExists;
  ReusableTile({
    super.key,
    required this.currentHour,
    required this.forcastHour,
    required this.forcastIcon,
    required this.forcastTemp,
    required this.forcastTime,
    required this.isImageExists,
  });

  @override
  State<ReusableTile> createState() => _ReusableTileState();
}

class _ReusableTileState extends State<ReusableTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: 65,
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: widget.currentHour == widget.forcastHour
                ? [
                    const Color(0xff331c71),
                    const Color(0xff955cd1),
                  ]
                : [
                    const Color(0xff331c71),
                    const Color(0xff331c71),
                  ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
          borderRadius: BorderRadius.circular(50),
          boxShadow: const [
            BoxShadow(
              offset: Offset(0, 1),
              blurRadius: 3,
              color: Color(0xff362A84),
            ),
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.forcastTime,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          Image(
            image: widget.isImageExists
                ? AssetImage("assets/${widget.forcastIcon}")
                : const AssetImage('assets/partlycloudy.png'),
            width: 40,
            height: 30,
          ),
          Text(
            '${widget.forcastTemp}°',
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
