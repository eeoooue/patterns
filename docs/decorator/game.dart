import 'dart:html';
import 'strategy.dart';
import 'boarddecorators.dart';
import 'gameboard.dart';
import 'pieces.dart';

abstract class Game {
  Element container;
  late GameBoard board;

  Game(this.container) {}

  void startGame() {
    clearPlayArea();
    board = createBoard();
    setupPieces();
  }

  void clearPlayArea() {
    container.children.clear();
  }

  void submitMove(int i, int j);

  GameBoard createBoard();

  void setupPieces();
}

class ChessGame extends Game {
  int turnCount = 0;
  late ChessBoard chessBoard;
  ChessPiece? activePiece = null;
  List<MoveOption> options = List.empty(growable: true);

  ChessGame(Element container) : super(container) {}

  GameBoard createBoard() {
    return ChequeredBoard(this, container);
  }

  String getTurnPlayer() {
    return (turnCount % 2 == 0) ? "w" : "b";
  }

  void submitMove(int i, int j) {
    print("Chess: move was made at board[${i}][${j}]");

    if (activePiece != null) {
      if (validMove(i, j)) {
        movePiece(activePiece!, i, j);
        endTurn();
        return;
      }
      activePiece = null;
    }

    dynamic piece = chessBoard.getPiece(i, j);

    if (piece is ChessPiece && piece.colour == getTurnPlayer()) {
      options = piece.move(chessBoard);
      activePiece = piece;
    }
  }

  void endTurn() {
    turnCount += 1;
  }

  bool validMove(int i, int j) {
    for (MoveOption move in options) {
      if ((move.i == i) && (move.j == j)) {
        return true;
      }
    }
    return false;
  }

  void movePiece(ChessPiece piece, int i, int j) {
    chessBoard.removePiece(piece.i, piece.j);
    chessBoard.removePiece(i, j);
    chessBoard.placePiece(piece, i, j);
    piece.hasMoved = true;
    activePiece = null;
  }

  void setupPieces() {
    var thing = board;

    if (thing is ChequeredBoard) {
      ChessBoard decoratedBoard = thing;
      decoratedBoard = BoardWithPawns(decoratedBoard);
      decoratedBoard = BoardWithBishops(decoratedBoard);
      decoratedBoard = BoardWithKnights(decoratedBoard);
      decoratedBoard = BoardWithRooks(decoratedBoard);
      decoratedBoard = BoardWithQueens(decoratedBoard);
      decoratedBoard = BoardWithKings(decoratedBoard);

      decoratedBoard.setupPieces("w");

      chessBoard = decoratedBoard;
    }
  }
}
