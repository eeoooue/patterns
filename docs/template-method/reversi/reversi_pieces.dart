import '../game.dart';
import 'dart:html';

class ReversiPiece extends GamePiece {
  String colour;
  bool empty = false;
  ReversiPiece(this.colour) {}

  Element createElement() {
    Element tile = document.createElement("div");
    tile.classes.add("reversi-tile");

    Element shade = document.createElement("div");
    shade.classes.add("reversi-shade");
    tile.children.add(shade);

    if (!empty) {
      Element img = createPieceImage();
      shade.children.add(img);
    }

    return tile;
  }

  Element createPieceImage() {
    Element piece = document.createElement("div");
    piece.classes.add("reversi-piece");
    piece.classes.add(colour);

    return piece;
  }
}

class EmptyReversiPiece extends ReversiPiece {
  EmptyReversiPiece(int iPosition, int jPosition) : super("none") {
    i = iPosition;
    j = jPosition;
    empty = true;
  }
}
