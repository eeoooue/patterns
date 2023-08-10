import 'dart:html';

abstract class Game {
  void startGame();
  void submitMove(int i, int j);
}

abstract class GameBoard {
  void removePiece(int i, int j);
  void setupPieces();
  GamePiece getPiece(int i, int j);
  void placePiece(GamePiece piece, int i, int j);
  List<List<GamePiece>> getBoardState();
}

abstract class GameView {
  void displayBoard(List<List<GamePiece>> boardstate);
  Element buildTile(GamePiece piece);
  void rotateBoard();
}

abstract class GamePiece {
  late String src;
  int i = 0;
  int j = 0;

  GamePiece() {}

  void setSource(String address) {
    src = address;
  }

  Element getElement() {
    Element img = document.createElement("img");
    img.classes.add("piece-img");
    if (img is ImageElement) {
      img.src = src;
    }

    return img;
  }
}
