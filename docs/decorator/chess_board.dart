import 'game.dart';
import 'chess_pieces.dart';

class ChequeredBoard implements GameBoard {
  List<List<GamePiece>> pieces = List.empty(growable: true);

  ChequeredBoard() {}

  void setupPieces() {
    for (int i = 0; i < 8; i++) {
      List<ChessPiece> row = List.empty(growable: true);
      for (int j = 0; j < 8; j++) {
        row.add(EmptyPiece(i, j));
      }
      pieces.add(row);
    }
  }

  List<List<GamePiece>> getBoardState() {
    return pieces;
  }

  void placePiece(GamePiece piece, int i, int j) {
    pieces[i][j] = piece;
    if (piece is ChessPiece) {
      piece.i = i;
      piece.j = j;
    }
  }

  void removePiece(int i, int j) {
    pieces[i][j] = EmptyPiece(i, j);
  }

  GamePiece getPiece(int i, int j) {
    return pieces[i][j];
  }

  bool validCoordinates(int i, int j) {
    return (0 <= i && i < 8) && (0 <= j && j < 8);
  }
}

abstract class BoardWithPieces implements GameBoard {
  GameBoard base;

  BoardWithPieces(this.base) {}

  void setupPieces();

  void removePiece(int i, int j) {
    base.removePiece(i, j);
  }

  void placePiece(GamePiece piece, int i, int j) {
    base.placePiece(piece, i, j);
  }

  GamePiece getPiece(int i, int j) {
    return base.getPiece(i, j);
  }

  List<List<GamePiece>> getBoardState() {
    return base.getBoardState();
  }
}

class BoardWithPawns extends BoardWithPieces {
  BoardWithPawns(GameBoard base) : super(base) {}

  void setupPieces() {
    base.setupPieces();
    for (int j = 0; j < 8; j++) {
      placePawn("b", 1, j);
      placePawn("w", 6, j);
    }
  }

  void placePawn(String colour, int i, int j) {
    ChessPiece pawn = ChessPiece(colour, "pawn", PawnMovement());
    base.placePiece(pawn, i, j);
  }
}

class BoardWithBishops extends BoardWithPieces {
  BoardWithBishops(GameBoard base) : super(base) {}

  void setupPieces() {
    base.setupPieces();
    placeBishop("b", 0, 2);
    placeBishop("b", 0, 5);
    placeBishop("w", 7, 2);
    placeBishop("w", 7, 5);
  }

  void placeBishop(String colour, int i, int j) {
    ChessPiece bishop = ChessPiece(colour, "bishop", BishopMovement());
    base.placePiece(bishop, i, j);
  }
}

class BoardWithKnights extends BoardWithPieces {
  BoardWithKnights(GameBoard base) : super(base) {}

  void setupPieces() {
    base.setupPieces();
    placeKnight("b", 0, 1);
    placeKnight("b", 0, 6);
    placeKnight("w", 7, 1);
    placeKnight("w", 7, 6);
  }

  void placeKnight(String colour, int i, int j) {
    ChessPiece knight = ChessPiece(colour, "knight", KnightMovement());
    base.placePiece(knight, i, j);
  }
}

class BoardWithRooks extends BoardWithPieces {
  BoardWithRooks(GameBoard base) : super(base) {}

  void setupPieces() {
    base.setupPieces();
    placeRook("b", 0, 0);
    placeRook("b", 0, 7);
    placeRook("w", 7, 0);
    placeRook("w", 7, 7);
  }

  void placeRook(String colour, int i, int j) {
    ChessPiece rook = ChessPiece(colour, "rook", RookMovement());
    base.placePiece(rook, i, j);
  }
}

class BoardWithKings extends BoardWithPieces {
  BoardWithKings(GameBoard base) : super(base) {}

  void setupPieces() {
    base.setupPieces();
    placeKing("b", 0, 4);
    placeKing("w", 7, 4);
  }

  void placeKing(String colour, int i, int j) {
    ChessPiece king = ChessPiece(colour, "king", KingMovement());
    base.placePiece(king, i, j);
  }
}

class BoardWithQueens extends BoardWithPieces {
  BoardWithQueens(GameBoard base) : super(base) {}

  void setupPieces() {
    base.setupPieces();
    placeQueen("b", 0, 3);
    placeQueen("w", 7, 3);
  }

  void placeQueen(String colour, int i, int j) {
    ChessPiece queen = ChessPiece(colour, "queen", QueenMovement());
    base.placePiece(queen, i, j);
  }
}
