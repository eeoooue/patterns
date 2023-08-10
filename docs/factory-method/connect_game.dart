import 'connect_board.dart';
import 'connect_pieces.dart';
import 'game.dart';
import 'dart:html';
import 'connect_view.dart';

class ConnectGame implements Game {
  late GameView view;
  GameBoard board = ConnectBoard();
  int turnCount = 0;
  bool gameOver = false;

  ConnectGame(Element container) {
    view = ConnectView(this, container);
  }

  bool gameIsOver() {
    return gameOver;
  }

  void startGame() {
    board.setupPieces();
    refreshView();
  }

  String getTurnPlayer() {
    return (turnCount % 2 == 0) ? "red" : "yellow";
  }

  int lowestSpaceInColumn(int j) {
    for (int i = 5; i >= 0; i--) {
      if (board.getPiece(i, j) is EmptyConnectPiece) {
        return i;
      }
    }
    return -1;
  }

  void refreshView() {
    view.displayBoard(board.getBoardState());
  }

  void endTurn() {
    turnCount += 1;
    refreshView();
  }

  void submitMove(int i, int j) {
    attemptMove(j);
  }

  void attemptMove(int j) {
    int i = lowestSpaceInColumn(j);
    if (i == -1) {
      return;
    }

    ConnectPiece piece = ConnectPiece(getTurnPlayer());
    board.placePiece(piece, i, j);
    endTurn();
  }
}
