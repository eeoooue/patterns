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

  List<CheckersMove> findPossibleMoves() {
    clearOptions();
    options.clear();
    checkCaptures();

    if (options.length == 0) {
      checkMoveOptions();
    }

    return options;
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
    List<CheckersMove> moves = List.empty(growable: true);

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
            moves.add(move);
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
            moves.add(move);
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
            moves.add(move);
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
            moves.add(move);
          }
        }
      }
    }

    piece.moveOptions = moves;

    print("the pieces have ${piece.moveOptions.length} options");

    return moves;
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
    List<CheckersMove> moves = List.empty(growable: true);

    int i = piece.i;
    int j = piece.j;

    if (piece.colour == "cream") {
      if (validCoords(i + 1, j - 1)) {
        GamePiece destination = board.getPiece(i + 1, j - 1);
        if (destination is EmptyCheckersPiece) {
          BoardPosition start = BoardPosition(i, j);
          BoardPosition end = BoardPosition(i + 1, j - 1);
          CheckersMove move = CheckersMove(start, end);
          moves.add(move);
        }
      }

      if (validCoords(i + 1, j + 1)) {
        GamePiece destination = board.getPiece(i + 1, j + 1);
        if (destination is EmptyCheckersPiece) {
          BoardPosition start = BoardPosition(i, j);
          BoardPosition end = BoardPosition(i + 1, j + 1);
          CheckersMove move = CheckersMove(start, end);
          moves.add(move);
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
          moves.add(move);
        }
      }

      if (validCoords(i - 1, j + 1)) {
        GamePiece destination = board.getPiece(i - 1, j + 1);
        if (destination is EmptyCheckersPiece) {
          BoardPosition start = BoardPosition(i, j);
          BoardPosition end = BoardPosition(i - 1, j + 1);
          CheckersMove move = CheckersMove(start, end);
          moves.add(move);
        }
      }
    }

    piece.moveOptions = moves;

    print("the pieces have ${piece.moveOptions.length} options");

    return moves;
  }

  bool validCoords(int i, int j) {
    return (0 <= i && i < 8) && (0 <= j && j < 8);
  }
}
