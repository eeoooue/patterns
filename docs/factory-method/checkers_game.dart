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
    GamePiece target = board.getPiece(i, j);

    if (!(activePiece is EmptyCheckersPiece)) {
      if (target is EmptyCheckersPiece) {
        movePiece(activePiece, i, j);
        endTurn();
      }
    }

    activePiece = EmptyCheckersPiece(0, 0);

    if (!(target is EmptyCheckersPiece)) {
      if (target is CheckersPiece && target.colour == getTurnPlayer()) {
        activePiece = target;
      }
    }
  }

  void endTurn() {
    turnCount += 1;
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
