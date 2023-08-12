import 'reversi_game.dart';
import 'reversi_board.dart';
import 'game.dart';
import 'reversi_pieces.dart';

class ReversiMove {
  int i;
  int j;
  ReversiMove(this.i, this.j) {}
}

class ReversiLogic {
  ReversiGame game;
  ReversiBoard board;
  bool gameOver = false;
  int possibleMoves = 0;
  List<ReversiPiece> flipping = List.empty(growable: true);

  ReversiLogic(this.game, this.board) {}

  void attemptMove(int i, int j) {
    print("attempted move at ${i} ${j} (turncount = ${game.turnCount})");
    ReversiPiece piece = newPiece();

    if (possibleMoves == 0) {
      game.endTurn();
    }

    GamePiece target = board.getPiece(i, j);

    if (target is EmptyReversiPiece && target.possibleMove) {
      board.placePiece(piece, i, j);

      flipPieces(i, j);

      game.endTurn();
    }
  }

  void flipPieces(int i, int j) {
    List<ReversiPiece> enemies = findAdjacentEnemies(i, j);

    for (ReversiPiece enemy in enemies) {
      int a = enemy.i - i;
      int b = enemy.j - j;
      allyAlongImpulse(enemy.i, enemy.j, a, b);
      for (ReversiPiece piece in flipping) {
        flipPiece(piece);
      }
    }
  }

  void flipPiece(ReversiPiece piece) {
    board.placePiece(newPiece(), piece.i, piece.j);
  }

  void refreshMoveOptions() {
    possibleMoves = 0;

    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        GamePiece piece = board.getPiece(i, j);
        if (piece is EmptyReversiPiece) {
          piece.possibleMove = false;
          if (isLegalMove(piece)) {
            possibleMoves += 1;
            piece.possibleMove = true;
          }
        }
      }
    }
  }

  bool noPossibleMoves() {
    return false;
  }

  bool isLegalMove(EmptyReversiPiece space) {
    List<ReversiPiece> enemies = findAdjacentEnemies(space.i, space.j);

    for (ReversiPiece enemy in enemies) {
      int a = enemy.i - space.i;
      int b = enemy.j - space.j;
      if (allyAlongImpulse(enemy.i, enemy.j, a, b)) {
        return true;
      }
    }

    return false;
  }

  bool allyAlongImpulse(int i, int j, int di, int dj) {
    flipping.clear();

    if (exploreImpulse(i, j, di, dj)) {
      return true;
    }

    flipping.clear();
    return false;
  }

  bool exploreImpulse(int i, int j, int di, int dj) {
    if (validCoords(i, j)) {
      GamePiece target = board.getPiece(i, j);
      if (target is EmptyReversiPiece) {
        return false;
      }
      if (target is ReversiPiece) {
        if (target.colour == game.getTurnPlayer()) {
          return true;
        }
        flipping.add(target);
        return exploreImpulse(i + di, j + dj, di, dj);
      }
    }

    return false;
  }

  bool validCoords(int i, int j) {
    return (0 <= i && i < 8) && (0 <= j && j < 8);
  }

  List<ReversiPiece> findAdjacentEnemies(int i, int j) {
    String enemy = (game.turnCount % 2 == 0) ? "black" : "white";
    List<ReversiPiece> enemyPieces = List.empty(growable: true);

    for (int a = -1; a <= 1; a++) {
      for (int b = -1; b <= 1; b++) {
        if (validCoords(i + a, j + b)) {
          GamePiece piece = board.getPiece(i + a, j + b);
          if (piece is ReversiPiece && piece.colour == enemy) {
            enemyPieces.add(piece);
          }
        }
      }
    }

    return enemyPieces;
  }

  ReversiPiece newPiece() {
    return ReversiPiece(game.getTurnPlayer());
  }
}
