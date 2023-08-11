import 'dart:html';

abstract class Game {
  Element container;
  late GameBoard board;

  Game(this.container) {}

  void startGame() {
    clearPlayArea();
    board = createBoard();
    setupPieces();
  }

  void clearPlayArea() {
    container.children.clear();
  }

  void submitMove(int i, int j);

  GameBoard createBoard();

  void setupPieces();
}

class TicTacToeGame extends Game {
  TicTacToeGame(Element container) : super(container) {}

  GameBoard createBoard() {
    return TicTacToeBoard(this, container);
  }

  void submitMove(int i, int j) {
    print("Tic-Tac-Toe: move was made at board[${i}][${j}]");
  }

  void setupPieces() {}
}

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

class CheckersGame extends Game {
  CheckersGame(Element container) : super(container) {}

  GameBoard createBoard() {
    return ChessBoard(this, container);
  }

  void submitMove(int i, int j) {
    print("Checkers: move was made at board[${i}][${j}]");
  }

  void setupPieces() {}
}

abstract class GameBoard {
  Game game;
  Element container;

  GameBoard(this.game, this.container) {
    insertTiles();
  }

  Element createRow() {
    Element row = document.createElement("div");
    row.classes.add("board-row");
    return row;
  }

  void insertTiles();
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
}

class TicTacToeBoard extends GameBoard {
  TicTacToeBoard(TicTacToeGame game, Element container)
      : super(game, container) {}

  void insertTiles() {
    for (int i = 0; i < 3; i++) {
      Element row = createRow();
      for (int j = 0; j < 3; j++) {
        Element tile = createTile(i, j);
        row.children.add(tile);
      }

      container.children.add(row);
    }
  }

  Element createTile(int i, int j) {
    Element tile = document.createElement("div");
    tile.classes.add("ttt-tile");

    Game ttt = game;
    if (ttt is TicTacToeGame) {
      tile.addEventListener("click", (event) {
        ttt.submitMove(i, j);
      });
    }

    return tile;
  }
}
