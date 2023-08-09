import 'pieces.dart';
import 'game.dart';

abstract class ChessBoard {
  void removePiece(int i, int j);
  void setupPieces();
  ChessPiece getPiece(int i, int j);
  void placePiece(ChessPiece piece, int i, int j);
  List<List<ChessPiece>> getBoardState();
}

class ChequeredBoard implements ChessBoard {
  List<List<ChessPiece>> pieces = List.empty(growable: true);

  ChequeredBoard(ChessGame game) {}

  void setupPieces() {
    for (int i = 0; i < 8; i++) {
      List<ChessPiece> row = List.empty(growable: true);
      for (int j = 0; j < 8; j++) {
        row.add(EmptyPiece(i, j));
      }
      pieces.add(row);
    }
  }

  List<List<ChessPiece>> getBoardState() {
    return pieces;
  }

  void placePiece(ChessPiece piece, int i, int j) {
    pieces[i][j] = piece;

    piece.i = i;
    piece.j = j;

    if (piece.initialRow == -1) {
      piece.initialRow = i;
    }
  }

  void removePiece(int i, int j) {
    pieces[i][j] = EmptyPiece(i, j);
  }

  ChessPiece getPiece(int i, int j) {
    return pieces[i][j];
  }

  bool validCoordinates(int i, int j) {
    return (0 <= i && i < 8) && (0 <= j && j < 8);
  }
}
