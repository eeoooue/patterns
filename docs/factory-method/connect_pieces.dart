import 'game.dart';

class ConnectPiece extends GamePiece {
  bool empty = false;

  ConnectPiece(String colour) {
    setSource("./assets/connect/connect_${colour}.png");
  }
}

class EmptyConnectPiece extends ConnectPiece {
  EmptyConnectPiece(int iInput, int jInput) : super("none") {
    empty = true;
    i = iInput;
    j = jInput;
  }
}
