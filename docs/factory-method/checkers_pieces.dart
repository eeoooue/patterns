import 'checkers_logic.dart';
import 'game.dart';

class CheckersPiece extends GamePiece {
  bool threatened = false;
  bool empty = false;
  String colour;
  List<CheckersMove> moveOptions = List.empty(growable: true);

  CheckersPiece(this.colour) {
    setSource("./assets/checkers/checkers_${colour}.png");
  }
}

class EmptyCheckersPiece extends CheckersPiece {
  EmptyCheckersPiece(int a, int b) : super("none") {
    empty = true;
    i = a;
    j = b;
  }
}
