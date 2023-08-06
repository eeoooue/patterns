import 'dart:html';
import 'boardgames.dart';

class ChessGame extends Game {
  ChessGame(Element container) : super(container) {}

  GameBoard createBoard() {
    return ChessBoard(this, container);
  }

  void submitMove(int i, int j) {
    print("Chess: move was made at board[${i}][${j}]");
  }

  void setupPieces() {}
}

class ChessBoard extends GameBoard {
  ChessBoard(Game game, Element container) : super(game, container) {}

  void insertTiles() {
    bool dark = false;

    for (int i = 0; i < 8; i++) {
      dark = !dark;
      Element row = createRow();

      for (int j = 0; j < 8; j++) {
        dark = !dark;
        Element tile = createTile(i, j, dark);
        row.children.add(tile);
      }

      container.children.add(row);
    }
  }

  Element createTile(int i, int j, bool dark) {
    Element tile = document.createElement("div");
    tile.classes.add("chess-tile");

    if (dark) {
      tile.classes.add("dark");
    }

    tile.addEventListener("click", (event) {
      game.submitMove(i, j);
    });

    return tile;
  }

  bool tileIsEmpty(int i, int j) {
    return false;
  }
}
