import 'dart:html';
import 'boardviews.dart';
import 'boarddecorators.dart';
import 'gameboard.dart';
import 'pieces.dart';

class ChessGame {
  int turnCount = 0;
  late ChessBoard board = ChequeredBoard();
  ChessPiece activePiece = EmptyPiece(0, 0);
  late ChessView view;
  Element container;
  bool rotated = false;

  ChessGame(this.container) {
    view = ChessBoardView(this, container);
  }

  void startGame() {
    setupPieces();
    refreshView();
  }

  String getTurnPlayer() {
    return (turnCount % 2 == 0) ? "w" : "b";
  }

  void submitMove(int i, int j) {
    if (validMove(activePiece, i, j)) {
      movePiece(activePiece, i, j);
      endTurn();
      return;
    }
    clearMoveOptions();
    activePiece = EmptyPiece(0, 0);

    ChessPiece piece = board.getPiece(i, j);
    if (piece.colour == getTurnPlayer()) {
      piece.move(board);
      activePiece = piece;
    }

    refreshView();
  }

  void refreshView() {
    view.displayBoard(board.getBoardState());
    if (rotated) {
      view.rotateBoard();
    }
  }

  void clearMoveOptions() {
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        ChessPiece piece = board.getPiece(i, j);
        piece.threatened = false;
      }
    }
  }

  void endTurn() {
    turnCount += 1;
    activePiece = EmptyPiece(0, 0);
    clearMoveOptions();
    refreshView();
  }

  bool validMove(ChessPiece piece, int i, int j) {
    ChessPiece target = board.getPiece(i, j);
    return target.threatened;
  }

  void movePiece(ChessPiece piece, int i, int j) {
    board.removePiece(piece.i, piece.j);
    board.removePiece(i, j);
    board.placePiece(piece, i, j);
    piece.hasMoved = true;
  }

  void setupPieces() {
    board = BoardWithPawns(board);
    board = BoardWithBishops(board);
    board = BoardWithKnights(board);
    board = BoardWithRooks(board);
    board = BoardWithQueens(board);
    board = BoardWithKings(board);
    board.setupPieces();
  }
}
