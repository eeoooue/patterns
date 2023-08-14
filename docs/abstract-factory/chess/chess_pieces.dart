import 'dart:collection';
import 'dart:html';
import '../game.dart';

class ChessPiece extends GamePiece {
  MovementStrategy moveStrategy;
  String colour;
  String name;
  bool hasMoved = false;
  bool threatened = false;
  ChessKing? myKing;

  ChessPiece(this.colour, this.name, this.moveStrategy) {
    setSource("./assets/chess/${name}_${colour}.png");
  }

  void setPosition(int iInput, int jInput) {
    i = iInput;
    j = jInput;
  }

  void move(GameBoard board) {
    moveStrategy.move(board, this);
  }

  bool canCapture(GameBoard board, int i, int j) {
    if (validCoords(i, j)) {
      GamePiece target = board.getPiece(i, j);

      if (target is ChessPiece && isSafeMove(board, i, j)) {
        if (!(target is EmptyPiece) && target.colour != colour) {
          target.threatened = true;
          return true;
        }
      }
    }

    return false;
  }

  bool canMove(GameBoard board, int i, int j) {
    if (validCoords(i, j)) {
      GamePiece target = board.getPiece(i, j);
      if (target is EmptyPiece && isSafeMove(board, i, j)) {
        target.threatened = true;
        return true;
      }
    }

    return false;
  }

  bool isSafeMove(GameBoard board, int endI, int endJ) {
    int startI = i;
    int startJ = j;
    GamePiece target = board.getPiece(endI, endJ);

    board.removePiece(startI, startJ);
    board.removePiece(endI, endJ);
    board.placePiece(this, endI, endJ);

    bool verdict = true;
    var king = myKing;
    if (king is ChessKing && king.isTheatened(board)) {
      print("my king is at ${king.i} , ${king.j}");
      verdict = false;
    }

    board.placePiece(this, startI, startJ);
    board.placePiece(target, endI, endJ);

    if (verdict) {
      print("this move is safe! (${endI}, ${endJ})");
    } else {
      print("this move is unsafe! (${endI}, ${endJ})");
    }

    return verdict;
  }

  bool validCoords(int i, int j) {
    return (0 <= i && i < 8) & (0 <= j && j < 8);
  }
}

class ChessKing extends ChessPiece {
  ChessKing(String colour) : super(colour, "king", KingMovement()) {}

  Element getCheckImage() {
    Element img = document.createElement("img");
    img.classes.add("piece-img");
    if (img is ImageElement) {
      img.src = "./assets/chess/king_${colour}_check.png";
    }
    return img;
  }

  bool isTheatened(GameBoard board) {
    if (attackedByPawn(board) || attackedByKnight(board)) {
      return true;
    } else if (attackedOnDiagonals(board) || attackedOnHorizontals(board)) {
      return true;
    }
    return false;
  }

  bool attackedOnDiagonals(GameBoard board) {
    HashSet<String> diagonalThreats = HashSet();
    diagonalThreats.add("queen");
    diagonalThreats.add("bishop");

    ChessPiece northEast = threatAlongImpulse(board, -1, 1);
    ChessPiece southEast = threatAlongImpulse(board, 1, 1);
    ChessPiece southWest = threatAlongImpulse(board, 1, -1);
    ChessPiece northWest = threatAlongImpulse(board, -1, -1);
    var threats = List.from({northEast, southEast, southWest, northWest});

    for (ChessPiece piece in threats) {
      if (diagonalThreats.contains(piece.name)) {
        return true;
      }
    }

    return false;
  }

  bool attackedOnHorizontals(GameBoard board) {
    HashSet<String> horizontalThreats = HashSet();
    horizontalThreats.add("queen");
    horizontalThreats.add("rook");

    ChessPiece north = threatAlongImpulse(board, -1, 0);
    ChessPiece east = threatAlongImpulse(board, 0, 1);
    ChessPiece south = threatAlongImpulse(board, 1, 0);
    ChessPiece west = threatAlongImpulse(board, 0, -1);
    var threats = List.from({north, east, south, west});

    for (ChessPiece piece in threats) {
      if (horizontalThreats.contains(piece.name)) {
        return true;
      }
    }

    return false;
  }

  ChessPiece threatAlongImpulse(GameBoard board, int di, int dj) {
    int a = i;
    int b = j;

    while (true) {
      a += di;
      b += dj;
      if (!validCoords(a, b)) {
        return EmptyPiece(0, 0);
      }

      ChessPiece threat = getPiece(board, a, b);
      if (threat is EmptyPiece) {
        continue;
      }
      if (threat.colour == colour) {
        return EmptyPiece(0, 0);
      }
      return threat;
    }
  }

  bool attackedByPawn(GameBoard board) {
    int row = (colour == "w") ? i - 1 : i + 1;

    for (int col in List.from({j - 1, j + 1})) {
      if (validCoords(row, col)) {
        ChessPiece pawn = getPiece(board, row, col);
        if (pawn.colour != colour && pawn.name == "pawn") {
          return true;
        }
      }
    }
    return false;
  }

  bool attackedByKnight(GameBoard board) {
    List<int> components = List.from({1, 2, -2, -1});

    for (int a in components) {
      for (int b in components) {
        if (a.abs() + b.abs() == 3) {
          ChessPiece knight = getPiece(board, i + a, j + b);
          if (knight.colour != colour && knight.name == "knight") {
            return true;
          }
        }
      }
    }

    return false;
  }

  ChessPiece getPiece(GameBoard board, int i, int j) {
    if (validCoords(i, j)) {
      GamePiece piece = board.getPiece(i, j);
      if (piece is ChessPiece) {
        return piece;
      }
    }
    return EmptyPiece(0, 0);
  }
}

class EmptyPiece extends ChessPiece {
  EmptyPiece(int iPosition, int jPosition)
      : super("empty", "empty", NoMovement()) {
    i = iPosition;
    j = jPosition;
  }
}

abstract class MovementStrategy {
  void move(GameBoard board, ChessPiece piece);
}

class NoMovement implements MovementStrategy {
  void move(GameBoard board, ChessPiece piece) {}
}

class PawnMovement implements MovementStrategy {
  void move(GameBoard board, ChessPiece piece) {
    if (piece.colour == "w") {
      return moveNorth(board, piece);
    } else {
      return moveSouth(board, piece);
    }
  }

  void moveSouth(GameBoard board, ChessPiece piece) {
    if (piece.canMove(board, piece.i + 1, piece.j)) {
      if (!piece.hasMoved) {
        piece.canMove(board, piece.i + 2, piece.j);
      }
    }

    piece.canCapture(board, piece.i + 1, piece.j + 1);
    piece.canCapture(board, piece.i + 1, piece.j - 1);
  }

  void moveNorth(GameBoard board, ChessPiece piece) {
    if (piece.canMove(board, piece.i - 1, piece.j)) {
      if (piece.hasMoved == false) {
        piece.canMove(board, piece.i - 2, piece.j);
      }
    }

    piece.canCapture(board, piece.i - 1, piece.j + 1);
    piece.canCapture(board, piece.i - 1, piece.j - 1);
  }
}

class KnightMovement implements MovementStrategy {
  void move(GameBoard board, ChessPiece piece) {
    void options = List.empty(growable: true);

    List<int> components = List.from({1, 2, -2, -1});

    for (int a in components) {
      for (int b in components) {
        if (a.abs() + b.abs() == 3) {
          piece.canMove(board, piece.i + a, piece.j + b);
          piece.canCapture(board, piece.i + a, piece.j + b);
        }
      }
    }

    return options;
  }
}

class BishopMovement implements MovementStrategy {
  void move(GameBoard board, ChessPiece piece) {
    List<int> components = List.from({1, -1});

    for (int a in components) {
      for (int b in components) {
        exploreImpulse(piece, board, a, b);
      }
    }
  }

  void exploreImpulse(ChessPiece piece, GameBoard board, int di, int dj) {
    int i = piece.i;
    int j = piece.j;
    while (true) {
      i += di;
      j += dj;
      if (piece.canCapture(board, i, j) || !piece.canMove(board, i, j)) {
        return;
      }
    }
  }
}

class RookMovement implements MovementStrategy {
  void move(GameBoard board, ChessPiece piece) {
    exploreImpulse(piece, board, 0, 1);
    exploreImpulse(piece, board, 0, -1);
    exploreImpulse(piece, board, 1, 0);
    exploreImpulse(piece, board, -1, 0);
  }

  void exploreImpulse(ChessPiece piece, GameBoard board, int di, int dj) {
    int i = piece.i;
    int j = piece.j;
    while (true) {
      i += di;
      j += dj;
      if (piece.canCapture(board, i, j) || !piece.canMove(board, i, j)) {
        return;
      }
    }
  }
}

class QueenMovement implements MovementStrategy {
  void move(GameBoard board, ChessPiece piece) {
    var pair = List.from({RookMovement(), BishopMovement()});
    for (MovementStrategy strategy in pair) {
      strategy.move(board, piece);
    }
  }
}

class KingMovement implements MovementStrategy {
  void move(GameBoard board, ChessPiece piece) {
    List<int> components = List.from({-1, 0, 1});

    for (int a in components) {
      for (int b in components) {
        piece.canCapture(board, piece.i + a, piece.j + b);
        piece.canMove(board, piece.i + a, piece.j + b);
      }
    }
  }
}
