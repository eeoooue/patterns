import 'dart:html';
import 'chess.dart';
import 'strategy.dart';

class StrategyDemo {
  ChessGame game;
  ChessPiece piece = ChessPiece("w", "queen", QueenMovement());
  SelectElement selector;
  ChessBoard board;

  StrategyDemo(this.game, this.board, this.selector) {
    game.board.placePiece(piece, piece.i, piece.j);
    armSelector();
  }

  void armSelector() {
    selector.addEventListener("input", (event) {
      String? strategy = selector.value;
      if (strategy is String) {
        board.clearHighlights();
        swapToStrategy(strategy);
      }
    });
  }

  void swapToStrategy(String name) {
    MovementStrategy strategy = getMatchingStrategy(name);
    piece.moveStrategy = strategy;

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
    ChessGame game = ChessGame(gameContainer);
    game.startGame();

    var myBoard = game.board;

    if (myBoard is ChessBoard) {
      StrategyDemo(game, myBoard, selector);
    }
  }
}
