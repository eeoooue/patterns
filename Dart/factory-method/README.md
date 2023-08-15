
# Factory Method

The factory method pattern delegates object instantiation in a class to an abstract method.

By leveraging an interface, the concrete subclasses can instantiate different objects in the factory method to suit their specific context.


### Demo: [Game Boards](https://eeoooue.github.io/patterns/factory-method/)

Board games often have unique boards which inform the logic of the game.

By creating a **GameBoard** interface, we can create a factory method in the abstract **Game** class, and implement this to instantiate specific boards in the subclasses.

![Image](/Dart/factory-method/factory-method-uml.png)
