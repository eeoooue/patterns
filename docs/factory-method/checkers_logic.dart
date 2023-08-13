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

    if (target is CheckersPiece && target.colour == "red") {
      if (destination is EmptyCheckersPiece) {
        CheckersMove move = CheckersMove(start, end, capture: cap);
        piece.moveOptions.add(move);
        return true;
      }
    }

    return false;
  }

  List<CheckersMove> getCapturesForPiece(CheckersPiece piece) {
    int i = piece.i;
    int j = piece.j;

    if (piece.colour == "cream") {
      if (validCoords(i + 2, j - 2)) {
        GamePiece target = board.getPiece(i + 1, j - 1);
        GamePiece destination = board.getPiece(i + 2, j - 2);

        if (target is CheckersPiece && target.colour == "red") {
          if (destination is EmptyCheckersPiece) {
            BoardPosition start = BoardPosition(i, j);
            BoardPosition cap = BoardPosition(i + 1, j - 1);
            BoardPosition end = BoardPosition(i + 2, j - 2);
            CheckersMove move = CheckersMove(start, end, capture: cap);
            piece.moveOptions.add(move);
          }
        }
      }

      if (validCoords(i + 2, j + 2)) {
        GamePiece target = board.getPiece(i + 1, j + 1);
        GamePiece destination = board.getPiece(i + 2, j + 2);

        if (target is CheckersPiece && target.colour == "red") {
          if (destination is EmptyCheckersPiece) {
            BoardPosition start = BoardPosition(i, j);
            BoardPosition cap = BoardPosition(i + 1, j + 1);
            BoardPosition end = BoardPosition(i + 2, j + 2);
            CheckersMove move = CheckersMove(start, end, capture: cap);
            piece.moveOptions.add(move);
          }
        }
      }
    }

    if (piece.colour == "red") {
      if (validCoords(i - 2, j - 2)) {
        GamePiece target = board.getPiece(i - 1, j - 1);
        GamePiece destination = board.getPiece(i - 2, j - 2);

        if (target is CheckersPiece && target.colour == "cream") {
          if (destination is EmptyCheckersPiece) {
            BoardPosition start = BoardPosition(i, j);
            BoardPosition cap = BoardPosition(i - 1, j - 1);
            BoardPosition end = BoardPosition(i - 2, j - 2);
            CheckersMove move = CheckersMove(start, end, capture: cap);
            piece.moveOptions.add(move);
          }
        }
      }

      if (validCoords(i - 2, j + 2)) {
        GamePiece target = board.getPiece(i - 1, j + 1);
        GamePiece destination = board.getPiece(i - 2, j + 2);

        if (target is CheckersPiece && target.colour == "cream") {
          if (destination is EmptyCheckersPiece) {
            BoardPosition start = BoardPosition(i, j);
            BoardPosition cap = BoardPosition(i - 1, j + 1);
            BoardPosition end = BoardPosition(i - 2, j + 2);
            CheckersMove move = CheckersMove(start, end, capture: cap);
            piece.moveOptions.add(move);
          }
        }
      }
    }

    return piece.moveOptions;
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
      if (validCoords(i + 1, j - 1)) {
        GamePiece destination = board.getPiece(i + 1, j - 1);
        if (destination is EmptyCheckersPiece) {
          BoardPosition start = BoardPosition(i, j);
          BoardPosition end = BoardPosition(i + 1, j - 1);
          CheckersMove move = CheckersMove(start, end);
          piece.moveOptions.add(move);
        }
      }

      if (validCoords(i + 1, j + 1)) {
        GamePiece destination = board.getPiece(i + 1, j + 1);
        if (destination is EmptyCheckersPiece) {
          BoardPosition start = BoardPosition(i, j);
          BoardPosition end = BoardPosition(i + 1, j + 1);
          CheckersMove move = CheckersMove(start, end);
          piece.moveOptions.add(move);
        }
      }
    }

    if (piece.colour == "red") {
      if (validCoords(i - 1, j - 1)) {
        GamePiece destination = board.getPiece(i - 1, j - 1);
        if (destination is EmptyCheckersPiece) {
          BoardPosition start = BoardPosition(i, j);
          BoardPosition end = BoardPosition(i - 1, j - 1);
          CheckersMove move = CheckersMove(start, end);
          piece.moveOptions.add(move);
        }
      }

      if (validCoords(i - 1, j + 1)) {
        GamePiece destination = board.getPiece(i - 1, j + 1);
        if (destination is EmptyCheckersPiece) {
          BoardPosition start = BoardPosition(i, j);
          BoardPosition end = BoardPosition(i - 1, j + 1);
          CheckersMove move = CheckersMove(start, end);
          piece.moveOptions.add(move);
        }
      }
    }

    return piece.moveOptions;
  }

  bool validCoords(int i, int j) {
    return (0 <= i && i < 8) && (0 <= j && j < 8);
  }
}
