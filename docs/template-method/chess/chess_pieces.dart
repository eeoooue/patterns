import '../game.dart';
import 'dart:html';

class ChessPiece extends GamePiece {
  String colour;
  String name;
  bool hasMoved = false;
  bool threatened = false;
  bool empty = false;

  ChessPiece(this.colour, this.name) {}

  Element createElement() {
    Element tile = createTile();

    if (!empty) {
      Element img = createPieceImage();
      tile.children.add(img);
    }

    return tile;
  }

  Element createPieceImage() {
    ImageElement img = ImageElement();
    img.classes.add("piece-img");
    img.src = "./assets/chess/${name}_${colour}.png";
    return img;
  }

  Element createTile() {
    Element tile = document.createElement("div");
    tile.classes.add("chess-tile");

    if ((i + j) % 2 != 0) {
      tile.classes.add("dark");
    }

    return tile;
  }

  void setPosition(int iInput, int jInput) {
    i = iInput;
    j = jInput;
  }
}

class EmptyPiece extends ChessPiece {
  EmptyPiece(int iPosition, int jPosition) : super("empty", "empty") {
    i = iPosition;
    j = jPosition;
    empty = true;
  }
}
