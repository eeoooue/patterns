import 'connect_board.dart';
import 'connect_game.dart';
import 'connect_pieces.dart';
import '../game.dart';
import 'dart:math';

class ConnectLogic {
  ConnectGame game;
  ConnectBoard board;
  bool gameOver = false;

  ConnectLogic(this.game, this.board) {}

  int lowestSpaceInColumn(int j) {
    for (int i = 5; i >= 0; i--) {
      if (board.getPiece(i, j) is EmptyConnectPiece) {
        return i;
      }
    }
    return -1;
  }

  bool attemptMove(int j) {
    int i = lowestSpaceInColumn(j);
    if (i == -1) {
      return false;
    }

    ConnectPiece piece = ConnectPiece(game.getTurnPlayer());
    board.placePiece(piece, i, j);
    gameOver = checkGameOver(i, j);
    return true;
  }

  bool checkGameOver(int i, int j) {
    if (game.turnCount == 42) {
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
      if (piece is ConnectPiece && piece.colour == game.getTurnPlayer()) {
        return explore(i, j, di, dj, depth + 1);
      }
    }

    return depth;
  }

  bool validCoords(int i, int j) {
    return (0 <= i && i < 6) && (0 <= j && j < 7);
  }
}
