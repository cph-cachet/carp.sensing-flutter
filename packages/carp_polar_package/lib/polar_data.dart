/*
 * Copyright 2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of carp_polar_package;

/// An abstract Datum for all Polar data points.
abstract class PolarData extends SensorData {
  /// Polar device identifier.
  String deviceIdentifier;

  /// Sample timestamp from the Polar device in nanoseconds.
  int? deviceTimestamp;

  PolarData(this.deviceIdentifier, this.deviceTimestamp) : super();

  /// Create a [PolarData] based on [deviceIdentifier] and [deviceTimestamp] from
  /// a Polar data reading.
  PolarData.fromPolarData(this.deviceIdentifier, [this.deviceTimestamp])
      : super();
}

/// Polar (x,y,z) values.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
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
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
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
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class PolarAccelerometer extends PolarData {
  static const dataType = PolarSamplingPackage.ACCELEROMETER;

  /// Acceleration samples list (x,y,z).
  List<PolarXYZ> samples;

  PolarAccelerometer(
    super.deviceIdentifier,
    super.deviceTimestamp,
    this.samples,
  );

  /// Create a [PolarAccelerometer] based on the original [PolarAccData] reading.
  PolarAccelerometer.fromPolarData(PolarAccData data)
      : samples =
            data.samples.map((xyz) => PolarXYZ.fromPolarData(xyz)).toList(),
        super.fromPolarData(data.identifier, data.timeStamp);

  factory PolarAccelerometer.fromJson(Map<String, dynamic> json) =>
      _$PolarAccelerometerFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PolarAccelerometerToJson(this);

  @override
  String get jsonType => PolarSamplingPackage.ACCELEROMETER;
}

/// Polar gyroscope data.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class PolarGyroscope extends PolarData {
  static const dataType = PolarSamplingPackage.GYROSCOPE;

  /// Gyroscope samples list (x,y,z) in °/s signed value
  List<PolarXYZ> samples;

  PolarGyroscope(
    super.deviceIdentifier,
    super.deviceTimestamp,
    this.samples,
  );

  /// Create a [PolarGyroscope] based on the original [PolarGyroData] reading.
  PolarGyroscope.fromPolarData(PolarGyroData data)
      : samples =
            data.samples.map((xyz) => PolarXYZ.fromPolarData(xyz)).toList(),
        super.fromPolarData(data.identifier, data.timeStamp);

  factory PolarGyroscope.fromJson(Map<String, dynamic> json) =>
      _$PolarGyroscopeFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PolarGyroscopeToJson(this);

  @override
  String get jsonType => PolarSamplingPackage.GYROSCOPE;
}

/// Polar magnetometer data.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class PolarMagnetometer extends PolarData {
  static const dataType = PolarSamplingPackage.MAGNETOMETER;

  /// Magnetometer samples list (x,y,z) in Gauss
  List<PolarXYZ> samples;

  PolarMagnetometer(
      super.deviceIdentifier, super.deviceTimestamp, this.samples);

  /// Create a [PolarMagnetometer] based on the original [PolarMagnetometerData] reading.
  PolarMagnetometer.fromPolarData(PolarMagnetometerData data)
      : samples =
            data.samples.map((xyz) => PolarXYZ.fromPolarData(xyz)).toList(),
        super.fromPolarData(data.identifier, data.timeStamp);

  factory PolarMagnetometer.fromJson(Map<String, dynamic> json) =>
      _$PolarMagnetometerFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PolarMagnetometerToJson(this);

  @override
  String get jsonType => PolarSamplingPackage.MAGNETOMETER;
}

/// Polar ECG data.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class PolarECG extends PolarData {
  static const dataType = PolarSamplingPackage.ECG;

  /// ECG sample in µVolts
  List<int> samples;

  PolarECG(super.deviceIdentifier, super.deviceTimestamp, this.samples);

  /// Create a [PolarECG] based on the original [PolarEcgData] reading.
  PolarECG.fromPolarData(PolarEcgData data)
      : samples = data.samples,
        super.fromPolarData(data.identifier, data.timeStamp);

  factory PolarECG.fromJson(Map<String, dynamic> json) =>
      _$PolarECGFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PolarECGToJson(this);

  @override
  String get jsonType => PolarSamplingPackage.ECG;
}

/// Polar optical heart rate (OHR) photoplethysmograpy (PPG) data.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class PolarPPG extends PolarData {
  static const dataType = PolarSamplingPackage.PPG;

  /// Source of OHR data
  OhrDataType type;

  /// ppg(s) and ambient(s) samples list
  List<List<int>> samples;

  PolarPPG(
    super.deviceIdentifier,
    super.deviceTimestamp,
    this.type,
    this.samples,
  );

  /// Create a [PolarPPG] based on the original [PolarOhrData] reading.
  PolarPPG.fromPolarData(PolarOhrData data)
      : samples = data.samples,
        type = data.type,
        super.fromPolarData(data.identifier, data.timeStamp);

  factory PolarPPG.fromJson(Map<String, dynamic> json) =>
      _$PolarPPGFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PolarPPGToJson(this);

  @override
  String get jsonType => PolarSamplingPackage.PPG;
}

/// Polar PP interval (PPI) in milliseconds.
/// Represents cardiac pulse-to-pulse interval extracted from PPG signal.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class PolarPPI extends PolarData {
  static const dataType = PolarSamplingPackage.PPI;

  /// List of PPI samples read from the Polar device.
  List<PolarPPISample> samples;

  PolarPPI(super.deviceIdentifier, super.deviceTimestamp, this.samples);

  /// Create a [PolarPPI] based on the original [PolarPpiData] reading.
  PolarPPI.fromPolarData(PolarPpiData data)
      : samples = data.samples
            .map((ppi) => PolarPPISample.fromPolarData(ppi))
            .toList(),
        super.fromPolarData(data.identifier, data.timeStamp);

  factory PolarPPI.fromJson(Map<String, dynamic> json) =>
      _$PolarPPIFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PolarPPIToJson(this);

  @override
  String get jsonType => PolarSamplingPackage.PPI;
}

/// Polar heart rate (HR).
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class PolarHR extends PolarData {
  static const dataType = PolarSamplingPackage.HR;

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

  PolarHR(
    super.deviceIdentifier,
    super.deviceTimestamp,
    this.hr,
    this.rrs,
    this.rrsMs,
    this.contactStatus,
    this.contactStatusSupported,
  );

  /// Create a [PolarPPI] based on the original [PolarPpiData] reading.
  PolarHR.fromPolarData(String identifier, PolarHrData data)
      : hr = data.hr,
        rrs = data.rrs,
        rrsMs = data.rrsMs,
        contactStatus = data.contactStatus,
        contactStatusSupported = data.contactStatusSupported,
        super.fromPolarData(identifier);

  factory PolarHR.fromJson(Map<String, dynamic> json) =>
      _$PolarHRFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PolarHRToJson(this);

  @override
  String get jsonType => PolarSamplingPackage.HR;
}
