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

  void setupPieces() {
    setupWhitePieces();
    setupBlackPieces();
  }

  void setupWhitePieces() {
    String colour = "w";

    ChessPiece king = ChessPiece("king", colour);
    board.placePiece(king, 7, 4);

    ChessPiece queen = ChessPiece("queen", colour);
    board.placePiece(queen, 7, 3);

    ChessPiece rookL = ChessPiece("rook", colour);
    board.placePiece(rookL, 7, 0);
    ChessPiece rookR = ChessPiece("rook", colour);
    board.placePiece(rookR, 7, 7);

    ChessPiece knightL = ChessPiece("knight", colour);
    board.placePiece(knightL, 7, 1);
    ChessPiece knightR = ChessPiece("knight", colour);
    board.placePiece(knightR, 7, 6);

    ChessPiece bishopL = ChessPiece("bishop", colour);
    board.placePiece(bishopL, 7, 2);
    ChessPiece bishopR = ChessPiece("bishop", colour);
    board.placePiece(bishopR, 7, 5);

    for (int j = 0; j < 8; j++) {
      ChessPiece pawn = ChessPiece("pawn", colour);
      board.placePiece(pawn, 6, j);
    }
  }

  void setupBlackPieces() {
    String colour = "b";

    ChessPiece king = ChessPiece("king", colour);
    board.placePiece(king, 0, 4);

    ChessPiece queen = ChessPiece("queen", colour);
    board.placePiece(queen, 0, 3);

    ChessPiece rookL = ChessPiece("rook", colour);
    board.placePiece(rookL, 0, 0);
    ChessPiece rookR = ChessPiece("rook", colour);
    board.placePiece(rookR, 0, 7);

    ChessPiece knightL = ChessPiece("knight", colour);
    board.placePiece(knightL, 0, 1);
    ChessPiece knightR = ChessPiece("knight", colour);
    board.placePiece(knightR, 0, 6);

    ChessPiece bishopL = ChessPiece("bishop", colour);
    board.placePiece(bishopL, 0, 2);
    ChessPiece bishopR = ChessPiece("bishop", colour);
    board.placePiece(bishopR, 0, 5);

    for (int j = 0; j < 8; j++) {
      ChessPiece pawn = ChessPiece("pawn", colour);
      board.placePiece(pawn, 1, j);
    }
  }
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
    setSource("/assets/chess/${name}_${colour}.png");
  }
}
