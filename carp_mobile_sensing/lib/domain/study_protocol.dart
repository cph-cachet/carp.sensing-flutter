// /*
//  * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
//  * Technical University of Denmark (DTU).
//  * Use of this source code is governed by a MIT-style license that can be
//  * found in the LICENSE file.
//  */

// part of domain;

// /// A description of how a study is to be executed as part of CAMS.
// ///
// /// A [CAMSStudyProtocol] defining the master device ([MasterDeviceDescriptor])
// /// responsible for aggregating data (typically this phone), the optional
// /// devices ([DeviceDescriptor]) connected to the master device,
// /// and the [Trigger]'s which lead to data collection on said devices.
// ///
// /// A study may be fetched via a [DeploymentService] that knows how to fetch a
// /// study protocol for this device.
// ///
// /// A study is controlled and executed by a [StudyController].
// /// Data from the study is uploaded to the specified [DataEndPoint] in the
// /// specified [dataFormat].
// @JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
// class CAMSStudyProtocol extends StudyProtocol {
//   /// A unique id for this study protcol.  If specified, this id is used as
//   /// the [studyId] in the [DataPointHeader].
//   ///
//   /// This [studyId] should **NOT** be confused with the study deployment id,
//   /// which is typically generated when this protocol is deployed using a
//   /// [DeploymentService].
//   String? studyId;

//   /// The textual [StudyProtocolDescription] containing the title, description
//   /// and purpose of this study protocol.
//   StudyProtocolDescription? protocolDescription;

//   /// Create a new [StudyProtocol].
//   CAMSStudyProtocol({
//     required String ownerId,
//     required String name,
//     String? description,
//     this.studyId,
//     this.protocolDescription,
//   }) : super(ownerId: ownerId, name: name, description: description);

//   factory CAMSStudyProtocol.fromJson(Map<String, dynamic> json) =>
//       _$CAMSStudyProtocolFromJson(json);
//   Map<String, dynamic> toJson() => _$CAMSStudyProtocolToJson(this);

//   String toString() => '${super.toString()}, studyId: $studyId';
// }
