import 'dart:html';

// board games
import 'boardgames.dart';
// game-specific classes
import 'chess.dart';

class GameSelector {
  ButtonElement button;
  Element choicesContainer;
  Element gameContainer;

  List<String> gameChoices = List.from({"Chess"});

  GameSelector(this.button, this.choicesContainer, this.gameContainer) {
    armButton();
  }

  void armButton() {
    button.addEventListener("click", (event) {
      showChoices();
    });
  }

  void showChoices() {
    button.classes.add("hidden");

    for (String title in gameChoices) {
      GameChoice choice = GameChoice(this, title);
      choicesContainer.children.add(choice.element);
    }
  }

  void hideChoices() {
    button.classes.remove("hidden");
    choicesContainer.children.clear();
  }

  void selectGame(String title) {
    print("'${title}' was chosen.");
    hideChoices();
    Game game = getGame(title);
    game.startGame();
  }

  Game getGame(String title) {
    return ChessGame(gameContainer);
  }
}

class GameChoice {
  GameSelector parent;
  String title;
  late Element element;

  GameChoice(this.parent, this.title) {
    element = createElement();
    armElement();
  }

  Element createElement() {
    element = document.createElement("button");
    element.classes.add("game-choice");
    element.innerText = title;
    return element;
  }

  void armElement() {
    element.addEventListener("click", (event) {
      parent.selectGame(title);
    });
  }
}

void main() {
  createGameSelector();
}

void createGameSelector() {
  Element? optionBtn = document.getElementById("option-btn");
  Element? choicesContainer = document.getElementById("choices-container");
  Element? gameContainer = document.getElementById("game-container");

  if (optionBtn is ButtonElement) {
    if (choicesContainer is Element && gameContainer is Element) {
      GameSelector(optionBtn, choicesContainer, gameContainer);
    }
  }
}
