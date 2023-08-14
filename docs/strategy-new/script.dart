import 'dart:html';
import 'game.dart';
import 'chess/chess_game.dart';
import 'mimic/mimic_game.dart';

class GameSelector {
  Element choicesContainer;
  Element gameContainer;
  late Game game;

  List<String> choices = List.from({"Chess"});

  GameSelector(this.choicesContainer, this.gameContainer) {
    showChoices();
  }

  void showChoices() {
    for (String title in choices) {
      GameChoice choice = GameChoice(this, title);
      choicesContainer.children.add(choice.element);

      if (title == "Chess") {
        choice.activate();
      }
    }
  }

  void resetButtons() {
    List<Element> buttons = document.querySelectorAll(".game-choice");
    for (Element button in buttons) {
      button.classes.remove("active");
    }
  }

  void selectGame(String title) {
    resetButtons();
    print("'${title}' was chosen.");
    Game game = getGame(title);
    game.startGame();
  }

  Game getGame(String title) {
    switch (title) {
      case "Chess":
        return MimicGame(gameContainer);
      default:
        return ChessGame(gameContainer);
    }
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
      activate();
    });
  }

  void activate() {
    parent.selectGame(title);
    element.classes.add("active");
  }
}

void main() {
  createGameSelector();
}

void createGameSelector() {
  Element? choicesContainer = document.getElementById("choices-container");
  Element? gameContainer = document.getElementById("game-container");

  if (choicesContainer is Element && gameContainer is Element) {
    GameSelector(choicesContainer, gameContainer);
  }
}
