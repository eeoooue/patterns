import '../game.dart';
import 'dart:html';
import 'reversi_board.dart';
import 'reversi_pieces.dart';

class ReversiGame extends Game {
  int turnCount = 0;

  ReversiGame(Element container) : super(container) {}

  GameBoard createBoard() {
    var board = ReversiBoard();
    board.initialize();
    return board;
  }

  void setupPieces(GameBoard board) {
    board.initialize();
    board.placePiece(ReversiPiece("white"), 3, 3);
    board.placePiece(ReversiPiece("black"), 3, 4);
    board.placePiece(ReversiPiece("black"), 4, 3);
    board.placePiece(ReversiPiece("white"), 4, 4);
    refreshView();
  }
}
