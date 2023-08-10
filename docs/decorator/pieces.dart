import 'dart:html';

abstract class GamePiece {
  late String src;

  GamePiece() {}

  void setSource(String address) {
    src = address;
  }

  Element getElement() {
    Element img = document.createElement("img");
    img.classes.add("piece-img");
    if (img is ImageElement) {
      img.src = src;
    }

    return img;
  }
}
