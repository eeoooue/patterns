import 'game.dart';

class CheckersPiece extends GamePiece {
  CheckersMovementStrategy moveStrategy;
  bool threatened = false;
  bool empty = false;
  String colour;
  CheckersPiece(this.colour, this.moveStrategy) {
    setSource("./assets/checkers/checkers_${colour}.png");
  }

  bool canCapture(GameBoard board, int i, int j) {
    if (validCoords(i, j)) {
      GamePiece target = board.getPiece(i, j);

      if (target is CheckersPiece) {
        if (!(target is EmptyCheckersPiece) && target.colour != colour) {
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
    piece.canMove(board, piece.i + 1, piece.j - 1);
    piece.canMove(board, piece.i + 1, piece.j + 1);
  }

  void tryCaptureChain(GameBoard board, CheckersPiece piece) {}
}

class CreamCheckerMovement implements CheckersMovementStrategy {
  void move(GameBoard board, CheckersPiece piece) {
    piece.canMove(board, piece.i - 1, piece.j - 1);
    piece.canMove(board, piece.i - 1, piece.j + 1);
  }

  void tryCaptureChain(GameBoard board, CheckersPiece piece) {}
}

class KingCheckerMovement implements CheckersMovementStrategy {
  void move(GameBoard board, CheckersPiece piece) {
    piece.canMove(board, piece.i + 1, piece.j - 1);
    piece.canMove(board, piece.i + 1, piece.j + 1);
    piece.canMove(board, piece.i - 1, piece.j - 1);
    piece.canMove(board, piece.i - 1, piece.j + 1);
  }

  void tryCaptureChain(GameBoard board, CheckersPiece piece) {}
}
