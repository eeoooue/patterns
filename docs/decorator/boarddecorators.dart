import 'strategy.dart';
import 'gameboard.dart';
import 'pieces.dart';

abstract class BoardWithPieces implements ChessBoard {
  ChessBoard base;

  BoardWithPieces(this.base) {}

  void setupPieces(String playerColour) {
    base.setupPieces(playerColour);
    String enemyColour = (playerColour == "w") ? "b" : "w";
    setupFriendlyPieces(playerColour);
    setupEnemyPieces(enemyColour);
  }

  void setupEnemyPieces(String colour);
  void setupFriendlyPieces(String colour);

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

  void setupEnemyPieces(String colour) {
    for (int j = 0; j < 8; j++) {
      ChessPiece pawn = ChessPiece(colour, "pawn", PawnMovement());
      base.placePiece(pawn, 1, j);
    }
  }

  void setupFriendlyPieces(String colour) {
    for (int j = 0; j < 8; j++) {
      ChessPiece pawn = ChessPiece(colour, "pawn", PawnMovement());
      base.placePiece(pawn, 6, j);
    }
  }
}

class BoardWithBishops extends BoardWithPieces {
  BoardWithBishops(ChessBoard base) : super(base) {}

  void setupEnemyPieces(String colour) {
    ChessPiece bishopL = ChessPiece(colour, "bishop", BishopMovement());
    base.placePiece(bishopL, 0, 2);
    ChessPiece bishopR = ChessPiece(colour, "bishop", BishopMovement());
    base.placePiece(bishopR, 0, 5);
  }

  void setupFriendlyPieces(String colour) {
    ChessPiece bishopL = ChessPiece(colour, "bishop", BishopMovement());
    base.placePiece(bishopL, 7, 2);
    ChessPiece bishopR = ChessPiece(colour, "bishop", BishopMovement());
    base.placePiece(bishopR, 7, 5);
  }
}

class BoardWithKnights extends BoardWithPieces {
  BoardWithKnights(ChessBoard base) : super(base) {}

  void setupEnemyPieces(String colour) {
    ChessPiece eKnightL = ChessPiece(colour, "knight", KnightMovement());
    base.placePiece(eKnightL, 0, 1);
    ChessPiece eKnightR = ChessPiece(colour, "knight", KnightMovement());
    base.placePiece(eKnightR, 0, 6);
  }

  void setupFriendlyPieces(String colour) {
    ChessPiece knightL = ChessPiece(colour, "knight", KnightMovement());
    base.placePiece(knightL, 7, 1);
    ChessPiece knightR = ChessPiece(colour, "knight", KnightMovement());
    base.placePiece(knightR, 7, 6);
  }
}

class BoardWithRooks extends BoardWithPieces {
  BoardWithRooks(ChessBoard base) : super(base) {}

  void setupEnemyPieces(String colour) {
    ChessPiece rookL = ChessPiece(colour, "rook", RookMovement());
    base.placePiece(rookL, 0, 0);
    ChessPiece rookR = ChessPiece(colour, "rook", RookMovement());
    base.placePiece(rookR, 0, 7);
  }

  void setupFriendlyPieces(String colour) {
    ChessPiece rookL = ChessPiece(colour, "rook", RookMovement());
    base.placePiece(rookL, 7, 0);
    ChessPiece rookR = ChessPiece(colour, "rook", RookMovement());
    base.placePiece(rookR, 7, 7);
  }
}

class BoardWithKings extends BoardWithPieces {
  BoardWithKings(ChessBoard base) : super(base) {}

  void setupEnemyPieces(String colour) {
    ChessPiece king = ChessPiece(colour, "king", KingMovement());

    if (colour == "b") {
      base.placePiece(king, 0, 4);
    } else {
      base.placePiece(king, 0, 3);
    }
  }

  void setupFriendlyPieces(String colour) {
    ChessPiece king = ChessPiece(colour, "king", KingMovement());

    if (colour == "b") {
      base.placePiece(king, 7, 3);
    } else {
      base.placePiece(king, 7, 4);
    }
  }
}

class BoardWithQueens extends BoardWithPieces {
  BoardWithQueens(ChessBoard base) : super(base) {}

  void setupEnemyPieces(String colour) {
    ChessPiece queen = ChessPiece(colour, "queen", QueenMovement());

    if (colour == "b") {
      base.placePiece(queen, 0, 3);
    } else {
      base.placePiece(queen, 0, 4);
    }
  }

  void setupFriendlyPieces(String colour) {
    ChessPiece queen = ChessPiece(colour, "queen", QueenMovement());

    if (colour == "b") {
      base.placePiece(queen, 7, 4);
    } else {
      base.placePiece(queen, 7, 3);
    }
  }
}
