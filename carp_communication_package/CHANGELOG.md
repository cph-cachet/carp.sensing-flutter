## 0.5.0
* `calendar` measure, probe, and datum added incl. default privacy protection 
* `phone_log` measure redesigned as a periodic measure
* `text_message_log` measure redesigned as a periodic measure
* Relying on carp_mobile_sensing ^0.5.0 which is migrated to AndroidX.
   * This shouldn't result in any functional changes, but it requires any Android apps using this plugin to also 
[migrate](https://developer.android.com/jetpack/androidx/migrate) if they're using the original support library. 
   * See Flutter [AndroidX compatibility](https://flutter.dev/docs/development/packages-and-plugins/androidx-compatibility)


## 0.3.4
* upgrade to json_serializable v.2
* privacy schema support for hashing text messages and phone numbers

## 0.3.3
* update to `carp_mobile_sensing` version 0.3.10

## 0.3.2
* Documentation

## 0.3.1
* Documentation

## 0.3.0
* Initial release compatible with `carp_mobile_sensing` version `0.3.*`
