/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of hardware;

/// A [Datum] that holds battery level collected from the phone.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class BatteryDatum extends CARPDatum {
  /// The battery level in percent.
  int batteryLevel;

  /// The charging status of the battery:
  /// - charging
  /// - full
  /// - discharging
  /// - unknown
  String batteryStatus;

  BatteryDatum({Measure measure}) : super(measure: measure);

  BatteryDatum.fromBatteryState(Measure measure, int level, BatteryState state)
      : batteryLevel = level,
        batteryStatus = _parseBatteryState(state),
        super(measure: measure);

  static String _parseBatteryState(BatteryState state) {
    switch (state) {
      case BatteryState.full:
        return "full";
      case BatteryState.charging:
        return "charging";
      case BatteryState.discharging:
        return "discharging";
      default:
        return "unknown";
    }
  }

  factory BatteryDatum.fromJson(Map<String, dynamic> json) => _$BatteryDatumFromJson(json);
  Map<String, dynamic> toJson() => _$BatteryDatumToJson(this);

  String toString() => 'battery: {level: $batteryLevel%, status: $batteryStatus}';
}

/// Holds information about free memory on the phone.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class FreeMemoryDatum extends CARPDatum {
  /// Amount of free physical memory in bytes.
  int freePhysicalMemory;

  /// Amount of free virtual memory in bytes.
  int freeVirtualMemory;

  FreeMemoryDatum({Measure measure}) : super(measure: measure);

  factory FreeMemoryDatum.fromJson(Map<String, dynamic> json) => _$FreeMemoryDatumFromJson(json);
  Map<String, dynamic> toJson() => _$FreeMemoryDatumToJson(this);

  String toString() => 'free memory: {physical: $freePhysicalMemory%, virtual: $freeVirtualMemory}';
}

/// Holds a screen event collected from the phone.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class ScreenDatum extends CARPDatum {
  /// A screen event:
  /// - SCREEN_OFF
  /// - SCREEN_ON
  /// - SCREEN_UNLOCKED
  String screenEvent;

  ScreenDatum({Measure measure}) : super(measure: measure);

  factory ScreenDatum.fromJson(Map<String, dynamic> json) => _$ScreenDatumFromJson(json);
  Map<String, dynamic> toJson() => _$ScreenDatumToJson(this);

  String toString() => 'screen_Event: {$screenEvent}';
}
