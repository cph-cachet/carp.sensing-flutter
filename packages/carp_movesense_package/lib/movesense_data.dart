part of carp_movesense_package;

/// Different states of the Movensense device.
///
/// See https://www.movesense.com/docs/esw/api_reference/#systemstates for an
/// overview.
enum MovesenseDeviceState {
  /// Device is moving.
  moving,

  /// Device connected to gear (e.g., strap).
  connected,

  /// Device tapped once.
  tap,

  /// Device double tapped.
  doubleTap,

  /// Device is in free fall (no gravity).
  freeFall,
}

@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class MovesenseStateChange {
  final MovesenseDeviceState state;

  MovesenseStateChange(this.state) 

  factory MovesenseStateChange.fromJson(Map<String, dynamic> json) =>
      _$MovesenseStateChangeFromJson(json);
  Map<String, dynamic> toJson() => _$MovesenseStateChangeToJson(this);

}

@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class MovesenseHRSample {
  final double hr;

  //final List<int> rr;

  MovesenseHRSample(this.hr) {
    print("heart rate sample $hr");
  }

  factory MovesenseHRSample.fromJson(Map<String, dynamic> json) =>
      _$MovesenseHRSampleFromJson(json);
  Map<String, dynamic> toJson() => _$MovesenseHRSampleToJson(this);

  @override
  String toString() => '$runtimeType - hr: $hr';
}

@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class MovesenseECGSample {
  final List<int> samples;

  MovesenseECGSample(this.samples);

  //final List<int> rr;

  factory MovesenseECGSample.fromJson(Map<String, dynamic> json) =>
      _$MovesenseECGSampleFromJson(json);
  Map<String, dynamic> toJson() => _$MovesenseECGSampleToJson(this);

  @override
  String toString() => '$runtimeType - samples: $samples';
}

class MovesensSamples<T> extends SensorData {
  final List<T> samples;

  MovesensSamples({required this.samples});
}

@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class MovesenseHR extends MovesensSamples<MovesenseHRSample> {
  static const dataType = MovesenseSamplingPackage.HR;
  MovesenseHR({required super.samples});

  static MovesenseHR fromMovesenseData(dynamic data) {
    Map<String, dynamic> body = data["Body"];
    double hr = body["average"];
    print("heart rate $hr");
    var movesensehr = MovesenseHR(samples: [MovesenseHRSample(hr)]);
    print("heart rate movesenseHR $movesensehr");
    return movesensehr;
  }

  /* MovesenseHR.fromMoveSenseData(dynamic data)
      : this(
            samples: data
                .map((sample) => MovesenseHRSample(
                      sample["Body"]["average"],
                      sample["Body"]["rr"],
                    ))
                .toList()); */

  @override
  Function get fromJsonFunction => _$MovesenseHRFromJson;
  factory MovesenseHR.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as MovesenseHR;
  @override
  Map<String, dynamic> toJson() => _$MovesenseHRToJson(this);
  @override
  String get jsonType => dataType;

  @override
  String toString() => '$runtimeType - hr: $samples';
}

@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class MovesenseECG extends MovesensSamples<MovesenseECGSample> {
  static const dataType = MovesenseSamplingPackage.ECG;
  MovesenseECG({required super.samples});

  static MovesenseECG fromMovesenseData(dynamic data) {
    print(data);
    Map<String, dynamic> body = data["Body"];
    return 0 as MovesenseECG;
  }

  /* MovesenseHR.fromMoveSenseData(dynamic data)
      : this(
            samples: data
                .map((sample) => MovesenseHRSample(
                      sample["Body"]["average"],
                      sample["Body"]["rr"],
                    ))
                .toList()); */

  @override
  Function get fromJsonFunction => _$MovesenseECGFromJson;
  factory MovesenseECG.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as MovesenseECG;
  @override
  Map<String, dynamic> toJson() => _$MovesenseECGToJson(this);
  @override
  String get jsonType => dataType;

  @override
  String toString() => '$runtimeType - ecg: $samples';
}
