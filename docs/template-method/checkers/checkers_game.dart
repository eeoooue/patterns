import 'checkers_pieces.dart';
import 'checkers_board.dart';
import '../game.dart';
import 'dart:html';

class CheckersGame extends Game {
  CheckersGame(Element container) : super(container) {}

  GameBoard createBoard() {
    var board = CheckersBoard();
    board.initialize();
    return board;
  }

  void setupPieces(GameBoard board) {
    board.initialize();

    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if ((i + j) % 2 != 0) {
          if (i <= 2) {
            GamePiece piece = CheckersPiece("cream");
            board.placePiece(piece, i, j);
          } else if (i >= 5) {
            GamePiece piece = CheckersPiece("red");
            board.placePiece(piece, i, j);
          }
        }
      }
    }

    refreshView();
  }
}
