import 'game.dart';
import 'reversi_pieces.dart';

class ReversiBoard {
  List<List<GamePiece>> pieces = List.empty(growable: true);

  void removePiece(int i, int j) {
    pieces[i][j] = EmptyReversiPiece();
  }

  void setupPieces() {
    for (int i = 0; i < 8; i++) {
      List<GamePiece> row = List.empty(growable: true);
      for (int j = 0; j < 8; j++) {
        GamePiece piece = EmptyReversiPiece();
        row.add(piece);
      }
      pieces.add(row);
    }

    placePiece(ReversiPiece("black"), 3, 3);
    placePiece(ReversiPiece("white"), 3, 4);
    placePiece(ReversiPiece("white"), 4, 3);
    placePiece(ReversiPiece("black"), 4, 4);
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
