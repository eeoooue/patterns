import 'game.dart';

class CheckersPiece extends GamePiece {
  bool empty = false;
  CheckersPiece(String team) {
    setSource("./assets/checkers/checkers_${team}.png");
  }
}

class EmptyCheckersPiece extends CheckersPiece {
  EmptyCheckersPiece(int iInput, int jInput) : super("none") {
    empty = true;
    i = iInput;
    j = jInput;
  }
}
