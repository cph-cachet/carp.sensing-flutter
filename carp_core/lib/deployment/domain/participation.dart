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

  /// Data that is related to everyone in the study deployment.
  Map<String, Data> common;

  /// Data that is related to specific roles in the study deployment.
  List<RoleData> roles;

  ParticipantData({
    required this.studyDeploymentId,
    this.common = const {},
    this.roles = const [],
  }) : super();

  factory ParticipantData.fromJson(Map<String, dynamic> json) =>
      _$ParticipantDataFromJson(json);
  Map<String, dynamic> toJson() => _$ParticipantDataToJson(this);
}

/// Expected participant [data] for all participants in a study deployment
/// with [studyDeploymentId].
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class RoleData {
  String roleName;

  /// Data that is related to everyone in the study deployment.
  Map<String, Data> data;

  RoleData({
    required this.roleName,
    this.data = const {},
  }) : super();

  factory RoleData.fromJson(Map<String, dynamic> json) =>
      _$RoleDataFromJson(json);
  Map<String, dynamic> toJson() => _$RoleDataToJson(this);
}

/// Identifies an [Account].
abstract class AccountIdentity extends Serializable {
  @override
  String get jsonType => 'dk.cachet.carp.common.users.$runtimeType';
}

/// Identifies an [AccountIdentity] using an email adress.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class EmailAccountIdentity extends AccountIdentity {
  String emailAddress;
  EmailAccountIdentity(this.emailAddress);

  @override
  Function get fromJsonFunction => _$EmailAccountIdentityFromJson;
  factory EmailAccountIdentity.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as EmailAccountIdentity;
  @override
  Map<String, dynamic> toJson() => _$EmailAccountIdentityToJson(this);

  @override
  String toString() => '$runtimeType - emailAddress: $emailAddress';
}
