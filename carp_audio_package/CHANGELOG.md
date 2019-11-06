## 0.6.1
* allignment with `carp_mobile_sensing` v. 0.6.1.
* improvement to the audio probe based

## 0.6.0
* update to `carp_mobile_sensing` version 0.6.0
* fixed noise probe.
* note that the noise and audio probe (still) can't run at the same time.

## 0.5.0 BREAKING
* **Breaking change.** This version has been migrated from the deprecated Android Support Library to *AndroidX*. 
This should not result in any functional changes, but it requires any Android app using this plugin to also 
[migrate](https://developer.android.com/jetpack/androidx/migrate) if they're using the original support library. 
* Use [`carp_mobile_sensing`](https://pub.dartlang.org/packages/carp_mobile_sensing) version 0.5.0 
* See Flutter [AndroidX compatibility](https://flutter.dev/docs/development/packages-and-plugins/androidx-compatibility)

## 0.3.5
* upgrade to json_serializable v.2
* fixed bug in audio recording probe (issue [#23](https://github.com/cph-cachet/carp.sensing-flutter/issues/23))

## 0.3.4
* update to `carp_mobile_sensing` version 0.3.10

## 0.3.3
* solved issue [#21](https://github.com/cph-cachet/carp.sensing-flutter/issues/21).

## 0.3.2
* Update to `carp_mobile_sensing` v. 0.3.7
* Using the data types in the package (`audio`, `noise`)
* Update of readme file.

## 0.3.1
* Documentation

## 0.3.0
* Initial release compatible with `carp_mobile_sensing` version `0.3.*`
