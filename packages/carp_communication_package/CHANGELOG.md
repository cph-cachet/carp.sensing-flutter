## 0.9.2
* upgrade to `carp_mobile_sensing` v. 0.9.2

## 0.9.0
* upgrade to `carp_mobile_sensing` v. 0.9.x

## 0.8.0
* upgrade to `carp_mobile_sensing` v. 0.8.x
* upgrading the `PhoneLogProbe`
  * removed the `PhoneLogMeasure` measure
  * using the new `MarkedMeasure` for the
* using `Duration` to specify the `CalendarMeasure`

## 0.7.0
* upgrade to `carp_mobile_sensing` v. 0.7.0

## 0.6.6
* upgrade to `carp_mobile_sensing` v. 0.6.6

## 0.6.5
* upgrade to `carp_mobile_sensing` v. 0.6.5

## 0.6.1
* allignment with `carp_mobile_sensing` v. 0.6.1.
* extensive testing on iOS 

## 0.6.0
* update to `carp_mobile_sensing` version 0.6.0

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
