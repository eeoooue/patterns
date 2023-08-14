import 'connect_board.dart';
import 'connect_logic.dart';
import '../game.dart';
import 'dart:html';
import 'connect_view.dart';

class ConnectGame implements Game {
  ConnectBoard board = ConnectBoard();
  int turnCount = 0;
  late ConnectLogic logic;
  late GameView view;

  ConnectGame(Element container) {
    view = ConnectView(this, container);
    logic = ConnectLogic(this, board);
  }

  bool gameIsOver() {
    return logic.gameOver;
  }

  void startGame() {
    board.setupPieces();
    refreshView();
  }

  String getTurnPlayer() {
    return (turnCount % 2 == 0) ? "red" : "yellow";
  }

  void refreshView() {
    view.displayBoard(board.getBoardState());
  }

  void endTurn() {
    turnCount += 1;
    refreshView();
  }

  void submitMove(int i, int j) {
    if (!gameIsOver()) {
      if (logic.attemptMove(j)) {
        endTurn();
      }
    }
  }
}
