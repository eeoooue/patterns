import 'gameboard.dart';
import 'pieces.dart';

class MoveOption {
  int i;
  int j;

  MoveOption(this.i, this.j) {}
}

abstract class MovementStrategy {
  List<MoveOption> move(ChessBoard board, ChessPiece piece);
}

class PawnMovement implements MovementStrategy {
  List<MoveOption> move(ChessBoard board, ChessPiece piece) {
    print("the pawn's initial row = ${piece.initialRow}");
    if (piece.initialRow == 6) {
      return moveNorth(board, piece);
    } else {
      return moveSouth(board, piece);
    }
  }

  List<MoveOption> moveSouth(ChessBoard board, ChessPiece piece) {
    List<MoveOption> options = List.empty(growable: true);

    MoveOption move = MoveOption(piece.i + 1, piece.j);
    if (piece.canMove(board, move.i, move.j)) {
      options.add(move);
      if (piece.hasMoved == false) {
        MoveOption firstBonus = MoveOption(piece.i + 2, piece.j);
        if (piece.canMove(board, firstBonus.i, firstBonus.j)) {
          options.add(firstBonus);
        }
      }
    }

    MoveOption capEast = MoveOption(piece.i + 1, piece.j + 1);
    MoveOption capWest = MoveOption(piece.i + 1, piece.j - 1);
    for (MoveOption cap in List.from({capEast, capWest})) {
      if (piece.canCapture(board, cap.i, cap.j)) {
        options.add(cap);
      }
    }

    return options;
  }

  List<MoveOption> moveNorth(ChessBoard board, ChessPiece piece) {
    List<MoveOption> options = List.empty(growable: true);

    MoveOption move = MoveOption(piece.i - 1, piece.j);
    if (piece.canMove(board, move.i, move.j)) {
      options.add(move);
      if (piece.hasMoved == false) {
        MoveOption firstBonus = MoveOption(piece.i - 2, piece.j);
        if (piece.canMove(board, firstBonus.i, firstBonus.j)) {
          options.add(firstBonus);
        }
      }
    }

    MoveOption capEast = MoveOption(piece.i - 1, piece.j + 1);
    MoveOption capWest = MoveOption(piece.i - 1, piece.j - 1);
    for (MoveOption cap in List.from({capEast, capWest})) {
      if (piece.canCapture(board, cap.i, cap.j)) {
        options.add(cap);
      }
    }
    return options;
  }
}

class KnightMovement implements MovementStrategy {
  List<MoveOption> move(ChessBoard board, ChessPiece piece) {
    List<MoveOption> options = List.empty(growable: true);

    List<int> components = List.from({1, 2, -2, -1});

    for (int a in components) {
      for (int b in components) {
        if (a.abs() + b.abs() == 3) {
          MoveOption move = MoveOption(piece.i + a, piece.j + b);

          if (piece.canMove(board, move.i, move.j)) {
            options.add(move);
          } else if (piece.canCapture(board, move.i, move.j)) {
            options.add(move);
          }
        }
      }
    }

    return options;
  }
}

class BishopMovement implements MovementStrategy {
  List<MoveOption> move(ChessBoard board, ChessPiece piece) {
    List<MoveOption> options = List.empty(growable: true);

    List<int> components = List.from({1, -1});

    for (int a in components) {
      for (int b in components) {
        for (MoveOption move
            in exploreDiagonal(piece, board, piece.i, piece.j, a, b)) {
          options.add(move);
        }
      }
    }

    return options;
  }

  List<MoveOption> exploreDiagonal(
      ChessPiece piece, ChessBoard board, int i, int j, int di, int dj) {
    List<MoveOption> options = List.empty(growable: true);

    while (true) {
      i += di;
      j += dj;
      MoveOption move = MoveOption(i, j);

      if (piece.canCapture(board, i, j)) {
        options.add(move);
        return options;
      }

      if (piece.canMove(board, i, j)) {
        options.add(move);
      } else {
        return options;
      }
    }
  }
}

class RookMovement implements MovementStrategy {
  List<MoveOption> move(ChessBoard board, ChessPiece piece) {
    List<MoveOption> options = List.empty(growable: true);

    for (MoveOption move
        in exploreImpulse(piece, board, piece.i, piece.j, 0, 1)) {
      options.add(move);
    }

    for (MoveOption move
        in exploreImpulse(piece, board, piece.i, piece.j, 0, -1)) {
      options.add(move);
    }

    for (MoveOption move
        in exploreImpulse(piece, board, piece.i, piece.j, 1, 0)) {
      options.add(move);
    }

    for (MoveOption move
        in exploreImpulse(piece, board, piece.i, piece.j, -1, 0)) {
      options.add(move);
    }

    return options;
  }

  List<MoveOption> exploreImpulse(
      ChessPiece piece, ChessBoard board, int i, int j, int di, int dj) {
    List<MoveOption> options = List.empty(growable: true);

    while (true) {
      i += di;
      j += dj;
      MoveOption move = MoveOption(i, j);

      if (piece.canCapture(board, i, j)) {
        options.add(move);
        return options;
      }

      if (piece.canMove(board, i, j)) {
        options.add(move);
      } else {
        return options;
      }
    }
  }
}

class QueenMovement implements MovementStrategy {
  List<MoveOption> move(ChessBoard board, ChessPiece piece) {
    List<MoveOption> options = List.empty(growable: true);

    var pair = List.from({RookMovement(), BishopMovement()});
    for (MovementStrategy strategy in pair) {
      for (MoveOption move in strategy.move(board, piece)) {
        options.add(move);
      }
    }

    return options;
  }
}

class KingMovement implements MovementStrategy {
  List<MoveOption> move(ChessBoard board, ChessPiece piece) {
    List<MoveOption> options = List.empty(growable: true);

    List<int> components = List.from({-1, 0, 1});

    for (int a in components) {
      for (int b in components) {
        MoveOption move = MoveOption(piece.i + a, piece.j + b);
        if (piece.canCapture(board, move.i, move.j)) {
          options.add(move);
        }
        if (piece.canMove(board, move.i, move.j)) {
          options.add(move);
        }
      }
    }

    return options;
  }
}
