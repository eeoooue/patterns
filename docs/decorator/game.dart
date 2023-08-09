import 'dart:html';
import 'boardviews.dart';
import 'strategy.dart';
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
  List<MoveOption> options = List.empty(growable: true);
  late ChessBoardView view;

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
    view.displayBoard(chessBoard.getBoardState());
  }

  bool validMove(int i, int j) {
    print("checking for move[${i}][${j}] in ${options.length} options");

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
    var thing = chessBoard;

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
