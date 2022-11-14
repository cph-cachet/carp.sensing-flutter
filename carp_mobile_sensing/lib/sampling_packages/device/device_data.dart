/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of device;

/// Holds basic information about the mobile device from where the data is collected.
///
/// More information on the data from Android and iOS are available at:
///   * [AndroidDeviceInfo](https://pub.dev/documentation/device_info/latest/device_info/AndroidDeviceInfo-class.html)
///   * [IosDeviceInfo](https://pub.dev/documentation/device_info/latest/device_info/IosDeviceInfo-class.html)
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class DeviceInformation extends Data {
  static const dataType = DeviceSamplingPackage.DEVICE_INFORMATION_TYPE_NAME;

  ///The platform type from which this Datum was collected.
  /// * `Android`
  /// * `IOS`
  String? platform;

  /// An identifier that is unique to the particular device which this [Datum] was collected.
  /// Note that this ID will change if the user performs a factory reset on their device.
  String? deviceId;

  /// The hardware type from which this [Datum] was collected (e.g. 'iPhone7,1' for iPhone 6 Plus).
  String? hardware;

  /// Device name as specified by the OS.
  String? deviceName;

  /// Device manufacturer as specified by the OS.
  String? deviceManufacturer;

  /// Device model as specified by the OS.
  String? deviceModel;

  /// Device OS as specified by the OS.
  String? operatingSystem;

  /// The SDK version.
  String? sdk;

  /// The OS release.
  String? release;

  DeviceInformation(this.platform, this.deviceId,
      {this.deviceName,
      this.deviceModel,
      this.deviceManufacturer,
      this.operatingSystem,
      this.hardware})
      : super();

  /// Returns `true` if the [deviceId] is equal.
  @override
  bool equivalentTo(ConditionalEvent? event) => deviceId == event!['deviceId'];

  factory DeviceInformation.fromJson(Map<String, dynamic> json) =>
      _$DeviceInformationFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$DeviceInformationToJson(this);

  @override
  String toString() =>
      '${super.toString()}, platform: $platform, deviceId: $deviceId, hardware: $hardware, name: $deviceName, manufacturer: $deviceManufacturer, model: $deviceModel, OS: $operatingSystem, SDK: $sdk, release: $release';
}

/// A [Datum] that holds battery level collected from the phone.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class BatteryState extends Data {
  static const dataType = DeviceSamplingPackage.BATTERY_STATE_TYPE_NAME;

  static const String STATE_FULL = 'full';
  static const String STATE_CHARGING = 'charging';
  static const String STATE_DISCHARGING = 'discharging';
  static const String STATE_UNKNOWN = 'unknown';

  /// The battery level in percent.
  int? batteryLevel;

  /// The charging status of the battery:
  ///  - full
  ///  - charging
  ///  - discharging
  ///  - unknown
  String? batteryStatus;

  BatteryState([this.batteryLevel, this.batteryStatus]) : super();

  BatteryState.fromBatteryState(int level, battery.BatteryState state)
      : batteryLevel = level,
        batteryStatus = _parseBatteryState(state),
        super();

  static String _parseBatteryState(battery.BatteryState state) {
    switch (state) {
      case battery.BatteryState.full:
        return STATE_FULL;
      case battery.BatteryState.charging:
        return STATE_CHARGING;
      case battery.BatteryState.discharging:
        return STATE_DISCHARGING;
      default:
        return STATE_UNKNOWN;
    }
  }

  /// Returns `true` if the [batteryLevel] is equal.
  @override
  bool equivalentTo(ConditionalEvent? event) =>
      batteryLevel == event!['batteryLevel'];

  factory BatteryState.fromJson(Map<String, dynamic> json) =>
      _$BatteryStateFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$BatteryStateToJson(this);

  @override
  String toString() =>
      '${super.toString()}, level: $batteryLevel%, status: $batteryStatus';
}

/// Holds information about free memory on the phone.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class FreeMemory extends Data {
  static const dataType = DeviceSamplingPackage.FREE_MEMORY_TYPE_NAME;

  /// Amount of free physical memory in bytes.
  int? freePhysicalMemory;

  /// Amount of free virtual memory in bytes.
  int? freeVirtualMemory;

  FreeMemory([this.freePhysicalMemory, this.freeVirtualMemory]) : super();

  factory FreeMemory.fromJson(Map<String, dynamic> json) =>
      _$FreeMemoryFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$FreeMemoryToJson(this);

  @override
  String toString() =>
      '${super.toString()}, physical: $freePhysicalMemory, virtual: $freeVirtualMemory';
}

/// Holds a screen event collected from the phone.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class ScreenEvent extends Data {
  static const dataType = DeviceSamplingPackage.SCREEN_EVENT_TYPE_NAME;

  /// A screen event:
  /// - SCREEN_OFF
  /// - SCREEN_ON
  /// - SCREEN_UNLOCKED
  String? screenEvent;

  ScreenEvent([this.screenEvent]) : super();

  factory ScreenEvent.fromScreenStateEvent(ScreenStateEvent event) {
    ScreenEvent sd = ScreenEvent();

    switch (event) {
      case ScreenStateEvent.SCREEN_ON:
        sd.screenEvent = 'SCREEN_ON';
        break;
      case ScreenStateEvent.SCREEN_OFF:
        sd.screenEvent = 'SCREEN_OFF';
        break;
      case ScreenStateEvent.SCREEN_UNLOCKED:
        sd.screenEvent = 'SCREEN_UNLOCKED';
        break;
    }
    return sd;
  }

  /// Returns `true` if the [screenEvent] is equal.
  @override
  bool equivalentTo(ConditionalEvent? event) =>
      screenEvent == event!['screenEvent'];

  factory ScreenEvent.fromJson(Map<String, dynamic> json) =>
      _$ScreenEventFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$ScreenEventToJson(this);

  @override
  String toString() => '${super.toString()}, screenEvent: $screenEvent';
}
