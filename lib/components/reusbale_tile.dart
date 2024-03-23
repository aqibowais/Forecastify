import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ReusableTile extends StatefulWidget {
  String image;
  String time, temp;

  ReusableTile(
      {super.key, required this.image, required this.time, required this.temp});

  @override
  State<ReusableTile> createState() => _ReusableTileState();
}

class _ReusableTileState extends State<ReusableTile> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        width: size.width * 0.18,
        height: size.height * 0.15,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [
              Color(0xff955cd1),
              Color(0xff362A84),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.time,
                style: const TextStyle(
                  fontSize: 17,
                  // fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Image(
                image: AssetImage(
                  widget.image,
                ),
                height: 30,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                '${widget.temp}°',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
