import 'dart:html';
import 'boardgames.dart';
import 'strategy.dart';

class ChessGame extends Game {
  ChessGame(Element container) : super(container) {}

  GameBoard createBoard() {
    return ChessBoard(this, container);
  }

  void submitMove(int i, int j) {
    print("Chess: move was made at board[${i}][${j}]");

    var myBoard = board;

    if (myBoard is ChessBoard) {
      GamePiece? piece = myBoard.getPiece(i, j);
      if (piece is ChessPiece) {
        List<MoveOption> options = piece.move(myBoard);
        print("checked for options: found ${options.length}");
        myBoard.highlightOptions(options);
      }
    }
  }

  void setupPieces() {
    placeQueen();
  }

  void placeQueen() {
    ChessPiece piece = ChessPiece("w", "queen", QueenMovement());
    board.placePiece(piece, 4, 3);
  }
}

class ChessBoard extends GameBoard {
  List<List<Element>> board = List.empty(growable: true);
  List<List<GamePiece?>> pieces = List.empty(growable: true);

  List<Element> highlights = List.empty(growable: true);

  ChessBoard(Game game, Element container) : super(game, container) {}

  void placePiece(GamePiece piece, int i, int j) {
    Element tile = board[i][j];
    tile.children.add(piece.element);
    pieces[i][j] = piece;

    if (piece is ChessPiece) {
      piece.i = i;
      piece.j = j;
    }
  }

  void removePiece(int i, int j) {
    Element tile = board[i][j];
    tile.children.clear();
    pieces[i][j] = null;
  }

  void clearHighlights() {
    for (Element highlight in highlights) {
      highlight.remove();
    }
  }

  void highlightOptions(List<MoveOption> options) {
    for (MoveOption move in options) {
      Element highlight = createHighlight();
      highlights.add(highlight);
      Element tile = board[move.i][move.j];
      tile.children.add(highlight);
    }
  }

  Element createHighlight() {
    Element e = document.createElement("div");
    e.classes.add("dot");
    return e;
  }

  GamePiece? getPiece(int i, int j) {
    return pieces[i][j];
  }

  void setupPieceMatrix() {
    for (int i = 0; i < 8; i++) {
      List<GamePiece?> row = List.empty(growable: true);
      for (int j = 0; j < 8; j++) {
        row.add(null);
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

  bool tileIsEmpty(int i, int j) {
    if (validCoordinates(i, j)) {
      Element tile = board[i][j];
      return tile.children.length == 0;
    }
    return false;
  }
}
