import 'dart:html';
import 'chess.dart';
import 'observer.dart';

class TurnplayerWidget implements Observer {
  late Element container;
  PlayerBlock blackBlock = PlayerBlock("Black");
  PlayerBlock whiteBlock = PlayerBlock("White");

  TurnplayerWidget(Subject game) {
    container = createContainer();
    container.children.add(createHeader());
    container.children.add(createBookshelf());
    game.subscribe(this);
    update(game);
  }

  Element createHeader() {
    Element header = document.createElement("h3");
    header.innerText = "Turn Player";
    return header;
  }

  Element createBookshelf() {
    Element bookshelf = document.createElement("div");
    bookshelf.classes.add("container");
    bookshelf.classes.add("bookshelf");
    bookshelf.id = "turnswitch-bar";
    bookshelf.children.add(whiteBlock.element);
    bookshelf.children.add(blackBlock.element);
    return bookshelf;
  }

  Element createContainer() {
    Element container = document.createElement("div");
    container.classes.add("container");
    container.classes.add("totempole");
    container.id = "turnplayer-widget";
    return container;
  }

  void update(Subject subject) {
    if (subject is ChessGame) {
      if (subject.getTurnPlayer() == "b") {
        blackBlock.setState(true);
        whiteBlock.setState(false);
      } else {
        blackBlock.setState(false);
        whiteBlock.setState(true);
      }
    }
  }
}

class PlayerBlock {
  String colour;
  late Element element;

  PlayerBlock(this.colour) {
    element = createElement();
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
