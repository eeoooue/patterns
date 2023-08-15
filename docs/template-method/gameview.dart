import 'dart:html';
import 'game.dart';

class GameView {
  Game game;
  Element container;

  GameView(this.game, this.container) {
    container.classes.add("game-view");
  }

  void displayBoard(List<List<GamePiece>> boardstate) {
    container.children.clear();
    for (List<GamePiece> rowOfPieces in boardstate) {
      Element row = createRowContainer();
      for (GamePiece piece in rowOfPieces) {
        Element tile = piece.createElement();
        row.children.add(tile);
      }
      container.children.add(row);
    }
  }

  Element createRowContainer() {
    Element row = document.createElement("div");
    row.classes.add("board-row");
    return row;
  }
}
