import 'game.dart';

class ChessPiece extends GamePiece {
  int i = 0;
  int j = 0;
  MovementStrategy moveStrategy;
  String colour;
  String name;
  bool hasMoved = false;
  bool threatened = false;

  ChessPiece(this.colour, this.name, this.moveStrategy) {
    setSource("./assets/chess/${name}_${colour}.png");
  }

  void setPosition(int iInput, int jInput) {
    i = iInput;
    j = jInput;
  }

  void move(GameBoard board) {
    moveStrategy.move(board, this);
  }

  bool canCapture(GameBoard board, int i, int j) {
    if (validCoords(i, j)) {
      GamePiece target = board.getPiece(i, j);

      if (target is ChessPiece) {
        if (!(target is EmptyPiece) && target.colour != colour) {
          target.threatened = true;
          return true;
        }
      }
    }

    return false;
  }

  bool canMove(GameBoard board, int i, int j) {
    if (validCoords(i, j)) {
      GamePiece target = board.getPiece(i, j);
      if (target is EmptyPiece) {
        target.threatened = true;
        return true;
      }
    }

    return false;
  }

  bool validCoords(int i, int j) {
    return (0 <= i && i < 8) & (0 <= j && j < 8);
  }
}

class EmptyPiece extends ChessPiece {
  EmptyPiece(int iPosition, int jPosition)
      : super("empty", "empty", NoMovement()) {
    i = iPosition;
    j = jPosition;
  }
}

abstract class MovementStrategy {
  void move(GameBoard board, ChessPiece piece);
}

class NoMovement implements MovementStrategy {
  void move(GameBoard board, ChessPiece piece) {}
}

class PawnMovement implements MovementStrategy {
  void move(GameBoard board, ChessPiece piece) {
    if (piece.colour == "w") {
      return moveNorth(board, piece);
    } else {
      return moveSouth(board, piece);
    }
  }

  void moveSouth(GameBoard board, ChessPiece piece) {
    if (piece.canMove(board, piece.i + 1, piece.j)) {
      if (!piece.hasMoved) {
        piece.canMove(board, piece.i + 2, piece.j);
      }
    }

    piece.canCapture(board, piece.i + 1, piece.j + 1);
    piece.canCapture(board, piece.i + 1, piece.j - 1);
  }

  void moveNorth(GameBoard board, ChessPiece piece) {
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
  void move(GameBoard board, ChessPiece piece) {
    void options = List.empty(growable: true);

    List<int> components = List.from({1, 2, -2, -1});

    for (int a in components) {
      for (int b in components) {
        if (a.abs() + b.abs() == 3) {
          piece.canMove(board, piece.i + a, piece.j + b);
          piece.canCapture(board, piece.i + a, piece.j + b);
        }
      }
    }

    return options;
  }
}

class BishopMovement implements MovementStrategy {
  void move(GameBoard board, ChessPiece piece) {
    List<int> components = List.from({1, -1});

    for (int a in components) {
      for (int b in components) {
        exploreImpulse(piece, board, a, b);
      }
    }
  }

  void exploreImpulse(ChessPiece piece, GameBoard board, int di, int dj) {
    int i = piece.i;
    int j = piece.j;
    while (true) {
      i += di;
      j += dj;
      if (piece.canCapture(board, i, j) || !piece.canMove(board, i, j)) {
        return;
      }
    }
  }
}

class RookMovement implements MovementStrategy {
  void move(GameBoard board, ChessPiece piece) {
    exploreImpulse(piece, board, 0, 1);
    exploreImpulse(piece, board, 0, -1);
    exploreImpulse(piece, board, 1, 0);
    exploreImpulse(piece, board, -1, 0);
  }

  void exploreImpulse(ChessPiece piece, GameBoard board, int di, int dj) {
    int i = piece.i;
    int j = piece.j;
    while (true) {
      i += di;
      j += dj;
      if (piece.canCapture(board, i, j) || !piece.canMove(board, i, j)) {
        return;
      }
    }
  }
}

class QueenMovement implements MovementStrategy {
  void move(GameBoard board, ChessPiece piece) {
    var pair = List.from({RookMovement(), BishopMovement()});
    for (MovementStrategy strategy in pair) {
      strategy.move(board, piece);
    }
  }
}

class KingMovement implements MovementStrategy {
  void move(GameBoard board, ChessPiece piece) {
    List<int> components = List.from({-1, 0, 1});

    for (int a in components) {
      for (int b in components) {
        piece.canCapture(board, piece.i + a, piece.j + b);
        piece.canMove(board, piece.i + a, piece.j + b);
      }
    }
  }
}
