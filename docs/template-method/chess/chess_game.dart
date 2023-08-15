import 'dart:html';
import '../game.dart';
import 'chess_board.dart';

class ChessGame extends Game {
  int turnCount = 0;

  ChessGame(Element container) : super(container) {}

  GameBoard createBoard() {
    board = ChequeredBoard();
    board.initialize();
    return board;
  }

  void setupPieces(GameBoard board) {
    board = BoardWithPawns(board);
    board = BoardWithBishops(board);
    board = BoardWithKnights(board);
    board = BoardWithRooks(board);
    board = BoardWithQueens(board);
    board = BoardWithKings(board);
    board.initialize();

    refreshView();
  }
}
