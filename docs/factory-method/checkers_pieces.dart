import 'game.dart';

class CheckersPiece extends GamePiece {
  bool empty = false;
  String colour;
  CheckersPiece(this.colour) {
    setSource("./assets/checkers/checkers_${colour}.png");
  }
}

class EmptyCheckersPiece extends CheckersPiece {
  EmptyCheckersPiece(int iInput, int jInput) : super("none") {
    empty = true;
    i = iInput;
    j = jInput;
  }
}
