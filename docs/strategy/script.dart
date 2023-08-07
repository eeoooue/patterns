import 'dart:html';

// game-specific classes
import 'chess.dart';

void main() {
  setupBox();
}

void setupBox() {
  Element? gameContainer = document.getElementById("game-container");

  if (gameContainer is Element) {
    ChessGame game = ChessGame(gameContainer);
    game.createBoard();
  }
}
