### Injector ###

This is a simple, easy and flexible dependency injection library, based on Dart. I use it for my projects. 
Inspired by [swiftsuspenders](https://github.com/robotlegs/swiftsuspenders).


### Usage ###

```dart

  var injector = new Injector();
  
  // map
  injector.map(Cat).toValue(cat);
  injector.map(Cat, "cat").toValue(cat2);
  injector.map(Dog).asSingleton();
  injector.map(Cat, "cat2").toSingleton(Dog);
  
  // get
  var c = injector.get(Cat);
  var c2 = injector.get(Cat, "cat");
  
  //inject
  class InjectTarget {
    @Inject("cat")
    Cat cat;
    @Inject()
    Dog dog;
  }
  
  var t = new InjectTarget();
  injector.inject(t);
  
  

```

### About Me ###

* [Blog](http://valorzhong.blogspot.com/)

