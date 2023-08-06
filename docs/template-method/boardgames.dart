import 'dart:html';

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

  void submitMove(int i, int j);

  GameBoard createBoard();

  void setupPieces();
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

  bool tileIsEmpty(int i, int j);
}

abstract class GamePiece {
  late String src;
  late ImageElement element;

  GamePiece() {}

  void setSource(String address) {
    src = address;
    buildElement();
  }

  void buildElement() {
    Element img = document.createElement("img");
    img.classes.add("piece-img");
    if (img is ImageElement) {
      img.src = src;
      element = img;
    }
  }
}
