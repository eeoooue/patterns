import '../game.dart';
import 'dart:html';

class ConnectPiece extends GamePiece {
  bool empty = false;
  String colour;

  ConnectPiece(this.colour) {}

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
    img.src = "./assets/connect/connect_${colour}.png";
    return img;
  }

  Element createTile() {
    Element tile = document.createElement("div");
    tile.classes.add("connect-tile");
    return tile;
  }

  void setPosition(int iInput, int jInput) {
    i = iInput;
    j = jInput;
  }
}

class EmptyConnectPiece extends ConnectPiece {
  EmptyConnectPiece(int iInput, int jInput) : super("none") {
    empty = true;
    i = iInput;
    j = jInput;
  }
}
