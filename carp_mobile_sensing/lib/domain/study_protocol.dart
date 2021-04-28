/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of domain;

/// A description of how a study is to be executed as part of CAMS.
///
/// A [CAMSStudyProtocol] defining the master device ([MasterDeviceDescriptor])
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
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class CAMSStudyProtocol extends StudyProtocol {
  /// A unique id for this study protcol.  If specified, this id is used as
  /// the [studyId] in the [DataPointHeader].
  ///
  /// This [studyId] should **NOT** be confused with the study deployment id,
  /// which is typically generated when this protocol is deployed using a
  /// [DeploymentService].
  String studyId;

  /// The textual [StudyProtocolDescription] containing the title, description
  /// and purpose of this study protocol.
  StudyProtocolDescription protocolDescription;

  /// The owner of this study.
  ProtocolOwner owner;

  /// The unique id of the owner.
  String get ownerId => owner?.id;

  /// Specify where and how to upload this study data.
  DataEndPoint dataEndPoint;

  /// The preferred format of the data to be uploaded according to
  /// [DataFormatType]. Default using the [NameSpace.CARP].
  String dataFormat;

  /// The [masterDevice] which is responsible for aggregating and synchronizing
  /// incoming data. Typically this phone.
  MasterDeviceDescriptor get masterDevice => masterDevices.first;

  /// Create a new [StudyProtocol].
  ///
  /// If no [dataFormat] is specified, the CARP namespace is used.
  CAMSStudyProtocol({
    this.studyId,
    String name,
    this.owner,
    this.protocolDescription,
    this.dataFormat = NameSpace.CARP,
  }) : super(owner: owner, name: name) {
    // TODO - move this elsewhere.... can't assumed that the programmer
    // create a protocol - s/he might download it e.g. from CARP.
    _registerFromJsonFunctions();
    // studyId ??= Uuid().v1();
  }

  Function get fromJsonFunction => _$CAMSStudyProtocolFromJson;
  factory CAMSStudyProtocol.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json);
  Map<String, dynamic> toJson() => _$CAMSStudyProtocolToJson(this);

  String toString() => '$runtimeType - $name [$ownerId]';
}

@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class StudyProtocolDescription extends Serializable {
  /// A longer printer-friendly title for this study.
  String title;

  /// The description of this study.
  String description;

  /// The purpose of the study. To be used to inform the user about
  /// this study and its purpose.
  String purpose;

  StudyProtocolDescription({this.title, this.description, this.purpose});

  Function get fromJsonFunction => _$StudyProtocolDescriptionFromJson;
  factory StudyProtocolDescription.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json);
  Map<String, dynamic> toJson() => _$StudyProtocolDescriptionToJson(this);

  String toString() =>
      '$runtimeType - title: $title, description: $description';
}
