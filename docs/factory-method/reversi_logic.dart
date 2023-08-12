import 'reversi_game.dart';
import 'reversi_board.dart';
import 'game.dart';
import 'reversi_pieces.dart';

class ReversiLogic {
  ReversiGame game;
  ReversiBoard board;
  bool gameOver = false;

  ReversiLogic(this.game, this.board) {}

  void attemptMove(int i, int j) {
    print("attempted move at ${i} ${j} (turncount = ${game.turnCount})");
    ReversiPiece piece = newPiece();

    if (noPossibleMoves()) {
      game.endTurn();
    }

    if (canMoveHere(i, j)) {
      board.placePiece(piece, i, j);
      game.endTurn();
    }
  }

  bool noPossibleMoves() {
    return false;
  }

  bool canMoveHere(int i, int j) {
    GamePiece target = board.getPiece(i, j);

    if (target is EmptyReversiPiece) {
      List<ReversiPiece> enemies = findAdjacentEnemies(i, j);

      for (ReversiPiece enemy in enemies) {
        int a = enemy.i - i;
        int b = enemy.j - j;
        if (allyAlongImpulse(enemy.i, enemy.j, a, b)) {
          return true;
        }
      }
    }

    return false;
  }

  bool allyAlongImpulse(int i, int j, int di, int dj) {
    if (validCoords(i, j)) {
      GamePiece target = board.getPiece(i, j);
      if (target is EmptyReversiPiece) {
        return false;
      }
      if (target is ReversiPiece) {
        if (target.colour == game.getTurnPlayer()) {
          return true;
        }
        return allyAlongImpulse(i + di, j + dj, di, dj);
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
