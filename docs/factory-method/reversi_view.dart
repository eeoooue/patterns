import 'dart:html';

import 'game.dart';
import 'reversi_game.dart';
import 'reversi_pieces.dart';

class ReversiView implements GameView {
  Element container;
  ReversiGame game;

  ReversiView(this.game, this.container) {}

  void displayBoard(List<List<GamePiece>> boardstate) {
    container.children.clear();

    for (List<GamePiece> list in boardstate) {
      Element row = createRowContainer();
      for (GamePiece piece in list) {
        Element tile = buildTile(piece);
        row.children.add(tile);
      }
      container.children.add(row);
    }
  }

  Element buildTile(GamePiece piece) {
    Element tile = document.createElement("div");
    tile.classes.add("reversi-tile");

    tile.addEventListener("click", (event) {
      game.submitMove(piece.i, piece.j);
    });

    Element shade = getFeltShade();
    tile.children.add(shade);

    if (piece is ReversiPiece && !(piece is EmptyReversiPiece)) {
      Element disc = createPiece(piece.colour);
      shade.children.add(disc);
    }

    if (piece is EmptyReversiPiece && piece.possibleMove) {
      String player = game.getTurnPlayer();
      Element disc = createPiece(player);
      disc.classes.add("ghost");
      Element text = createMoveOptionText(player);
      disc.children.add(text);
      shade.children.add(disc);
    }

    return tile;
  }

  Element createMoveOptionText(String player) {
    Element div = document.createElement("div");
    div.classes.add("ghost-text");
    div.innerText = (player == "white") ? "白" : "黒";
    return div;
  }

  Element createPiece(String colour) {
    Element piece = document.createElement("div");
    piece.classes.add("reversi-piece");
    piece.classes.add(colour);

    return piece;
  }

  Element createRowContainer() {
    Element row = document.createElement("div");
    row.classes.add("board-row");
    return row;
  }

  Element getFeltShade() {
    Element shade = document.createElement("div");
    shade.classes.add("reversi-shade");
    return shade;
  }

  void rotateBoard() {}
}
