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
  List<List<Element>> board = List.empty(growable: true);

  ChessBoard(Game game, Element container) : super(game, container) {}

  void placePiece(GamePiece piece, int i, int j) {
    Element tile = board[i][j];
    tile.children.add(piece.element);
  }

  void insertTiles() {
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

  bool tileIsEmpty(int i, int j) {
    return false;
  }
}

class ChessPiece extends GamePiece {
  ChessPiece(String name, String colour) {
    setSource("./assets/chess/${name}_${colour}.png");
  }
}
