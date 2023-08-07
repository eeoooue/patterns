import 'boardgames.dart';
import 'chess.dart';

class MimicPiece extends GamePiece {
  int i;
  int j;
  MovementStrategy moveStrategy;

  MimicPiece(this.i, this.j, this.moveStrategy) {
    setSource("./assets/checkers/checkers_cream.png");
  }

  List<MoveOption> move(ChessBoard board) {
    return moveStrategy.move(board, i, j);
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
    List<MoveOption> options = List.empty(growable: true);

    MoveOption move = MoveOption(i - 1, j);
    if (board.tileIsEmpty(move.i, move.j)) {
      options.add(move);
    }

    return options;
  }
}

class KnightMovement implements MovementStrategy {
  List<MoveOption> move(ChessBoard board, int i, int j) {
    List<MoveOption> options = List.empty(growable: true);

    List<int> components = List.from({1, 2, -2, -1});

    for (int a in components) {
      for (int b in components) {
        if (a.abs() + b.abs() == 3) {
          MoveOption move = MoveOption(i + a, j + b);
          if (board.tileIsEmpty(move.i, move.j)) {
            options.add(move);
          }
        }
      }
    }

    return options;
  }
}

class BishopMovement implements MovementStrategy {
  List<MoveOption> move(ChessBoard board, int i, int j) {
    List<MoveOption> options = List.empty(growable: true);

    List<int> components = List.from({1, -1});

    for (int a in components) {
      for (int b in components) {
        for (MoveOption move in exploreDiagonal(board, i, j, a, b)) {
          options.add(move);
        }
      }
    }

    // for (MoveOption move in exploreDiagonal(board, i, j, 1, 1)) {
    //   options.add(move);
    // }

    // for (MoveOption move in exploreDiagonal(board, i, j, 1, -1)) {
    //   options.add(move);
    // }

    // for (MoveOption move in exploreDiagonal(board, i, j, -1, -1)) {
    //   options.add(move);
    // }

    // for (MoveOption move in exploreDiagonal(board, i, j, -1, 1)) {
    //   options.add(move);
    // }

    return options;
  }

  List<MoveOption> exploreDiagonal(
      ChessBoard board, int i, int j, int di, int dj) {
    List<MoveOption> options = List.empty(growable: true);

    while (true) {
      i += di;
      j += dj;
      MoveOption move = MoveOption(i, j);

      if (board.tileIsEmpty(i, j)) {
        options.add(move);
      } else {
        return options;
      }
    }
  }
}
