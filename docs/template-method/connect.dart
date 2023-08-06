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
  List<List<Element>> board = List.empty(growable: true);

  ConnectBoard(ConnectGame game, Element container) : super(game, container) {}

  void placePiece(GamePiece piece, int i, int j) {
    Element tile = board[i][j];
    tile.children.add(piece.element);
  }

  void insertTiles() {
    for (int i = 0; i < 6; i++) {
      List<Element> rowList = List.empty(growable: true);
      Element row = createRow();
      for (int j = 0; j < 7; j++) {
        Element tile = createTile(i, j);
        row.children.add(tile);
        rowList.add(tile);
      }

      board.add(rowList);
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
