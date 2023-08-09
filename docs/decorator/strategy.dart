import 'gameboard.dart';
import 'pieces.dart';

class MoveOption {
  int i;
  int j;

  MoveOption(this.i, this.j) {}
}

abstract class MovementStrategy {
  void move(ChessBoard board, ChessPiece piece);
}

class NoMovement implements MovementStrategy {
  void move(ChessBoard board, ChessPiece piece) {}
}

class PawnMovement implements MovementStrategy {
  void move(ChessBoard board, ChessPiece piece) {
    if (piece.initialRow == 6) {
      return moveNorth(board, piece);
    } else {
      return moveSouth(board, piece);
    }
  }

  void moveSouth(ChessBoard board, ChessPiece piece) {
    if (piece.canMove(board, piece.i + 1, piece.j)) {
      if (piece.hasMoved == false) {
        piece.canMove(board, piece.i + 2, piece.j);
      }
    }

    piece.canCapture(board, piece.i + 1, piece.j + 1);
    piece.canCapture(board, piece.i + 1, piece.j - 1);
  }

  void moveNorth(ChessBoard board, ChessPiece piece) {
    if (piece.canMove(board, piece.i - 1, piece.j)) {
      if (piece.hasMoved == false) {
        piece.canMove(board, piece.i - 2, piece.j);
      }
    }

    piece.canCapture(board, piece.i - 1, piece.j + 1);
    piece.canCapture(board, piece.i - 1, piece.j - 1);
  }
}

class KnightMovement implements MovementStrategy {
  void move(ChessBoard board, ChessPiece piece) {
    void options = List.empty(growable: true);

    List<int> components = List.from({1, 2, -2, -1});

    for (int a in components) {
      for (int b in components) {
        if (a.abs() + b.abs() == 3) {
          MoveOption move = MoveOption(piece.i + a, piece.j + b);

          if (piece.canMove(board, move.i, move.j) == false) {
            piece.canCapture(board, move.i, move.j);
          }
        }
      }
    }

    return options;
  }
}

class BishopMovement implements MovementStrategy {
  void move(ChessBoard board, ChessPiece piece) {
    List<int> components = List.from({1, -1});

    for (int a in components) {
      for (int b in components) {
        exploreDiagonal(piece, board, piece.i, piece.j, a, b);
      }
    }
  }

  void exploreDiagonal(
      ChessPiece piece, ChessBoard board, int i, int j, int di, int dj) {
    while (true) {
      i += di;
      j += dj;

      if (piece.canCapture(board, i, j)) {
        return;
      }

      if (piece.canMove(board, i, j) == false) {
        return;
      }
    }
  }
}

class RookMovement implements MovementStrategy {
  void move(ChessBoard board, ChessPiece piece) {
    exploreImpulse(piece, board, piece.i, piece.j, 0, 1);
    exploreImpulse(piece, board, piece.i, piece.j, 0, -1);
    exploreImpulse(piece, board, piece.i, piece.j, 1, 0);
    exploreImpulse(piece, board, piece.i, piece.j, -1, 0);
  }

  void exploreImpulse(
      ChessPiece piece, ChessBoard board, int i, int j, int di, int dj) {
    while (true) {
      i += di;
      j += dj;

      if (piece.canCapture(board, i, j)) {
        return;
      }

      if (piece.canMove(board, i, j) == false) {
        return;
      }
    }
  }
}

class QueenMovement implements MovementStrategy {
  void move(ChessBoard board, ChessPiece piece) {
    var pair = List.from({RookMovement(), BishopMovement()});
    for (MovementStrategy strategy in pair) {
      strategy.move(board, piece);
    }
  }
}

class KingMovement implements MovementStrategy {
  void move(ChessBoard board, ChessPiece piece) {
    List<int> components = List.from({-1, 0, 1});

    for (int a in components) {
      for (int b in components) {
        MoveOption move = MoveOption(piece.i + a, piece.j + b);
        piece.canCapture(board, move.i, move.j);
        piece.canMove(board, move.i, move.j);
      }
    }
  }
}
