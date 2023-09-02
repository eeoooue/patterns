
# Abstract Factory

The Abstract Factory pattern introduces an abstraction for creating a family of objects. 

This pattern differs from the Factory Method in that it has _many methods_ for creating objects. These objects must fall under some abstraction/interface, used as the return type.

By programming to these abstractions, we can change between the category of objects we are instantiating at runtime.

This pattern can be useful if different execution pathways at runtime can necessitate a categorically different set of objects (e.g. when serving multiple platforms or for accessibility)


### Demo: [Creating Chesspieces](https://eeoooue.github.io/patterns/abstract-factory/)

While different board games have different pieces, it wouldn't make sense to use the Abstract Factory to rotate between pieces for each game.

While Draughts pieces and Chess pieces are game pieces, the sets of pieces themselves don't have much in common.

![Image](/notes/abstract-factory/abstract-factory-uml.png)

This example is over-engineered but hopefully illustrates what might constitute a family of objects and how we can swap between factories at runtime.