import 'dart:html';
import 'strategy.dart';
import 'gameboard.dart';

abstract class GamePiece {
  late String src;

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

class ChessPiece extends GamePiece {
  int i = 0;
  int j = 0;
  MovementStrategy moveStrategy;
  String colour;
  String name;
  bool hasMoved = false;
  bool threatened = false;

  ChessPiece(this.colour, this.name, this.moveStrategy) {
    setSource("./assets/chess/${name}_${colour}.png");
  }

  void setPosition(int iInput, int jInput) {
    i = iInput;
    j = jInput;
  }

  void move(ChessBoard board) {
    moveStrategy.move(board, this);
  }

  bool canCapture(ChessBoard board, int i, int j) {
    if (validCoords(i, j)) {
      ChessPiece target = board.getPiece(i, j);
      if (!(target is EmptyPiece) && target.colour != colour) {
        target.threatened = true;
        return true;
      }
    }

    return false;
  }

  bool canMove(ChessBoard board, int i, int j) {
    if (validCoords(i, j)) {
      GamePiece target = board.getPiece(i, j);
      if (target is EmptyPiece) {
        target.threatened = true;
        return true;
      }
    }

    return false;
  }

  bool validCoords(int i, int j) {
    return (0 <= i && i < 8) & (0 <= j && j < 8);
  }
}

class EmptyPiece extends ChessPiece {
  EmptyPiece(int iPosition, int jPosition)
      : super("empty", "empty", NoMovement()) {
    i = iPosition;
    j = jPosition;
  }
}
