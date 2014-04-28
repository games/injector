library valorzhong.injector;


@MirrorsUsed(targets: 'valorzhong.injector')
import 'dart:mirrors' show MirrorsUsed, ClassMirror, InstanceMirror, VariableMirror, reflect, reflectClass;




class Injector {

  Map<String, InjectionMapping> _mappings;

  Injector(): _mappings = {};

  InjectionMapping map(Type type, [String name = ""]) {
    var mappingId = '${type.toString()}|$name';
    var mapping = _mappings[mappingId];
    if (mapping == null) {
      mapping = new InjectionMapping(type, name);
      _mappings[mappingId] = mapping;
    }
    return mapping;
  }

  void unmap(Type type, [String name = ""]) => _mappings.remove('${type.toString()}|$name').destroy();

  get(Type type, [String name = ""]) {
    var mapping = _mappings['${type.toString()}|$name'];
    if (mapping == null) {
      return null;
    }
    return mapping.value;
  }

  inject(target) {
    InstanceMirror m = reflect(target);
    ClassMirror c = m.type;
    c.declarations.forEach((Symbol k, v) {
      if (v is VariableMirror) {
        v.metadata.forEach((InstanceMirror meta) {
          if (meta.reflectee is Inject) {
            m.setField(k, get(v.type.reflectedType, meta.reflectee.name));
          }
        });
      }
    });
  }
}

class Inject {
  final String name;
  const Inject([this.name = ""]);
}

class InjectionMapping {
  Type type;
  String name;
  DependencyProvider provider;

  InjectionMapping(this.type, this.name) {
    toType(type);
  }

  toValue(value) => provider = new ValueProvider(value);
  toType(Type t) => provider = new ClassProvider(t);
  toSingleton(Type type) => provider = new SingletonProvider(type);
  asSingleton() => toSingleton(type);
  destroy() => provider.destroy();

  get value => provider.get();
}

abstract class DependencyProvider {
  get();
  destroy();
}

class ValueProvider implements DependencyProvider {
  dynamic value;
  ValueProvider(this.value);
  @override
  destroy() => value = null;
  @override
  get() => value;
}

class ClassProvider implements DependencyProvider {
  ClassMirror _mirror;
  ClassProvider(Type type): _mirror = reflectClass(type);

  @override
  destroy() => _mirror = null;

  @override
  get() => _mirror.newInstance(unnamedConstructor, []).reflectee;
}

class SingletonProvider implements DependencyProvider {
  dynamic _instance;
  ClassMirror _mirror;
  SingletonProvider(Type type): _mirror = reflectClass(type);

  @override
  destroy() {
    _instance = null;
  }

  @override
  get() {
    if (_instance == null) {
      _instance = _mirror.newInstance(unnamedConstructor, []).reflectee;
    }
    return _instance;
  }
}

const unnamedConstructor = const Symbol('');
const Inject inject = const Inject();