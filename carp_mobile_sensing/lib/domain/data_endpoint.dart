/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of domain;

/// Specify an endpoint where a file-based [DataManager] can store JSON
/// data as files on the local device.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class FileDataEndPoint extends DataEndPoint {
  /// The buffer size of the raw JSON file in bytes.
  ///
  /// All Probed data will be written to a JSON file until the buffer is
  /// filled, at which time the file will be zipped. There is not a single-best
  /// [bufferSize] value.
  /// If data are collected at high rates, a higher value will be best to
  /// minimize zip operations. If data are collected at low rates, a lower
  /// value will be best to minimize the likelihood of data loss when the app
  /// is killed or crashes. Default size is 500 KB.
  int bufferSize;

  /// Is data to be compressed (zipped) before storing in a file.
  /// True as default.
  ///
  /// If zipped, the JSON file will be reduced to 1/5 of its size.
  /// For example, the 500 KB buffer typically is reduced to ~100 KB.
  bool zip = true;

  /// Is data to be encrypted before storing. False as default.
  ///
  /// Support only one-way encryption using a public key.
  bool encrypt = false;

  /// If [encrypt] is true, this should hold the public key in a RSA KPI
  /// encryption of data.
  String? publicKey;

  /// Creates a [FileDataEndPoint].
  ///
  /// [type] is defined in [DataEndPointTypes]. Is typically of type
  /// [DataEndPointType.FILE] but specialized file types can be specified.
  FileDataEndPoint({
    String? type,
    String dataFormat = NameSpace.CARP,
    this.bufferSize = 500 * 1000,
    this.zip = true,
    this.encrypt = false,
    this.publicKey,
  }) : super(type: type ?? DataEndPointTypes.FILE, dataFormat: dataFormat);

  /// The function which can transform this [FileDataEndPoint] into JSON.
  ///
  /// See [Serializable].
  Function get fromJsonFunction => _$FileDataEndPointFromJson;

  /// Create a [FileDataEndPoint] from a JSON map.
  factory FileDataEndPoint.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as FileDataEndPoint;

  /// Serialize this [FileDataEndPoint] as a JSON map.
  Map<String, dynamic> toJson() => _$FileDataEndPointToJson(this);

  String toString() => 'FILE - buffer ${(bufferSize / 1000).round()} KB'
      '${zip ? ', zipped' : ''}${encrypt ? ', encrypted' : ''}';
}
