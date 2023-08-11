import 'checkers_pieces.dart';
import 'game.dart';
import 'dart:html';

class CheckersView implements GameView {
  Element container;
  Game game;

  CheckersView(this.container, this.game) {}

  void displayBoard(List<List<GamePiece>> boardstate) {
    container.children.clear();
    for (List<GamePiece> rowOfPieces in boardstate) {
      Element row = createRowContainer();
      for (GamePiece piece in rowOfPieces) {
        Element tile = buildTile(piece);
        row.children.add(tile);
      }
      container.children.add(row);
    }
  }

  Element createRowContainer() {
    Element row = document.createElement("div");
    row.classes.add("board-row");
    return row;
  }

  Element buildTile(GamePiece piece) {
    Element tile = createTile(piece);

    if (piece is CheckersPiece && !piece.empty) {
      Element img = piece.getElement();
      tile.children.add(img);
    }

    if (piece is EmptyCheckersPiece) {
      if (piece.threatened) {
        Element marker = createMarker(piece);
        tile.children.add(marker);
      }
    }

    return tile;
  }

  Element createTile(GamePiece piece) {
    Element tile = document.createElement("div");
    tile.classes.add("chess-tile");

    if ((piece.i + piece.j) % 2 != 0) {
      tile.classes.add("dark");
    }

    tile.addEventListener("click", (event) {
      game.submitMove(piece.i, piece.j);
    });

    return tile;
  }

  Element createMarker(CheckersPiece piece) {
    Element element = document.createElement("div");
    element.classes.add("marker");
    String subtype = (piece is EmptyCheckersPiece) ? "dot" : "circle";
    element.classes.add(subtype);
    return element;
  }

  void rotateBoard() {}
}
