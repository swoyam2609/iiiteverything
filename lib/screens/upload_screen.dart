import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

Widget comingSoon() {
  return Container(
    color: Color(0xFF302C42),
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Lottie.network(
              "https://assets7.lottiefiles.com/packages/lf20_oo3N9WVAgU.json",
            ),
          ),
          Text(
            "Coming Soon",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.purple[200],
              fontSize: 30,
            ),
          )
        ],
      ),
    ),
  );
}
