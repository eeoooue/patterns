import 'connect_pieces.dart';
import '../game.dart';

class ConnectBoard implements GameBoard {
  List<List<GamePiece>> pieces = List.empty(growable: true);

  ConnectBoard() {}

  void initialize() {
    pieces.clear();
    for (int i = 0; i < 6; i++) {
      List<GamePiece> row = List.empty(growable: true);
      for (int j = 0; j < 7; j++) {
        row.add(EmptyConnectPiece(i, j));
      }
      pieces.add(row);
    }
  }

  void removePiece(int i, int j) {
    pieces[i][j] = EmptyConnectPiece(i, j);
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
