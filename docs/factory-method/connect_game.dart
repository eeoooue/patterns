import 'connect_board.dart';
import 'connect_pieces.dart';
import 'game.dart';
import 'dart:html';
import 'connect_view.dart';
import 'dart:math';

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
    if (gameIsOver()) {
      return;
    }
    attemptMove(j);
  }

  void attemptMove(int j) {
    int i = lowestSpaceInColumn(j);
    if (i == -1) {
      return;
    }

    ConnectPiece piece = ConnectPiece(getTurnPlayer());
    board.placePiece(piece, i, j);
    gameOver = checkGameOver(i, j);
    endTurn();
  }

  bool checkGameOver(int i, int j) {
    if (turnCount == 42) {
      return true;
    }

    int size = 0;
    size = max(size, checkDiagonalA(i, j));
    size = max(size, checkDiagonalB(i, j));
    size = max(size, checkHorizonal(i, j));
    size = max(size, checkVertical(i, j));
    return size >= 4;
  }

  int checkDiagonalA(int i, int j) {
    int size = 1;
    size += explore(i, j, -1, -1, 0);
    size += explore(i, j, 1, 1, 0);

    return size;
  }

  int checkDiagonalB(int i, int j) {
    int size = 1;
    size += explore(i, j, -1, 1, 0);
    size += explore(i, j, 1, -1, 0);

    return size;
  }

  int checkHorizonal(int i, int j) {
    int size = 1;
    size += explore(i, j, 0, -1, 0);
    size += explore(i, j, 0, 1, 0);

    return size;
  }

  int checkVertical(int i, int j) {
    int size = 1;
    size += explore(i, j, -1, 0, 0);
    size += explore(i, j, 1, 0, 0);

    return size;
  }

  int explore(int i, int j, int di, int dj, int depth) {
    i += di;
    j += dj;

    if (validCoords(i, j)) {
      GamePiece piece = board.getPiece(i, j);
      if (piece is ConnectPiece && piece.colour == getTurnPlayer()) {
        return explore(i, j, di, dj, depth + 1);
      }
    }

    return depth;
  }

  bool validCoords(int i, int j) {
    return (0 <= i && i < 6) && (0 <= j && j < 7);
  }
}
