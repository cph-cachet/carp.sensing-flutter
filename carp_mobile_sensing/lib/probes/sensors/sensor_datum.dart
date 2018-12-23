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
  /// Acceleration force along the x axis (including gravity) measured in m/s^2.
  double x;

  /// Acceleration force along the y axis (including gravity) measured in m/s^2.
  double y;

  /// Acceleration force along the z axis (including gravity) measured in m/s^2.
  double z;

  AccelerometerDatum({Measure measure, this.x, this.y, this.z}) : super(measure: measure, multiDatum: true);
  factory AccelerometerDatum.fromAccelerometerEvent(Measure measure, AccelerometerEvent event) =>
      AccelerometerDatum(measure: measure)
        ..x = event.x
        ..y = event.y
        ..z = event.z;

  factory AccelerometerDatum.fromJson(Map<String, dynamic> json) => _$AccelerometerDatumFromJson(json);
  Map<String, dynamic> toJson() => _$AccelerometerDatumToJson(this);

  String toString() => 'accelerometer: {x: $x, y: $y, x: $z}';
}

/// A [Datum] that holds rotation data collected from the native gyroscope on the phone.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: true)
class GyroscopeDatum extends CARPDatum {
  /// Rate of rotation around the x axis measured in rad/s.
  double x;

  /// Rate of rotation around the y axis measured in rad/s.
  double y;

  /// Rate of rotation around the z axis measured in rad/s.
  double z;

  GyroscopeDatum({Measure measure, this.x, this.y, this.z}) : super(measure: measure, multiDatum: true);
  factory GyroscopeDatum.fromGyroscopeEvent(Measure measure, GyroscopeEvent event) => GyroscopeDatum(measure: measure)
    ..x = event.x
    ..y = event.y
    ..z = event.z;

  factory GyroscopeDatum.fromJson(Map<String, dynamic> json) => _$GyroscopeDatumFromJson(json);
  Map<String, dynamic> toJson() => _$GyroscopeDatumToJson(this);

  String toString() => 'gyroscope: {x: $x, y: $y, x: $z}';
}

/// A [Datum] that holds light intensity in Lux from the light sensor on the phone.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class LightDatum extends CARPDatum {
  /// Intensity in Lux
  num meanLux;
  num stdLux;
  num minLux;
  num maxLux;

  LightDatum({Measure measure, this.meanLux, this.stdLux, this.minLux, this.maxLux})
      : super(measure: measure, multiDatum: false);

  factory LightDatum.fromJson(Map<String, dynamic> json) => _$LightDatumFromJson(json);
  Map<String, dynamic> toJson() => _$LightDatumToJson(this);

  String toString() => 'light: {avgLux: $meanLux, stdLux: $stdLux, minLux: $minLux, maxLux: $maxLux}';
}
