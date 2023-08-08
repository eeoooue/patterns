import 'dart:html';
import 'chess.dart';
import 'strategy.dart';

class StrategyDemo {
  ChessGame game;
  ChessPiece piece = ChessPiece("w", "queen", QueenMovement());
  ChessBoard board;

  StrategyDemo(this.game, this.board) {
    game.board.placePiece(piece, piece.i, piece.j);
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
