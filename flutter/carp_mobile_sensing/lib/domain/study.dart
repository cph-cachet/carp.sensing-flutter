/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_mobile_sensing/domain/serialization.dart';
import 'package:json_annotation/json_annotation.dart';

part 'study.g.dart';

/**
 * The [Study] holds information about the study to be performed on this device.
 * The study may be fetched in a [StudyManager] who knows how to fetch a study protocol for this device.
 *
 * A [Study] mainly consists of a list of [Task]s.
 */
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class Study extends Serializable {
  String id;
  String userId;
  String name;
  String description;

  /// Specify where and how to upload this study data.
  DataEndPoint dataEndPoint;

  List<Task> tasks = new List<Task>();

  Study(this.id, this.userId, {this.name, this.description}) : super();

  static Function get fromJsonFunction => _$StudyFromJson;
  factory Study.fromJson(Map<String, dynamic> json) => _$StudyFromJson(json);
  Map<String, dynamic> toJson() => _$StudyToJson(this);

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
  factory DataEndPoint.fromJson(Map<String, dynamic> json) => _$DataEndPointFromJson(json);
  Map<String, dynamic> toJson() => _$DataEndPointToJson(this);
}

/// Specify an endpoint where a [FileDataManager] can store JSON data as files on the local device.
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
  /// Support only one-way encryption using the a public key.
  bool encrypt = false;

  /// If [encrypt] is true, this should hold the public key in a RSA KPI encryption of data.
  String publicKey;

  /// Creates a [FileDataEndPoint]. [type] is defined in [DataEndPointType].
  FileDataEndPoint(String type) : super(type);

  static Function get fromJsonFunction => _$FileDataEndPointFromJson;
  factory FileDataEndPoint.fromJson(Map<String, dynamic> json) => _$FileDataEndPointFromJson(json);
  Map<String, dynamic> toJson() => _$FileDataEndPointToJson(this);
}

/// Specify a RESTful data endpoint where a [DataManager] can upload data.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class RESTDataEndPoint extends DataEndPoint {
  /// The HTTP method to use in a REST call to upload data. See [HTTPMethod]. Typically POST.
  HTTPMethod method;

  /// The URI of the REST end point.
  Uri uri;

  UploadStrategy uploadStrategy = UploadStrategy.CONTINUOUSLY;

  /// Creates a [DataEndPoint]. [type] is defined in [DataEndPointType].
  RESTDataEndPoint(String type, {this.uri, this.method, this.uploadStrategy}) : super(type);

  factory RESTDataEndPoint.fromJson(Map<String, dynamic> json) => _$RESTDataEndPointFromJson(json);
  Map<String, dynamic> toJson() => _$RESTDataEndPointToJson(this);
}

/// A enumeration of possible endpoint API types.
class DataEndPointType {
  // TODO : we need to establish the mapping of these -- are these the right names for the data endpoint types?
  static const String PRINT = "print";
  static const String FILE = "file";
  static const String FIREBASE = "firebase";
  static const String CARP = "carp";
  static const String OMH = "omh";
}

/// HTTP Methods
enum HTTPMethod { GET, POST, HEAD, PUT, DELETE }

/// A enumeration of possible upload strategies for this end point.
///
// TODO : Currently not implemented.
enum UploadStrategy { CONTINUOUSLY, PERIODIC }
