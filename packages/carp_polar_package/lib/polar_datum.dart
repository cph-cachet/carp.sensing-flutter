/*
 * Copyright 2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of carp_polar_package;

/// An abstract Datum for all Polar data points.
abstract class PolarDatum extends Datum {
  /// Polar device identifier.
  String deviceIdentifier;

  /// Sample timestamp from the Polar device in nanoseconds.
  int? deviceTimestamp;

  PolarDatum(this.deviceIdentifier, this.deviceTimestamp) : super();

  /// Create a [PolarDatum] based on [deviceIdentifier] and [deviceTimestamp] from
  /// a Polar data reading.
  PolarDatum.fromPolarData(this.deviceIdentifier, [this.deviceTimestamp])
      : super();
}

/// Polar (x,y,z) values.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class PolarXYZ {
  ///  value
  final double x;

  /// Y value
  final double y;

  /// Z value
  final double z;

  PolarXYZ(this.x, this.y, this.z);

  /// Create a [PolarXYZ] based on the original [Xyz] polar reading.
  PolarXYZ.fromPolarData(Xyz data)
      : x = data.x,
        y = data.y,
        z = data.z,
        super();

  factory PolarXYZ.fromJson(Map<String, dynamic> json) =>
      _$PolarXYZFromJson(json);
  Map<String, dynamic> toJson() => _$PolarXYZToJson(this);
}

/// Polar optical heart rate (OHR) pulse-to-pulse interval (PPI) sample.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class PolarPPISample {
  /// Pulse-to-pulse interval (PPI) in milliseconds.
  int ppi;

  /// Estimate of the expected absolute error in [ppi] in milliseconds.
  ///
  /// The value indicates the quality of the measured [ppi].
  /// When error estimate is below 10ms [ppi] readings are probably very accurate.
  /// Error estimate values over 30ms may be caused by movement artefact or too
  /// loose sensor-skin contact. See [skinContactStatus].
  int errorEstimate;

  /// Heart rate (HR) in beats pr. minute (BPM).
  int hr;

  /// True if PPI measurement was invalid due to acceleration or other reasons.
  bool blockerBit;

  /// False if the device detects poor or no contact with the skin.
  bool skinContactStatus;

  /// True if the Sensor Contact feature is supported.
  bool skinContactSupported;

  PolarPPISample(
    this.ppi,
    this.errorEstimate,
    this.hr,
    this.blockerBit,
    this.skinContactStatus,
    this.skinContactSupported,
  ) : super();

  /// Create a [PolarPPISample] based on the original [PolarOhrPpiSample] reading.
  PolarPPISample.fromPolarData(PolarOhrPpiSample data)
      : ppi = data.ppi,
        errorEstimate = data.errorEstimate,
        hr = data.hr,
        blockerBit = data.blockerBit,
        skinContactStatus = data.skinContactStatus,
        skinContactSupported = data.skinContactSupported,
        super();

  factory PolarPPISample.fromJson(Map<String, dynamic> json) =>
      _$PolarPPISampleFromJson(json);
  Map<String, dynamic> toJson() => _$PolarPPISampleToJson(this);
}

/// Polar accelerometer data.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class PolarAccelerometerDatum extends PolarDatum {
  @JsonKey(ignore: true)
  @override
  DataFormat get format =>
      DataFormat.fromString(PolarSamplingPackage.POLAR_ACCELEROMETER);

  /// Acceleration samples list (x,y,z).
  List<PolarXYZ> samples;

  PolarAccelerometerDatum(
    super.deviceIdentifier,
    super.deviceTimestamp,
    this.samples,
  );

  /// Create a [PolarAccelerometerDatum] based on the original [PolarAccData] reading.
  PolarAccelerometerDatum.fromPolarData(PolarAccData data)
      : samples =
            data.samples.map((xyz) => PolarXYZ.fromPolarData(xyz)).toList(),
        super.fromPolarData(data.identifier, data.timeStamp);

  factory PolarAccelerometerDatum.fromJson(Map<String, dynamic> json) =>
      _$PolarAccelerometerDatumFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PolarAccelerometerDatumToJson(this);
}

/// Polar gyroscope data.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class PolarGyroscopeDatum extends PolarDatum {
  @JsonKey(ignore: true)
  @override
  DataFormat get format =>
      DataFormat.fromString(PolarSamplingPackage.POLAR_GYROSCOPE);

  /// Gyroscope samples list (x,y,z) in °/s signed value
  List<PolarXYZ> samples;

  PolarGyroscopeDatum(
    super.deviceIdentifier,
    super.deviceTimestamp,
    this.samples,
  );

  /// Create a [PolarGyroscopeDatum] based on the original [PolarGyroData] reading.
  PolarGyroscopeDatum.fromPolarData(PolarGyroData data)
      : samples =
            data.samples.map((xyz) => PolarXYZ.fromPolarData(xyz)).toList(),
        super.fromPolarData(data.identifier, data.timeStamp);

  factory PolarGyroscopeDatum.fromJson(Map<String, dynamic> json) =>
      _$PolarGyroscopeDatumFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PolarGyroscopeDatumToJson(this);
}

/// Polar magnetometer data.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class PolarMagnetometerDatum extends PolarDatum {
  @JsonKey(ignore: true)
  @override
  DataFormat get format =>
      DataFormat.fromString(PolarSamplingPackage.POLAR_MAGNETOMETER);

  /// Magnetometer samples list (x,y,z) in Gauss
  List<PolarXYZ> samples;

  PolarMagnetometerDatum(
      super.deviceIdentifier, super.deviceTimestamp, this.samples);

  /// Create a [PolarMagnetometerDatum] based on the original [PolarMagnetometerData] reading.
  PolarMagnetometerDatum.fromPolarData(PolarMagnetometerData data)
      : samples =
            data.samples.map((xyz) => PolarXYZ.fromPolarData(xyz)).toList(),
        super.fromPolarData(data.identifier, data.timeStamp);

  factory PolarMagnetometerDatum.fromJson(Map<String, dynamic> json) =>
      _$PolarMagnetometerDatumFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PolarMagnetometerDatumToJson(this);
}

/// Polar ECG data.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class PolarECGDatum extends PolarDatum {
  @JsonKey(ignore: true)
  @override
  DataFormat get format =>
      DataFormat.fromString(PolarSamplingPackage.POLAR_ECG);

  /// ECG sample in µVolts
  List<int> samples;

  PolarECGDatum(super.deviceIdentifier, super.deviceTimestamp, this.samples);

  /// Create a [PolarECGDatum] based on the original [PolarEcgData] reading.
  PolarECGDatum.fromPolarData(PolarEcgData data)
      : samples = data.samples,
        super.fromPolarData(data.identifier, data.timeStamp);

  factory PolarECGDatum.fromJson(Map<String, dynamic> json) =>
      _$PolarECGDatumFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PolarECGDatumToJson(this);
}

/// Polar exercise data.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class PolarExerciseDatum extends PolarDatum {
  @JsonKey(ignore: true)
  @override
  DataFormat get format =>
      DataFormat.fromString(PolarSamplingPackage.POLAR_EXERCISE);

  /// Exercise interval in seconds.
  int interval;

  /// List of HR or RR samples in BPM
  List<int> samples;

  PolarExerciseDatum(
    super.deviceIdentifier,
    super.deviceTimestamp,
    this.interval,
    this.samples,
  );

  /// Create a [PolarExerciseDatum] based on the original [PolarExerciseData] reading.
  PolarExerciseDatum.fromPolarData(PolarExerciseData data)
      : samples = data.samples,
        interval = data.interval,
        super.fromPolarData(data.identifier);

  factory PolarExerciseDatum.fromJson(Map<String, dynamic> json) =>
      _$PolarExerciseDatumFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PolarExerciseDatumToJson(this);
}

/// Polar optical heart rate (OHR) photoplethysmograpy (PPG) data.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class PolarPPGDatum extends PolarDatum {
  @JsonKey(ignore: true)
  @override
  DataFormat get format =>
      DataFormat.fromString(PolarSamplingPackage.POLAR_PPG);

  /// Source of OHR data
  OhrDataType type;

  /// ppg(s) and ambient(s) samples list
  List<List<int>> samples;

  PolarPPGDatum(
    super.deviceIdentifier,
    super.deviceTimestamp,
    this.type,
    this.samples,
  );

  /// Create a [PolarPPGDatum] based on the original [PolarOhrData] reading.
  PolarPPGDatum.fromPolarData(PolarOhrData data)
      : samples = data.samples,
        type = data.type,
        super.fromPolarData(data.identifier, data.timeStamp);

  factory PolarPPGDatum.fromJson(Map<String, dynamic> json) =>
      _$PolarPPGDatumFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PolarPPGDatumToJson(this);
}

/// Polar PP interval (PPI) in milliseconds.
/// Represents cardiac pulse-to-pulse interval extracted from PPG signal.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class PolarPPIDatum extends PolarDatum {
  @JsonKey(ignore: true)
  @override
  DataFormat get format =>
      DataFormat.fromString(PolarSamplingPackage.POLAR_PPI);

  /// List of PPI samples read from the Polar device.
  List<PolarPPISample> samples;

  PolarPPIDatum(super.deviceIdentifier, super.deviceTimestamp, this.samples);

  /// Create a [PolarPPIDatum] based on the original [PolarPpiData] reading.
  PolarPPIDatum.fromPolarData(PolarPpiData data)
      : samples = data.samples
            .map((ppi) => PolarPPISample.fromPolarData(ppi))
            .toList(),
        super.fromPolarData(data.identifier, data.timeStamp);

  factory PolarPPIDatum.fromJson(Map<String, dynamic> json) =>
      _$PolarPPIDatumFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PolarPPIDatumToJson(this);
}

/// Polar heart rate (HR).
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class PolarHRDatum extends PolarDatum {
  @JsonKey(ignore: true)
  @override
  DataFormat get format => DataFormat.fromString(PolarSamplingPackage.POLAR_HR);

  /// Heart rate (HR) in BPM
  int hr;

  /// RR interval in 1/1024.
  /// R is a the top highest peak in the QRS complex of the ECG wave and
  /// RR is the interval between successive Rs.
  List<int> rrs;

  /// RR interval in ms.
  List<int> rrsMs;

  /// True if there is contact between the device and the user's skin.
  bool contactStatus;

  /// True contact detection is supported on the device.
  bool contactStatusSupported;

  PolarHRDatum(
    super.deviceIdentifier,
    super.deviceTimestamp,
    this.hr,
    this.rrs,
    this.rrsMs,
    this.contactStatus,
    this.contactStatusSupported,
  );

  /// Create a [PolarPPIDatum] based on the original [PolarPpiData] reading.
  PolarHRDatum.fromPolarData(String identifier, PolarHrData data)
      : hr = data.hr,
        rrs = data.rrs,
        rrsMs = data.rrsMs,
        contactStatus = data.contactStatus,
        contactStatusSupported = data.contactStatusSupported,
        super.fromPolarData(identifier);

  factory PolarHRDatum.fromJson(Map<String, dynamic> json) =>
      _$PolarHRDatumFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PolarHRDatumToJson(this);
}
