import 'dart:html';
import 'dart:collection';
import 'game.dart';

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

  void move(GameBoard board) {
    moveStrategy.move(board, this);
  }

  bool canCapture(GameBoard board, int i, int j) {
    if (validCoords(i, j)) {
      GamePiece target = board.getPiece(i, j);

      if (target is ChessPiece) {
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

class ChessGame {
  int turnCount = 0;
  late GameBoard board = ChequeredBoard();
  ChessPiece activePiece = EmptyPiece(0, 0);
  late GameView view;
  Element container;
  bool rotated = false;

  ChessGame(this.container) {
    view = ChessBoardView(this, container);
  }

  void startGame() {
    List<bool> initState = List.empty(growable: true);
    initState.add(true);
    initState.add(true);
    initState.add(true);
    initState.add(true);
    initState.add(true);
    initState.add(true);

    setupPieces(initState);
    refreshView();
  }

  String getTurnPlayer() {
    return (turnCount % 2 == 0) ? "w" : "b";
  }

  void submitMove(int i, int j) {
    if (validMove(activePiece, i, j)) {
      movePiece(activePiece, i, j);
      endTurn();
      return;
    }
    clearMoveOptions();
    activePiece = EmptyPiece(0, 0);

    GamePiece piece = board.getPiece(i, j);

    if (piece is ChessPiece) {
      if (piece.colour == getTurnPlayer()) {
        piece.move(board);
        activePiece = piece;
      }
    }

    refreshView();
  }

  void refreshView() {
    view.displayBoard(board.getBoardState());
    if (rotated) {
      view.rotateBoard();
    }
  }

  void clearMoveOptions() {
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        GamePiece piece = board.getPiece(i, j);
        if (piece is ChessPiece) {
          piece.threatened = false;
        }
      }
    }
  }

  void endTurn() {
    turnCount += 1;
    activePiece = EmptyPiece(0, 0);
    clearMoveOptions();
    refreshView();
  }

  bool validMove(ChessPiece piece, int i, int j) {
    GamePiece target = board.getPiece(i, j);
    if (target is ChessPiece) {
      return target.threatened;
    }
    return false;
  }

  void movePiece(ChessPiece piece, int i, int j) {
    board.removePiece(piece.i, piece.j);
    board.removePiece(i, j);
    board.placePiece(piece, i, j);
    piece.hasMoved = true;
  }

  void setupPieces(List<bool> state) {
    board = ChequeredBoard();
    if (state[0]) {
      board = BoardWithPawns(board);
    }
    if (state[1]) {
      board = BoardWithBishops(board);
    }
    if (state[2]) {
      board = BoardWithKnights(board);
    }
    if (state[3]) {
      board = BoardWithRooks(board);
    }
    if (state[4]) {
      board = BoardWithQueens(board);
    }
    if (state[5]) {
      board = BoardWithKings(board);
    }

    board.setupPieces();
    refreshView();
  }
}

class ChessBoardView implements GameView {
  Element container;
  ChessGame game;

  ChessBoardView(this.game, this.container) {}

  void rotateBoard() {
    Queue<Element> stack = Queue();
    for (Element row in container.querySelectorAll(".board-row")) {
      stack.add(row);
    }

    container.children.clear();

    while (stack.length > 0) {
      Element row = stack.removeLast();
      mirrorRow(row);
      container.children.add(row);
    }
  }

  void mirrorRow(Element row) {
    Queue<Element> stack = Queue();
    for (Element tile in row.querySelectorAll(".chess-tile")) {
      stack.add(tile);
    }

    row.children.clear();

    while (stack.length > 0) {
      Element tile = stack.removeLast();
      row.children.add(tile);
    }
  }

  void displayBoard(List<List<GamePiece>> boardstate) {
    container.children.clear();
    for (List<GamePiece> rowOfPieces in boardstate) {
      Element row = createRowContainer();
      for (GamePiece piece in rowOfPieces) {
        Element tile = buildTile(piece);
        row.children.add(tile);
      }
      container.children.add(row);
    }
  }

  Element createRowContainer() {
    Element row = document.createElement("div");
    row.classes.add("board-row");
    return row;
  }

  Element buildTile(GamePiece piece) {
    Element tile = createTile(piece);

    if (!(piece is EmptyPiece)) {
      Element img = piece.getElement();
      tile.children.add(img);
    }

    if (piece is ChessPiece) {
      if (piece.threatened) {
        Element marker = createMarker(piece);
        tile.children.add(marker);
      }
    }

    return tile;
  }

  Element createTile(GamePiece piece) {
    Element tile = document.createElement("div");
    tile.classes.add("chess-tile");

    if (piece is ChessPiece) {
      if ((piece.i + piece.j) % 2 != 0) {
        tile.classes.add("dark");
      }

      tile.addEventListener("click", (event) {
        game.submitMove(piece.i, piece.j);
      });
    }

    return tile;
  }

  Element createMarker(ChessPiece piece) {
    Element element = document.createElement("div");
    element.classes.add("marker");
    String subtype = (piece is EmptyPiece) ? "dot" : "circle";
    element.classes.add(subtype);
    return element;
  }
}

class ChequeredBoard implements GameBoard {
  List<List<GamePiece>> pieces = List.empty(growable: true);

  ChequeredBoard() {}

  void setupPieces() {
    for (int i = 0; i < 8; i++) {
      List<ChessPiece> row = List.empty(growable: true);
      for (int j = 0; j < 8; j++) {
        row.add(EmptyPiece(i, j));
      }
      pieces.add(row);
    }
  }

  List<List<GamePiece>> getBoardState() {
    return pieces;
  }

  void placePiece(GamePiece piece, int i, int j) {
    pieces[i][j] = piece;
    if (piece is ChessPiece) {
      piece.i = i;
      piece.j = j;
    }
  }

  void removePiece(int i, int j) {
    pieces[i][j] = EmptyPiece(i, j);
  }

  GamePiece getPiece(int i, int j) {
    return pieces[i][j];
  }

  bool validCoordinates(int i, int j) {
    return (0 <= i && i < 8) && (0 <= j && j < 8);
  }
}

abstract class BoardWithPieces implements GameBoard {
  GameBoard base;

  BoardWithPieces(this.base) {}

  void setupPieces();

  void removePiece(int i, int j) {
    base.removePiece(i, j);
  }

  void placePiece(GamePiece piece, int i, int j) {
    base.placePiece(piece, i, j);
  }

  GamePiece getPiece(int i, int j) {
    return base.getPiece(i, j);
  }

  List<List<GamePiece>> getBoardState() {
    return base.getBoardState();
  }
}

class BoardWithPawns extends BoardWithPieces {
  BoardWithPawns(GameBoard base) : super(base) {}

  void setupPieces() {
    base.setupPieces();
    for (int j = 0; j < 8; j++) {
      placePawn("b", 1, j);
      placePawn("w", 6, j);
    }
  }

  void placePawn(String colour, int i, int j) {
    ChessPiece pawn = ChessPiece(colour, "pawn", PawnMovement());
    base.placePiece(pawn, i, j);
  }
}

class BoardWithBishops extends BoardWithPieces {
  BoardWithBishops(GameBoard base) : super(base) {}

  void setupPieces() {
    base.setupPieces();
    placeBishop("b", 0, 2);
    placeBishop("b", 0, 5);
    placeBishop("w", 7, 2);
    placeBishop("w", 7, 5);
  }

  void placeBishop(String colour, int i, int j) {
    ChessPiece bishop = ChessPiece(colour, "bishop", BishopMovement());
    base.placePiece(bishop, i, j);
  }
}

class BoardWithKnights extends BoardWithPieces {
  BoardWithKnights(GameBoard base) : super(base) {}

  void setupPieces() {
    base.setupPieces();
    placeKnight("b", 0, 1);
    placeKnight("b", 0, 6);
    placeKnight("w", 7, 1);
    placeKnight("w", 7, 6);
  }

  void placeKnight(String colour, int i, int j) {
    ChessPiece knight = ChessPiece(colour, "knight", KnightMovement());
    base.placePiece(knight, i, j);
  }
}

class BoardWithRooks extends BoardWithPieces {
  BoardWithRooks(GameBoard base) : super(base) {}

  void setupPieces() {
    base.setupPieces();
    placeRook("b", 0, 0);
    placeRook("b", 0, 7);
    placeRook("w", 7, 0);
    placeRook("w", 7, 7);
  }

  void placeRook(String colour, int i, int j) {
    ChessPiece rook = ChessPiece(colour, "rook", RookMovement());
    base.placePiece(rook, i, j);
  }
}

class BoardWithKings extends BoardWithPieces {
  BoardWithKings(GameBoard base) : super(base) {}

  void setupPieces() {
    base.setupPieces();
    placeKing("b", 0, 4);
    placeKing("w", 7, 4);
  }

  void placeKing(String colour, int i, int j) {
    ChessPiece king = ChessPiece(colour, "king", KingMovement());
    base.placePiece(king, i, j);
  }
}

class BoardWithQueens extends BoardWithPieces {
  BoardWithQueens(GameBoard base) : super(base) {}

  void setupPieces() {
    base.setupPieces();
    placeQueen("b", 0, 3);
    placeQueen("w", 7, 3);
  }

  void placeQueen(String colour, int i, int j) {
    ChessPiece queen = ChessPiece(colour, "queen", QueenMovement());
    base.placePiece(queen, i, j);
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
