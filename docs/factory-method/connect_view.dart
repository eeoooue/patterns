import 'dart:html';
import 'connect_game.dart';
import 'connect_pieces.dart';
import 'game.dart';

class ConnectView implements GameView {
  Element container;
  ConnectGame game;
  ConnectView(this.game, this.container) {}

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

  Element buildTile(GamePiece piece) {
    Element tile = document.createElement("div");
    tile.classes.add("connect-tile");

    tile.addEventListener("click", (event) {
      game.submitMove(piece.i, piece.j);
    });

    if (piece is ConnectPiece && !piece.empty) {
      Element img = piece.getElement();
      tile.children.add(img);
    }

    return tile;
  }

  Element createRowContainer() {
    Element row = document.createElement("div");
    row.classes.add("board-row");
    return row;
  }

  void rotateBoard() {}
}
