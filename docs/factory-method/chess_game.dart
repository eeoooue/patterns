import 'dart:html';
import 'game.dart';
import 'chess_pieces.dart';
import 'chess_view.dart';
import 'chess_board.dart';

class ChessGame implements Game {
  ChessPiece activePiece = EmptyPiece(0, 0);
  bool rotated = false;
  int turnCount = 0;
  GameBoard board = ChequeredBoard();
  late GameView view;
  bool gameOver = false;
  ChessKing? blackKing = null;
  ChessKing? whiteKing = null;

  ChessGame(Element container) {
    view = ChessBoardView(this, container);
  }

  bool gameIsOver() {
    return gameOver;
  }

  void startGame() {
    List<bool> initState = List.empty(growable: true);
    initState.add(true);
    initState.add(true);
    initState.add(true);
    initState.add(true);
    initState.add(true);
    initState.add(true);

    setupPieces(initState);
    pairKings();
    refreshView();
  }

  void findKings() {
    for (var row in board.getBoardState()) {
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
      for (var row in board.getBoardState()) {
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

  String getTurnPlayer() {
    return (turnCount % 2 == 0) ? "w" : "b";
  }

  void submitMove(int i, int j) {
    if (gameIsOver()) {
      return;
    }

    if (validMove(activePiece, i, j)) {
      movePiece(activePiece, i, j);
      endTurn();
      return;
    }
    clearMoveOptions();
    activePiece = EmptyPiece(0, 0);

    GamePiece piece = board.getPiece(i, j);

    if (piece is ChessPiece) {
      if (piece.colour == getTurnPlayer()) {
        piece.move(board);
        activePiece = piece;
      }
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
        GamePiece piece = board.getPiece(i, j);
        if (piece is ChessPiece) {
          piece.threatened = false;
        }
      }
    }
  }

  void endTurn() {
    turnCount += 1;
    activePiece = EmptyPiece(0, 0);
    clearMoveOptions();
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

  void setupPieces(List<bool> state) {
    board = ChequeredBoard();
    if (state[0]) {
      board = BoardWithPawns(board);
    }
    if (state[1]) {
      board = BoardWithBishops(board);
    }
    if (state[2]) {
      board = BoardWithKnights(board);
    }
    if (state[3]) {
      board = BoardWithRooks(board);
    }
    if (state[4]) {
      board = BoardWithQueens(board);
    }
    if (state[5]) {
      board = BoardWithKings(board);
    }

    board.setupPieces();
    refreshView();
  }
}
