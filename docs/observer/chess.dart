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
      processMove(myBoard, i, j);
    }
  }

  void processMove(ChessBoard chessBoard, int i, int j) {
    ChessPiece? piece;

    piece = chessBoard.activePiece;
    if (piece != null) {
      if (chessBoard.canMoveHere(piece, i, j)) {
        chessBoard.movePiece(piece, i, j);
        return;
      }
    }

    piece = chessBoard.getPiece(i, j) as ChessPiece?;
    if (piece is ChessPiece) {
      chessBoard.clearHighlights();
      List<MoveOption> options = piece.move(chessBoard);
      print("checked for options: found ${options.length}");
      chessBoard.setActivePiece(piece);
      chessBoard.highlightOptions(options);
    }
  }

  void setupPieces() {
    setupWhitePieces();
    setupBlackPieces();
  }

  void setupWhitePieces() {
    String colour = "w";

    ChessPiece king = ChessPiece(colour, "king", KingMovement());
    board.placePiece(king, 7, 4);

    ChessPiece queen = ChessPiece(colour, "queen", QueenMovement());
    board.placePiece(queen, 7, 3);

    ChessPiece rookL = ChessPiece(colour, "rook", RookMovement());
    board.placePiece(rookL, 7, 0);
    ChessPiece rookR = ChessPiece(colour, "rook", RookMovement());
    board.placePiece(rookR, 7, 7);

    ChessPiece knightL = ChessPiece(colour, "knight", KnightMovement());
    board.placePiece(knightL, 7, 1);
    ChessPiece knightR = ChessPiece(colour, "knight", KnightMovement());
    board.placePiece(knightR, 7, 6);

    ChessPiece bishopL = ChessPiece(colour, "bishop", BishopMovement());
    board.placePiece(bishopL, 7, 2);
    ChessPiece bishopR = ChessPiece(colour, "bishop", BishopMovement());
    board.placePiece(bishopR, 7, 5);

    for (int j = 0; j < 8; j++) {
      ChessPiece pawn = ChessPiece(colour, "pawn", PawnMovement());
      board.placePiece(pawn, 6, j);
    }
  }

  void setupBlackPieces() {
    String colour = "b";

    ChessPiece king = ChessPiece(colour, "king", KingMovement());
    board.placePiece(king, 0, 4);

    ChessPiece queen = ChessPiece(colour, "queen", QueenMovement());
    board.placePiece(queen, 0, 3);

    ChessPiece rookL = ChessPiece(colour, "rook", RookMovement());
    board.placePiece(rookL, 0, 0);
    ChessPiece rookR = ChessPiece(colour, "rook", RookMovement());
    board.placePiece(rookR, 0, 7);

    ChessPiece knightL = ChessPiece(colour, "knight", KnightMovement());
    board.placePiece(knightL, 0, 1);
    ChessPiece knightR = ChessPiece(colour, "knight", KnightMovement());
    board.placePiece(knightR, 0, 6);

    ChessPiece bishopL = ChessPiece(colour, "bishop", BishopMovement());
    board.placePiece(bishopL, 0, 2);
    ChessPiece bishopR = ChessPiece(colour, "bishop", BishopMovement());
    board.placePiece(bishopR, 0, 5);

    for (int j = 0; j < 8; j++) {
      ChessPiece pawn = ChessPiece(colour, "pawn", PawnMovement());
      board.placePiece(pawn, 1, j);
    }
  }
}

class ChessBoard extends GameBoard {
  List<List<Element>> board = List.empty(growable: true);
  List<List<GamePiece?>> pieces = List.empty(growable: true);

  List<Element> highlights = List.empty(growable: true);

  ChessPiece? activePiece = null;

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

  bool canMoveHere(GamePiece piece, int i, int j) {
    Element destination = board[i][j];

    for (Element div in destination.children) {
      if (div.classes.contains("dot")) {
        return true;
      }
    }

    return false;
  }

  void removePiece(int i, int j) {
    Element tile = board[i][j];
    tile.children.clear();
    pieces[i][j] = null;
  }

  void setActivePiece(ChessPiece piece) {
    activePiece = piece;
  }

  void movePiece(ChessPiece piece, int i, int j) {
    clearHighlights();
    removePiece(piece.i, piece.j);
    placePiece(piece, i, j);
    piece.hasMoved = true;
    activePiece = null;
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
