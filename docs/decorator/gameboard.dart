import 'dart:html';
import 'pieces.dart';
import 'game.dart';

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

abstract class ChessBoard {
  void removePiece(int i, int j);
  void setupPieces(String playerColour);
  ChessPiece getPiece(int i, int j);
  void placePiece(ChessPiece piece, int i, int j);
}

class ChequeredBoard extends GameBoard implements ChessBoard {
  List<List<Element>> board = List.empty(growable: true);
  List<List<ChessPiece>> pieces = List.empty(growable: true);

  ChequeredBoard(Game game, Element container) : super(game, container) {}

  void setupPieces(String playerColour) {}

  void placePiece(ChessPiece piece, int i, int j) {
    Element tile = board[i][j];
    tile.children.add(piece.element);
    pieces[i][j] = piece;

    piece.i = i;
    piece.j = j;

    if (piece.initialRow == -1) {
      piece.initialRow = i;
    }
  }

  void removePiece(int i, int j) {
    Element tile = board[i][j];
    tile.children.clear();
    pieces[i][j] = EmptyPiece();
  }

  ChessPiece getPiece(int i, int j) {
    return pieces[i][j];
  }

  void setupPieceMatrix() {
    for (int i = 0; i < 8; i++) {
      List<ChessPiece> row = List.empty(growable: true);
      for (int j = 0; j < 8; j++) {
        row.add(EmptyPiece());
      }
      pieces.add(row);
    }
  }

  void insertTiles() {
    setupPieceMatrix();
    bool dark = false;

    for (int i = 0; i < 8; i++) {
      dark = !dark;
      List<Element> rowList = List.empty(growable: true);
      Element row = createRow();

      for (int j = 0; j < 8; j++) {
        dark = !dark;
        Element tile = createTile(i, j, dark);
        row.children.add(tile);
        rowList.add(tile);
      }

      board.add(rowList);
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

  bool validCoordinates(int i, int j) {
    if (0 <= i && i < board.length) {
      if (0 <= j && j < board[0].length) {
        return true;
      }
    }
    return false;
  }
}
