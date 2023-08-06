import 'dart:html';

// game-specific classes
import 'chess.dart';

class PieceBox {
  ChessGame game;
  Element container;
  ButtonElement button;

  PieceBox(this.game, this.container, this.button) {}
}

void main() {
  setupBox();
}

void setupBox() {
  Element? gameContainer = document.getElementById("game-container");

  if (gameContainer is Element) {
    ChessGame game = ChessGame(gameContainer);
    game.createBoard();

    Element? switchBtn = document.querySelector(".colour-switcher");
    Element? pieceContainer = document.getElementById("piece-box");

    if (switchBtn is ButtonElement && pieceContainer is Element) {
      PieceBox(game, pieceContainer, switchBtn);
    }
  }
}
