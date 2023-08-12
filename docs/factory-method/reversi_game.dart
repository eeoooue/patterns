import 'game.dart';
import 'dart:html';
import 'reversi_board.dart';
import 'reversi_logic.dart';
import 'reversi_view.dart';

class ReversiGame implements Game {
  ReversiBoard board = ReversiBoard();
  int turnCount = 0;
  late ReversiLogic logic;
  late GameView view;

  ReversiGame(Element container) {
    view = ReversiView(this, container);
    logic = ReversiLogic(this, board);
  }

  bool gameIsOver() {
    return logic.gameOver;
  }

  void startGame() {
    board.setupPieces();
    refreshView();
  }

  String getTurnPlayer() {
    return (turnCount % 2 == 0) ? "white" : "black";
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
      // DO STUFF
      logic.attemptMove(i, j);
    }
  }
}
