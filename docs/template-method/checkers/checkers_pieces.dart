import '../game.dart';
import 'dart:html';

class CheckersPiece extends GamePiece {
  String colour;
  bool empty = false;

  CheckersPiece(this.colour) {}

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
    img.src = "./assets/checkers/checkers_${colour}.png";
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
}

class EmptyCheckersPiece extends CheckersPiece {
  EmptyCheckersPiece(int a, int b) : super("none") {
    empty = true;
    i = a;
    j = b;
  }
}
