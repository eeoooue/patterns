import 'dart:html';
import 'chess.dart';
import 'strategy.dart';

class StrategyDemo {
  ChessGame game;
  ChessBoard board;

  StrategyDemo(this.game, this.board) {
    placeQueen();
  }

  void placeQueen() {
    ChessPiece piece = ChessPiece("w", "queen", QueenMovement());
    game.board.placePiece(piece, 4, 3);
  }
}

void main() {
  setupDemo();
}

void setupDemo() {
  Element? gameContainer = document.getElementById("game-container");

  if (gameContainer is Element) {
    ChessGame game = ChessGame(gameContainer);
    game.startGame();

    var myBoard = game.board;

    if (myBoard is ChessBoard) {
      StrategyDemo(game, myBoard);
    }
  }
}
