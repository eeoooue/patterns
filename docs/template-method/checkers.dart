import 'dart:html';
import 'chess.dart';
import 'boardgames.dart';

class CheckersGame extends Game {
  CheckersGame(Element container) : super(container) {}

  GameBoard createBoard() {
    return ChessBoard(this, container);
  }

  void submitMove(int i, int j) {
    print("Checkers: move was made at board[${i}][${j}]");
  }

  void setupPieces() {
    setupCreamPieces();
    setupRedPieces();
  }

  void setupCreamPieces() {
    int i = 0;
    int j = 1;

    for (int r = 0; r < 12; r++) {
      CheckersPiece piece = CheckersPiece("cream");
      board.placePiece(piece, i, j);

      j += 2;

      if (j == 8) {
        j = 1;
        i += 1;
      }

      if (j == 9) {
        j = 0;
        i += 1;
      }
    }
  }

  void setupRedPieces() {
    int i = 5;
    int j = 0;

    for (int r = 0; r < 12; r++) {
      CheckersPiece piece = CheckersPiece("red");
      board.placePiece(piece, i, j);

      j += 2;

      if (j == 8) {
        j = 1;
        i += 1;
      }

      if (j == 9) {
        j = 0;
        i += 1;
      }
    }
  }
}

class CheckersPiece extends GamePiece {
  CheckersPiece(String team) {
    setSource("/assets/checkers/checkers_${team}.png");
  }
}
