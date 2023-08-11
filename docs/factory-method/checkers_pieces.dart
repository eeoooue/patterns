import 'game.dart';

class CheckersPiece extends GamePiece {
  CheckersMovementStrategy moveStrategy;
  bool threatened = false;
  bool empty = false;
  String colour;
  CheckersPiece(this.colour, this.moveStrategy) {
    setSource("./assets/checkers/checkers_${colour}.png");
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
  void move(GameBoard board, GamePiece piece);
}

class NoCheckerMovement implements CheckersMovementStrategy {
  void move(GameBoard board, GamePiece piece) {}
}

class RedCheckerMovement implements CheckersMovementStrategy {
  void move(GameBoard board, GamePiece piece) {}
}

class CreamCheckerMovement implements CheckersMovementStrategy {
  void move(GameBoard board, GamePiece piece) {}
}

class KingCheckerMovement implements CheckersMovementStrategy {
  void move(GameBoard board, GamePiece piece) {}
}
