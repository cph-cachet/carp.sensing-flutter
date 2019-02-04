# CARP Context Sampling Package

[![pub package](https://img.shields.io/pub/v/carp_context_package.svg)](https://pub.dartlang.org/packages/carp_context_package)

This library contains a sampling package for communication to work with 
the [`carp_mobile_sensing`](https://pub.dartlang.org/packages/carp_mobile_sensing) package.
This packages supports sampling of the following [`Measure`](https://pub.dartlang.org/documentation/carp_mobile_sensing/latest/core/Measure-class.html) types:

* `location`
* `activity`
* `weather`

See the [wiki]() for further documentation, particularly on available [probes](https://github.com/cph-cachet/carp.sensing-flutter/wiki/Probes)
and [sampling schemas](https://github.com/cph-cachet/carp.sensing-flutter/wiki/Schemas#sampling-schema).


For Flutter plugins for other CARP products, see [CARP Mobile Sensing in Flutter](https://github.com/cph-cachet/carp.sensing-flutter/blob/master/README.md).

If you're interested in writing you own sampling packages for CARP, see the description on
how to [extend](https://github.com/cph-cachet/carp.sensing-flutter/wiki/Extending) CARP on the wiki.

## Installing

To use this package, add the following to you `pubspc.yaml` file. Note that
this package only works together with `carp_mobile_sensing`.

`````dart
dependencies:
  flutter:
    sdk: flutter
  carp_mobile_sensing: ^0.3.0
  carp_context_package: ^0.3.0
  ...
`````

