import 'checkers_board.dart';
import 'checkers_game.dart';
import 'checkers_pieces.dart';
import '../game.dart';

class BoardPosition {
  int i;
  int j;
  BoardPosition(this.i, this.j) {}
}

class CheckersMove {
  BoardPosition start;
  BoardPosition end;
  BoardPosition? capture;

  CheckersMove(this.start, this.end, {BoardPosition? this.capture}) {}
}

class CheckersLogic {
  CheckersGame game;
  CheckersBoard board;
  bool captureAvailable = false;

  CheckersLogic(this.board, this.game) {}

  void clearOptions() {
    clearHighlights();
    captureAvailable = false;
    for (List<GamePiece> row in board.getBoardState()) {
      for (GamePiece piece in row) {
        if (piece is CheckersPiece) {
          piece.moveOptions = List.empty(growable: true);
        }
      }
    }
  }

  void clearHighlights() {
    for (List<GamePiece> row in board.getBoardState()) {
      for (GamePiece piece in row) {
        if (piece is CheckersPiece) {
          piece.threatened = false;
        }
      }
    }
  }

  void findPossibleMoves() {
    clearOptions();
    checkCaptures();
    if (!captureAvailable) {
      checkMoveOptions();
    }
  }

  void checkCaptures() {
    String player = game.getTurnPlayer();
    for (List<GamePiece> row in board.getBoardState()) {
      for (GamePiece piece in row) {
        if (piece is CheckersPiece && piece.colour == player) {
          findCapturesForPiece(piece);
        }
      }
    }
  }

  void findCapturesForPiece(CheckersPiece piece) {
    int i = piece.i;
    int j = piece.j;

    if (piece.colour == "cream" || piece.king) {
      tryCapture(piece, i + 2, j - 2);
      tryCapture(piece, i + 2, j + 2);
    }

    if (piece.colour == "red" || piece.king) {
      tryCapture(piece, i - 2, j - 2);
      tryCapture(piece, i - 2, j + 2);
    }
  }

  void tryCapture(CheckersPiece piece, int endI, int endJ) {
    if (!validCoords(endI, endJ)) {
      return;
    }

    int di = (endI - piece.i) ~/ 2;
    int dj = (endJ - piece.j) ~/ 2;

    BoardPosition start = BoardPosition(piece.i, piece.j);
    BoardPosition cap = BoardPosition(piece.i + di, piece.j + dj);
    BoardPosition end = BoardPosition(endI, endJ);

    GamePiece target = board.getPiece(cap.i, cap.j);
    GamePiece destination = board.getPiece(end.i, end.j);

    if (capturableTarget(piece, target)) {
      if (destination is EmptyCheckersPiece) {
        CheckersMove move = CheckersMove(start, end, capture: cap);
        piece.moveOptions.add(move);
        captureAvailable = true;
      }
    }
  }

  bool capturableTarget(CheckersPiece piece, GamePiece target) {
    if (target is CheckersPiece && target.colour != piece.colour) {
      if (target is EmptyCheckersPiece) {
        return false;
      }
      return true;
    }
    return false;
  }

  void checkMoveOptions() {
    String player = game.getTurnPlayer();
    for (List<GamePiece> row in board.getBoardState()) {
      for (GamePiece piece in row) {
        if (piece is CheckersPiece && piece.colour == player) {
          findMoves(piece);
        }
      }
    }
  }

  void findMoves(CheckersPiece piece) {
    int i = piece.i;
    int j = piece.j;

    if (piece.colour == "cream" || piece.king) {
      tryMove(piece, i + 1, j - 1);
      tryMove(piece, i + 1, j + 1);
    }

    if (piece.colour == "red" || piece.king) {
      tryMove(piece, i - 1, j - 1);
      tryMove(piece, i - 1, j + 1);
    }
  }

  void tryMove(CheckersPiece piece, int endI, int endJ) {
    if (!validCoords(endI, endJ)) {
      return;
    }

    BoardPosition start = BoardPosition(piece.i, piece.j);
    BoardPosition end = BoardPosition(endI, endJ);

    GamePiece destination = board.getPiece(end.i, end.j);

    if (destination is EmptyCheckersPiece) {
      CheckersMove move = CheckersMove(start, end);
      piece.moveOptions.add(move);
    }
  }

  bool validCoords(int i, int j) {
    return (0 <= i && i < 8) && (0 <= j && j < 8);
  }
}
