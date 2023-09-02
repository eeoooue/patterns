

# Observer

The observer pattern gives us a way to inform objects about changes to some subject.

The pattern avoids excessive coupling by leveraging simple interfaces at both sides of the one-to-many relationship.

### Demo: [Gamestate Widgets](https://eeoooue.github.io/patterns/observer/)

High-profile games of Chess are often a spectacle.

Rather than checking on the game at intervals, we could devise a way to notify those interested whenever a move is made.

For this demo, game-state sensitive widgets are updated whenever a move is made on the board.

![Image](/notes/observer/observer-uml.png)


The **Game** implements the **Subject** interface - maintaining a set of **Observer** objects, which are notified whenever a move is made.

It's important to recognise that the **Observers** don't have to be widgets! We could use this same setup to play sound effects when moves are made, or to display a pop-up when the game ends.
