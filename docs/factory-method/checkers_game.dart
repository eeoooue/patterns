import 'checkers_view.dart';
import 'game.dart';
import 'checkers_board.dart';
import 'dart:html';

class CheckersGame implements Game {
  late GameView view;
  GameBoard board = CheckersBoard();
  int turnCount = 0;

  CheckersGame(Element container) {
    view = CheckersView(container, this);
  }

  void startGame() {
    board.setupPieces();
    refreshView();
  }

  String getTurnPlayer() {
    return (turnCount % 2 == 0) ? "red" : "cream";
  }

  void submitMove(int i, int j) {}

  void refreshView() {
    view.displayBoard(board.getBoardState());
  }
}
