import 'package:unittest/unittest.dart';
import '../lib/injector.dart';

class Cat {
  String name;
}

class Dog {
  String name;
}

class InjectTarget {
  @Inject("cat")
  Cat cat;
  @Inject()
  Dog dog;
}

_mapValue() {
  var cat = new Cat();
  var injector = new Injector();
  injector.map(Cat).toValue(cat);

  var cat2 = injector.get(Cat);
  expect(cat, cat2);
  expect(cat, isNot(equals(new Cat())));
}

_mapType() {
  var injector = new Injector();
  injector.map(Cat);

  expect(injector.get(Cat), isNot(equals(injector.get(Cat))));
}

_mapSingleton() {
  var injector = new Injector();
  injector.map(Cat).asSingleton();
  expect(injector.get(Cat), equals(injector.get(Cat)));
}

_mapSingletonToValue() {
  var injector = new Injector();
  injector.map(Cat).toSingleton(Dog);

  expect(injector.get(Cat), equals(injector.get(Cat)));
  if (!(injector.get(Cat) is Dog)) {
    fail("should be dog");
  }
}

_mapInject() {
  var injector = new Injector();
  var cat = new Cat();
  cat.name = "cat1";
  var cat2 = new Cat();
  cat2.name = "cat2";
  injector.map(Cat).toValue(cat);
  injector.map(Cat, "cat").toValue(cat2);
  var u3 = new Dog();
  injector.map(Dog).toValue(u3);

  var t = new InjectTarget();
  injector.inject(t);

  expect(t.cat, cat2);
  expect(t.cat, isNot(equals(cat)));
  expect(t.dog, u3);
  expect(t.dog, isNot(equals(new Dog())));
}

_mapGetbyname() {
  var injector = new Injector();
  injector.map(Cat, "cat").asSingleton();
  injector.map(Cat, "cat2").toSingleton(Dog);
  if (!(injector.get(Cat, "cat") is Cat)) {
    fail("should be cat");
  }
  if (!(injector.get(Cat, "cat2") is Dog)) {
    fail("should be cat2");
  }
  if (!(injector.get(Cat) == null)) {
    fail("should be null");
  }
}

void main() {
  test("map value", _mapValue);
  test("map type", _mapType);
  test("map singleton", _mapSingleton);
  test("map singleton to value", _mapSingletonToValue);
  test("get by name", _mapGetbyname);
  test("inject", _mapInject);
}










