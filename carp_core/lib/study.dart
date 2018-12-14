/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_core;

/// The [Study] holds information about the study to be performed on this device.
/// The study may be fetched in a [StudyManager] who knows how to fetch a study protocol for this device.
///
/// A [Study] mainly consists of a list of [Task]s, which again consists of a list of [Measure]s.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class Study extends Serializable {
  /// The ID of this [Study].
  String id;

  /// The ID of the user executing this study. May be [null] if no user is known.
  String userId;

  /// A printer-friendly name for this study.
  String name;

  /// A longer description of this study. To be used to inform the user about this study and its purpose.
  String description;

  /// Specify where and how to upload this study data.
  DataEndPoint dataEndPoint;

  /// The list of [Task]s in this [Study].
  List<Task> tasks = new List<Task>();

  Study(this.id, this.userId, {this.name, this.description}) : super();

  static Function get fromJsonFunction => _$StudyFromJson;
  factory Study.fromJson(Map<String, dynamic> json) => _$StudyFromJson(json);
  Map<String, dynamic> toJson() => _$StudyToJson(this);

  /// Add a [Task] to this [Study]
  void addTask(Task task) => tasks.add(task);

  @override
  String toString() {
    String s = "";
    s += "Study  id : " + id + "\n";
    s += "     name : " + name + "\n";
    s += "     user : " + userId + "\n";
    s += " endpoint : " + dataEndPoint.type + "\n";
    tasks.forEach((t) {
      s += t.toString();
    });
    return s;
  }
}

/// Specify an endpoint where a [DataManager] can upload data.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class DataEndPoint extends Serializable {
  /// The type of endpoint as enumerated in [DataEndPointType].
  String type;

  /// Creates a simple [DataEndPoint]. [type] is defined in [DataEndPointType].
  DataEndPoint(this.type) : super();

  static Function get fromJsonFunction => _$DataEndPointFromJson;
  factory DataEndPoint.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory.fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$DataEndPointToJson(this);
}

/// Specify an endpoint where a file-based [DataManager] can store JSON data as files on the local device.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class FileDataEndPoint extends DataEndPoint {
  /// The buffer size of the raw JSON file in bytes.
  ///
  /// All Probed data will be written to a JSON file until the buffer is filled, at which time
  /// the file will be zipped. There is not a single-best [bufferSize] value.
  /// If data are collected at high rates, a higher value will be best to minimize
  /// zip operations. If data are collected at low rates, a lower value will be best
  /// to minimize the likelihood of data loss when the app is killed or crashes.
  /// Default size is 500 KB.
  int bufferSize = 500 * 1000;

  ///Is data to be compressed (zipped) before storing in a file. True as default.
  ///
  /// If zipped, the JSON file will be reduced to 1/5 of its size.
  /// For example, the 500 KB buffer typically is reduced to ~100 KB.
  bool zip = true;

  ///Is data to be encrypted before storing. False as default.
  ///
  /// Support only one-way encryption using a public key.
  bool encrypt = false;

  /// If [encrypt] is true, this should hold the public key in a RSA KPI encryption of data.
  String publicKey;

  /// Creates a [FileDataEndPoint]. [type] is defined in [DataEndPointType].
  FileDataEndPoint({String type, this.bufferSize, this.zip, this.encrypt, this.publicKey})
      : super(type == null ? DataEndPointType.FILE : type);

  static Function get fromJsonFunction => _$FileDataEndPointFromJson;
  factory FileDataEndPoint.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory.fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$FileDataEndPointToJson(this);
}

/// A enumeration of known endpoint API types.
class DataEndPointType {
  static const String PRINT = "print";
  static const String FILE = "file";
  static const String FIREBASE_STORAGE = "firebase-storage";
  static const String FIREBASE_DATABASE = "firebase-database";
  static const String CARP = "carp";
  static const String OMH = "omh";
}
