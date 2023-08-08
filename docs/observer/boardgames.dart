import 'dart:html';
import 'observer.dart';

abstract class Game implements Subject {
  Element container;
  late GameBoard board;

  List<Observer> observers = List.empty(growable: true);

  Game(this.container) {}

  void subscribe(Observer observer) {
    observers.add(observer);
  }

  void unsubscribe(Observer observer) {
    observers.remove(observer);
  }

  void notify() {
    for (Observer observer in observers) {
      observer.update(this);
    }
  }

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

  void placePiece(GamePiece piece, int i, int j);
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
