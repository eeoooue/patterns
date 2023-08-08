abstract class Subject {
  void subscribe(Observer observer);
  void unsubscribe(Observer observer);
  void notify();
}

abstract class Observer {
  void update(Subject subject);
}
