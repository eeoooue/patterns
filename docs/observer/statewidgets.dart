import 'dart:html';
import 'dart:math';
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

class AnalysisWidget implements Observer {
// <div class="container totempole" id="analysis-widget">
//     <h3>Analysis</h3>
//     <div class="container bookshelf" id="analysis-bar">
//         <div class="teamclr-block white"></div>
//         <div class="teamclr-block black"></div>
//     </div>
// </div>

  late Element container;
  late Element progressBar;
  Random rand = Random();

  AnalysisWidget(Subject game) {
    container = createContainer();
    container.children.add(createHeader());
    container.children.add(createBookshelf());
    game.subscribe(this);
    // update(game);
  }

  Element createProgressBar() {
    Element bar = document.createElement("div");
    bar.classes.add("white-block");
    return bar;
  }

  Element createHeader() {
    Element header = document.createElement("h3");
    header.innerText = "Analysis";
    return header;
  }

  Element createBookshelf() {
    Element bookshelf = document.createElement("div");
    bookshelf.classes.add("container");
    bookshelf.classes.add("bookshelf");
    bookshelf.id = "analysis-bar";
    progressBar = createProgressBar();
    bookshelf.children.add(progressBar);
    return bookshelf;
  }

  Element createContainer() {
    Element container = document.createElement("div");
    container.classes.add("container");
    container.classes.add("totempole");
    container.id = "analysis-widget";
    return container;
  }

  String getRandPercentage() {
    int amount = rand.nextInt(101);
    return "${amount}%";
  }

  void update(Subject subject) {
    progressBar.style.width = getRandPercentage();
  }
}
