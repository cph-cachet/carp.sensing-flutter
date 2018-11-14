/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of domain;

/// A CARP Data Point which can be uploaded to a CARP data endpoint.
///
/// See https://github.com/cph-cachet/carp.documentation/wiki/Data-application-service-endpoint-and-data-point-DTO
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class CARPDataPoint {
  String id;

  /// A unique, server-side generated ID for this data point.
  //String get id => (_id == null) ? "" : _id;

  /// The CARP data point header.
  CARPDataPointHeader carpHeader;

  /// The CARP data point body. Can be any payload modelled as a [Datun].
  Datum carpBody;

  CARPDataPoint(this.carpHeader, this.carpBody);

  CARPDataPoint.fromDatum(String studyId, String userId, Datum datum) {
    CARPDataPointHeader header = new CARPDataPointHeader(studyId, userId);
    header.startTime = (datum is CARPDatum) ? datum.timestamp.toUtc() : new DateTime.now().toUtc();
    header.dataFormat = datum.getCARPDataFormat();

    this.carpHeader = header;
    this.carpBody = datum;
  }

  factory CARPDataPoint.fromJson(Map<String, dynamic> json) => _$CARPDataPointFromJson(json);
  Map<String, dynamic> toJson() => _$CARPDataPointToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class CARPDataPointHeader {
  String studyId;
  String deviceRoleName;
  String triggerId;
  String userId;

  /// The UTC time stamp of when this data point was uploaded to the server.
  /// Set by the server.
  DateTime uploadTime;

  /// The UTC start timestamp for this data point.
  DateTime startTime;

  /// The UTC end timestamp for this data point.
  /// If this data point does not cover a period, [endTime] will be null.
  DateTime endTime;

  /// The CARP data format. See [CARPDataFormat] and [NameSpace].
  CARPDataFormat dataFormat;

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

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class CARPDataFormat {
  String namepace;
  String name;

  CARPDataFormat(this.namepace, this.name);
  factory CARPDataFormat.unknown() => new CARPDataFormat(NameSpace.UNKNOWN_NAMESPACE, "unknown");

  factory CARPDataFormat.fromJson(Map<String, dynamic> json) => _$CARPDataFormatFromJson(json);
  Map<String, dynamic> toJson() => _$CARPDataFormatToJson(this);

  String toString() {
    return "$namepace.$name";
  }
}

/// An abstract class represent any OMH schema.
/// Currently supporting:
/// * omh  : Open mHealth data format
/// * carp : CARP data format
abstract class NameSpace {
  static const String UNKNOWN_NAMESPACE = "unknown";
  static const String OMH_NAMESPACE = "omh";
  static const String CARP_NAMESPACE = "carp";
}
