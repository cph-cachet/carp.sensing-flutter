# CARP Mobile Sensing in Flutter

This repo hold the source code for the [CACHET](http://www.cachet.dk/) Research Platform (CARP) Mobile Sensing Flutter software.
It contains the source code for CACHET first-party (i.e., developed by the core CACHET team) frameworks, packages, and apps.

In addition, the CARP team maintain a set of [Flutter plugins](https://github.com/cph-cachet/flutter-plugins) (mainly) for sensing purposes. Flutter plugins enable access to platform-specific APIs. For more information
about plugins, and how to use them, see
[https://flutter.io/platform-plugins/](https://flutter.io/platform-plugins/).

These plugins are also available on [pub](https://pub.dartlang.org/flutter/plugins).

## Software Components
These are the available CARP Mobile Sensing Flutter components in this repository.

| Component | Description | Pub | 
|-----------|-------------|-----|
| [carp_core](./carp_core) | The core CARP domain model | [![pub package](https://img.shields.io/pub/v/carp_core.svg)](https://pub.dartlang.org/packages/carp_core) |
| [carp_mobile_sensing](./carp_mobile_sensing) | The main CARP Mobile Sensing Framework | [![pub package](https://img.shields.io/pub/v/carp_mobile_sensing.svg)](https://pub.dartlang.org/packages/carp_mobile_sensing) |
| [carp_webservices](./carp_webservices) | Flutter API for CARP web services | [![pub package](https://img.shields.io/pub/v/carp_webservices.svg)](https://pub.dartlang.org/packages/carp_webservices) |
| [carp_backend](./carp_backend) | Support for uploading data to a CARP data backend as JSON. | [![pub package](https://img.shields.io/pub/v/carp_backend.svg)](https://pub.dartlang.org/packages/carp_backend) |
| [carp_firebase_backend](./carp_firebase_backend) | Support for uploading data to a Firebase Storage data endpoint as zipped JSON files| [![pub package](https://img.shields.io/pub/v/carp_firebase_backend.svg)](https://pub.dartlang.org/packages/carp_firebase_backend) |
| [carp_mobile_sensing_app](./carp_mobile_sensing_app) | The CARP Mobile Sensing app | N/A |

## Issues

Please check existing issues and file any new issues, bugs, or feature requests in the [carp.sensing-flutter repo](https://github.com/cph-cachet/carp.sensing-flutter/issues).

## Contributing

Contributing is not entirely in place yet. However, if you wish to contribute a change to any of the existing components in this repo,
please review our [contribution guide](https://github.com/cph-cachet/carp.sensing/CONTRIBUTING.md),
and send a [pull request](https://github.com/cph-cachet/carp.sensing-flutter/pulls).


