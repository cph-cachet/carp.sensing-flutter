part of carp_movesense_package;

/// Different states of the Movensense device.
///
/// See https://www.movesense.com/docs/esw/api_reference/#systemstates for an
/// overview.
enum MovesenseDeviceState {
  /// Unknown state.
  unknown,

  /// Device is moving.
  moving,

  /// Device is not moving.
  notMoving,

  /// Device connected to gear (e.g., strap).
  connected,

  /// Device disconnected to gear.
  disconnected,

  /// Device tapped once.
  tap,

  /// Device double tapped.
  doubleTap,

  /// Device is under acceleration.
  acceleration,

  /// Device is in free fall (no gravity).
  freeFall,
}

/// States API is a uniform, simplistic interface for accessing states of internal
/// device components.
///
/// Currently available states are listed in [MovesenseDeviceState].
///
/// See https://www.movesense.com/docs/esw/api_reference/#systemstates
///
/// **NOTE**, however, that currently there is a bug i the Movesense API and the
/// [MovesenseStateChangeProbe] is only able to collect single tap events.
/// See issue [#15](https://github.com/petri-lipponen-movesense/mdsflutter/issues/15).
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class MovesenseStateChange extends SensorData {
  static const dataType = MovesenseSamplingPackage.STATE;

  /// The state event.
  final MovesenseDeviceState state;

  /// The timestamp of this state event in milliseconds.
  late int timestamp;

  MovesenseStateChange(this.state, [int? timestamp])
      : timestamp = timestamp ?? DateTime.now().millisecond;

  // Example event:
  //
  //   Body: {Timestamp: 614897, StateId: 0, NewState: 1}
  //
  // NOTE - the json listed on the official Movesense API is wrong!
  factory MovesenseStateChange.fromMovesenseData(dynamic data) {
    MovesenseDeviceState state = MovesenseDeviceState.unknown;

    num timestamp = data["Body"]["Timestamp"] as num;
    num stateId = data["Body"]["StateId"] as num;
    num newState = data["Body"]["NewState"] as num;

    switch (stateId) {
      case 0: // movement
        state = (newState == 0)
            ? MovesenseDeviceState.notMoving
            : MovesenseDeviceState.moving;
        break;
      case 2: // connectors
        state = (newState == 0)
            ? MovesenseDeviceState.disconnected
            : MovesenseDeviceState.connected;
        break;
      case 3: // double-tap
        if (newState == 1) {
          state = MovesenseDeviceState.doubleTap;
        }
        break;
      case 4: // tap
        if (newState == 1) {
          state = MovesenseDeviceState.tap;
        }
        break;
      case 5: // free-fall
        state = (newState == 0)
            ? MovesenseDeviceState.acceleration
            : MovesenseDeviceState.freeFall;
        break;

      default:
    }

    return MovesenseStateChange(state, timestamp.toInt());
  }

  @override
  bool equivalentTo(Data other) =>
      other is MovesenseStateChange && state == other.state;

  @override
  Function get fromJsonFunction => _$MovesenseStateChangeFromJson;
  factory MovesenseStateChange.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as MovesenseStateChange;
  @override
  Map<String, dynamic> toJson() => _$MovesenseStateChangeToJson(this);

  @override
  String get jsonType => dataType;
}

/// Movesense sensor is equipped with analog front-end capable of capturing ECG
/// signals and calculating user's heart rate from this.
///
/// See https://www.movesense.com/docs/esw/api_reference/#meashr
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class MovesenseHR extends SensorData {
  static const dataType = MovesenseSamplingPackage.HR;

  /// The average heart rate (Hz).
  final double hr;

  /// The latest R-R measurement (ms).
  final int? rr;

  MovesenseHR(this.hr, [this.rr]);

  factory MovesenseHR.fromMovesenseData(dynamic data) {
    num average = data["Body"]["average"] as num;
    // returns a list of R-R measures with only one entry (the latest)
    int rr = (data["Body"]["rrData"] as List<dynamic>)
        .map((e) => e as int)
        .toList()[0];

    return MovesenseHR(average.toDouble(), rr);
  }

  @override
  Function get fromJsonFunction => _$MovesenseHRFromJson;
  factory MovesenseHR.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as MovesenseHR;
  @override
  Map<String, dynamic> toJson() => _$MovesenseHRToJson(this);

  @override
  String get jsonType => dataType;
}

/// Movesense sensor is equipped with analog front-end capable of capturing ECG
/// signals.
///
/// See https://www.movesense.com/docs/esw/api_reference/#measecg
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class MovesenseECG extends SensorData {
  static const dataType = MovesenseSamplingPackage.ECG;

  /// The device's internal timestamp of this sample in milliseconds.
  final int timestamp;

  /// The ECG samples.
  final List<int> samples;

  MovesenseECG(this.timestamp, this.samples);

  factory MovesenseECG.fromMovesenseData(dynamic data) {
    List<int> samples = (data["Body"]["Samples"] as List<dynamic>)
        .map((e) => e as int)
        .toList();
    num timestamp = data["Body"]["Timestamp"] as num;
    return MovesenseECG(timestamp.toInt(), samples);
  }

  @override
  Function get fromJsonFunction => _$MovesenseECGFromJson;
  factory MovesenseECG.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as MovesenseECG;
  @override
  Map<String, dynamic> toJson() => _$MovesenseECGToJson(this);

  @override
  String get jsonType => dataType;
}

/// The Movesense MD sensor is equipped with temperature sensor, which can be
/// used to measure device's internal temperature. Returned values are in units
/// of Kelvins (K).
///
/// See https://www.movesense.com/docs/esw/api_reference/#meastemperature
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class MovesenseTemperature extends SensorData {
  static const dataType = MovesenseSamplingPackage.TEMPERATURE;

  /// The device's internal timestamp of this sample in milliseconds.
  final int timestamp;

  /// The device's internal temperature in units of Kelvins (K).
  final int measurement;

  MovesenseTemperature(this.timestamp, this.measurement);

  factory MovesenseTemperature.fromMovesenseData(dynamic data) {
    num timestamp = data["Body"]["Timestamp"] as num;
    num measurement = data["Body"]["Measurement"] as num;

    return MovesenseTemperature(timestamp.toInt(), measurement.toInt());
  }

  @override
  Function get fromJsonFunction => _$MovesenseTemperatureFromJson;
  factory MovesenseTemperature.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as MovesenseTemperature;
  @override
  Map<String, dynamic> toJson() => _$MovesenseTemperatureToJson(this);

  @override
  String get jsonType => dataType;
}

/// Provides a synchronized access to combined accelerometer, gyroscope and
/// magnetometer data samples for easier processing e.g. for AHRS algorithms.
/// It is more efficient to subscribe to the IMU resource than to subscribe the
/// individual sensors separately.
///
/// See https://www.movesense.com/docs/esw/api_reference/#measimu
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class MovesenseIMU extends SensorData {
  static const dataType = MovesenseSamplingPackage.ECG;

  /// The device's internal timestamp of this sample in milliseconds.
  final int timestamp;

  final List<MovesenseAccelerometerSample> accelerometer;
  final List<MovesenseGyroscopeSample> gyroscope;
  final List<MovesenseMagnetometerSample> magnetometer;

  MovesenseIMU(
    this.timestamp,
    this.accelerometer,
    this.gyroscope,
    this.magnetometer,
  );

  factory MovesenseIMU.fromMovesenseData(dynamic data) {
    num timestamp = data["Body"]["Timestamp"] as num;

    List<MovesenseAccelerometerSample> acc =
        (data["Body"]["ArrayAcc"] as List<dynamic>)
            .map((sample) => MovesenseAccelerometerSample(
                sample['x'] as num, sample['y'] as num, sample['z'] as num))
            .toList();

    List<MovesenseGyroscopeSample> gyro =
        (data["Body"]["ArrayAcc"] as List<dynamic>)
            .map((sample) => MovesenseGyroscopeSample(
                sample['x'] as num, sample['y'] as num, sample['z'] as num))
            .toList();

    List<MovesenseMagnetometerSample> mag =
        (data["Body"]["ArrayAcc"] as List<dynamic>)
            .map((sample) => MovesenseMagnetometerSample(
                sample['x'] as num, sample['y'] as num, sample['z'] as num))
            .toList();

    return MovesenseIMU(timestamp.toInt(), acc, gyro, mag);
  }

  @override
  Function get fromJsonFunction => _$MovesenseIMUFromJson;
  factory MovesenseIMU.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as MovesenseIMU;
  @override
  Map<String, dynamic> toJson() => _$MovesenseIMUToJson(this);

  @override
  String get jsonType => dataType;
}

/// Movesense accelerometer sample
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class MovesenseAccelerometerSample {
  /// X,Y,Z value in milli-G (including gravity)
  final num x, y, z;

  MovesenseAccelerometerSample(this.x, this.y, this.z);

  factory MovesenseAccelerometerSample.fromJson(Map<String, dynamic> json) =>
      _$MovesenseAccelerometerSampleFromJson(json);
  Map<String, dynamic> toJson() => _$MovesenseAccelerometerSampleToJson(this);
}

/// Movesense gyroscope sample
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class MovesenseGyroscopeSample {
  /// X, Y, Z axis value in deg/sec
  final num x, y, z;

  MovesenseGyroscopeSample(this.x, this.y, this.z);

  factory MovesenseGyroscopeSample.fromJson(Map<String, dynamic> json) =>
      _$MovesenseGyroscopeSampleFromJson(json);
  Map<String, dynamic> toJson() => _$MovesenseGyroscopeSampleToJson(this);
}

/// Movesense magnetometer sample
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class MovesenseMagnetometerSample {
  /// X, Y, Z axis value in Gauss
  final num x, y, z;

  MovesenseMagnetometerSample(this.x, this.y, this.z);

  factory MovesenseMagnetometerSample.fromJson(Map<String, dynamic> json) =>
      _$MovesenseMagnetometerSampleFromJson(json);
  Map<String, dynamic> toJson() => _$MovesenseMagnetometerSampleToJson(this);
}
