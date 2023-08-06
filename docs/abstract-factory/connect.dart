import 'dart:html';
import 'boardgames.dart';

class ConnectGame extends Game {
  int turnPlayer = 0;

  ConnectGame(Element container) : super(container) {}

  GameBoard createBoard() {
    return ConnectBoard(this, container);
  }

  void submitMove(int i, int j) {
    print("Connect Game: move was attempted in column[${j}]");

    var grid = board;
    if (grid is ConnectBoard) {
      makeMove(grid, j);
    }
  }

  void makeMove(ConnectBoard grid, int j) {
    int i = grid.lowestSpaceInColumn(j);
    if (i == -1) {
      return;
    }

    String colour = (turnPlayer == 0) ? "red" : "yellow";
    ConnectPiece piece = ConnectPiece(colour);

    board.placePiece(piece, i, j);

    turnPlayer = (turnPlayer + 1) % 2;
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

  int lowestSpaceInColumn(int j) {
    for (int i = board.length - 1; i >= 0; i--) {
      if (tileIsEmpty(i, j)) {
        return i;
      }
    }
    return -1;
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
    Element tile = board[i][j];
    return tile.children.length == 0;
  }
}

class ConnectPiece extends GamePiece {
  ConnectPiece(String colour) {
    setSource("./assets/connect/connect_${colour}.png");
  }
}
