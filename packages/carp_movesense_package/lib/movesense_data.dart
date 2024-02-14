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

@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class MovesenseStateChange extends SensorData {
  static const dataType = MovesenseSamplingPackage.STATE;

  final MovesenseDeviceState state;

  MovesenseStateChange(this.state);

  factory MovesenseStateChange.fromMovesenseData(dynamic data) {
    MovesenseStateChange state =
        MovesenseStateChange(MovesenseDeviceState.unknown);

    debug("MovesenseStateChange - data event: $data");

    num stateId = data["Body"]["StateId"][0] as num;
    num newState = data["Body"]["NewState"] as num;

    switch (stateId) {
      case 0: // movement
        state = (newState == 0)
            ? MovesenseStateChange(MovesenseDeviceState.notMoving)
            : MovesenseStateChange(MovesenseDeviceState.moving);
        break;
      case 2: // connectors
        state = (newState == 0)
            ? MovesenseStateChange(MovesenseDeviceState.disconnected)
            : MovesenseStateChange(MovesenseDeviceState.connected);
        break;
      case 3: // double-tap
        if (newState == 1) {
          state = MovesenseStateChange(MovesenseDeviceState.doubleTap);
        }
        break;
      case 4: // tap
        if (newState == 1) {
          state = MovesenseStateChange(MovesenseDeviceState.tap);
        }
        break;
      case 5: // free-fall
        state = (newState == 0)
            ? MovesenseStateChange(MovesenseDeviceState.acceleration)
            : MovesenseStateChange(MovesenseDeviceState.freeFall);
        break;

      default:
    }

    return state;
  }

  @override
  Function get fromJsonFunction => _$MovesenseStateChangeFromJson;
  factory MovesenseStateChange.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as MovesenseStateChange;
  @override
  Map<String, dynamic> toJson() => _$MovesenseStateChangeToJson(this);

  @override
  String get jsonType => dataType;
}

@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class MovesenseHR extends SensorData {
  static const dataType = MovesenseSamplingPackage.HR;

  /// The average heart rate.
  final double hr;

  /// The list of R-R intervals in this sample.
  final List<int> rr;

  MovesenseHR(this.hr, [this.rr = const []]);

  factory MovesenseHR.fromMovesenseData(dynamic data) {
    debug("MovesenseHR - data event: $data");

    num average = data["Body"]["average"] as num;
    List<int> rr = data["Body"]["rrData"] as List<int>;
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

@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class MovesenseECG extends SensorData {
  static const dataType = MovesenseSamplingPackage.ECG;

  /// The timestamp of this ECG sample in milliseconds.
  final int timestamp;

  /// The ECG samples.
  final List<int> samples;

  MovesenseECG(this.samples, this.timestamp);

  factory MovesenseECG.fromMovesenseData(dynamic data) {
    debug("MovesenseECG - data event: $data");

    List<int> samples = data["Body"]["Samples"] as List<int>;
    num timestamp = data["Body"]["Timestamp"] as num;
    return MovesenseECG(samples, timestamp.toInt());
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
