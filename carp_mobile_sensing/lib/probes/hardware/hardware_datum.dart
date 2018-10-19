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
  static CARPDataFormat CARP_DATA_FORMAT = new CARPDataFormat(
      NameSpace.CARP_NAMESPACE, ProbeRegistry.BATTERY_MEASURE);

  /// The battery level in percent.
  int batteryLevel;

  /// The charging status of the battery:
  /// - charging
  /// - full
  /// - discharging
  /// - unknown
  String batteryStatus;

  BatteryDatum() : super();

  factory BatteryDatum.fromJson(Map<String, dynamic> json) =>
      _$BatteryDatumFromJson(json);
  Map<String, dynamic> toJson() => _$BatteryDatumToJson(this);

  CARPDataFormat getCARPDataFormat() => CARP_DATA_FORMAT;

  String toString() =>
      'battery: {level: $batteryLevel%, status: $batteryStatus}';
}

/// Holds information about free memory on the phone.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class FreeMemoryDatum extends CARPDatum {
  static CARPDataFormat CARP_DATA_FORMAT = new CARPDataFormat(
      NameSpace.CARP_NAMESPACE, ProbeRegistry.MEMORY_MEASURE);

  /// Amount of free physical memory in bytes.
  int freePhysicalMemory;

  /// Amount of free virtual memory in bytes.
  int freeVirtualMemory;

  FreeMemoryDatum() : super();

  factory FreeMemoryDatum.fromJson(Map<String, dynamic> json) =>
      _$FreeMemoryDatumFromJson(json);
  Map<String, dynamic> toJson() => _$FreeMemoryDatumToJson(this);

  CARPDataFormat getCARPDataFormat() => CARP_DATA_FORMAT;

  String toString() =>
      'free memory: {physical: $freePhysicalMemory%, virtual: $freeVirtualMemory}';
}

/// Holds a screen event collected from the phone.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class ScreenDatum extends CARPDatum {
  static CARPDataFormat CARP_DATA_FORMAT = new CARPDataFormat(
      NameSpace.CARP_NAMESPACE, ProbeRegistry.SCREEN_MEASURE);

  /// A screen event:
  /// - SCREEN_OFF
  /// - SCREEN_ON
  /// - SCREEN_UNLOCKED
  String screenEvent;

  ScreenDatum() : super();

  factory ScreenDatum.fromJson(Map<String, dynamic> json) =>
      _$ScreenDatumFromJson(json);
  Map<String, dynamic> toJson() => _$ScreenDatumToJson(this);

  CARPDataFormat getCARPDataFormat() => CARP_DATA_FORMAT;

  String toString() => 'screen_Event: {$screenEvent}';
}
