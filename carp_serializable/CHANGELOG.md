## 2.0.0

* type safe annotation in class factor method, like this; `FromJsonFactory().fromJson<A>(json)`
* graceful handling of errors when a non-known JSON type is encountered by allowing for a "notAvailable" parameter to the fromJson factory method, like this; `FromJsonFactory().fromJson<B>(json, notAvailable: B(-1))`
* refactor of universal unique IDs (UUIDs) to using the `Uuid().v1` construct
* extending unit test coverage (incl., e.g. exceptions)
* improvement to examples in the `example.dart` file and documentation in the API doc and README

## 1.2.0

* added support for generating universal unique IDs (UUIDs) via the `UUID.v1` construct

## 1.1.1

* Dart type annotation in json is changed from `$type` to `__type` since there were conflict in the Javascript world. This also follows the [CARP Core](https://github.com/cph-cachet/carp.core-kotlin) serialization approach.
* fix of linter errors

## 1.0.0

* Initial release extracted from [carp_core](https://pub.dev/packages/carp_core) version 0.40.0
