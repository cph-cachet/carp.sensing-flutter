/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of audio;

/// An [AudioDatum] that holds the path to audio file on the local device
/// as well as the bytes of the audio file.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class AudioDatum extends CARPDatum {
  static CARPDataFormat CARP_DATA_FORMAT =
      new CARPDataFormat(NameSpace.CARP_NAMESPACE, ProbeRegistry.AUDIO_MEASURE);

  /// The filename of the audio file store on this device.
  String filename;

  /// The timestamp for start of recording.
  DateTime startRecordingTime;

  /// The timestamp for end of recording.
  DateTime endRecordingTime;

  AudioDatum({this.filename, this.startRecordingTime, this.endRecordingTime})
      : super();

  factory AudioDatum.fromJson(Map<String, dynamic> json) =>
      _$AudioDatumFromJson(json);
  Map<String, dynamic> toJson() => _$AudioDatumToJson(this);

  CARPDataFormat getCARPDataFormat() => CARP_DATA_FORMAT;

  String toString() =>
      'Audio File: {filename: $filename, start: $startRecordingTime, end: $endRecordingTime}';
}
