/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_core;

/// Set [data] for all expected participant data in the study deployment
/// with [studyDeploymentId].
/// Data which is not set equals null.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class ParticipantData {
  String studyDeploymentId;
  Map<String, dynamic> data;

  ParticipantData({this.studyDeploymentId, this.data}) : super();

  operator [](String key) => data[key];
  operator []=(String key, dynamic value) => data[key] = value;

  factory ParticipantData.fromJson(Map<String, dynamic> json) =>
      _$ParticipantDataFromJson(json);
  Map<String, dynamic> toJson() => _$ParticipantDataToJson(this);

  String toString() => '$runtimeType - studyDeploymentId: $studyDeploymentId';
}
