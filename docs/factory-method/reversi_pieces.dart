import 'game.dart';

class ReversiPiece extends GamePiece {
  String colour;
  ReversiPiece(this.colour) {}
}

class EmptyReversiPiece extends ReversiPiece {
  EmptyReversiPiece(int iPosition, int jPosition) : super("none") {
    i = iPosition;
    j = jPosition;
  }
}
