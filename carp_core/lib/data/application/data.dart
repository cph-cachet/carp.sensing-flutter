/*
 * Copyright 2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_core_data;

// /// Holds data for a [DataType].
// @JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
// class Data extends Serializable {
//   @JsonKey(ignore: true)
//   DataType format;

//   Data([this.format = DataType.UNKNOWN]) : super();

//   @override
//   Function get fromJsonFunction => _$DataFromJson;
//   factory Data.fromJson(Map<String, dynamic> json) =>
//       FromJsonFactory().fromJson(json) as Data;
//   @override
//   Map<String, dynamic> toJson() => _$DataToJson(this);
//   @override
//   String get jsonType => toString();
// }

/// Holds data for a [DataType].
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class Data extends Serializable {
  @JsonKey(ignore: true)
  DataType get format => DataType.fromString(jsonType);

  Data() : super();

  @override
  Function get fromJsonFunction => _$DataFromJson;
  factory Data.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as Data;
  @override
  Map<String, dynamic> toJson() => _$DataToJson(this);
  @override
  String get jsonType => '${NameSpace.CARP}.$runtimeType'.toLowerCase();
}

/// Holds data for a [DataType] collected by a sensor which may include additional
/// [sensorSpecificData].
abstract class SensorData extends Data {
  /// Additional sensor-specific data pertaining to this data point.
  /// This can be used to append highly-specific sensor data to an otherwise
  /// common data type.
  Data? sensorSpecificData;
}

/// Holds geolocation data as latitude and longitude in decimal degrees within
/// the World Geodetic System 1984.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class Geolocation extends SensorData {
  double latitude;
  double longitude;

  Geolocation({
    required this.latitude,
    required this.longitude,
  }) : super();

  Function get fromJsonFunction => _$GeolocationFromJson;
  factory Geolocation.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as Geolocation;
  @override
  Map<String, dynamic> toJson() => _$GeolocationToJson(this);
}

/// The relative received signal strength of a wireless device.
/// The unit of the received signal strength indicator ([rssi]) is arbitrary
/// and determined by the chip manufacturer, but the greater the value,
/// the stronger the signal.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class SignalStrength extends SensorData {
  int rssi;
  SignalStrength({required this.rssi}) : super();

  Function get fromJsonFunction => _$SignalStrengthFromJson;
  factory SignalStrength.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as SignalStrength;
  @override
  Map<String, dynamic> toJson() => _$SignalStrengthToJson(this);
}
