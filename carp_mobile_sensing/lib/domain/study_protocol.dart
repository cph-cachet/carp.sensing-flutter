/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of domain;

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class TestStudyProtocol extends carp_core_domain.Serializable
    with carp_core_domain.StudyProtocol {
  /// A longer printer-friendly title for this study.
  String title;

  DataType get dataType => DataType('1', '2');

  MasterDeviceDescriptor get masterDevice =>
      masterDevices.first as MasterDeviceDescriptor;

  @override
  // TODO: implement fromJsonFunction
  Function get fromJsonFunction => throw UnimplementedError();

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}

/// A description of how a study is to be executed.
///
/// A [StudyProtocol] defining the master device ([MasterDeviceDescriptor])
/// responsible for aggregating data (typically this phone), the optional
/// devices ([DeviceDescriptor]) connected to the master device,
/// and the [Trigger]'s which lead to data collection on said devices.
///
/// A study may be fetched via a [DeploymentService] that knows how to fetch a
/// study protocol for this device.
///
/// A study is controlled and executed by a [StudyController].
/// Data from the study is uploaded to the specified [DataEndPoint] in the
/// specified [dataFormat].
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class StudyProtocol extends carp_core_domain.Serializable
    with carp_core_domain.StudyProtocol {
  /// A longer printer-friendly title for this study.
  String title;

  /// The purpose of the study. To be used to inform the user about
  /// this study and its purpose.
  String purpose;

  /// The owner of this study.
  ProtocolOwner owner;

  String get ownerId => owner.id;

  /// The sampling strategy according to [SamplingSchemaType].
  String samplingStrategy = SamplingSchemaType.NORMAL;

  /// Specify where and how to upload this study data.
  DataEndPoint dataEndPoint;

  /// The preferred format of the data to be uploaded according to
  /// [DataFormatType]. Default using the [NameSpace.CARP].
  String dataFormat;

  /// The [masterDevice] which is responsible for aggregating and synchronizing
  /// incoming data. Typically this phone.
  MasterDeviceDescriptor get masterDevice =>
      masterDevices.first as MasterDeviceDescriptor;

  /// Create a new [StudyProtocol].
  ///
  /// If no [dataFormat] the CARP namespace is used.
  StudyProtocol({
    this.owner,
    String name,
    this.title,
    String description,
    this.purpose,
    this.samplingStrategy,
    this.dataEndPoint,
    this.dataFormat,
  }) : super() {
    super.name = name;
    super.description = description;
    samplingStrategy ??= SamplingSchemaType.NORMAL;
    dataFormat ??= NameSpace.CARP;
  }

  /// Get the list of all [Mesure]s in this study protocol.
  List<Measure> get measures {
    List<Measure> _measures = [];
    tasks.forEach((task) => _measures.addAll(task.measures));

    return _measures;
  }

  /// Adapt the sampling [Measure]s of this [StudyProtocol] to the specified
  /// [SamplingSchema].
  void adapt(SamplingSchema schema, {bool restore = true}) {
    assert(schema != null);
    samplingStrategy = schema.format;
    schema.adapt(this, restore: restore);
  }

  Function get fromJsonFunction => _$CAMSStudyProtocolFromJson;
  factory StudyProtocol.fromJson(Map<String, dynamic> json) => FromJsonFactory()
      .fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$CAMSStudyProtocolToJson(this);

  String toString() => '$runtimeType - $name, $title';
}

/// A person that created a [StudyProtocol].
/// Typically the Principal Investigator (PI) who is reposnibile for the study.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class ProtocolOwner extends carp_core_domain.Serializable {
  String id;
  String name;
  String title;
  String email;
  String address;
  String affiliation;

  ProtocolOwner({
    this.id,
    this.name,
    this.title,
    this.email,
    this.affiliation,
    this.address,
  });

  Function get fromJsonFunction => _$ProtocolOwnerFromJson;
  factory ProtocolOwner.fromJson(Map<String, dynamic> json) => FromJsonFactory()
      .fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$ProtocolOwnerToJson(this);

  String toString() => '$runtimeType - $name, $title <$email>';
}

/// Specify an endpoint where a [DataManager] can upload data.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class DataEndPoint extends carp_core_domain.Serializable {
  /// The type of endpoint as enumerated in [DataEndPointTypes].
  String type;

  /// The public key in a PKI setup for encryption of data
  String publicKey;

  /// Creates a [DataEndPoint]. [type] is defined in [DataEndPointTypes].
  DataEndPoint({this.type, this.publicKey}) : super();

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
