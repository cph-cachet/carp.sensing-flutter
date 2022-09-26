# CARP Serialization

A package for polymorphic serialization to/from JSON build on top of [json_serializable](https://pub.dev/packages/json_serializable).

This package allows for implementing serialization and deserialization to/from JSON.
This is done using the [json_serializable](https://pub.dev/packages/json_serializable) package, so please study how the json_serializable package works, before using this package.

The key feature of this package is that it extends json_serializable with support for serialization of **polymorphic** classes, i.e. classes that inherits from each other. This is done by adding type information to the json.

## Getting started

To use this package, add [`carp_serializable`](https://pub.dev/packages/carp_serializable) and [`json_annotation`](https://pub.dev/packages/json_annotation) as [dependencies in your `pubspec.yaml` file](https://flutter.io/platform-plugins/). Also add [`build_runner`](https://pub.dev/packages/build_runner) and [`json_serializable`](https://pub.dev/packages/json_serializable) to the `dev_dependencies`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  json_annotation: ^latest
  carp_serializable: ^latest

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: any   # For building json serialization
  json_serializable: any
```

## Usage

To support polymorphic serialization, each class should:

* extend from `Serializable`
* annotate the class with `@JsonSerializable`
* add the three json methods
  * `Function get fromJsonFunction => ...`
  * `factory ...fromJson(...)`
  * `Map<String, dynamic> toJson() => ...`
* register the classes in the `FromJsonFactory()` registry.
* build json function using the `flutter pub run build_runner build --delete-conflicting-outputs` command

Below is a simple example of two classes `A` and `B` where B extends A.

```dart
@JsonSerializable()
class A extends Serializable {
  int index;

  A() : super();

  Function get fromJsonFunction => _$AFromJson;
  factory A.fromJson(Map<String, dynamic> json) => FromJsonFactory().fromJson(json) as A;
  Map<String, dynamic> toJson() => _$AToJson(this);
}

@JsonSerializable()
class B extends A {
  String str;

  B() : super();

  Function get fromJsonFunction => _$BFromJson;
  factory B.fromJson(Map<String, dynamic> json) => FromJsonFactory().fromJson(json) as B;
  Map<String, dynamic> toJson() => _$BToJson(this);
}
```

Note that the naming of the `fromJson()` and `toJson()` functions follows the [json_serializable](https://pub.dev/packages/json_serializable) package. For example the `fromJson` function for class `A` is called `_$AFromJson`.

The `fromJsonFunction` must be registered on app startup (before use of de-serialization) in the `FromJsonFactory` singleton, like this:

```dart
 FromJsonFactory().register(A());
```

For this purpose it is helpful to have an empty constructor, but any constructur will work, since only the `fromJsonFunction` function is used.

Polymorphic serialization is handled by setting the `$type` property in the `Serializable` class. Per default, an object's `runtimeType` is used as the
 `$type` for an object. Hence, the json of object of type `A` and `B` would
 look like this:

 ```json
  {
   "$type": "A",
   "index": 1
  }
  {
   "$type": "B",
   "index": 2
   "str": "abc"
  }
 ```

However, if you want to specify your own class type (e.g., if you get json serialized from another language which uses a package structure like Java, C# or Kotlin), you can specify the json type in the `jsonType` property of the class.

For example, if the class `B` above should use a different `$type` annotation, using the following:

```dart
 @JsonSerializable()
 class B extends A {

   <<as above>>

   String get jsonType => 'dk.cachet.$runtimeType';
 }
 ````

 In which case the json would look like:

 ```json
  {
   "$type": "dk.cachet.B",
   "index": 2
   "str": "abc"
  }
```

Once the serialization code is used as above, run the

```shell
flutter pub run build_runner build --delete-conflicting-outputs
```

command as usual to generate the `toJson()` and `fromJson()` methods.

## Features and bugs

Please read about existing issues and file new feature requests and bug reports at the [issue tracker][tracker].

[tracker]: https://github.com/cph-cachet/carp.sensing-flutter/issues

## License

This software is copyright (c) [Copenhagen Center for Health Technology (CACHET)](https://www.cachet.dk/) at the [Technical University of Denmark (DTU)](https://www.dtu.dk).
This software is available 'as-is' under a [MIT license](https://github.com/cph-cachet/carp.sensing-flutter/blob/master/LICENSE).
