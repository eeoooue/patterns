import '../game.dart';
import 'mimic_board.dart';
import 'mimic_pieces.dart';
import 'dart:html';
import 'mimic_view.dart';

class MimicGame implements Game {
  int turnCount = 0;
  MimicBoard board = MimicBoard();
  late GameView view;
  MimicPiece demoPiece = MimicPiece(4, 3, PawnMovement());

  MimicGame(Element container) {
    view = MimicView(this, container);
  }

  bool gameIsOver() {
    return false;
  }

  void startGame() {
    setupPieces();
    refreshView();
  }

  String getTurnPlayer() {
    return (turnCount % 2 == 0) ? "w" : "b";
  }

  void submitMove(int i, int j) {
    if (validEnd(i, j)) {
      movePiece(demoPiece, i, j);
      clearMoveOptions();
    } else {
      clearMoveOptions();
      if (i == demoPiece.i && j == demoPiece.j) {
        print("moving piece at [${i}][${j}]");
        List<MoveOption> options = demoPiece.move(board);
        threatenOptions(options);
      }
    }

    refreshView();
  }

  void threatenOptions(List<MoveOption> options) {
    for (MoveOption move in options) {
      GamePiece target = board.getPiece(move.i, move.j);

      if (target is EmptyPiece) {
        target.threatened = true;
      }
    }
  }

  void refreshView() {
    view.displayBoard(board.getBoardState());
  }

  void clearMoveOptions() {
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        GamePiece piece = board.getPiece(i, j);

        if (piece is MimicPiece) {
          piece.threatened = false;
        }
      }
    }
  }

  void endTurn() {
    turnCount += 1;
    clearMoveOptions();
    refreshView();
  }

  bool validEnd(int i, int j) {
    GamePiece target = board.getPiece(i, j);
    if (target is MimicPiece) {
      return target.threatened;
    }
    return false;
  }

  void movePiece(MimicPiece piece, int i, int j) {
    board.removePiece(piece.i, piece.j);
    board.removePiece(i, j);
    board.placePiece(piece, i, j);
    piece.hasMoved = true;
  }

  void setupPieces() {
    board.setupPieces();
    board.placePiece(demoPiece, demoPiece.i, demoPiece.j);
    refreshView();
  }
}
