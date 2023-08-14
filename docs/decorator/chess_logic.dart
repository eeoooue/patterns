import 'chess_game.dart';
import 'game.dart';
import 'chess_pieces.dart';

class ChessLogic {
  ChessGame game;

  ChessKing? blackKing = null;
  ChessKing? whiteKing = null;

  ChessPiece activePiece = EmptyPiece(0, 0);
  bool gameOver = false;

  ChessLogic(this.game) {}

  bool gameIsOver() {
    return gameOver;
  }

  void findKings() {
    for (var row in game.board.getBoardState()) {
      for (GamePiece piece in row) {
        if (piece is ChessKing) {
          if (piece.colour == "b") {
            print("black king found ! ${piece.i} ${piece.j}");
            blackKing = piece;
          } else {
            print("white king found ! ${piece.i} ${piece.j}");
            whiteKing = piece;
          }
        }
      }
    }
  }

  void pairKings() {
    findKings();
    if (blackKing is ChessKing && whiteKing is ChessKing) {
      for (var row in game.board.getBoardState()) {
        for (GamePiece piece in row) {
          if (piece is ChessPiece) {
            if (piece.colour == "b") {
              piece.myKing = blackKing;
            }
            if (piece.colour == "w") {
              piece.myKing = whiteKing;
            }
          }
        }
      }
    }
  }

  void submitMove(int i, int j) {
    if (gameOver) {
      return;
    }

    if (validMove(activePiece, i, j)) {
      movePiece(activePiece, i, j);
      game.endTurn();
      return;
    }
    clearMoveOptions();
    activePiece = EmptyPiece(0, 0);

    GamePiece piece = game.board.getPiece(i, j);

    if (piece is ChessPiece) {
      if (piece.colour == game.getTurnPlayer()) {
        piece.move(game.board);
        activePiece = piece;
      }
    }

    game.refreshView();
  }

  void clearMoveOptions() {
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        GamePiece piece = game.board.getPiece(i, j);
        if (piece is ChessPiece) {
          piece.threatened = false;
        }
      }
    }
  }

  void updateKings() {
    var bKing = blackKing;
    var wKing = whiteKing;

    if (bKing is ChessKing) {
      bKing.threatened = bKing.isTheatened(game.board);
    }

    if (wKing is ChessKing) {
      wKing.threatened = wKing.isTheatened(game.board);
    }
  }

  bool validMove(ChessPiece piece, int i, int j) {
    GamePiece target = game.board.getPiece(i, j);
    if (target is ChessPiece) {
      return target.threatened;
    }
    return false;
  }

  void movePiece(ChessPiece piece, int i, int j) {
    game.board.removePiece(piece.i, piece.j);
    game.board.removePiece(i, j);
    game.board.placePiece(piece, i, j);
    piece.hasMoved = true;
  }
}
