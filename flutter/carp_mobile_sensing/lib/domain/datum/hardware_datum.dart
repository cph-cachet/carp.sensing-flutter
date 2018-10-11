/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:json_annotation/json_annotation.dart';

part 'hardware_datum.g.dart';

/// A [Datum] that holds battery level collected from the phone.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class BatteryDatum extends CARPDatum {
  static CARPDataFormat CARP_DATA_FORMAT = new CARPDataFormat(NameSpace.CARP_NAMESPACE, ProbeRegistry.BATTERY_MEASURE);

  /// The battery level in percent.
  int batteryLevel;

  /// The charging status of the battery as either charging, full, discharging, or unknown.
  String batteryStatus;

  BatteryDatum() : super();

  factory BatteryDatum.fromJson(Map<String, dynamic> json) => _$BatteryDatumFromJson(json);
  Map<String, dynamic> toJson() => _$BatteryDatumToJson(this);

  CARPDataFormat getCARPDataFormat() => CARP_DATA_FORMAT;

  String toString() => 'battery: {level: $batteryLevel%, status: $batteryStatus}';
}

/// A [Datum] that holds battery level collected from the phone.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class FreeMemoryDatum extends CARPDatum {
  static CARPDataFormat CARP_DATA_FORMAT = new CARPDataFormat(NameSpace.CARP_NAMESPACE, ProbeRegistry.MEMORY_MEASURE);

  /// Returns the amount of free physical memory in bytes.
  int freePhysicalMemory;

  /// Returns the amount of free virtual memory in bytes.
  int freeVirtualMemory;

  FreeMemoryDatum() : super();

  factory FreeMemoryDatum.fromJson(Map<String, dynamic> json) => _$FreeMemoryDatumFromJson(json);
  Map<String, dynamic> toJson() => _$FreeMemoryDatumToJson(this);

  CARPDataFormat getCARPDataFormat() => CARP_DATA_FORMAT;

  String toString() => 'free memory: {physical: $freePhysicalMemory%, virtual: $freeVirtualMemory}';
}

/// A [Datum] that holds user information obtained from the operating system.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class UserDatum extends CARPDatum {
  static CARPDataFormat CARP_DATA_FORMAT = new CARPDataFormat(NameSpace.CARP_NAMESPACE, ProbeRegistry.USER_MEASURE);

  /// Returns the identifier of current user.
  String userId;

  /// Returns the name of current user.
  String userName;

  UserDatum() : super();

  factory UserDatum.fromJson(Map<String, dynamic> json) => _$UserDatumFromJson(json);
  Map<String, dynamic> toJson() => _$UserDatumToJson(this);

  CARPDataFormat getCARPDataFormat() => CARP_DATA_FORMAT;

  String toString() => 'os_user: {id: $userId, name: $userName}';
}

/// A [Datum] that holds a screen event collected from the phone.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class ScreenDatum extends CARPDatum {
  static CARPDataFormat CARP_DATA_FORMAT = new CARPDataFormat(NameSpace.CARP_NAMESPACE, ProbeRegistry.SCREEN_MEASURE);

  /// A screen event: OFF/ON/UNLOCKED
  String screenEvent;

  ScreenDatum() : super();

  factory ScreenDatum.fromJson(Map<String, dynamic> json) => _$ScreenDatumFromJson(json);
  Map<String, dynamic> toJson() => _$ScreenDatumToJson(this);

  CARPDataFormat getCARPDataFormat() => CARP_DATA_FORMAT;

  String toString() => 'screen_Event: {$screenEvent}';
}
