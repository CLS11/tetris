import 'package:flutter/material.dart';
import 'package:tetris/board.dart';
import 'package:tetris/value.dart';

class Piece {
  Piece({required this.type}) {
    initializePiece();
  }

  // Type of Tetris piece
  Tetromino type;

  // The piece is just a list of numbers representing its position
  List<int> position = [];

  // Color of Tetris piece
  Color get color {
    return tetrominoColors[type] ??
        Colors.white; // Default to white if not found
  }

  // Generate the integers based on the type
  void initializePiece() {
    switch (type) {
      case Tetromino.L:
        position = [-26, -16, -6, -5];
      case Tetromino.J:
        position = [-25, -15, -5, -6];
      case Tetromino.I:
        position = [-4, -5, -6, -7];
      case Tetromino.O:
        position = [-15, -16, -5, -6];
      case Tetromino.S:
        position = [-15, -14, -6, -5];
      case Tetromino.Z:
        position = [-17, -16, -6, -5];
      case Tetromino.T:
        position = [-26, -16, -6, -15];
    }
  }

  // Moving piece
  void movePiece(Direction direction) {
    switch (direction) {
      case Direction.down:
        for (var i = 0; i < position.length; i++) {
          position[i] += rowLength;
        }
      case Direction.right:
        for (var i = 0; i < position.length; i++) {
          position[i] += 1;
        }
      case Direction.left:
        for (var i = 0; i < position.length; i++) {
          position[i] -= 1;
        }
    }
  }

  // Rotating a piece
  int rotationState = 0;

  void rotatePiece() {
    // New position
    List<int> newPosition = [];

    // Rotating based on the type of the piece
    switch (type) {
      case Tetromino.L:
        switch (rotationState) {
          case 0:
            newPosition = [
              position[1] - rowLength,
              position[1],
              position[1] + rowLength,
              position[1] + rowLength + 1,
            ];
          case 1:
            newPosition = [
              position[1] - 1,
              position[1],
              position[1] + 1,
              position[1] + rowLength + 1,
            ];
          case 2:
            newPosition = [
              position[1] + rowLength,
              position[1],
              position[1] - rowLength,
              position[1] - rowLength - 1,
            ];
          case 3:
            newPosition = [
              position[1] - rowLength + 1,
              position[1],
              position[1] + 1,
              position[1] - 1,
            ];
        }

      case Tetromino.J:
        switch (rotationState) {
          case 0:
            newPosition = [
              position[1] - rowLength,
              position[1],
              position[1] + rowLength,
              position[1] - rowLength - 1,
            ];
          case 1:
            newPosition = [
              position[1] - 1,
              position[1],
              position[1] + 1,
              position[1] + rowLength + 1,
            ];
          case 2:
            newPosition = [
              position[1] + rowLength,
              position[1],
              position[1] - rowLength,
              position[1] + rowLength + 1,
            ];
          case 3:
            newPosition = [
              position[1] - rowLength + 1,
              position[1],
              position[1] - 1,
              position[1] + 1,
            ];
        }

      case Tetromino.I:
        switch (rotationState) {
          case 0:
            newPosition = [
              position[1] - 1,
              position[1],
              position[1] + 1,
              position[1] + 2,
            ];
          case 1:
            newPosition = [
              position[1] - rowLength * 2,
              position[1] - rowLength,
              position[1],
              position[1] + rowLength,
            ];
        }

      case Tetromino.O:
        // O piece doesn't change on rotation
        return;

      case Tetromino.S:
        switch (rotationState) {
          case 0:
            newPosition = [
              position[1],
              position[1] + rowLength,
              position[1] - 1,
              position[1] - rowLength + 1,
            ];
          case 1:
            newPosition = [
              position[1],
              position[1] - rowLength,
              position[1] - 1,
              position[1] + rowLength - 1,
            ];
        }

      case Tetromino.Z:
        switch (rotationState) {
          case 0:
            newPosition = [
              position[1],
              position[1] + rowLength,
              position[1] + 1,
              position[1] - rowLength + 1,
            ];
          case 1:
            newPosition = [
              position[1],
              position[1] - rowLength,
              position[1] - 1,
              position[1] + rowLength - 1,
            ];
        }

      case Tetromino.T:
        switch (rotationState) {
          case 0:
            newPosition = [
              position[1] - rowLength,
              position[1],
              position[1] + 1,
              position[1] - 1,
            ];
          case 1:
            newPosition = [
              position[1],
              position[1] - rowLength,
              position[1] + rowLength,
              position[1] + 1,
            ];
          case 2:
            newPosition = [
              position[1] + rowLength,
              position[1],
              position[1] - 1,
              position[1] + 1,
            ];
          case 3:
            newPosition = [
              position[1],
              position[1] - rowLength,
              position[1] + rowLength,
              position[1] - 1,
            ];
        }
    }

    // Check whether the position is valid
    if (piecePositionIsValid(newPosition)) {
      position = newPosition;
      rotationState = (rotationState + 1) %
          (type == Tetromino.I ? 2 : 4); // Update rotation state
    }
  }

  // Check if the position is valid
  bool positionIsValid(int position) {
    // Getting the values of row and the column
    int row = (position / rowLength).floor();
    int col = position % rowLength;

    // If the position is occupied
    if (row < 0 || col < 0 || gameBoard[row][col] != null) {
      return false;
    }

    // Valid position
    return true;
  }

  // Check if the piece is at the valid position
  bool piecePositionIsValid(List<int> piecePosition) {
    bool firstColumnOccupied = false;
    bool lastColumnOccupied = false;

    for (int pos in piecePosition) {
      // Return false if the position is already occupied
      if (!positionIsValid(pos)) {
        return false;
      }

      // Get the column of the position
      int col = pos % rowLength;

      // Check if the first or last column is occupied
      if (col == 0) {
        firstColumnOccupied = true;
      }

      if (col == rowLength - 1) {
        lastColumnOccupied = true;
      }
    }

    // If there is a piece in both first and last column -> going through the wall
    return !(firstColumnOccupied && lastColumnOccupied);
  }
}
