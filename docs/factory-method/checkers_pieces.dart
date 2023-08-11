import 'game.dart';

class CheckersPiece extends GamePiece {
  CheckersMovementStrategy moveStrategy;
  bool threatened = false;
  bool empty = false;
  String colour;
  CheckersPiece(this.colour, this.moveStrategy) {
    setSource("./assets/checkers/checkers_${colour}.png");
  }

  void move(GameBoard board) {
    moveStrategy.move(board, this);
  }

  bool canCapture(GameBoard board, int iStart, int jStart, int iEnd, int jEnd) {
    if (!validCoords(iStart, jStart) || !validCoords(iEnd, jEnd)) {
      return false;
    }

    int a = ((iEnd - iStart) ~/ 2) + iStart;
    int b = ((jEnd - jStart) ~/ 2) + jStart;
    GamePiece target = board.getPiece(a, b);

    if (target is CheckersPiece) {
      if (!(target is EmptyCheckersPiece) && target.colour != colour) {
        if (canMove(board, iEnd, jEnd)) {
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
      if (target is EmptyCheckersPiece) {
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

class EmptyCheckersPiece extends CheckersPiece {
  EmptyCheckersPiece(int a, int b) : super("none", NoCheckerMovement()) {
    empty = true;
    i = a;
    j = b;
  }
}

abstract class CheckersMovementStrategy {
  void move(GameBoard board, CheckersPiece piece);
}

class NoCheckerMovement implements CheckersMovementStrategy {
  void move(GameBoard board, CheckersPiece piece) {}
}

class RedCheckerMovement implements CheckersMovementStrategy {
  void move(GameBoard board, CheckersPiece piece) {
    piece.canMove(board, piece.i - 1, piece.j - 1);
    piece.canMove(board, piece.i - 1, piece.j + 1);
    tryCaptureChain(board, piece);
  }

  void tryCaptureChain(GameBoard board, CheckersPiece piece) {
    explore(board, piece, piece.i, piece.j);
  }

  void explore(GameBoard board, CheckersPiece piece, int i, int j) {
    // cap up left
    if (piece.canCapture(board, i, j, i - 2, j - 2)) {
      explore(board, piece, i - 2, j - 2);
    }

    // cap up right
    if (piece.canCapture(board, i, j, i - 2, j + 2)) {
      explore(board, piece, i - 2, j + 2);
    }
  }
}

class CreamCheckerMovement implements CheckersMovementStrategy {
  void move(GameBoard board, CheckersPiece piece) {
    piece.canMove(board, piece.i + 1, piece.j - 1);
    piece.canMove(board, piece.i + 1, piece.j + 1);
    tryCaptureChain(board, piece);
  }

  void tryCaptureChain(GameBoard board, CheckersPiece piece) {
    explore(board, piece, piece.i, piece.j);
  }

  void explore(GameBoard board, CheckersPiece piece, int i, int j) {
    // cap down left
    if (piece.canCapture(board, i, j, i + 2, j - 2)) {
      explore(board, piece, i + 2, j - 2);
    }

    // cap down right
    if (piece.canCapture(board, i, j, i + 2, j + 2)) {
      explore(board, piece, i + 2, j + 2);
    }
  }
}

class KingCheckerMovement implements CheckersMovementStrategy {
  void move(GameBoard board, CheckersPiece piece) {
    piece.canMove(board, piece.i + 1, piece.j - 1);
    piece.canMove(board, piece.i + 1, piece.j + 1);
    piece.canMove(board, piece.i - 1, piece.j - 1);
    piece.canMove(board, piece.i - 1, piece.j + 1);
    tryCaptureChain(board, piece);
  }

  void tryCaptureChain(GameBoard board, CheckersPiece piece) {}
}
