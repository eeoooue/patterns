

# Strategy

We can use the strategy pattern to 'inject' an object with a behaviour.

This can be useful for:

- Changing an object's behaviour at runtime (swapping a strategy)
- Reusing code without introducing new inheritance relationships


### Demo: [Chess Movement](https://eeoooue.github.io/patterns/strategy/)

In Chess, the pieces have different ways of moving around on the board.

To introduce the strategy pattern, we could can encapsulate these rules in objects that implement a common interface.

We don't need the strategy pattern to implement traditional Chess, but in the demo I'm using it to allow us to change how a piece can move at runtime.

![Image](/Dart/strategy/strategy-uml.png)

The **MimicPiece** object has a **MoveStrategy** - which it leverages for its ```move()``` behaviour.

