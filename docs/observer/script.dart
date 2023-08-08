import 'dart:html';
import 'chess.dart';

class StrategyDemo {
  ChessGame game;
  ChessBoard board;

  StrategyDemo(this.game, this.board) {}
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
