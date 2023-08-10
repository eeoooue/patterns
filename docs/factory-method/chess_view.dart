import 'dart:html';
import 'dart:collection';
import 'game.dart';
import 'chess_pieces.dart';

class ChessBoardView implements GameView {
  Element container;
  Game game;

  ChessBoardView(this.game, this.container) {}

  void rotateBoard() {
    Queue<Element> stack = Queue();
    for (Element row in container.querySelectorAll(".board-row")) {
      stack.add(row);
    }

    container.children.clear();

    while (stack.length > 0) {
      Element row = stack.removeLast();
      mirrorRow(row);
      container.children.add(row);
    }
  }

  void mirrorRow(Element row) {
    Queue<Element> stack = Queue();
    for (Element tile in row.querySelectorAll(".chess-tile")) {
      stack.add(tile);
    }

    row.children.clear();

    while (stack.length > 0) {
      Element tile = stack.removeLast();
      row.children.add(tile);
    }
  }

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

    if (!(piece is EmptyPiece)) {
      Element img = piece.getElement();
      tile.children.add(img);
    }

    if (piece is ChessPiece) {
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

  Element createMarker(ChessPiece piece) {
    Element element = document.createElement("div");
    element.classes.add("marker");
    String subtype = (piece is EmptyPiece) ? "dot" : "circle";
    element.classes.add(subtype);
    return element;
  }
}
