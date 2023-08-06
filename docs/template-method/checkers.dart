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

  void setupPieces() {}
}
