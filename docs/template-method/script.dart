import 'dart:html';
import 'game.dart';
import 'checkers/checkers_game.dart';
import 'connect/connect_game.dart';
import 'chess/chess_game.dart';
import 'reversi/reversi_game.dart';

class GameSelector {
  Element choicesContainer;
  Element gameContainer;
  late Game game;
  ControlWidget? widget;

  List<String> choices = List.from({"Chess", "Connect", "Draughts", "Reversi"});

  GameSelector(this.choicesContainer, this.gameContainer) {
    showChoices();
  }

  void clearContainer() {
    game.clearContainer();
    // game.refreshView();
  }

  void createView() {
    game.view = game.createView(game.container);
    // game.refreshView();
  }

  void createBoard() {
    game.board = game.createBoard();
    game.refreshView();
  }

  void setupPieces() {
    game.setupPieces(game.board);
    game.refreshView();
  }

  void pairWidget(ControlWidget controlWidget) {
    widget = controlWidget;
  }

  void showChoices() {
    for (String title in choices) {
      GameChoice choice = GameChoice(this, title);
      choicesContainer.children.add(choice.element);

      if (title == "Chess") {
        choice.activate();
        game.startGame();
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
    game = getGame(title);
    widget?.setState(0);
  }

  Game getGame(String title) {
    switch (title) {
      case "Chess":
        return ChessGame(gameContainer);
      case "Connect":
        return ConnectGame(gameContainer);
      case "Draughts":
        return CheckersGame(gameContainer);
      case "Reversi":
        return ReversiGame(gameContainer);
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

class ControlWidget {
  GameSelector selector;
  ButtonElement startBtn;

  Element? btn1;
  Element? btn2;
  Element? btn3;
  Element? btn4;

  int currentState = 0;

  ControlWidget(this.selector, this.startBtn) {
    findButtons();
    armButtons();
  }

  void findButtons() {
    btn1 = document.getElementById("clear-container-btn");
    btn2 = document.getElementById("create-view-btn");
    btn3 = document.getElementById("create-board-btn");
    btn4 = document.getElementById("setup-pieces-btn");
  }

  void armButtons() {
    startBtn.addEventListener("click", (event) {
      setState(4);
    });

    if (btn1 is ButtonElement) {
      btn1?.addEventListener("click", (event) {
        if (!btn1!.classes.contains("active")) {
          setState(1);
        }
      });
    }

    if (btn2 is ButtonElement) {
      btn2?.addEventListener("click", (event) {
        if (!btn2!.classes.contains("active")) {
          setState(2);
        }
      });
    }

    if (btn3 is ButtonElement) {
      btn3?.addEventListener("click", (event) {
        if (!btn3!.classes.contains("active")) {
          setState(3);
        }
      });
    }

    if (btn4 is ButtonElement) {
      btn4?.addEventListener("click", (event) {
        if (!btn4!.classes.contains("active")) {
          setState(4);
        }
      });
    }
  }

  void clearButtons() {
    for (Element element in document.querySelectorAll(".method-btn")) {
      element.classes.remove("active");
    }
  }

  void setState(int n) {
    currentState = n;

    clearButtons();

    print("set state to ${n}");

    if (n > 0) {
      selector.clearContainer();
      btn1?.classes.add("active");
    }

    if (n > 1) {
      selector.createView();
      btn2?.classes.add("active");
    }

    if (n > 2) {
      selector.createBoard();
      btn3?.classes.add("active");
    }

    if (n > 3) {
      selector.setupPieces();
      btn4?.classes.add("active");
      startBtn.classes.add("active");
    }
  }
}

void main() {
  createGameSelector();
}

void createGameSelector() {
  Element? choicesContainer = document.getElementById("choices-container");
  Element? gameContainer = document.getElementById("game-container");

  if (choicesContainer is Element && gameContainer is Element) {
    var selector = GameSelector(choicesContainer, gameContainer);

    Element? startGameBtn = document.getElementById("start-game-btn");

    if (startGameBtn is ButtonElement) {
      var widget = ControlWidget(selector, startGameBtn);
      selector.pairWidget(widget);
    }
  }
}
