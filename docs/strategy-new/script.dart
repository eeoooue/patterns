import 'dart:html';
import 'mimic/mimic_board.dart';
import 'mimic/mimic_game.dart';
import 'mimic/mimic_pieces.dart';

class StrategyDemo {
  MimicGame game;
  SelectElement selector;
  MimicBoard board;

  StrategyDemo(this.game, this.board, this.selector) {
    armSelector();
  }

  void armSelector() {
    selector.addEventListener("input", (event) {
      String? strategy = selector.value;
      if (strategy is String) {
        swapToStrategy(strategy);
        game.clearMoveOptions();
        game.refreshView();
      }
    });
  }

  void swapToStrategy(String name) {
    MovementStrategy strategy = getMatchingStrategy(name);
    game.demoPiece.moveStrategy = strategy;

    print("swapped strat to ${name}");
  }

  MovementStrategy getMatchingStrategy(String name) {
    switch (name) {
      case "Pawn":
        {
          return PawnMovement();
        }
      case "Bishop":
        {
          return BishopMovement();
        }
      case "Knight":
        {
          return KnightMovement();
        }
      case "Rook":
        {
          return RookMovement();
        }
      case "Queen":
        {
          return QueenMovement();
        }
      case "King":
        {
          return KingMovement();
        }
    }
    throw Exception("Couldn't find a matching strategy");
  }
}

void main() {
  setupDemo();
}

void setupDemo() {
  Element? gameContainer = document.getElementById("game-container");

  Element? selector = document.getElementById("strategy-selector");

  if (gameContainer is Element && selector is SelectElement) {
    MimicGame game = MimicGame(gameContainer);
    game.startGame();

    var myBoard = game.board;

    StrategyDemo(game, myBoard, selector);
  }
}
