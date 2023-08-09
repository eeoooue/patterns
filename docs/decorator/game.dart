import 'dart:html';
import 'boardviews.dart';
import 'boarddecorators.dart';
import 'gameboard.dart';
import 'pieces.dart';

abstract class Game {
  Element container;

  Game(this.container) {}

  void startGame();

  void clearPlayArea() {
    container.children.clear();
  }

  void submitMove(int i, int j);
}

class ChessGame extends Game {
  int turnCount = 0;
  late ChessBoard chessBoard;
  ChessPiece? activePiece = null;
  late ChessView view;

  ChessGame(Element container) : super(container) {
    view = ChessBoardView(this, container);
  }

  void startGame() {
    clearPlayArea();
    chessBoard = createBoard();
    setupPieces();
    view.displayBoard(chessBoard.getBoardState());
  }

  ChessBoard createBoard() {
    return ChequeredBoard(this);
  }

  String getTurnPlayer() {
    return (turnCount % 2 == 0) ? "w" : "b";
  }

  void submitMove(int i, int j) {
    if (activePiece != null) {
      if (validMove(activePiece, i, j)) {
        movePiece(activePiece!, i, j);
        endTurn();
        return;
      }
      clearMoveOptions();
      activePiece = null;
    }

    dynamic piece = chessBoard.getPiece(i, j);

    if (piece is ChessPiece && piece.colour == getTurnPlayer()) {
      piece.move(chessBoard);
      activePiece = piece;
      view.displayBoard(chessBoard.getBoardState());
    }
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
    clearMoveOptions();
    view.displayBoard(chessBoard.getBoardState());
  }

  bool validMove(ChessPiece? piece, int i, int j) {
    if (piece == null) {
      return false;
    }

    ChessPiece target = chessBoard.getPiece(i, j);
    return target.threatened;
  }

  void movePiece(ChessPiece piece, int i, int j) {
    chessBoard.removePiece(piece.i, piece.j);
    chessBoard.removePiece(i, j);
    chessBoard.placePiece(piece, i, j);
    piece.hasMoved = true;
    activePiece = null;
  }

  void setupPieces() {
    var thing = chessBoard;

    if (thing is ChequeredBoard) {
      ChessBoard decoratedBoard = thing;
      decoratedBoard = BoardWithPawns(decoratedBoard);
      decoratedBoard = BoardWithBishops(decoratedBoard);
      decoratedBoard = BoardWithKnights(decoratedBoard);
      decoratedBoard = BoardWithRooks(decoratedBoard);
      decoratedBoard = BoardWithQueens(decoratedBoard);
      decoratedBoard = BoardWithKings(decoratedBoard);
      decoratedBoard.setupPieces();
      chessBoard = decoratedBoard;
    }
  }
}
