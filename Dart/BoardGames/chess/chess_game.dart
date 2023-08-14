import 'dart:html';
import '../game.dart';

import 'chess_pieces.dart';
import 'chess_view.dart';
import 'chess_board.dart';
import 'chess_logic.dart';

class ChessGame implements Game {
  bool rotated = false;
  int turnCount = 0;
  GameBoard board = ChequeredBoard();
  bool gameOver = false;
  ChessKing? blackKing = null;
  ChessKing? whiteKing = null;
  late GameView view;
  late ChessLogic logic;

  ChessGame(Element container) {
    view = ChessBoardView(this, container);
    logic = ChessLogic(this);
  }

  bool gameIsOver() {
    return gameOver;
  }

  void startGame() {
    setupPieces();
    logic.pairKings();
    refreshView();
  }

  String getTurnPlayer() {
    return (turnCount % 2 == 0) ? "w" : "b";
  }

  void submitMove(int i, int j) {
    logic.submitMove(i, j);
    refreshView();
  }

  void refreshView() {
    view.displayBoard(board.getBoardState());
    if (rotated) {
      view.rotateBoard();
    }
  }

  void endTurn() {
    turnCount += 1;
    logic.activePiece = EmptyPiece(0, 0);
    logic.clearMoveOptions();
    updateKings();
    refreshView();
  }

  void updateKings() {
    var bKing = blackKing;
    var wKing = whiteKing;

    if (bKing is ChessKing) {
      bKing.threatened = bKing.isTheatened(board);
    }

    if (wKing is ChessKing) {
      wKing.threatened = wKing.isTheatened(board);
    }
  }

  bool validMove(ChessPiece piece, int i, int j) {
    GamePiece target = board.getPiece(i, j);
    if (target is ChessPiece) {
      return target.threatened;
    }
    return false;
  }

  void movePiece(ChessPiece piece, int i, int j) {
    board.removePiece(piece.i, piece.j);
    board.removePiece(i, j);
    board.placePiece(piece, i, j);
    piece.hasMoved = true;
  }

  void setupPieces() {
    board = createBoard();
    board.setupPieces();
    refreshView();
  }

  GameBoard createBoard() {
    board = ChequeredBoard();
    board = BoardWithPawns(board);
    board = BoardWithBishops(board);
    board = BoardWithKnights(board);
    board = BoardWithRooks(board);
    board = BoardWithQueens(board);
    board = BoardWithKings(board);
    return board;
  }
}
