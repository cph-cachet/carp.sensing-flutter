/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_core_domain;

/// A description of how a study is to be executed.
///
/// This is part of the [carp.protocols](https://github.com/cph-cachet/carp.core-kotlin/blob/develop/docs/carp-protocols.md) domain model.
///
/// A [StudyProtocol] defining the master device ([MasterDeviceDescriptor])
/// responsible for aggregating data (typically this phone), the optional
/// devices ([DeviceDescriptor]) connected to the master device,
/// and the [CAMSTrigger]'s which lead to data collection on said devices.
///
/// A study may be fetched in a [StudyManager] who knows how to fetch a study
/// protocol for this device.
/// A study is controlled and executed by a [StudyController].
/// Data from the study is uploaded to the specified [DataEndPoint] in the
/// specified [dataFormat].
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class StudyProtocol extends Serializable {
  /// The id of this [StudyProtocol].
  String id;

  /// A short printer-friendly name for this study.
  String name;

  /// A longer printer-friendly title for this study.
  String title;

  /// A longer description of this study.
  String description;

  /// The purpose of the study. To be used to inform the user about
  /// this study and its purpose.
  String purpose;

  /// The PI of this study.
  PrincipalInvestigator pi;

  /// The ID of the user executing this study.
  String userId;

  /// The sampling strategy according to [SamplingSchemaType].
  String samplingStrategy = SamplingSchemaType.NORMAL;

  /// Specify where and how to upload this study data.
  DataEndPoint dataEndPoint;

  /// The preferred format of the data to be uploaded according to
  /// [DataFormatType]. Default using the [NameSpace.CARP].
  String dataFormat;

  /// The public key in a PKI setup for encryption of data in the [dataEndPoint].
  String publicKey;

  /// The devices this device needs to connect to.
  List<Device> devices = [];

  /// The set of [CAMSTrigger]s which can trigger [Task](s) in this study.
  List<CAMSTrigger> triggers = [];

  List<Measure> _measures;

  /// Get the list of all [Mesure] in this study.
  List<Measure> get measures {
    if (_measures == null) {
      _measures = [];
      triggers.forEach((trigger) =>
          trigger.tasks.forEach((task) => _measures.addAll(task.measures)));
    }

    return _measures;
  }

  /// Create a new [StudyProtocol] object with a set of configurations.
  ///
  /// The [id]  is required for a new study.
  /// If no [dataFormat] the CARP namespace is used.
  StudyProtocol({
    @required this.id,
    this.userId,
    this.pi,
    this.name,
    this.title,
    this.description,
    this.purpose,
    this.samplingStrategy,
    this.dataEndPoint,
    this.dataFormat,
    this.publicKey,
  }) : super() {
    assert(id != null, 'Cannot create a Study without an id: id=null');
    samplingStrategy ??= SamplingSchemaType.NORMAL;
    dataFormat ??= NameSpace.CARP;
  }

  Function get fromJsonFunction => _$StudyProtocolFromJson;
  factory StudyProtocol.fromJson(Map<String, dynamic> json) => FromJsonFactory()
      .fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$StudyProtocolToJson(this);

  /// Add a [CAMSTrigger] to this [StudyProtocol]
  void addTrigger(CAMSTrigger trigger) => triggers.add(trigger);

  /// Add a [Task] with a [CAMSTrigger] to this [StudyProtocol]
  void addTriggerTask(CAMSTrigger trigger, Task task) {
    if (!triggers.contains(trigger)) triggers.add(trigger);
    trigger.addTask(task);
  }

  /// The list of all [Task]s in this [StudyProtocol].
  List<Task> get tasks {
    List<Task> _tasks = [];
    triggers.forEach((trigger) => _tasks.addAll(trigger.tasks));
    return _tasks;
  }

  /// Adapt the sampling [Measure]s of this [StudyProtocol] to the specified
  /// [SamplingSchema].
  void adapt(SamplingSchema schema, {bool restore = true}) {
    assert(schema != null);
    samplingStrategy = schema.type;
    schema.adapt(this, restore: restore);
  }

  String toString() => name;
}

/// A Principal Investigator (PI) is reposnibile for a [StudyProtocol].
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class PrincipalInvestigator extends Serializable {
  String name;
  String title;
  String email;
  String address;
  String affiliation;

  PrincipalInvestigator({
    this.name,
    this.title,
    this.email,
    this.affiliation,
    this.address,
  });

  Function get fromJsonFunction => _$PrincipalInvestigatorFromJson;
  factory PrincipalInvestigator.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory()
          .fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$PrincipalInvestigatorToJson(this);

  String toString() => '$name, $title <$email>';
}

/// Specify an endpoint where a [DataManager] can upload data.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class DataEndPoint extends Serializable {
  /// The type of endpoint as enumerated in [DataEndPointTypes].
  String type;

  /// Creates a [DataEndPoint]. [type] is defined in [DataEndPointTypes].
  DataEndPoint({this.type}) : super();

  Function get fromJsonFunction => _$DataEndPointFromJson;
  factory DataEndPoint.fromJson(Map<String, dynamic> json) => FromJsonFactory()
      .fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$DataEndPointToJson(this);

  String toString() => type;
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
  static const String FIREBASE_DATABSE = 'FIREBASE_DATABSE';
  static const String CARP = 'CARP';
  static const String OMH = 'OMH';
  static const String AWS = 'AWS';
}
