import 'dart:html';
import 'game.dart';
import 'chess/chess_game.dart';

abstract class Demo {
  void insertCheckboxes();
  void rebuildGame();
}

class DecoratorDemo implements Demo {
  Element sideTray;
  List<DecoratorCheckbox> checkboxes = List.empty(growable: true);
  Game game;

  DecoratorDemo(this.sideTray, this.game) {
    insertCheckboxes();
  }

  void insertCheckboxes() {
    addCheckbox("Pawn");
    addCheckbox("Bishop");
    addCheckbox("Knight");
    addCheckbox("Rook");
    addCheckbox("Queen");
    addCheckbox("King");
  }

  void addCheckbox(String piece) {
    DecoratorCheckbox box = DecoratorCheckbox(this, piece);
    checkboxes.add(box);
    sideTray.children.add(box.container);
  }

  void rebuildGame() {
    List<bool> state = List.empty(growable: true);
    for (int i = 0; i < checkboxes.length; i++) {
      state.add(checkboxes[i].checked);
    }

    var chessGame = game;
    if (chessGame is ChessGame) {
      chessGame.setupPieces(state);
    }
  }
}

class DecoratorCheckbox {
  Element container = document.createElement("div");
  Demo demo;
  String piece;
  bool checked = true;

  DecoratorCheckbox(this.demo, this.piece) {
    container.classes.add("deco-cbox");
    Element cbox = createCheckbox();
    container.children.add(cbox);
    Element label = createLabel();
    container.children.add(label);

    if (cbox is InputElement) {
      armCheckbox(cbox);
    }
  }

  void armCheckbox(InputElement cbox) {
    cbox.addEventListener("input", (event) {
      checked = !checked;
      demo.rebuildGame();
    });
  }

  Element createCheckbox() {
    Element cbox = document.createElement("input");
    cbox.id = "${piece}-cbox";
    cbox.classes.add("cbox");
    if (cbox is InputElement) {
      cbox.type = "checkbox";
      cbox.checked = true;
    }

    return cbox;
  }

  Element createLabel() {
    Element label = document.createElement("label");
    label.classes.add("cbox-label");
    if (label is LabelElement) {
      label.htmlFor = "${piece}-cbox";
      label.innerText = "${piece}s";
    }

    return label;
  }
}

void main() {
  setupDemo();
}

void setupDemo() {
  Element? gameContainer = document.getElementById("game-container");
  Element? sideTray = document.getElementById("side-tray");

  if (gameContainer is Element && sideTray is Element) {
    Game game = ChessGame(gameContainer);
    game.startGame();

    DecoratorDemo(sideTray, game);
  }
}
