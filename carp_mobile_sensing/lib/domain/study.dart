/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of domain;

/// The [Study] holds information about the study to be performed on this device.
///
/// A [Study] specify a set of [Trigger]s, each consisting of a set of [Task]s,
/// which again consists of a list of [Measure]s.
///
///   `Study---*Trigger---*Task---*Measure`
///
/// A study may be fetched in a [StudyManager] who knows how to fetch a study protocol for this device.
/// A study is controlled and executed by a [StudyController].
/// Data from the study is uploaded to the specified [DataEndPoint] in the specified [dataFormat].
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class Study extends Serializable {
  /// The id of this [Study].
  String id;

  /// The ID of the user executing this study. May be [null] if no user is known.
  String userId;

  /// A printer-friendly name for this study.
  String name;

  /// A longer description of this study. To be used to inform the user about this study and its purpose.
  String description;

  /// The sampling strategy according to [SamplingSchemaType].
  String samplingStrategy = SamplingSchemaType.NORMAL;

  /// Specify where and how to upload this study data.
  DataEndPoint dataEndPoint;

  /// The preferred format of the data to be uploaded according to [DataFormatType].
  /// Default using the [NameSpace.CARP].
  String dataFormat;

  /// The set of [Trigger]s which can trigger [Task](s) in this study.
  List<Trigger> triggers = new List<Trigger>();

  /// Create a new [Study] object with a set of configurations.
  ///
  /// The [id] and [userId] are required for a new study.
  Study(this.id, this.userId, {this.name, this.description, this.samplingStrategy, this.dataEndPoint, this.dataFormat})
      : assert(id != null, 'Cannot create a Study without an id: id=null'),
        assert(userId != null, 'Cannot create a Study without an user id: userId=null'),
        super() {
    samplingStrategy ??= SamplingSchemaType.NORMAL;
    dataFormat ??= NameSpace.CARP;
  }

  static Function get fromJsonFunction => _$StudyFromJson;

  factory Study.fromJson(Map<String, dynamic> json) => _$StudyFromJson(json);

  Map<String, dynamic> toJson() => _$StudyToJson(this);

  /// Add a [Trigger] to this [Study]
  void addTrigger(Trigger trigger) => triggers.add(trigger);

  /// Add a [Task] with a [Trigger] to this [Study]
  void addTriggerTask(Trigger trigger, Task task) {
    if (!triggers.contains(trigger)) triggers.add(trigger);
    trigger.addTask(task);
  }

  /// The list of all [Task]s in this [Study].
  List<Task> get tasks {
    List<Task> _tasks = List<Task>();
    triggers.forEach((trigger) => _tasks.addAll(trigger.tasks));
    return _tasks;
  }

  /// Adapt the sampling [Measure]s of this [Study] to the specified [SamplingSchema].
  void adapt(SamplingSchema schema, {bool restore = true}) {
    assert(schema != null);
    samplingStrategy = schema.type;
    schema.adapt(this, restore: restore);
  }

  String toString() => name;
}

/// Specify an endpoint where a [DataManager] can upload data.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class DataEndPoint extends Serializable {
  /// The type of endpoint as enumerated in [DataEndPointType].
  DataEndPointType type;

  /// Creates a [DataEndPoint]. [type] is defined in [DataEndPointType].
  DataEndPoint(this.type)
      : assert(type != null),
        super();

  static Function get fromJsonFunction => _$DataEndPointFromJson;
  //factory DataEndPoint.fromJson(Map<String, dynamic> json) => _$DataEndPointFromJson(json);
  factory DataEndPoint.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory.fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$DataEndPointToJson(this);

  String toString() => type.toString();
}

/// A enumeration of known (but not necessarily implemented) endpoint API types.
enum DataEndPointType {
  UNKNOWN,
  PRINT,
  FILE,
  SQLITE,
  FIREBASE_STORAGE,
  FIREBASE_DATABSE,
  CARP,
  OMH,
  AWS,
}
