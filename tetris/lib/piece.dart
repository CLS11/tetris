import 'package:tetris/value.dart';

class Piece {
  Piece({required this.type});
//type of tetris piece
  Tetromino type;

//The piece is just a list of numbers
  List<int> position = [];

//Generate teh integers
  void intializePiece() {
    switch (type) {
      case Tetromino.L:
        position = [
          4,
          14,
          24,
          25,
        ];
        break;
      default:
    }
  }

  //Moving piece
  void movePiece(Direction direction) {
    switch (direction) {
      case Direction.down:
        for (int i = 0; i < position.length; i++) {
          position[i] += rowLength;
        }
        break;
      case Direction.right:
        for (int i = 0; i < position.length; i++) {
          position[i] += 1;
        }
        break;
      case Direction.left:
        for (int i = 0; i < position.length; i++) {
          position[i] -= 1;
        }
        break;

      default:
    }
  }
}
