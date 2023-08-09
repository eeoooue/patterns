import 'strategy.dart';
import 'gameboard.dart';
import 'pieces.dart';

abstract class BoardWithPieces implements ChessBoard {
  ChessBoard base;

  BoardWithPieces(this.base) {}

  void setupPieces();

  void removePiece(int i, int j) {
    base.removePiece(i, j);
  }

  void placePiece(ChessPiece piece, int i, int j) {
    base.placePiece(piece, i, j);
  }

  ChessPiece getPiece(int i, int j) {
    return base.getPiece(i, j);
  }

  List<List<ChessPiece>> getBoardState() {
    return base.getBoardState();
  }
}

class BoardWithPawns extends BoardWithPieces {
  BoardWithPawns(ChessBoard base) : super(base) {}

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
  BoardWithBishops(ChessBoard base) : super(base) {}

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
  BoardWithKnights(ChessBoard base) : super(base) {}

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
  BoardWithRooks(ChessBoard base) : super(base) {}

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
  BoardWithKings(ChessBoard base) : super(base) {}

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
  BoardWithQueens(ChessBoard base) : super(base) {}

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
