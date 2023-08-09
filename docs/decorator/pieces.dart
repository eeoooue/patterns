import 'dart:html';
import 'strategy.dart';
import 'gameboard.dart';

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

class ChessPiece extends GamePiece {
  int i = 0;
  int j = 0;
  MovementStrategy moveStrategy;
  String colour;
  String name;
  bool selected = false;
  bool hasMoved = false;
  int initialRow = -1;

  ChessPiece(this.colour, this.name, this.moveStrategy) {
    setSource("./assets/chess/${name}_${colour}.png");
  }

  void setPosition(int iInput, int jInput) {
    i = iInput;
    j = jInput;
  }

  List<MoveOption> move(ChessBoard board) {
    List<MoveOption> options = moveStrategy.move(board, this);
    print("the piece has ${options.length} options");
    return options;
  }

  bool canCapture(ChessBoard board, int i, int j) {
    if (validCoords(i, j)) {
      ChessPiece target = board.getPiece(i, j);
      if (!(target is EmptyPiece) && target.colour != colour) {
        return true;
      }
    }

    return false;
  }

  bool canMove(ChessBoard board, int i, int j) {
    if (validCoords(i, j)) {
      GamePiece target = board.getPiece(i, j);
      if (target is EmptyPiece) {
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
  EmptyPiece() : super("empty", "empty", NoMovement()) {}
}
