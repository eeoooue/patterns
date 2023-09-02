
# Decorator

The decorator pattern uses composition to extend the functionality of an object. 

We create some **Decorator**  that extends a class, while also having a reference to an instance of that class (composition) - 'wrapping' it as a decoration.

The existing behaviour of the wrapped object is maintained by creating methods of the same name that call the method of the wrapped object. This gives opportunity to add new behaviour/responsibilities to these methods. 

This pattern offers high customization without creating huge classes or deep inheritance trees.

### Demo: [Board Setup](https://eeoooue.github.io/patterns/decorator/)

We'll use the Decorator pattern to enable customization of the initial boardstate of a Chess game.

![Image](/Dart/decorator/decorator-uml.png)

_**ChessBoardDecorator**_ wraps an instance of **ChessBoard** while also extending the class and making ```setupPieces()``` abstract.

Our **ConcreteDecorators** implement ```setupPieces()```, calling the base method (of the wrapped instance) and then placing their own pieces.

Toggling these 6 **ConcreteDecorators** as decorations, we can achieve 64 different initial states of the board (empty board, board with only pawns & kings etc.)
