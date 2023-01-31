/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_core_deployment;

/// Specify an endpoint where a [DataManager] can upload data.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class DataEndPoint extends Serializable {
  /// The type of endpoint as enumerated in [DataEndPointTypes].
  String type;

  /// The preferred format of the data to be uploaded according to
  /// [NameSpace]. Default using the [NameSpace.CARP].
  String dataFormat;

  /// Creates a [DataEndPoint].
  /// [type] is defined in [DataEndPointTypes].
  /// [dataFormat] is defined in [NameSpace]. Default is [NameSpace.CARP].
  @mustCallSuper
  DataEndPoint({
    required this.type,
    this.dataFormat = NameSpace.CARP,
  }) : super();

  @override
  Function get fromJsonFunction => _$DataEndPointFromJson;

  @override
  factory DataEndPoint.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as DataEndPoint;

  @override
  Map<String, dynamic> toJson() => _$DataEndPointToJson(this);

  @override
  String toString() => '$runtimeType - type: $type, dataFormat: $dataFormat';
}

/// A enumeration of known (but not necessarily implemented) endpoint API types.
///
/// Note that the type is basically a [String], which allow for extension of
/// new application-specific data endpoints.
class DataEndPointTypes {
  static const String UNKNOWN = 'UNKNOWN';
  static const String PRINT = 'PRINT';
  static const String FILE = 'FILE';
  static const String SQLITE = 'SQLITE';
  static const String FIREBASE_STORAGE = 'FIREBASE_STORAGE';
  static const String FIREBASE_DATABASE = 'FIREBASE_DATABASE';
  static const String CARP = 'CARP';
  static const String OMH = 'OMH';
  static const String AWS = 'AWS';
}
