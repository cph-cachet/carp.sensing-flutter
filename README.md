![CARP-Mobile-Sensing-Vertical](https://user-images.githubusercontent.com/1196642/98542469-43eadd80-2291-11eb-9013-87542d0b23e6.png)

This repo hold the source code for the [CACHET Research Platform (CARP)](https://carp.cachet.dk) Mobile Sensing (CAMS) Flutter software.
It contains the source code for CACHET first-party (i.e., developed by the core CACHET team) CAMS framework, its packages, and example apps.

In addition, the CARP team maintain a set of [Flutter plugins](https://github.com/cph-cachet/flutter-plugins) (mainly) for sensing purposes. Flutter plugins enable access to platform-specific APIs. For more information
about plugins, and how to use them, see the
[Flutter Packages](https://flutter.io/platform-plugins/) description.

All the CARP Flutter components including the these plugins are also available on [pub.dev](https://pub.dev/publishers/cachet.dk/packages).

## Software Components
These are the available CARP Mobile Sensing Flutter components in this repository.

| Component | Description | [pub.dev](https://pub.dev/packages?q=publisher%3Acachet.dk+) |
|-----------|-------------|:-----------------:|
| **Core** | **Basic components** | <img width=250/> |
| [carp_serializable](./carp_serializable) | A package for polymorphic serialization to/from JSON build on top of [json_serializable](https://pub.dev/packages/json_serializable) | [![pub package](https://img.shields.io/pub/v/carp_serializable.svg)](https://pub.dartlang.org/packages/carp_serializable) |
| [carp_core](./carp_core) | The CARP core domain model | [![pub package](https://img.shields.io/pub/v/carp_core.svg)](https://pub.dartlang.org/packages/carp_core) |
| [carp_mobile_sensing](./carp_mobile_sensing) | The main CARP Mobile Sensing Framework | [![pub package](https://img.shields.io/pub/v/carp_mobile_sensing.svg)](https://pub.dartlang.org/packages/carp_mobile_sensing) |
| **Packages** | **Data sampling packages** |  |
| [carp_apps_package](./packages/carp_apps_package) | App sampling package (installed apps, app usage) | [![pub package](https://img.shields.io/pub/v/carp_apps_package.svg)](https://pub.dartlang.org/packages/carp_apps_package) |
| [carp_connectivity_package](./packages/carp_connectivity_package) | Connectivity sampling package (bluetooth, wifi, connectivity) | [![pub package](https://img.shields.io/pub/v/carp_connectivity_package.svg)](https://pub.dartlang.org/packages/carp_connectivity_package) |
| [carp_communication_package](./packages/carp_communication_package) | Communication sampling package (phone, sms) | [![pub package](https://img.shields.io/pub/v/carp_communication_package.svg)](https://pub.dartlang.org/packages/carp_communication_package) |
| [carp_context_package](./packages/carp_context_package) | Context sampling package (location, activity, weather) | [![pub package](https://img.shields.io/pub/v/carp_context_package.svg)](https://pub.dartlang.org/packages/carp_context_package) |
| [carp_audio_package](./packages/carp_audio_package) | Audio sampling package (audio, noise) | [![pub package](https://img.shields.io/pub/v/carp_audio_package.svg)](https://pub.dartlang.org/packages/carp_audio_package) |
| [carp_survey_package](./packages/carp_survey_package) | Sampling package for collecting survey data from [Research Package](https://carp.cachet.dk/research-package/) and running cognitive test using the [Cognition Package](https://carp.cachet.dk/cognition-package/) | [![pub package](https://img.shields.io/pub/v/carp_survey_package.svg)](https://pub.dartlang.org/packages/carp_survey_package) |
| [carp_health_package](./packages/carp_health_package) | Sampling package for collecting health data from [Apple Health](https://www.apple.com/ios/health/) and [Google Fit](https://www.google.com/fit/) | [![pub package](https://img.shields.io/pub/v/carp_health_package.svg)](https://pub.dartlang.org/packages/carp_health_package) |
| **Wearables** | **Sampling Packages for Wearable Devices** |  |
| [carp_movisens_package](./packages/carp_movisens_package) | Movisens Move & ECG sampling package (movement, MET-level, ECG) | [![pub package](https://img.shields.io/pub/v/carp_movisens_package.svg)](https://pub.dartlang.org/packages/carp_movisens_package) |
| [carp_esense_package](./packages/carp_esense_package) | Sampling package for the eSense ear plug device (button pressed & movement) | [![pub package](https://img.shields.io/pub/v/carp_esense_package.svg)](https://pub.dartlang.org/packages/carp_esense_package) |
| [carp_polar_package](./packages/carp_polar_package) | Sampling package for the [Polar heart rate monitors](https://www.polar.com/) | [![pub package](https://img.shields.io/pub/v/carp_polar_package.svg)](https://pub.dartlang.org/packages/carp_polar_package) |
| **Backends** | **Backend data upload components** |  |
| [carp_webservices](./backends/carp_webservices) | Flutter API for CARP web services | [![pub package](https://img.shields.io/pub/v/carp_webservices.svg)](https://pub.dartlang.org/packages/carp_webservices) |
| [carp_backend](./backends/carp_backend) | Support for uploading data to a CARP data backend as JSON. | [![pub package](https://img.shields.io/pub/v/carp_backend.svg)](https://pub.dartlang.org/packages/carp_backend) |
| [carp_firebase_backend](./backends/carp_firebase_backend) | Support for uploading data to Firebase as both zipped files and JSON data| [![pub package](https://img.shields.io/pub/v/carp_firebase_backend.svg)](https://pub.dartlang.org/packages/carp_firebase_backend) |
| **Utilities** | **Misc. CAMS utilities** |  |
| [carp_study_generator](./utilities/carp_study_generator) | A simple command line interface (CLI) to upload study protocols, informed consent and localization files to the CARP backend.  | [![pub package](https://img.shields.io/pub/v/carp_study_generator.svg)](https://pub.dartlang.org/packages/carp_study_generator) |
| **Apps** | **Misc. mobile sensing demo apps** |  |
| [carp_mobile_sensing_app](./apps/carp_mobile_sensing_app) | Demonstrates how basic mobile sensing can be implemented in a Flutter app using CAMS. Also demonstrates how to integrate to wearable devices over BLE connections.  |  |
| [pulmonary_monitor_app](https://github.com/cph-cachet/pulmonary_monitor_app) | Demonstrates how user tasks (aka. [AppTask](https://pub.dev/documentation/carp_mobile_sensing/latest/domain/AppTask-class.html)) are supported in CAMS. |  |

## Documentation

The overall documentation on the software architecture of CARP Mobile Sensing, and how to use and extend it is available on this github [wiki](https://github.com/cph-cachet/carp.sensing-flutter/wiki). Each of the specific packages also contain more specific documentation on how each package is used in the framework (e.g. how the [Firebase data backend package](https://pub.dartlang.org/packages/carp_firebase_backend) is to be used).

## Issues

Please check existing issues and file any new issues, bugs, or feature requests in the [carp.sensing-flutter repo](https://github.com/cph-cachet/carp.sensing-flutter/issues).

## Contributing

Contributing is not entirely in place yet. However, if you wish to contribute a change to any of the existing components in this repo,
please review our [contribution guide](https://github.com/cph-cachet/carp.sensing/CONTRIBUTING.md),
and send a [pull request](https://github.com/cph-cachet/carp.sensing-flutter/pulls).
