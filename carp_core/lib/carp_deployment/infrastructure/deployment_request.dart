/*
 * Copyright 2020 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of carp_core_deployment;

// -----------------------------------------------------
// Deployment Service Requests
// See https://github.com/cph-cachet/carp.core-kotlin/blob/develop/carp.deployment.core/src/commonMain/kotlin/dk/cachet/carp/deployment/infrastructure/DeploymentServiceRequest.kt
// -----------------------------------------------------

/// A [DeploymentServiceRequest] and all its sub-classes contain the data for
/// sending a RPC request to the CARP web service.
///
/// All deployment requests to the CARP Service is defined in
/// [carp.core-kotlin](https://github.com/cph-cachet/carp.core-kotlin/blob/develop/carp.deployment.core/src/commonMain/kotlin/dk/cachet/carp/deployment/infrastructure/DeploymentServiceRequest.kt)
abstract class DeploymentServiceRequest extends ServiceRequest {
  final String _infrastructurePackageNamespace =
      'dk.cachet.carp.deployment.infrastructure';
  DeploymentServiceRequest([this.studyDeploymentId]) : super();

  /// The CARP study deployment ID.
  String? studyDeploymentId;

  String get jsonType =>
      '$_infrastructurePackageNamespace.DeploymentServiceRequest.$runtimeType';

  String toString() => '$runtimeType - studyDeploymentId: $studyDeploymentId';
}

/// A request for creating a deployment based on the [protocol].
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: true)
class CreateStudyDeployment extends DeploymentServiceRequest {
  StudyProtocol protocol;

  @JsonKey(ignore: true)
  String? studyDeploymentId;

  CreateStudyDeployment(this.protocol) : super();

  Function get fromJsonFunction => _$CreateStudyDeploymentFromJson;
  factory CreateStudyDeployment.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as CreateStudyDeployment;
  Map<String, dynamic> toJson() => _$CreateStudyDeploymentToJson(this);

  String toString() => '$runtimeType - protocol: ${protocol.name}}';
}

/// A request for getting the status of a study deployment.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: true)
class GetStudyDeploymentStatus extends DeploymentServiceRequest {
  GetStudyDeploymentStatus(String studyDeploymentId) : super(studyDeploymentId);

  Function get fromJsonFunction => _$GetStudyDeploymentStatusFromJson;
  factory GetStudyDeploymentStatus.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as GetStudyDeploymentStatus;
  Map<String, dynamic> toJson() => _$GetStudyDeploymentStatusToJson(this);
}

/// A request for getting the status of a list of study deployment.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: true)
class GetStudyDeploymentStatusList extends DeploymentServiceRequest {
  List<String> studyDeploymentIds;

  GetStudyDeploymentStatusList(this.studyDeploymentIds) : super();

  Function get fromJsonFunction => _$GetStudyDeploymentStatusListFromJson;
  factory GetStudyDeploymentStatusList.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as GetStudyDeploymentStatusList;
  Map<String, dynamic> toJson() => _$GetStudyDeploymentStatusListToJson(this);
}

/// A request for registering this device.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: true)
class RegisterDevice extends DeploymentServiceRequest {
  RegisterDevice(
      String studyDeploymentId, this.deviceRoleName, this.registration)
      : super(studyDeploymentId);

  /// The role name of this device.
  String deviceRoleName;

  /// The registration.
  DeviceRegistration registration;

  Function get fromJsonFunction => _$RegisterDeviceFromJson;
  factory RegisterDevice.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as RegisterDevice;
  Map<String, dynamic> toJson() => _$RegisterDeviceToJson(this);

  String toString() => '${super.toString()}, deviceRoleName: $deviceRoleName';
}

/// A request for unregistering this device.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: true)
class UnregisterDevice extends DeploymentServiceRequest {
  UnregisterDevice(String studyDeploymentId, this.deviceRoleName)
      : super(studyDeploymentId);

  /// The role name of this device.
  String deviceRoleName;

  Function get fromJsonFunction => _$UnregisterDeviceFromJson;
  factory UnregisterDevice.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as UnregisterDevice;
  Map<String, dynamic> toJson() => _$UnregisterDeviceToJson(this);

  String toString() => '${super.toString()}, deviceRoleName: $deviceRoleName';
}

/// A request for getting the deployment for this master device.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: true)
class GetDeviceDeploymentFor extends DeploymentServiceRequest {
  GetDeviceDeploymentFor(String studyDeploymentId, this.masterDeviceRoleName)
      : super(studyDeploymentId);

  /// The role name of this master device.
  String masterDeviceRoleName;

  Function get fromJsonFunction => _$GetDeviceDeploymentForFromJson;
  factory GetDeviceDeploymentFor.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as GetDeviceDeploymentFor;
  Map<String, dynamic> toJson() => _$GetDeviceDeploymentForToJson(this);

  String toString() =>
      '${super.toString()}, masterDeviceRoleName: $masterDeviceRoleName';
}

/// A request for reporting this deployment as successful.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: true)
class DeploymentSuccessful extends GetDeviceDeploymentFor {
  /// Timestamp when this was last updated in UTC
  DateTime? deviceDeploymentLastUpdateDate;

  DeploymentSuccessful(
    String studyDeploymentId,
    String masterDeviceRoleName,
    DateTime deviceDeploymentLastUpdateDate,
  ) : super(studyDeploymentId, masterDeviceRoleName);

  Function get fromJsonFunction => _$DeploymentSuccessfulFromJson;
  factory DeploymentSuccessful.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as DeploymentSuccessful;
  Map<String, dynamic> toJson() => _$DeploymentSuccessfulToJson(this);

  String toString() =>
      '${super.toString()}, masterDeviceRoleName: $masterDeviceRoleName';
}

/// A request for permanently stopping a study deployment.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: true)
class Stop extends DeploymentServiceRequest {
  Stop(String studyDeploymentId) : super(studyDeploymentId);

  Function get fromJsonFunction => _$StopFromJson;
  factory Stop.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as Stop;
  Map<String, dynamic> toJson() => _$StopToJson(this);
}
