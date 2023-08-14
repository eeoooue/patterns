import 'dart:html';
import 'chess/chess_game.dart';
import 'statewidgets.dart';

class ObserverDemo {
  Element sideTray;
  ChessGame game;

  ObserverDemo(this.sideTray, this.game) {
    addTurnplayerWidget();
    addAnalysisWidget();
  }

  void addTurnplayerWidget() {
    var widget = TurnplayerWidget(game);
    sideTray.children.add(widget.container);
  }

  void addAnalysisWidget() {
    var widget = AnalysisWidget(game);
    sideTray.children.add(widget.container);
  }
}

void main() {
  setupDemo();
}

void setupDemo() {
  Element? gameContainer = document.getElementById("game-container");
  Element? sideTray = document.getElementById("side-tray");

  if (gameContainer is Element && sideTray is Element) {
    ChessGame game = ChessGame(gameContainer);
    game.startGame();
    ObserverDemo(sideTray, game);
  }
}
