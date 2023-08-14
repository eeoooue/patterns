import 'dart:html';

// game-specific classes
import 'abstractfactory.dart';
import './chess/chess_game.dart';
import './chess/chess_pieces.dart';

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

    String title = (factory.colour == "black") ? "Black" : "White";
    button.innerText = "${title}PieceFactory";

    presentPieces();
  }

  void activateSelection(ChessPiece piece) {
    print("selection indicated! ${piece.name} ${piece.colour}");
    selection = piece;
    game.threatenAllWith(piece);
    presentPieces();
  }

  void presentPieces() {
    container.children.clear();
    for (PieceOption option in getOptions()) {
      container.children.add(option.element);
    }
  }

  List<PieceOption> getOptions() {
    List<PieceOption> options = List.empty(growable: true);

    options.add(PieceOption(this, factory.createPawn()));
    options.add(PieceOption(this, factory.createBishop()));
    options.add(PieceOption(this, factory.createKnight()));
    options.add(PieceOption(this, factory.createRook()));
    options.add(PieceOption(this, factory.createQueen()));
    options.add(PieceOption(this, factory.createKing()));

    return options;
  }
}

class PieceOption {
  PieceBox parent;
  ChessPiece piece;
  late Element element;

  PieceOption(this.parent, this.piece) {
    element = createElement();
  }

  Element createElement() {
    Element element = document.createElement("div");

    element.classes.add("piece-option");

    element.addEventListener("click", (event) {
      parent.activateSelection(piece);
    });

    element.children.add(piece.getElement());

    return element;
  }
}

void main() {
  setupBox();
}

void setupBox() {
  Element? gameContainer = document.getElementById("game-container");

  if (gameContainer is Element) {
    ChessGame game = ChessGame(gameContainer);
    game.startGame();

    List<bool> initState = List.empty(growable: true);
    initState.add(false);
    initState.add(false);
    initState.add(false);
    initState.add(false);
    initState.add(false);
    initState.add(false);
    game.setupPieces(initState);

    Element? switchBtn = document.querySelector(".colour-switcher");
    Element? pieceContainer = document.getElementById("piece-box");

    if (switchBtn is ButtonElement && pieceContainer is Element) {
      PieceBox(game, pieceContainer, switchBtn);
    }
  }
}
