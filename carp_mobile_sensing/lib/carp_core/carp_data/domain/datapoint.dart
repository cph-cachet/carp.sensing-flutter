/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_core;

// VERSION 1.2 -- EXAMPLE
//
// {
//  "id": 224038,  # set by the server, not used in upload
//  "created_by_user_id": 1,
//  "study_id": "c9d341ae-2209-4a70-b9a1-09446bb05dca",
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
//   "id": "1e828ea0-78f7-11eb-a4c1-8518ece21966",
//   "timestamp": "2021-02-27T12:27:12.902614Z"
//   "max_lux": 12,
//   "mean_lux": 23,
//   "min_lux": 0.3,
//   "std_lux": 0.4,
//  }
// }
//

/// A data point storing meta-information and the data.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class DataPoint {
  /// A unique, server-side generated ID for this data point.
  /// `null` if this data point is not yet stored.
  int id;

  /// The unique id of the user who created / uploaded this data point.
  /// `null` if this data point is not yet stored.
  ///
  /// This user id is the server-side generated user id (an integer), and **NOT**
  /// the user id that this data point belongs to, which is stored in the
  /// [DataPointHeader] as the [userId] (a string, typically the email).
  ///
  /// This [createdByUserId] id may, or may not, be identical to the id of the
  /// user who this data point belongs to.
  /// By being able to separate who uploads a data point and who the data point
  /// belongs to, allows for one user to upload data on behalf of another user.
  /// For example, a parent on behalf of a child.
  int createdByUserId;

  /// The unique study deployment id that this data point belongs to / is uploaded
  /// as part of. Set by the server.
  /// `null` if this data point is not yet stored.
  String studyId;

  /// The data point header.
  DataPointHeader carpHeader;

  /// The CARP data point body. Can be any payload modelled as a [Data].
  Data carpBody;

  /// Create a new [DataPoint].
  DataPoint(this.carpHeader, this.carpBody);

  /// Create a [DataPoint] from a [Data].
  factory DataPoint.fromData(
    Data data, {
    int triggerId,
    String deviceRoleName,
  }) =>
      DataPoint(
          DataPointHeader(
            dataFormat: data.format,
            triggerId: (triggerId != null) ? '$triggerId' : '',
            deviceRoleName: deviceRoleName ?? '',
            startTime: DateTime.now(),
          ),
          data);

  /// Create a [DataPoint] from a JSON map.
  factory DataPoint.fromJson(Map<String, dynamic> json) =>
      _$DataPointFromJson(json);

  /// Serialize this [DataPoint] as a JSON map.
  Map<String, dynamic> toJson() => _$DataPointToJson(this);
}

/// The header (meta-data) attached to all [DataPoint]s.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class DataPointHeader {
  /// An ID of this study.
  ///
  /// This is typically the study deployment id of the [StudyDeployment] from
  /// which this data point was generated. But it may be different, in which case
  /// it denotes a user-specified id for this study.
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

  /// The data format. See [DataFormat] and [NameSpace].
  DataFormat dataFormat;

  /// Create a new [DataPointHeader].
  DataPointHeader({
    this.studyId,
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
///
/// Note that the only reason why we have both a [DataType] and a [DataFormat]
/// class definition is because the JSON serialization is different in data
/// upload versus download from CANS.... :-?
/// Upload is `FieldRename.snake` while download is `FieldRename.none`.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class DataFormat {
  static final DataFormat UNKNOWN = DataFormat(NameSpace.CARP, 'unknown');

  /// The data type namespace. See [NameSpace].
  ///
  /// Uniquely identifies the organization/person who determines how to
  /// interpret [name].
  /// To prevent conflicts, a reverse domain namespace is suggested:
  /// e.g., "org.openmhealth" or "dk.cachet.carp".
  final String namespace;

  /// The name of this data format. See [DataType].
  ///
  /// Uniquely identifies something within the [namespace].
  /// The name may not contain any periods. Periods are reserved for namespaces.
  final String name;

  /// Create a [DataFormat].
  const DataFormat(this.namespace, this.name) : super();

  factory DataFormat.fromJson(Map<String, dynamic> json) =>
      _$DataFormatFromJson(json);
  Map<String, dynamic> toJson() => _$DataFormatToJson(this);
}
