import 'dart:html';
import 'gameview.dart';

abstract class Game {
  late GameBoard board;
  late GameView view;
  Element container;

  Game(this.container) {}

  void startGame() {
    clearContainer();
    view = createView(container);
    board = createBoard();
    setupPieces(board);
  }

  void clearContainer() {
    container.classes.remove("game-view");
    container.children.clear();
  }

  GameView createView(Element container) {
    return GameView(this, container);
  }

  GameBoard createBoard();

  void setupPieces(GameBoard board);

  void refreshView() {
    view.displayBoard(board.getBoardState());
  }
}

abstract class GameBoard {
  void initialize();
  void removePiece(int i, int j);
  GamePiece getPiece(int i, int j);
  void placePiece(GamePiece piece, int i, int j);
  List<List<GamePiece>> getBoardState();
}

abstract class GamePiece {
  int i = 0;
  int j = 0;

  Element createElement();
}
