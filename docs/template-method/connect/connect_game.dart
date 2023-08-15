import 'connect_board.dart';
import '../game.dart';
import 'dart:html';

class ConnectGame extends Game {
  int turnCount = 0;

  ConnectGame(Element container) : super(container) {}

  GameBoard createBoard() {
    var board = ConnectBoard();
    board.initialize();
    return board;
  }

  void setupPieces(GameBoard board) {
    board.initialize();
    refreshView();
  }
}
