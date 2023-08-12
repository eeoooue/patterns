import 'game.dart';

class ReversiPiece extends GamePiece {
  String colour;
  ReversiPiece(this.colour) {}
}

class EmptyReversiPiece extends ReversiPiece {
  EmptyReversiPiece() : super("none");
}
