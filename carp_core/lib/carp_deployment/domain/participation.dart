/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_core_deployment;

/// Expected participant [data] for all participants in a study deployment
/// with [studyDeploymentId].
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class ParticipantData {
  String studyDeploymentId;
  Map<String, dynamic> data;

  ParticipantData({
    required this.studyDeploymentId,
    required this.data,
  }) : super();

  dynamic operator [](String key) => data[key];
  operator []=(String key, dynamic value) => data[key] = value;

  factory ParticipantData.fromJson(Map<String, dynamic> json) =>
      _$ParticipantDataFromJson(json);
  Map<String, dynamic> toJson() => _$ParticipantDataToJson(this);

  String toString() => '$runtimeType - studyDeploymentId: $studyDeploymentId';
}

/// Identifies an [Account].
abstract class AccountIdentity extends Serializable {
  String get jsonType => 'dk.cachet.carp.common.users.$runtimeType';
}

/// Identifies an [AccountIdentity] using an email adress.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class EmailAccountIdentity extends AccountIdentity {
  String emailAddress;
  EmailAccountIdentity(this.emailAddress);

  Function get fromJsonFunction => _$EmailAccountIdentityFromJson;
  factory EmailAccountIdentity.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as EmailAccountIdentity;
  Map<String, dynamic> toJson() => _$EmailAccountIdentityToJson(this);

  String toString() => '$runtimeType - emailAddress: $emailAddress';
}
