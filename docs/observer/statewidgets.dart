import 'dart:html';
import 'observer.dart';

class TurnplayerWidget implements Observer {
  Element container;
  PlayerBlock blackBlock = PlayerBlock("Black");
  PlayerBlock whiteBlock = PlayerBlock("White");

  TurnplayerWidget(Subject game, this.container) {
    container.children.clear();
    container.children.add(whiteBlock.element);
    container.children.add(blackBlock.element);
    game.subscribe(this);
  }

  void update(Subject subject) {
    String turnPlayer = "w";

    if (turnPlayer == "b") {
      blackBlock.setState(true);
      whiteBlock.setState(false);
    } else {
      blackBlock.setState(false);
      whiteBlock.setState(true);
    }
  }
}

class PlayerBlock {
  String colour;
  late Element element;

  PlayerBlock(this.colour) {
    createElement();
  }

  Element createElement() {
    Element element = document.createElement("div");
    element.classes.add("player-block");
    element.classes.add(colour.toLowerCase());
    element.innerText = colour;

    return element;
  }

  void setState(bool active) {
    element.classes.add("inactive");

    if (active == true) {
      element.classes.remove("inactive");
    }
  }
}
