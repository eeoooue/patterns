

# Template Method

We might use the Template Method pattern to outline the skeleton of an algorithm as a series of method calls.

The template method itself should be in an abstract class and consist of method calls within the class, some of which may be overridden/implemented by children of the class to give child-specific behaviour.


### Demo: [Starting a Game](https://eeoooue.github.io/patterns/template-method/)

Whenever we play a board game, we might find ourselves making these steps:

1. Clear the play area
2. Put down the game board
3. Place the pieces in their starting setup

In programming, we might want to reuse the same code for clearing the play area but creating the game board & setting up the pieces will be specific to the board game.

![Image](/notes/template-method/template-method-uml.png)

We can create a Template Method ```startGame()``` in our abstract class **Game**, which consists of calls to other methods.

We'll make the methods ```createBoard()``` & ```setupPieces()``` abstract, to be implemented by the specific child classes.

