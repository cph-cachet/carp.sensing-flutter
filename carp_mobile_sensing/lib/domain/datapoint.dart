/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of domain;

/// A data point storing meta-information and the data.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class DataPoint {
  /// The data point header.
  DataPointHeader header;

  /// The CARP data point body. Can be any payload modelled as a [Datum].
  Datum body;

  DataPoint(this.header, this.body);

  DataPoint.fromDatum(int studyId, String userId, Datum datum) {
    DataPointHeader header = new DataPointHeader(studyId, userId);
    header.startTime = (datum is CARPDatum) ? datum.timestamp.toUtc() : new DateTime.now().toUtc();
    header.dataFormat = datum.format;

    this.header = header;
    this.body = datum;
  }

  factory DataPoint.fromJson(Map<String, dynamic> json) => _$DataPointFromJson(json);
  Map<String, dynamic> toJson() => _$DataPointToJson(this);
}

/// The header (meta-data) attached to all [DataPoint]s.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class DataPointHeader {
  /// The ID of the [Study] from which this data point was generated.
  int studyId;

  /// The ID of the user (if known).
  String userId;

  /// The UTC time stamp of when this data point was uploaded to the server.
  /// Set by the server.
  DateTime uploadTime;

  /// The UTC start timestamp for this data point.
  DateTime startTime;

  /// The UTC end timestamp for this data point.
  /// If this data point does not cover a period, [endTime] will be null.
  DateTime endTime;

  /// The data format. See [DataFormat] and [NameSpace].
  DataFormat dataFormat;

  // Create a new [DataPointHeader]. [studyId] and [userId] are required.
  DataPointHeader(this.studyId, this.userId, {this.startTime, this.endTime}) {
    if (startTime != null) startTime.toUtc();
    if (endTime != null) endTime.toUtc();
  }

  factory DataPointHeader.fromJson(Map<String, dynamic> json) => _$DataPointHeaderFromJson(json);
  Map<String, dynamic> toJson() => _$DataPointHeaderToJson(this);
}
