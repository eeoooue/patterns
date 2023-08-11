import 'checkers_pieces.dart';
import 'checkers_view.dart';
import 'game.dart';
import 'checkers_board.dart';
import 'dart:html';

class CheckersGame implements Game {
  late GameView view;
  GameBoard board = CheckersBoard();
  int turnCount = 0;
  GamePiece activePiece = EmptyCheckersPiece(0, 0);
  bool gameOver = false;

  CheckersGame(Element container) {
    view = CheckersView(container, this);
  }

  bool gameIsOver() {
    return gameOver;
  }

  void startGame() {
    board.setupPieces();
    refreshView();
  }

  String getTurnPlayer() {
    return (turnCount % 2 == 0) ? "red" : "cream";
  }

  void submitMove(int i, int j) {
    if (gameIsOver()) {
      return;
    }
    if (!processMoveEnd(i, j)) {
      clearMoveOptions();
      processMoveStart(i, j);
      refreshView();
    }
  }

  void clearMoveOptions() {
    for (int i = 0; i < 6; i++) {
      for (int j = 0; j < 7; j++) {
        GamePiece piece = board.getPiece(i, j);
        if (piece is CheckersPiece) {
          piece.threatened = false;
        }
      }
    }
  }

  bool processMoveEnd(int i, int j) {
    GamePiece target = board.getPiece(i, j);

    if (!(activePiece is EmptyCheckersPiece)) {
      if (target is CheckersPiece && target.threatened) {
        movePiece(activePiece, i, j);
        endTurn();
        return true;
      }
    }
    return false;
  }

  bool processMoveStart(int i, int j) {
    GamePiece target = board.getPiece(i, j);

    activePiece = EmptyCheckersPiece(0, 0);

    if (!(target is EmptyCheckersPiece)) {
      if (target is CheckersPiece && target.colour == getTurnPlayer()) {
        activePiece = target;
        target.move(board);
        return true;
      }
    }

    return false;
  }

  void endTurn() {
    turnCount += 1;
    activePiece = EmptyCheckersPiece(0, 0);
    clearMoveOptions();
    refreshView();
  }

  void movePiece(GamePiece piece, int i, int j) {
    board.removePiece(piece.i, piece.j);
    board.removePiece(i, j);
    board.placePiece(piece, i, j);
  }

  void refreshView() {
    view.displayBoard(board.getBoardState());
  }
}
