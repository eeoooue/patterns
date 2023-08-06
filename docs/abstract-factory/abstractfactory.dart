// board games
// game-specific classes
import 'chess.dart';
import 'blackpieces.dart';
import 'whitepieces.dart';

abstract class ChessPieceFactory {
  String colour;

  ChessPieceFactory(this.colour) {}

  Pawn createPawn();
  Knight createKnight();
  Bishop createBishop();
  Rook createRook();
  King createKing();
  Queen createQueen();
}

class BlackPieceFactory extends ChessPieceFactory {
  BlackPieceFactory() : super("black") {}

  Pawn createPawn() {
    return BlackPawn();
  }

  Knight createKnight() {
    return BlackKnight();
  }

  Bishop createBishop() {
    return BlackBishop();
  }

  Rook createRook() {
    return BlackRook();
  }

  King createKing() {
    return BlackKing();
  }

  Queen createQueen() {
    return BlackQueen();
  }
}

class WhitePieceFactory extends ChessPieceFactory {
  WhitePieceFactory() : super("white") {}

  Pawn createPawn() {
    return WhitePawn();
  }

  Knight createKnight() {
    return WhiteKnight();
  }

  Bishop createBishop() {
    return WhiteBishop();
  }

  Rook createRook() {
    return WhiteRook();
  }

  King createKing() {
    return WhiteKing();
  }

  Queen createQueen() {
    return WhiteQueen();
  }
}
