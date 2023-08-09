import 'dart:html';
import 'boardviews.dart';
import 'boarddecorators.dart';
import 'gameboard.dart';
import 'pieces.dart';

class ChessGame {
  int turnCount = 0;
  late ChessBoard chessBoard;
  ChessPiece activePiece = EmptyPiece(0, 0);
  late ChessView view;
  Element container;

  ChessGame(this.container) {
    view = ChessBoardView(this, container);
  }

  void startGame() {
    chessBoard = createBoard();
    setupPieces();
    refreshView();
  }

  ChessBoard createBoard() {
    return ChequeredBoard(this);
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

    ChessPiece piece = chessBoard.getPiece(i, j);
    if (piece.colour == getTurnPlayer()) {
      piece.move(chessBoard);
      activePiece = piece;
    }

    refreshView();
  }

  void refreshView() {
    view.displayBoard(chessBoard.getBoardState());
  }

  void clearMoveOptions() {
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        ChessPiece piece = chessBoard.getPiece(i, j);
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
    ChessPiece target = chessBoard.getPiece(i, j);
    return target.threatened;
  }

  void movePiece(ChessPiece piece, int i, int j) {
    chessBoard.removePiece(piece.i, piece.j);
    chessBoard.removePiece(i, j);
    chessBoard.placePiece(piece, i, j);
    piece.hasMoved = true;
  }

  void setupPieces() {
    chessBoard = BoardWithPawns(chessBoard);
    chessBoard = BoardWithBishops(chessBoard);
    chessBoard = BoardWithKnights(chessBoard);
    chessBoard = BoardWithRooks(chessBoard);
    chessBoard = BoardWithQueens(chessBoard);
    chessBoard = BoardWithKings(chessBoard);
    chessBoard.setupPieces();
  }
}
