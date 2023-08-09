import 'dart:html';
import 'game.dart';
import 'pieces.dart';

abstract class ChessView {
  void displayBoard(List<List<ChessPiece>> boardstate);
  Element createTile(ChessPiece piece);
}

class ChessBoardView implements ChessView {
  Element container;
  ChessGame game;

  ChessBoardView(this.game, this.container) {}

  void displayBoard(List<List<ChessPiece>> boardstate) {
    container.children.clear();
    for (List<ChessPiece> rowOfPieces in boardstate) {
      Element row = createRowContainer();
      for (ChessPiece piece in rowOfPieces) {
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

  Element buildTile(ChessPiece piece) {
    Element tile = createTile(piece);

    if (!(piece is EmptyPiece)) {
      Element img = piece.getElement();
      tile.children.add(img);
    }

    if (piece.threatened) {
      Element marker = createMarker(piece);
      tile.children.add(marker);
    }

    return tile;
  }

  Element createTile(ChessPiece piece) {
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

  Element createMarker(ChessPiece piece) {
    Element element = document.createElement("div");
    element.classes.add("marker");
    String subtype = (piece is EmptyPiece) ? "dot" : "circle";
    element.classes.add(subtype);
    return element;
  }
}
