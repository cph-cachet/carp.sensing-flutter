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
  CARPDataPointHeader carpHeader;
  Datum carpBody;

  CARPDataPoint(this.carpHeader, this.carpBody);

  CARPDataPoint.fromDatum(String studyId, String userId, Datum datum) {
    CARPDataPointHeader header = new CARPDataPointHeader(studyId, userId);
    header.startTime = new DateTime.now();
    header.dataFormat = datum.getCARPDataFormat();

    this.carpHeader = header;
    this.carpBody = datum;
  }

  factory CARPDataPoint.fromJson(Map<String, dynamic> json) =>
      _$CARPDataPointFromJson(json);
  Map<String, dynamic> toJson() => _$CARPDataPointToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class CARPDataPointHeader {
  String studyId;
  String deviceRoleName;
  String triggerId;
  String userId;
  CARPDataFormat dataFormat;
  DateTime uploadTime;
  DateTime startTime;
  DateTime endTime;

  // Create a new [CARPDataPointHeader]. [studyId] and [userId] are required.
  CARPDataPointHeader(this.studyId, this.userId,
      {this.deviceRoleName, this.triggerId, this.startTime, this.endTime});

  factory CARPDataPointHeader.fromJson(Map<String, dynamic> json) =>
      _$CARPDataPointHeaderFromJson(json);
  Map<String, dynamic> toJson() => _$CARPDataPointHeaderToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class CARPDataFormat {
  String namepace;
  String name;

  CARPDataFormat(this.namepace, this.name);
  factory CARPDataFormat.unknown() =>
      new CARPDataFormat(NameSpace.UNKNOWN_NAMESPACE, "unknown");

  factory CARPDataFormat.fromJson(Map<String, dynamic> json) =>
      _$CARPDataFormatFromJson(json);
  Map<String, dynamic> toJson() => _$CARPDataFormatToJson(this);

  @override
  String toString() {
    // TODO: implement toString
    return "$namepace.$name";
  }
}

// An abstract class represent any OMH schema.
abstract class NameSpace {
  static const String UNKNOWN_NAMESPACE = "unknown";
  static const String OMH_NAMESPACE = "omh";
  static const String CARP_NAMESPACE = "carp";
}
