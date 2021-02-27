/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_core_domain;

// VERSION 1.2 -- EXAMPLE
//
// {
//  "id": 224038,  # set by the server, not used in upload
//  "carp_header": {
//   "study_id": "01cf04a7-d154-40f0-9a75-ab759cf74eb3",
//   "device_role_name": "unknown",
//   "trigger_id": "unknown",
//   "user_id": "user@dtu.dk",
//   "upload_time": "2021-02-27T12:27:14.933672Z",   # set by the server, not used in upload
//   "start_time": "2021-02-27T12:27:12.902614Z",
//   "end_time": "2021-02-27T12:27:14.933672Z",
//   "data_format": {
//    "namespace": "carp",
//    "name": "light"
//   }
//  },
//  "carp_body": {
//   "max_lux": 12,
//   "mean_lux": 23,
//   "id": "1e828ea0-78f7-11eb-a4c1-8518ece21966",
//   "min_lux": 0.3,
//   "std_lux": 0.4,
//   "timestamp": "2021-02-27T12:27:12.902614Z"
//  }
// }
//

/// A data point storing meta-information and the data.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class DataPoint {
  /// A unique, server-side generated ID for this data point.
  /// [null] if this data point is not yet stored.
  int id;

  /// The unique id of the user who created / uploaded this data point.
  /// [null] if this data point is not yet stored.
  ///
  /// This user id is the server-side generated user id (an integer), and *not*
  /// the user login id (a string, typically the email).
  /// This user id may, or may not, be identical to the id of the user who this
  /// data point belongs to, as specified in the [DataPointHeader].
  ///
  /// By being able to separate who uploads a data point and who the data point
  /// belongs to, allows for one user to upload data on behalf of another user.
  /// For example, a parent on behalf of a child.
  int createdByUserId;

  /// The data point header.
  DataPointHeader carpHeader;

  /// The CARP data point body. Can be any payload modelled as a [Data].
  Data carpBody;

  /// Create a new [DataPoint].
  DataPoint(this.carpHeader, this.carpBody);

  /// Create a [DataPoint] from a JSON map.
  factory DataPoint.fromJson(Map<String, dynamic> json) =>
      _$DataPointFromJson(json);

  /// Serialize this [DataPoint] as a JSON map.
  Map<String, dynamic> toJson() => _$DataPointToJson(this);
}

/// The header (meta-data) attached to all [DataPoint]s.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class DataPointHeader {
  /// The study deployment id of the [StudyDeployment] from which this data
  /// point was generated.
  String studyId;

  /// The role of the device that collected this data point.
  String deviceRoleName;

  /// The id of the [Trigger] in the study deployment that generated this data point.
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

  /// The data format. See [DataType] and [NameSpace].
  DataFormat dataFormat;

  /// Create a new [DataPointHeader]. [studyId] is required.
  DataPointHeader({
    @required this.studyId,
    this.userId,
    this.deviceRoleName,
    this.triggerId,
    this.startTime,
    this.endTime,
    this.dataFormat,
  }) {
    assert(
      studyId != null,
      'Must specify what study this data point belongs to',
    );
    // make sure that timestamps are in UTC
    if (startTime != null) startTime.toUtc();
    if (endTime != null) endTime.toUtc();
    // [deviceRoleName] and [triggerId] has to be specified when sending this data point to the CARP web service.
    // TODO - need to add device and triggers to the domain model.
    deviceRoleName ??= "unknown";
    triggerId ??= "unknown";
    dataFormat ??= DataFormat.UNKNOWN;
  }

  /// Create a [DataPointHeader] from a JSON map.
  factory DataPointHeader.fromJson(Map<String, dynamic> json) =>
      _$DataPointHeaderFromJson(json);

  /// Return a JSON encoding of this object.
  Map<String, dynamic> toJson() => _$DataPointHeaderToJson(this);
}

/// Specifies the format of the [Data] in a [DataPoint].
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class DataFormat with DataType {
  static final DataFormat UNKNOWN = DataFormat(NameSpace.CARP, 'unknown');

  /// Create a [DataFormat].
  DataFormat(String namespace, String name) : super() {
    super.namespace = namespace;
    super.name = name;
  }

  factory DataFormat.fromJson(Map<String, dynamic> json) =>
      _$DataFormatFromJson(json);
  Map<String, dynamic> toJson() => _$DataFormatToJson(this);
}
