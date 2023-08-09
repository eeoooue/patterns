import 'dart:html';
import 'pieces.dart';

abstract class ChessView {
  void clearAll();
  void displayBoard(List<List<ChessPiece>> boardstate);
  Element createTile(ChessPiece piece);
}

class ChessBoardView {
  Element container;

  ChessBoardView(this.container) {}

  void clearAll() {
    container.children.clear();
  }

  void displayBoard(List<List<ChessPiece>> boardstate) {}

  Element createTile(ChessPiece piece) {
    Element tile = document.createElement("div");
    tile.classes.add("chess-tile");

    return tile;
  }
}
