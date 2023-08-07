import 'dart:html';

// game-specific classes
import 'chess.dart';
import 'strategy.dart';

void main() {
  setupDemo();
}

void setupDemo() {
  Element? gameContainer = document.getElementById("game-container");

  if (gameContainer is Element) {
    ChessGame game = ChessGame(gameContainer);
    game.startGame();

    int i = 4;
    int j = 3;

    MimicPiece mimic = MimicPiece(i, j, KingMovement());
    game.board.placePiece(mimic, i, j);
  }
}
