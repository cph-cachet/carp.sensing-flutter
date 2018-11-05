/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of sensors;

/// A [Datum] that holds acceleration data collected from the native accelerometer on the phone.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class AccelerometerDatum extends CARPDatum {
  static CARPDataFormat CARP_DATA_FORMAT = new CARPDataFormat(
      NameSpace.CARP_NAMESPACE, ProbeRegistry.ACCELEROMETER_MEASURE);

  /// Acceleration force along the x axis (including gravity) measured in m/s^2.
  double x;

  /// Acceleration force along the y axis (including gravity) measured in m/s^2.
  double y;

  /// Acceleration force along the z axis (including gravity) measured in m/s^2.
  double z;

  AccelerometerDatum({this.x, this.y, this.z})
      : super(includeDeviceInfo: false);

  factory AccelerometerDatum.fromJson(Map<String, dynamic> json) =>
      _$AccelerometerDatumFromJson(json);
  Map<String, dynamic> toJson() => _$AccelerometerDatumToJson(this);

  CARPDataFormat getCARPDataFormat() => CARP_DATA_FORMAT;

  String toString() => 'accelerometer: {x: $x, y: $y, x: $z}';
}

/// A [Datum] that holds rotation data collected from the native gyroscope on the phone.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class GyroscopeDatum extends CARPDatum {
  static CARPDataFormat CARP_DATA_FORMAT = new CARPDataFormat(
      NameSpace.CARP_NAMESPACE, ProbeRegistry.GYROSCOPE_MEASURE);

  /// Rate of rotation around the x axis measured in rad/s.
  double x;

  /// Rate of rotation around the y axis measured in rad/s.
  double y;

  /// Rate of rotation around the z axis measured in rad/s.
  double z;

  GyroscopeDatum({this.x, this.y, this.z}) : super(includeDeviceInfo: false);

  factory GyroscopeDatum.fromJson(Map<String, dynamic> json) =>
      _$GyroscopeDatumFromJson(json);
  Map<String, dynamic> toJson() => _$GyroscopeDatumToJson(this);

  CARPDataFormat getCARPDataFormat() => CARP_DATA_FORMAT;

  String toString() => 'gyroscope: {x: $x, y: $y, x: $z}';
}

/// A [Datum] that holds light intensity in Lux from the light sensor on the phone.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class LightDatum extends CARPDatum {
  static CARPDataFormat CARP_DATA_FORMAT =
      new CARPDataFormat(NameSpace.CARP_NAMESPACE, ProbeRegistry.LIGHT_MEASURE);

  /// Intensity in Lux
  num avgLux;
  num stdLux;
  num minLux;
  num maxLux;

  LightDatum({this.avgLux, this.stdLux, this.minLux, this.maxLux})
      : super(includeDeviceInfo: false);

  factory LightDatum.fromJson(Map<String, dynamic> json) =>
      _$LightDatumFromJson(json);
  Map<String, dynamic> toJson() => _$LightDatumToJson(this);

  CARPDataFormat getCARPDataFormat() => CARP_DATA_FORMAT;

  String toString() =>
      'light: {avgLux: $avgLux, stdLux: $stdLux, minLux: $minLux, avgLux: $maxLux}';
}
