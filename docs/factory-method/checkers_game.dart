import 'checkers_logic.dart';
import 'checkers_pieces.dart';
import 'checkers_view.dart';
import 'game.dart';
import 'checkers_board.dart';
import 'dart:html';

class CheckersGame implements Game {
  CheckersBoard board = CheckersBoard();
  late GameView view;
  late CheckersLogic logic;
  int turnCount = 0;
  CheckersPiece activePiece = EmptyCheckersPiece(0, 0);
  bool capturedThisTurn = false;
  bool gameOver = false;

  CheckersGame(Element container) {
    view = CheckersView(container, this);
    logic = CheckersLogic(board, this);
  }

  bool gameIsOver() {
    return gameOver;
  }

  void startGame() {
    board.setupPieces();
    tryLogic();
    refreshView();
  }

  void tryLogic() {
    logic.findPossibleMoves();
  }

  String getTurnPlayer() {
    return (turnCount % 2 == 0) ? "red" : "cream";
  }

  void submitMove(int i, int j) {
    if (gameIsOver()) {
      return;
    }

    if (processMoveEnd(i, j)) {
      logic.clearOptions();
      if (capturedThisTurn) {
        logic.getCapturesForPiece(activePiece);
      }
      if (activePiece.moveOptions.length == 0) {
        activePiece = EmptyCheckersPiece(0, 0);
        endTurn();
      }
      refreshView();
      return;
    } else {
      logic.clearHighlights();
    }

    processMoveStart(i, j);
    refreshView();
  }

  bool processMoveEnd(int i, int j) {
    for (CheckersMove move in activePiece.moveOptions) {
      BoardPosition endPos = move.end;
      if (endPos.i == i && endPos.j == j) {
        movePiece(activePiece, i, j);
        BoardPosition? cap = move.capture;
        if (cap is BoardPosition) {
          board.removePiece(cap.i, cap.j);
          capturedThisTurn = true;
        }
        return true;
      }
    }

    return false;
  }

  bool processMoveStart(int i, int j) {
    GamePiece target = board.getPiece(i, j);

    activePiece = EmptyCheckersPiece(0, 0);

    if (target is CheckersPiece && target.moveOptions.length > 0) {
      activePiece = target;

      for (CheckersMove move in target.moveOptions) {
        BoardPosition pos = move.end;
        GamePiece piece = board.getPiece(pos.i, pos.j);

        if (piece is CheckersPiece) {
          piece.threatened = true;
        }
      }
      return true;
    }

    return false;
  }

  void endTurn() {
    turnCount += 1;
    capturedThisTurn = false;
    activePiece = EmptyCheckersPiece(0, 0);
    logic.clearOptions();
    refreshView();
    tryLogic();
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
