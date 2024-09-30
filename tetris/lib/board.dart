import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tetris/piece.dart';
import 'package:tetris/pixel.dart';
import 'package:tetris/value.dart';

/*
GAME BOARD

This a 2x2 grid with null representing an empty space.
A non empty space will have the color  to represent the landing pieces.

*/

//Game board
List<List<Tetromino?>> gameBoard = List.generate(
  colLength,
  (i) => List.generate(
    rowLength,
    (j) => null,
  ),
);

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  //Current tetris piece
  Piece currentPiece = Piece(type: Tetromino.T);

  @override
  void initState() {
    super.initState();

    //start game when app starts
    startGame();
  }

  void startGame() {
    currentPiece.initializePiece();

    //Frame refresh rate
    Duration frameRate = const Duration(milliseconds: 400);
    gameLoop(frameRate);
  }

  //Game loop
  void gameLoop(Duration frameRate) {
    Timer.periodic(frameRate, (timer) {
      setState(() {
        //check the landing pieces
        checkLanding();
        //move current piece down
        currentPiece.movePiece(Direction.down);
      });
    });
  }

  //Collision detection
  //Check for collision in a future position => bool
  bool checkCollision(Direction direction) {
    //Checking every position
    for (int i = 0; i < currentPiece.position.length; i++) {
      //Calculating the row and column of the current position
      int row = (currentPiece.position[i] / rowLength).floor();
      int col = currentPiece.position[i] % rowLength;

      //Adjusting the row and column based on the direction
      if (direction == Direction.left) {
        col += 1;
      } else if (direction == Direction.right) {
        col -= 1;
      } else if (direction == Direction.down) {
        row += 1;
      }

      //Check whether the piece is droopy or not
      if (row >= colLength || col < 0 || col >= rowLength) {
        return true;
      }
    }

    //When no collisions are detected
    return false;
  }

  //Checking where the piece is landing
  void checkLanding() {
    //Down
    if (checkCollision(Direction.down)) {
      //Mark the position occupied
      for (int i = 0; i < currentPiece.position.length; i++) {
        int row = (currentPiece.position[i] / rowLength).floor();
        int col = currentPiece.position[i] % rowLength;
        if (row >= 0 && col >= 0) {
          gameBoard[row][col] = currentPiece.type;
        }
      }

      //After landing
      createNewPiece();
    }
  }

  //Creating a new piece
  void createNewPiece() {
    //create a random object to generate random tetromino type
    Random rand = Random();

    //craete new piece with random type
    Tetromino randomType =
        Tetromino.values[rand.nextInt(Tetromino.values.length)];

    currentPiece = Piece(type: randomType);
    currentPiece.initializePiece();
  }

  //move left
  void moveLeft() {
    //check whether the move is valid
    if (!checkCollision(Direction.left)) {
      setState(() {
        currentPiece.movePiece(Direction.left);
      });
    }
  }

  //rotate
  void rotatePiece() {}

  //move right
  void moveRight() {
    //check whether the move is valid
    if (!checkCollision(Direction.right)) {
      setState(() {
        currentPiece.movePiece(Direction.right);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          //GAME GRID
          Expanded(
            child: GridView.builder(
              itemCount: rowLength * colLength,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: rowLength,
              ),
              itemBuilder: (context, index) {
                //Knowing the rows and column
                int row = (index / rowLength).floor();
                int col = index % rowLength;

                //Current piece
                if (currentPiece.position.contains(index)) {
                  return Pixel(
                    child: index,
                    color: currentPiece.color,
                  );
                }

                //Landed pieces
                else if (gameBoard[row][col] != null) {
                  final Tetromino? tetrominoType = gameBoard[row][col];
                  return Pixel(
                    color: tetrominoColors[tetrominoType],
                    child: '',
                  );
                }

                //Blank pixel
                else {
                  return Pixel(
                    child: index,
                    color: Colors.grey[900],
                  );
                }
              },
            ),
          ),

          //GAME CONTROLS
          Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //left
                IconButton(
                  onPressed: moveLeft,
                  color: Colors.white,
                  icon: Icon(Icons.arrow_back_ios_new),
                ),

                //rotate
                IconButton(
                  onPressed: rotatePiece,
                  color: Colors.white,
                  icon: Icon(Icons.rotate_right),
                ),

                //right
                IconButton(
                  onPressed: moveRight,
                  color: Colors.white,
                  icon: Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
