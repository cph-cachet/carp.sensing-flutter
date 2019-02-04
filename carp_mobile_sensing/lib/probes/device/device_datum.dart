/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of device;

/// Holds basic information about the mobile device from where the data is collected.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class DeviceDatum extends CARPDatum {
  static const DataFormat CARP_DATA_FORMAT = DataFormat(NameSpace.CARP, DataType.DEVICE);
  DataFormat get format => CARP_DATA_FORMAT;

  ///The platform type from which this Datum was collected.
  /// * `Android`
  /// * `IOS`
  String platform;

  /// An identifier that is unique to the particular device which this [Datum] was collected.
  /// Note that this ID will change if the user performs a factory reset on their device.
  String deviceId;

  /// The hardware type from which this [Datum] was collected (e.g. 'iPhone7,1' for iPhone 6 Plus).
  String hardware;

  /// Device name as specified by the OS.
  String deviceName;

  /// Device manufacturer as specified by the OS.
  String deviceManufacturer;

  /// Device model as specified by the OS.
  String deviceModel;

  /// Device OS as specified by the OS.
  String operatingSystem;

  DeviceDatum(this.platform, this.deviceId,
      {this.deviceName, this.deviceModel, this.deviceManufacturer, this.operatingSystem, this.hardware})
      : super();

  factory DeviceDatum.fromJson(Map<String, dynamic> json) => _$DeviceDatumFromJson(json);
  Map<String, dynamic> toJson() => _$DeviceDatumToJson(this);

  String toString() =>
      'Device - platform: $platform, deviceId: $deviceId, hardware: $hardware, name: $deviceName, manufacturer: $deviceManufacturer, model: $deviceModel, OS: $operatingSystem';
}

/// A [Datum] that holds battery level collected from the phone.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class BatteryDatum extends CARPDatum {
  static const DataFormat CARP_DATA_FORMAT = DataFormat(NameSpace.CARP, DataType.BATTERY);
  DataFormat get format => CARP_DATA_FORMAT;

  static const String STATE_FULL = 'full';
  static const String STATE_CHARGING = 'charging';
  static const String STATE_DISCHARGING = 'discharging';
  static const String STATE_UNKNOWN = 'unknown';

  /// The battery level in percent.
  int batteryLevel;

  /// The charging status of the battery:
  ///  - full
  ///  - charging
  ///  - discharging
  ///  - unknown
  String batteryStatus;

  BatteryDatum() : super();

  BatteryDatum.fromBatteryState(int level, BatteryState state)
      : batteryLevel = level,
        batteryStatus = _parseBatteryState(state),
        super();

  static String _parseBatteryState(BatteryState state) {
    switch (state) {
      case BatteryState.full:
        return STATE_FULL;
      case BatteryState.charging:
        return STATE_CHARGING;
      case BatteryState.discharging:
        return STATE_DISCHARGING;
      default:
        return STATE_UNKNOWN;
    }
  }

  factory BatteryDatum.fromJson(Map<String, dynamic> json) => _$BatteryDatumFromJson(json);
  Map<String, dynamic> toJson() => _$BatteryDatumToJson(this);

  String toString() => 'Battery - level: $batteryLevel%, status: $batteryStatus';
}

/// Holds information about free memory on the phone.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class FreeMemoryDatum extends CARPDatum {
  static const DataFormat CARP_DATA_FORMAT = DataFormat(NameSpace.CARP, DataType.MEMORY);
  DataFormat get format => CARP_DATA_FORMAT;

  /// Amount of free physical memory in bytes.
  int freePhysicalMemory;

  /// Amount of free virtual memory in bytes.
  int freeVirtualMemory;

  FreeMemoryDatum() : super();

  factory FreeMemoryDatum.fromJson(Map<String, dynamic> json) => _$FreeMemoryDatumFromJson(json);
  Map<String, dynamic> toJson() => _$FreeMemoryDatumToJson(this);

  String toString() => 'free memory: {physical: $freePhysicalMemory%, virtual: $freeVirtualMemory}';
}

/// Holds a screen event collected from the phone.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class ScreenDatum extends CARPDatum {
  static const DataFormat CARP_DATA_FORMAT = DataFormat(NameSpace.CARP, DataType.SCREEN);
  DataFormat get format => CARP_DATA_FORMAT;

  /// A screen event:
  /// - SCREEN_OFF
  /// - SCREEN_ON
  /// - SCREEN_UNLOCKED
  String screenEvent;

  ScreenDatum() : super();

  factory ScreenDatum.fromScreenStateEvent(ScreenStateEvent event) {
    ScreenDatum sd = new ScreenDatum();

    switch (event) {
      case ScreenStateEvent.SCREEN_ON:
        sd.screenEvent = "SCREEN_ON";
        break;
      case ScreenStateEvent.SCREEN_OFF:
        sd.screenEvent = "SCREEN_OFF";
        break;
      case ScreenStateEvent.SCREEN_UNLOCKED:
        sd.screenEvent = "SCREEN_UNLOCKED";
        break;
    }
    return sd;
  }

  factory ScreenDatum.fromJson(Map<String, dynamic> json) => _$ScreenDatumFromJson(json);
  Map<String, dynamic> toJson() => _$ScreenDatumToJson(this);

  String toString() => 'Screen Event - $screenEvent';
}
