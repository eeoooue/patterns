import 'checkers_board.dart';
import 'checkers_game.dart';
import 'checkers_pieces.dart';
import 'game.dart';

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
  List<CheckersMove> options = List.empty(growable: true);

  CheckersLogic(this.board, this.game) {}

  void clearOptions() {
    clearHighlights();
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
    options.clear();
    checkCaptures();

    if (options.length == 0) {
      checkMoveOptions();
    }
  }

  void checkCaptures() {
    String player = game.getTurnPlayer();
    for (List<GamePiece> row in board.getBoardState()) {
      for (GamePiece piece in row) {
        if (piece is CheckersPiece && piece.colour == player) {
          var moves = getCapturesForPiece(piece);
          for (CheckersMove move in moves) {
            options.add(move);
          }
        }
      }
    }
  }

  List<CheckersMove> getCapturesForPiece(CheckersPiece piece) {
    int i = piece.i;
    int j = piece.j;

    if (piece.colour == "cream") {
      tryCapture(piece, i + 2, j - 2);
      tryCapture(piece, i + 2, j + 2);
    }

    if (piece.colour == "red") {
      tryCapture(piece, i - 2, j - 2);
      tryCapture(piece, i - 2, j + 2);
    }

    return piece.moveOptions;
  }

  bool tryCapture(CheckersPiece piece, int endI, int endJ) {
    if (!validCoords(endI, endJ)) {
      return false;
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
        return true;
      }
    }

    return false;
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
          var moves = getMoves(piece);
          for (CheckersMove move in moves) {
            options.add(move);
          }
        }
      }
    }
  }

  List<CheckersMove> getMoves(CheckersPiece piece) {
    int i = piece.i;
    int j = piece.j;

    if (piece.colour == "cream") {
      tryMove(piece, i + 1, j - 1);
      tryMove(piece, i + 1, j + 1);
    }

    if (piece.colour == "red") {
      tryMove(piece, i - 1, j - 1);
      tryMove(piece, i - 1, j + 1);
    }

    return piece.moveOptions;
  }

  bool tryMove(CheckersPiece piece, int endI, int endJ) {
    if (!validCoords(endI, endJ)) {
      return false;
    }

    BoardPosition start = BoardPosition(piece.i, piece.j);
    BoardPosition end = BoardPosition(endI, endJ);

    GamePiece destination = board.getPiece(end.i, end.j);

    if (destination is EmptyCheckersPiece) {
      CheckersMove move = CheckersMove(start, end);
      piece.moveOptions.add(move);
      return true;
    }

    return false;
  }

  bool validCoords(int i, int j) {
    return (0 <= i && i < 8) && (0 <= j && j < 8);
  }
}
