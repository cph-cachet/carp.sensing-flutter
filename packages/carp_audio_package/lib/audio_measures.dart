/*
 * Copyright 2018-2020 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of audio;

/// Specify how to collect noise data, including setting the
/// [frequency], [duration], and [samplingRate] for collecting audio.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class NoiseMeasure extends PeriodicMeasure {
  static const int DEFAULT_SAMPLING_RATE = 500;

  late int samplingRate;

  NoiseMeasure({
    required String type,
    String? name,
    String? description,
    bool enabled = true,
    required Duration frequency,
    required Duration duration,
    int? samplingRate,
  }) : super(
          type: type,
          name: name,
          description: description,
          enabled: enabled,
          frequency: frequency,
          duration: duration,
        ) {
    this.samplingRate = samplingRate ?? DEFAULT_SAMPLING_RATE;
  }

  Function get fromJsonFunction => _$NoiseMeasureFromJson;
  factory NoiseMeasure.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as NoiseMeasure;
  Map<String, dynamic> toJson() => _$NoiseMeasureToJson(this);

  String toString() => super.toString() + ', samplingRate: $samplingRate';
}
