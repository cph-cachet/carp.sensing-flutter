/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of sensors;

/// A [Datum] that holds acceleration data collected from the native accelerometer
/// on the phone.
/// Accelerometers measure the velocity of the device. Note that these readings
/// include the effects of gravity. Put simply, you can use accelerometer
/// readings to tell if the device is moving in a particular direction.
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

/// A [Datum] that holds rotation data collected from the native gyroscope on
/// the phone.
/// Gyroscopes measure the rate or rotation of the device in 3D space.
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

/// A [Datum] that holds magnetometer data collected from the native magnetometer
/// on the phone.
///
/// Magnetometers measure the ambient magnetic field surrounding the sensor,
/// returning values in microteslas μT for each three-dimensional axis.
///
/// Consider that these samples may bear effects of Earth's magnetic field as
/// well as local factors such as the metal of the device itself or nearby magnets,
/// though most devices compensate for these factors.
///
/// A compass is an example of a general utility for magnetometer data.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class MagnetometerDatum extends Datum {
  @override
  DataFormat get format =>
      DataFormat.fromString(SensorSamplingPackage.GYROSCOPE);

  /// The ambient magnetic field in the x axis surrounding the sensor in microteslas μT.
  double? x;

  /// The ambient magnetic field in the y axis surrounding the sensor in microteslas μT.
  double? y;

  /// The ambient magnetic field in the z axis surrounding the sensor in microteslas μT.
  double? z;

  MagnetometerDatum({super.multiDatum = false, this.x, this.y, this.z});

  factory MagnetometerDatum.fromMagnetometerEvent(MagnetometerEvent event,
          {bool multiDatum = false}) =>
      MagnetometerDatum(multiDatum: multiDatum)
        ..x = event.x
        ..y = event.y
        ..z = event.z;

  factory MagnetometerDatum.fromJson(Map<String, dynamic> json) =>
      _$MagnetometerDatumFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$MagnetometerDatumToJson(this);

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
