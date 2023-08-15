import '../game.dart';
import 'reversi_pieces.dart';

class ReversiBoard implements GameBoard {
  List<List<GamePiece>> pieces = List.empty(growable: true);

  void removePiece(int i, int j) {
    pieces[i][j] = EmptyReversiPiece(i, j);
  }

  void initialize() {
    pieces.clear();
    for (int i = 0; i < 8; i++) {
      List<GamePiece> row = List.empty(growable: true);
      for (int j = 0; j < 8; j++) {
        GamePiece piece = EmptyReversiPiece(i, j);
        row.add(piece);
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
