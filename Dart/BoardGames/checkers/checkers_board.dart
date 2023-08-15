import '../game.dart';
import 'checkers_pieces.dart';

class CheckersBoard implements GameBoard {
  List<List<GamePiece>> pieces = List.empty(growable: true);

  void removePiece(int i, int j) {
    pieces[i][j] = EmptyCheckersPiece(i, j);
  }

  void setupPieces() {
    for (int i = 0; i < 8; i++) {
      List<GamePiece> row = List.empty(growable: true);
      for (int j = 0; j < 8; j++) {
        row.add(EmptyCheckersPiece(i, j));
      }
      pieces.add(row);
    }
  }

  GamePiece getPiece(int i, int j) {
    return pieces[i][j];
  }

  void placePiece(GamePiece piece, int i, int j) {
    pieces[i][j] = piece;
    piece.i = i;
    piece.j = j;
  }

  List<List<GamePiece>> getBoardState() {
    return pieces;
  }
}
