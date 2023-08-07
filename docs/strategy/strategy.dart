import 'boardgames.dart';
import 'chess.dart';

class MimicPiece extends GamePiece {
  int i;
  int j;
  MovementStrategy moveStrategy;

  MimicPiece(this.i, this.j, this.moveStrategy) {
    setSource("./assets/checkers/checkers_cream.png");
  }
}

class MoveOption {
  int i;
  int j;

  MoveOption(this.i, this.j) {}
}

abstract class MovementStrategy {
  List<MoveOption> move(ChessBoard board, int i, int j);
}

class PawnMovement implements MovementStrategy {
  List<MoveOption> move(ChessBoard board, int i, int j) {
    List<MoveOption> options = List.empty();

    MoveOption move = MoveOption(i - 1, j);
    if (board.tileIsEmpty(move.i, move.j)) {
      options.add(move);
    }

    return options;
  }
}
