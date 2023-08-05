import 'dart:html';

class GameSelector {
  ButtonElement button;
  Element choicesContainer;
  Element gameContainer;

  List<String> gameChoices =
      List.from({"Chess", "Checkers", "Tic-Tac-Toe", "Connect 4"});

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
    return TicTacToeGame(this.gameContainer);
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

abstract class Game {
  Element container;
  late GameBoard board;

  Game(this.container) {}

  void startGame() {
    clearPlayArea();
    board = createBoard();
    setupPieces();
  }

  void clearPlayArea() {
    container.children.clear();
  }

  GameBoard createBoard();

  void setupPieces();
}

class TicTacToeGame extends Game {
  TicTacToeGame(Element container) : super(container) {}

  GameBoard createBoard() {
    return TicTacToeBoard(this, container);
  }

  void submitMove(int i, int j) {
    print("Tic-Tac-Toe: move was made at board[${i}][${j}]");
  }

  void setupPieces() {}
}

abstract class GameBoard {
  Game game;
  Element container;

  GameBoard(this.game, this.container) {
    insertTiles();
  }

  Element createRow() {
    Element row = document.createElement("div");
    row.classes.add("board-row");
    return row;
  }

  void insertTiles();
}

class TicTacToeBoard extends GameBoard {
  TicTacToeBoard(TicTacToeGame game, Element container)
      : super(game, container) {}

  void insertTiles() {
    for (int i = 0; i < 3; i++) {
      Element row = createRow();
      for (int j = 0; j < 3; j++) {
        Element tile = createTile(i, j);
        row.children.add(tile);
      }

      container.children.add(row);
    }
  }

  Element createTile(int i, int j) {
    Element tile = document.createElement("div");
    tile.classes.add("ttt-tile");

    Game ttt = game;
    if (ttt is TicTacToeGame) {
      tile.addEventListener("click", (event) {
        ttt.submitMove(i, j);
      });
    }

    return tile;
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
