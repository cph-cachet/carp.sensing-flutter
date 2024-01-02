part of carp_movesense_package;

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

class MovesensSamples<T> extends SensorData {
  final List<T> samples;

  MovesensSamples({required this.samples});
}

@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class MovesenseHR extends MovesensSamples<MovesenseHRSample> {
  static const dataType = MovesenseSamplingPackage.HR;
  MovesenseHR({required super.samples});

  static MovesenseHR fromMoveSenseData(dynamic data) {
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
