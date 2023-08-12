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
    GamePiece target = board.getPiece(i, j);
    ReversiPiece piece = newPiece();

    if (target is EmptyReversiPiece) {
      board.placePiece(piece, i, j);
      game.endTurn();
    }
  }

  ReversiPiece newPiece() {
    return ReversiPiece(game.getTurnPlayer());
  }
}
