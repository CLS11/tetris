import 'package:flutter/material.dart';
import 'package:tetris/board.dart';

void main() {
  runApp(const Tetris());
}

class Tetris extends StatelessWidget {
  const Tetris({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GameBoard(),
    );
  }
}
