import 'package:flutter/material.dart';

class Pixel extends StatelessWidget {
  const Pixel({required this.color, Key? key}) : super(key: key); // Use const constructor for better performance

  final Color color; // Specify the color type

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
      ),
      margin: const EdgeInsets.all(1),
    );
  }
}
