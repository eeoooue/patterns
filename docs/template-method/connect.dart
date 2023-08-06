import 'dart:html';
import 'boardgames.dart';

class ConnectGame extends Game {
  ConnectGame(Element container) : super(container) {}

  GameBoard createBoard() {
    return ConnectBoard(this, container);
  }

  void submitMove(int i, int j) {
    print("Connect Game: move was made at board[${i}][${j}]");
  }

  void setupPieces() {}
}

class ConnectBoard extends GameBoard {
  ConnectBoard(ConnectGame game, Element container) : super(game, container) {}

  void insertTiles() {
    for (int i = 0; i < 6; i++) {
      Element row = createRow();
      for (int j = 0; j < 7; j++) {
        Element tile = createTile(i, j);
        row.children.add(tile);
      }

      container.children.add(row);
    }
  }

  Element createTile(int i, int j) {
    Element tile = document.createElement("div");
    tile.classes.add("connect-tile");

    Game connectGame = game;
    if (connectGame is ConnectGame) {
      tile.addEventListener("click", (event) {
        connectGame.submitMove(i, j);
      });
    }

    return tile;
  }

  bool tileIsEmpty(int i, int j) {
    return false;
  }
}
