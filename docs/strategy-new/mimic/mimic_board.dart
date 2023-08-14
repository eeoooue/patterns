import '../game.dart';
import 'mimic_pieces.dart';

class MimicBoard implements GameBoard {
  List<List<GamePiece>> pieces = List.empty(growable: true);

  MimicBoard() {}

  void setupPieces() {
    for (int i = 0; i < 8; i++) {
      List<MimicPiece> row = List.empty(growable: true);
      for (int j = 0; j < 8; j++) {
        row.add(EmptyPiece(i, j));
      }
      pieces.add(row);
    }
  }

  bool tileIsEmpty(int i, int j) {
    return pieces[i][j] is EmptyPiece;
  }

  List<List<GamePiece>> getBoardState() {
    return pieces;
  }

  void placePiece(GamePiece piece, int i, int j) {
    pieces[i][j] = piece;
    piece.i = i;
    piece.j = j;
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
