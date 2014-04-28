### Injector ###

This is a simple, easy and flexible dependency injection library, based on Dart. I use it for my projects. 
Inspired by [swiftsuspenders](https://github.com/robotlegs/swiftsuspenders).


### Usage ###

```dart

  var injector = new Injector();
  
  // mappings
  
  // create a basic mapping, will instantiate a new Cat for each request.
  injector.map(Cat);
  // map to a value, as singleton
  injector.map(Cat).toValue(cat);
  // map to a value with name
  injector.map(Cat, "cat").toValue(cat2);
  // map as singleton
  injector.map(Dog).asSingleton();
  // map as singleton to another class
  injector.map(Cat, "cat2").toSingleton(Dog);
  
  // get
  var c = injector.get(Cat);
  var c2 = injector.get(Cat, "cat");
  
  //injection using metadata
  class InjectTarget {
    @Inject("cat")
    Cat cat;
    @inject
    Dog dog;
  }
  var t = new InjectTarget();
  injector.inject(t);
  
  

```

### About Me ###

* [Blog](http://valorzhong.blogspot.com/)

