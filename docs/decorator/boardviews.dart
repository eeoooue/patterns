import 'dart:html';
import 'game.dart';
import 'pieces.dart';
import 'strategy.dart';

abstract class ChessView {
  void clearAll();
  void displayBoard(List<List<ChessPiece>> boardstate);
  Element createTile(ChessPiece piece);
  void highlightMoves(ChessPiece piece);
}

class ChessBoardView implements ChessView {
  Element container;
  ChessGame game;

  ChessBoardView(this.game, this.container) {}

  void clearAll() {
    container.children.clear();
  }

  Element getTile(int i, int j) {
    List<Element> rows = container.querySelectorAll(".board-row");
    Element row = rows[i];
    List<Element> tiles = row.querySelectorAll(".chess-tile");
    return tiles[j];
  }

  void displayBoard(List<List<ChessPiece>> boardstate) {
    clearAll();
    for (List<ChessPiece> list in boardstate) {
      Element row = createRow();
      for (ChessPiece piece in list) {
        Element tile = createTile(piece);
        row.children.add(tile);
      }
      container.children.add(row);
    }
  }

  Element createRow() {
    Element row = document.createElement("div");
    row.classes.add("board-row");
    return row;
  }

  Element createTile(ChessPiece piece) {
    Element tile = document.createElement("div");
    tile.classes.add("chess-tile");

    if ((piece.i + piece.j) % 2 != 0) {
      tile.classes.add("dark");
    }

    if (!(piece is EmptyPiece)) {
      Element img = getPieceImage(piece);
      tile.children.add(img);
    }

    tile.addEventListener("click", (event) {
      game.submitMove(piece.i, piece.j);
    });

    return tile;
  }

  void highlightMoves(ChessPiece piece) {
    for (MoveOption move in piece.options) {
      Element tile = getTile(move.i, move.j);
      Element marker;

      if (tile.children.length == 0) {
        marker = createMarker("dot");
      } else {
        marker = createMarker("circle");
      }

      tile.children.add(marker);
    }
  }

  Element createMarker(String markerType) {
    Element element = document.createElement("div");
    element.classes.add("marker");
    element.classes.add(markerType);
    return element;
  }

  Element getPieceImage(ChessPiece piece) {
    return piece.getElement();
  }
}
