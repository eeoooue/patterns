import 'dart:html';

// board games
import 'boardgames.dart';
// game-specific classes
import 'chess.dart';

void main() {
  createGame();
}

void createGame() {
  Element? gameContainer = document.getElementById("game-container");

  if (gameContainer is Element) {
    Game game = ChessGame(gameContainer);
    game.startGame();
  }
}
