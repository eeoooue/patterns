import 'dart:html';

// game-specific classes
import 'abstractfactory.dart';
import 'chess.dart';

class PieceBox {
  ChessGame game;
  Element container;
  ButtonElement button;
  ChessPieceFactory factory = BlackPieceFactory();
  ChessPiece? selection = null;

  PieceBox(this.game, this.container, this.button) {
    armButton();
    switchColour();
  }

  void armButton() {
    button.addEventListener("click", (event) {
      switchColour();
    });
  }

  void switchColour() {
    String current = factory.colour;
    factory = (current == "black") ? WhitePieceFactory() : BlackPieceFactory();

    button.classes.remove("${current}-btn");
    button.classes.add("${factory.colour}-btn");
    button.innerText = factory.colour;

    presentPieces();
  }

  void presentPieces() {
    container.children.clear();

    for (ChessPiece piece in getOptions()) {
      container.children.add(piece.element);
    }
  }

  List<ChessPiece> getOptions() {
    List<ChessPiece> options = List.empty(growable: true);

    options.add(factory.createPawn());
    options.add(factory.createBishop());
    options.add(factory.createKnight());
    options.add(factory.createRook());
    options.add(factory.createQueen());
    options.add(factory.createKing());

    return options;
  }
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
