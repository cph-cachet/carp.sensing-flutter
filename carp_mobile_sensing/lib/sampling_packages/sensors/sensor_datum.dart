/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of sensors;

/// A [Datum] that holds acceleration data collected from the native accelerometer on the phone.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class AccelerometerDatum extends Datum {
  @override
  DataFormat get format =>
      DataFormat.fromString(SensorSamplingPackage.ACCELEROMETER);

  /// Acceleration force along the x axis (including gravity) measured in m/s^2.
  double? x;

  /// Acceleration force along the y axis (including gravity) measured in m/s^2.
  double? y;

  /// Acceleration force along the z axis (including gravity) measured in m/s^2.
  double? z;

  AccelerometerDatum({super.multiDatum = false, this.x, this.y, this.z});

  factory AccelerometerDatum.fromAccelerometerEvent(AccelerometerEvent event,
          {bool multiDatum = false}) =>
      AccelerometerDatum(multiDatum: multiDatum)
        ..x = event.x
        ..y = event.y
        ..z = event.z;

  factory AccelerometerDatum.fromJson(Map<String, dynamic> json) =>
      _$AccelerometerDatumFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$AccelerometerDatumToJson(this);

  @override
  String toString() => '${super.toString()}, x: $x, y: $y, z: $z';
}

/// A [Datum] that holds rotation data collected from the native gyroscope on the phone.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class GyroscopeDatum extends Datum {
  @override
  DataFormat get format =>
      DataFormat.fromString(SensorSamplingPackage.GYROSCOPE);

  /// Rate of rotation around the x axis measured in rad/s.
  double? x;

  /// Rate of rotation around the y axis measured in rad/s.
  double? y;

  /// Rate of rotation around the z axis measured in rad/s.
  double? z;

  GyroscopeDatum({super.multiDatum = false, this.x, this.y, this.z});

  factory GyroscopeDatum.fromGyroscopeEvent(GyroscopeEvent event,
          {bool multiDatum = false}) =>
      GyroscopeDatum(multiDatum: multiDatum)
        ..x = event.x
        ..y = event.y
        ..z = event.z;

  factory GyroscopeDatum.fromJson(Map<String, dynamic> json) =>
      _$GyroscopeDatumFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$GyroscopeDatumToJson(this);

  @override
  String toString() => '${super.toString()}, x: $x, y: $y, z: $z';
}

/// A [Datum] that holds light intensity in Lux from the light sensor on the phone.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class LightDatum extends Datum {
  @override
  DataFormat get format => DataFormat.fromString(SensorSamplingPackage.LIGHT);

  /// Intensity in Lux
  num? meanLux;
  num? stdLux;
  num? minLux;
  num? maxLux;

  LightDatum({this.meanLux, this.stdLux, this.minLux, this.maxLux})
      : super(multiDatum: false);

  factory LightDatum.fromJson(Map<String, dynamic> json) =>
      _$LightDatumFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$LightDatumToJson(this);

  @override
  String toString() =>
      '${super.toString()}, avgLux: $meanLux, stdLux: $stdLux, minLux: $minLux, maxLux: $maxLux';
}

/// Holds the step count.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class PedometerDatum extends Datum {
  @override
  DataFormat get format =>
      DataFormat.fromString(SensorSamplingPackage.PEDOMETER);

  /// The amount of steps.
  int? stepCount;

  PedometerDatum([this.stepCount]) : super();

  /// Returns `true` if the [stepCount] is equal.
  @override
  bool equivalentTo(ConditionalEvent? event) =>
      stepCount == event!['stepCount'];

  factory PedometerDatum.fromJson(Map<String, dynamic> json) =>
      _$PedometerDatumFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$PedometerDatumToJson(this);

  @override
  String toString() => '${super.toString()}, steps: $stepCount';
}
