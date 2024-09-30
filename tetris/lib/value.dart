import'package:flutter/material.dart';
  
  //Grid dimensions
   int rowLength = 10;
   int colLength = 20;

enum Direction{
  left,
  right,
  down,
}


enum Tetromino{
  L,
  J,
  I,
  O,
  S,
  Z,
  T,
}

const Map<Tetromino, Color> tetrominoColors = {
  Tetromino.L: Color(0xFFFFA500), // Orange
  Tetromino.J: Color(0xFF0000FF), // Blue
  Tetromino.T: Color(0xFF800080), // Purple
  Tetromino.S: Color(0xFF00FF00), // Green
  Tetromino.Z: Color(0xFFFF0000), // Red
  Tetromino.I: Color(0xFF00FFFF), // Cyan
  Tetromino.O: Color(0xFFFFFF00), // Yellow
};
