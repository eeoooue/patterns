import 'checkers_logic.dart';
import 'checkers_pieces.dart';
import 'checkers_view.dart';
import 'checkers_board.dart';
import 'checkers_factory.dart';
import '../game.dart';
import 'dart:html';

class CheckersGame implements Game {
  CheckersBoard board = CheckersBoard();
  late GameView view;
  late CheckersLogic logic;
  int turnCount = 0;
  CheckersPiece activePiece = EmptyCheckersPiece(0, 0);
  bool capturedThisTurn = false;
  bool gameOver = false;
  CheckersFactory factory = CheckersFactory();

  CheckersGame(Element container) {
    view = CheckersView(container, this);
    logic = CheckersLogic(board, this);
  }

  bool gameIsOver() {
    return gameOver;
  }

  GameBoard createBoard() {
    return CheckersBoard();
  }

  void startGame() {
    board.setupPieces();
    placePieces();
    logic.findPossibleMoves();
    refreshView();
  }

  String getTurnPlayer() {
    return (turnCount % 2 == 0) ? "red" : "cream";
  }

  void submitMove(int i, int j) {
    if (gameIsOver()) {
      return;
    }

    if (validMoveEnd(i, j)) {
      processMoveContinuation();
      refreshView();
      return;
    }

    logic.clearThreats();

    processMoveStart(i, j);
    refreshView();
  }

  bool validMoveEnd(int i, int j) {
    for (CheckersMove move in activePiece.moveOptions) {
      if (move.end.i == i && move.end.j == j) {
        makeMove(move);
        return true;
      }
    }
    return false;
  }

  void makeMove(CheckersMove move) {
    movePiece(activePiece, move.end.i, move.end.j);
    BoardPosition? capture = move.capture;
    if (capture is BoardPosition) {
      board.removePiece(capture.i, capture.j);
      capturedThisTurn = true;
    }
  }

  void processMoveContinuation() {
    logic.clearOptions();
    if (capturedThisTurn) {
      logic.findCapturesForPiece(activePiece);
    }
    if (activePiece.moveOptions.length == 0) {
      endTurn();
    }
  }

  bool processMoveStart(int i, int j) {
    GamePiece target = board.getPiece(i, j);
    activePiece = createPiece();

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
    activePiece = createPiece();
    logic.clearOptions();
    refreshView();
    logic.findPossibleMoves();
  }

  void movePiece(GamePiece piece, int i, int j) {
    board.removePiece(piece.i, piece.j);
    board.removePiece(i, j);
    board.placePiece(piece, i, j);

    if (i == 0 || i == 7) {
      if (piece is CheckersPiece) {
        piece.makeKing();
        capturedThisTurn = false;
      }
    }
  }

  void refreshView() {
    view.displayBoard(board.getBoardState());
  }

  void placePieces() {
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if ((i + j) % 2 != 0) {
          if (i <= 2) {
            GamePiece piece = factory.createPiece(CreamChecker);
            board.placePiece(piece, i, j);
          } else if (i >= 5) {
            GamePiece piece = factory.createPiece(RedChecker);
            board.placePiece(piece, i, j);
          }
        }
      }
    }
  }

  CheckersPiece createPiece({String colour = "none"}) {
    if (colour == "none") {
      return EmptyCheckersPiece(0, 0);
    }
    return CheckersPiece(colour);
  }
}
