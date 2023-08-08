import 'dart:html';
import 'boardgames.dart';
import 'strategy.dart';
import 'decorators.dart';

abstract class ChessBoard {
  void removePiece(int i, int j);
  void setupPieces(String playerColour);
  GamePiece? getPiece(int i, int j);
  void placePiece(GamePiece piece, int i, int j);
  void addMarker(int i, int j, String marker);
  void clearHighlights();
}

class ChessGame extends Game {
  int turnCount = 0;
  late ChessBoard chessBoard;
  ChessPiece? activePiece = null;
  List<MoveOption> options = List.empty(growable: true);

  ChessGame(Element container) : super(container) {}

  GameBoard createBoard() {
    return ChequeredBoard(this, container);
  }

  String getTurnPlayer() {
    return (turnCount % 2 == 0) ? "w" : "b";
  }

  void submitMove(int i, int j) {
    print("Chess: move was made at board[${i}][${j}]");

    if (activePiece != null && validMove(i, j)) {
      movePiece(activePiece!, i, j);
      endTurn();
      return;
    }

    dynamic piece = chessBoard.getPiece(i, j);

    if (piece is ChessPiece && piece.colour == getTurnPlayer()) {
      options = piece.move(chessBoard);
      activePiece = piece;
    }
  }

  void endTurn() {
    chessBoard.clearHighlights();
    turnCount += 1;
  }

  bool validMove(int i, int j) {
    for (MoveOption move in options) {
      if ((move.i == i) && (move.j == j)) {
        return true;
      }
    }
    return false;
  }

  void movePiece(ChessPiece piece, int i, int j) {
    chessBoard.removePiece(piece.i, piece.j);
    chessBoard.removePiece(i, j);
    chessBoard.placePiece(piece, i, j);
    piece.hasMoved = true;
    activePiece = null;
  }

  void setupPieces() {
    var thing = board;

    if (thing is ChequeredBoard) {
      ChessBoard decoratedBoard = thing;
      decoratedBoard = BoardWithPawns(decoratedBoard);
      decoratedBoard = BoardWithBishops(decoratedBoard);
      decoratedBoard = BoardWithKnights(decoratedBoard);
      decoratedBoard = BoardWithRooks(decoratedBoard);
      decoratedBoard = BoardWithQueens(decoratedBoard);
      decoratedBoard = BoardWithKings(decoratedBoard);

      decoratedBoard.setupPieces("w");

      chessBoard = decoratedBoard;
    }
  }
}

class ChequeredBoard extends GameBoard implements ChessBoard {
  List<List<Element>> board = List.empty(growable: true);
  List<List<GamePiece?>> pieces = List.empty(growable: true);

  ChequeredBoard(Game game, Element container) : super(game, container) {}

  void setupPieces(String playerColour) {}

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

  void clearHighlights() {
    List<Element> elements = document.querySelectorAll(".marker");

    for (Element highlight in elements) {
      highlight.remove();
    }
  }

  void addMarker(int i, int j, String marker) {
    Element tile = board[i][j];
    Element mark = document.createElement("div");
    mark.classes.add("marker");
    mark.classes.add(marker);
    tile.children.add(mark);
  }
}
