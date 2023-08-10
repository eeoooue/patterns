import 'game.dart';
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

    setupCreamPieces();
    setupRedPieces();
  }

  void setupCreamPieces() {
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 8; j++) {
        if ((i + j) % 2 != 0) {
          CheckersPiece piece = CheckersPiece("cream");
          placePiece(piece, i, j);
        }
      }
    }
  }

  void setupRedPieces() {
    for (int i = 5; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if ((i + j) % 2 != 0) {
          CheckersPiece piece = CheckersPiece("red");
          placePiece(piece, i, j);
        }
      }
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
