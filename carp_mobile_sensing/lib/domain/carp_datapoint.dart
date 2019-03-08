/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of domain;

/// A CARP Data Point which can be uploaded to a CARP data endpoint.
///
/// See https://github.com/cph-cachet/carp.webservices
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class CARPDataPoint {
  /// A unique, server-side generated ID for this data point.
  /// [null] if this data point is not yet stored in the CARP server.
  int id;

  /// The CARP data point header.
  CARPDataPointHeader carpHeader;

  /// The CARP data point body. Can be any payload modelled as a [Datum].
  Datum carpBody;

  CARPDataPoint(this.carpHeader, this.carpBody);

  CARPDataPoint.fromDatum(String studyId, String userId, CARPDatum datum) {
    CARPDataPointHeader header = new CARPDataPointHeader(studyId, userId);
    header.startTime = (datum is CARPDatum) ? datum.timestamp.toUtc() : new DateTime.now().toUtc();
    header.dataFormat = datum.format;

    this.carpHeader = header;
    this.carpBody = datum;
  }

  factory CARPDataPoint.fromJson(Map<String, dynamic> json) => _$CARPDataPointFromJson(json);
  Map<String, dynamic> toJson() => _$CARPDataPointToJson(this);
}

/// The header attached to all [CARPDataPoint]s.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class CARPDataPointHeader {
  /// The ID of the [Study] from which this data point was generated.
  String studyId;

  /// The role of this device in the [Study].
  String deviceRoleName;

  /// The ID of the [Trigger] that generated this data point.
  String triggerId;

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

  /// The CARP data format. See [DataFormat] and [NameSpace].
  DataFormat dataFormat;

  // Create a new [CARPDataPointHeader]. [studyId] and [userId] are required.
  CARPDataPointHeader(this.studyId, this.userId, {this.deviceRoleName, this.triggerId, this.startTime, this.endTime}) {
    if (startTime != null) startTime.toUtc();
    if (endTime != null) endTime.toUtc();
    // [deviceRoleName] and [triggerId] has to be specified when sending this data point to the CARP web service.
    // TODO - need to add device and triggers to the domain model.
    if (deviceRoleName == null) deviceRoleName = "unknown";
    if (triggerId == null) triggerId = "unknown";
  }

  factory CARPDataPointHeader.fromJson(Map<String, dynamic> json) => _$CARPDataPointHeaderFromJson(json);
  Map<String, dynamic> toJson() => _$CARPDataPointHeaderToJson(this);
}
