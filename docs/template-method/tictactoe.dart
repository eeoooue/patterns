import 'dart:html';
import 'script.dart';

class TicTacToeGame extends Game {
  int turnPlayer = 0;
  bool gameOver = false;

  TicTacToeGame(Element container) : super(container) {}

  GameBoard createBoard() {
    return TicTacToeBoard(this, container);
  }

  void submitMove(int i, int j) {
    print("Tic-Tac-Toe: move was made at board[${i}][${j}]");
    if (board.tileIsEmpty(i, j)) {
      makeMove(i, j);
    }
  }

  void makeMove(int i, int j) {
    String team = (turnPlayer == 0) ? "nought" : "cross";
    TicTacToePiece piece = TicTacToePiece(team);

    var myBoard = board;
    if (myBoard is TicTacToeBoard) {
      myBoard.placePiece(piece, i, j);
      turnPlayer = (turnPlayer + 1) % 2;
    }
  }

  void setupPieces() {}
}

class TicTacToePiece extends GamePiece {
  TicTacToePiece(String team) {
    setSource("/assets/tictactoe/ttt_${team}.png");
  }
}

class TicTacToeBoard extends GameBoard {
  List<List<Element>> board = List.empty(growable: true);

  TicTacToeBoard(TicTacToeGame game, Element container)
      : super(game, container) {}

  void placePiece(GamePiece piece, int i, int j) {
    Element tile = board[i][j];
    tile.children.add(piece.element);
  }

  void removePiece(int i, int j) {
    Element tile = board[i][j];
    tile.children.clear();
  }

  void insertTiles() {
    for (int i = 0; i < 3; i++) {
      List<Element> rowList = List.empty(growable: true);
      Element row = createRow();
      for (int j = 0; j < 3; j++) {
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
    tile.classes.add("ttt-tile");

    Game ttt = game;
    if (ttt is TicTacToeGame) {
      tile.addEventListener("click", (event) {
        ttt.submitMove(i, j);
      });
    }

    return tile;
  }

  bool tileIsEmpty(int i, int j) {
    Element tile = board[i][j];
    return tile.children.length == 0;
  }
}
