/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of carp_core_deployment;

// -----------------------------------------------------
// Participation Service Requests
// See https://github.com/cph-cachet/carp.core-kotlin/blob/develop/carp.deployment.core/src/commonMain/kotlin/dk/cachet/carp/deployment/infrastructure/ParticipationServiceRequest.kt
// -----------------------------------------------------

/// A [ParticipationServiceRequest] and its sub-classes contain the data for
/// sending a participant request to the CARP web service.
///
/// All participant requests to the CARP Service is defined in
/// [carp.core-kotlin](https://github.com/cph-cachet/carp.core-kotlin/blob/develop/carp.deployment.core/src/commonMain/kotlin/dk/cachet/carp/deployment/infrastructure/ParticipationServiceRequest.kt)
abstract class ParticipationServiceRequest extends DeploymentServiceRequest {
  final String _serviceRequestPackageNamespace =
      'dk.cachet.carp.deployment.infrastructure.ParticipationServiceRequest';
  ParticipationServiceRequest([String? studyDeploymentId])
      : super(studyDeploymentId);
  String get jsonType => '$_serviceRequestPackageNamespace.$runtimeType';
}

/// A request for getting the deployment invitations for an account id.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: true)
class GetActiveParticipationInvitations extends ParticipationServiceRequest {
  GetActiveParticipationInvitations(this.accountId) : super();

  @JsonKey(ignore: true)
  String? studyDeploymentId;

  /// The CARP account (user) ID.
  String accountId;

  Function get fromJsonFunction => _$GetActiveParticipationInvitationsFromJson;
  factory GetActiveParticipationInvitations.fromJson(
          Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as GetActiveParticipationInvitations;
  Map<String, dynamic> toJson() =>
      _$GetActiveParticipationInvitationsToJson(this);

  String toString() => '$runtimeType - accountId: $accountId';
}

/// A request for getting the status of a study deployment.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: true)
class GetParticipantData extends ParticipationServiceRequest {
  GetParticipantData(String studyDeploymentId) : super(studyDeploymentId);

  Function get fromJsonFunction => _$GetParticipantDataFromJson;
  factory GetParticipantData.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as GetParticipantData;
  Map<String, dynamic> toJson() => _$GetParticipantDataToJson(this);
}

/// A request for getting the list of partication data for this a list
/// of [studyDeploymentIds].
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: true)
class GetParticipantDataList extends ParticipationServiceRequest {
  List<String> studyDeploymentIds;
  GetParticipantDataList(this.studyDeploymentIds) : super();

  Function get fromJsonFunction => _$GetParticipantDataListFromJson;
  factory GetParticipantDataList.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as GetParticipantDataList;
  Map<String, dynamic> toJson() => _$GetParticipantDataListToJson(this);
}

/// A request for adding data for a participant.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: true)
class SetParticipantData extends ParticipationServiceRequest {
  SetParticipantData(String studyDeploymentId, this.inputDataType, this.data)
      : super(studyDeploymentId);

  /// The input data type.
  String inputDataType;

  /// The data to be set.
  ParticipantData data;

  Function get fromJsonFunction => _$SetParticipantDataFromJson;
  factory SetParticipantData.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as SetParticipantData;
  Map<String, dynamic> toJson() => _$SetParticipantDataToJson(this);

  String toString() => '${super.toString()}, inputDataType: $inputDataType';
}
