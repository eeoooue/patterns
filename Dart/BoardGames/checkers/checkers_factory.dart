import '../game.dart';
import 'checkers_pieces.dart';

class CheckersFactory extends GamePieceFactory {
  GamePiece createPiece(Type pieceType) {
    switch (pieceType) {
      case RedChecker:
        {
          return RedChecker();
        }
      case CreamChecker:
        {
          return CreamChecker();
        }
      default:
        {
          return EmptyCheckersPiece(0, 0);
        }
    }
  }
}
