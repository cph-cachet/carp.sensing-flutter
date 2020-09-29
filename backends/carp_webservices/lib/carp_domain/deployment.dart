/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of carp_domain;

// -----------------------------------------------------
// Deployment Service Requests
// See https://github.com/cph-cachet/carp.core-kotlin/blob/develop/carp.deployment.core/src/commonMain/kotlin/dk/cachet/carp/deployment/infrastructure/DeploymentServiceRequest.kt
// -----------------------------------------------------

/// A [DeploymentServiceRequest] contains the data for sending a request
/// to the CARP web service.
///
/// All deployment requests to the CARP Service is defined in
/// [carp.core-kotlin](https://github.com/cph-cachet/carp.core-kotlin/blob/develop/carp.deployment.core/src/commonMain/kotlin/dk/cachet/carp/deployment/infrastructure/DeploymentServiceRequest.kt)
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class DeploymentServiceRequest extends Serializable {
  DeploymentServiceRequest(this.studyDeploymentId) : super() {
    $type = 'dk.cachet.carp.deployment.infrastructure.DeploymentServiceRequest';
  }

  /// The CARP study deployment ID.
  String studyDeploymentId;

  static Function get fromJsonFunction => _$DeploymentServiceRequestFromJson;
  factory DeploymentServiceRequest.fromJson(Map<String, dynamic> json) => FromJsonFactory.fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$DeploymentServiceRequestToJson(this);

  String toString() => "$runtimeType - studyDeploymentId: $studyDeploymentId";
}

/// A request for getting the status of a study deployment.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class GetStudyDeploymentStatus extends DeploymentServiceRequest {
  GetStudyDeploymentStatus(String studyDeploymentId) : super(studyDeploymentId) {
    $type = 'dk.cachet.carp.deployment.infrastructure.DeploymentServiceRequest.GetStudyDeploymentStatus';
  }

  static Function get fromJsonFunction => _$GetStudyDeploymentStatusFromJson;
  factory GetStudyDeploymentStatus.fromJson(Map<String, dynamic> json) => FromJsonFactory.fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$GetStudyDeploymentStatusToJson(this);

  String toString() => super.toString();
}

/// A request for registering this device.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class RegisterDevice extends DeploymentServiceRequest {
  RegisterDevice(String studyDeploymentId, this.deviceRoleName, this.registration) : super(studyDeploymentId) {
    $type = 'dk.cachet.carp.deployment.infrastructure.DeploymentServiceRequest.RegisterDevice';
  }

  /// The role name of this device.
  String deviceRoleName;

  /// The registration.
  DeviceRegistration registration;

  static Function get fromJsonFunction => _$RegisterDeviceFromJson;
  factory RegisterDevice.fromJson(Map<String, dynamic> json) => FromJsonFactory.fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$RegisterDeviceToJson(this);

  String toString() => '${super.toString()}, deviceRoleName: $deviceRoleName';
}

/// A request for unregistering this device.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: true)
class UnregisterDevice extends DeploymentServiceRequest {
  UnregisterDevice(String studyDeploymentId, this.deviceRoleName) : super(studyDeploymentId) {
    $type = 'dk.cachet.carp.deployment.infrastructure.DeploymentServiceRequest.UnregisterDevice';
  }

  /// The role name of this device.
  String deviceRoleName;

  static Function get fromJsonFunction => _$UnregisterDeviceFromJson;
  factory UnregisterDevice.fromJson(Map<String, dynamic> json) => FromJsonFactory.fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$UnregisterDeviceToJson(this);

  String toString() => '${super.toString()}, deviceRoleName: $deviceRoleName';
}

/// A device registration description used in a [RegisterDevice] request.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class DeviceRegistration extends Serializable {
  DeviceRegistration({this.registrationCreationDate, this.deviceId}) : super() {
    $type = 'dk.cachet.carp.protocols.domain.devices.DefaultDeviceRegistration';
    registrationCreationDate ??= DateTime.now().millisecondsSinceEpoch;
  }

  /// The registration time in milliseconds since epoch.
  int registrationCreationDate;

  /// A unique device id for this deployment.
  String deviceId;

  static Function get fromJsonFunction => _$DeviceRegistrationFromJson;
  factory DeviceRegistration.fromJson(Map<String, dynamic> json) => FromJsonFactory.fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$DeviceRegistrationToJson(this);

  String toString() => '${super.toString()}, deviceId: $deviceId, registrationCreationDate: $registrationCreationDate';
}

/// A request for getting the deployment for this master device.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: true)
class GetDeviceDeploymentFor extends DeploymentServiceRequest {
  GetDeviceDeploymentFor(String studyDeploymentId, this.masterDeviceRoleName) : super(studyDeploymentId) {
    $type = 'dk.cachet.carp.deployment.infrastructure.DeploymentServiceRequest.GetDeviceDeploymentFor';
  }

  /// The role name of this master device.
  String masterDeviceRoleName;

  static Function get fromJsonFunction => _$GetDeviceDeploymentForFromJson;
  factory GetDeviceDeploymentFor.fromJson(Map<String, dynamic> json) => FromJsonFactory.fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$GetDeviceDeploymentForToJson(this);

  String toString() => '${super.toString()}, masterDeviceRoleName: $masterDeviceRoleName';
}

/// A request for reporting this deployment as successful.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: true)
class DeploymentSuccessful extends GetDeviceDeploymentFor {
  DeploymentSuccessful(String studyDeploymentId, String masterDeviceRoleName) : super(studyDeploymentId, masterDeviceRoleName) {
    $type = 'dk.cachet.carp.deployment.infrastructure.DeploymentServiceRequest.DeploymentSuccessful';
    deviceDeploymentLastUpdateDate = DateTime.now().millisecondsSinceEpoch;
  }

  /// Timestamp when this was last updated.
  int deviceDeploymentLastUpdateDate;

  static Function get fromJsonFunction => _$DeploymentSuccessfulFromJson;
  factory DeploymentSuccessful.fromJson(Map<String, dynamic> json) => FromJsonFactory.fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$DeploymentSuccessfulToJson(this);

  String toString() => '${super.toString()}, masterDeviceRoleName: $masterDeviceRoleName';
}

// -----------------------------------------------------
// Deployment Domain Classes
// See https://github.com/cph-cachet/carp.core-kotlin/tree/develop/carp.deployment.core/src/commonMain/kotlin/dk/cachet/carp/deployment/domain
// -----------------------------------------------------

abstract class DeploymentDomainObject extends Serializable {
  /// The CARP study deployment ID.
  String studyDeploymentId;
  DeploymentDomainObject({this.studyDeploymentId});
}

/// The deployment data for a master device as read from the CARP web service
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class MasterDeviceDeployment extends Serializable {
  MasterDeviceDeployment() : super();

  /// Configuration for this master device.
  DeviceRegistration configuration;

  /// The devices this device needs to connect to.
  List<DeviceDescriptor> connectedDevices;

  /// Preregistration of connected devices, including configuration such as connection properties, stored per role name.
  Map<String, DeviceRegistration> connectedDeviceConfigurations;

  /// All tasks which should be able to be executed on this or connected devices.
  List<TaskDescriptor> tasks;

  /// All triggers originating from this device and connected devices, stored per assigned id unique within the study protocol.
  Map<String, TriggerDescriptor> triggers;

  /// The specification of tasks triggered and the devices they are sent to.
  List<TriggeredTask> triggeredTasks;

  /// The time when this device deployment was last updated.
  /// This corresponds to the most recent device registration as part of this device deployment.
  int lastUpdateDate;

  static Function get fromJsonFunction => _$MasterDeviceDeploymentFromJson;
  factory MasterDeviceDeployment.fromJson(Map<String, dynamic> json) => FromJsonFactory.fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$MasterDeviceDeploymentToJson(this);

  String toString() => "$runtimeType - configuration: $configuration";
}

/// Describes requested measures to be collected on a device.
///
/// See [TaskDescriptor.kt](https://github.com/cph-cachet/carp.core-kotlin/blob/develop/carp.protocols.core/src/commonMain/kotlin/dk/cachet/carp/protocols/domain/tasks/TaskDescriptor.kt).
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class TaskDescriptor extends Serializable {
  TaskDescriptor() : super();

  /// A name which uniquely identifies the task.
  String name;

  /// The data which needs to be collected/measured as part of this task.
  List<Measure> measures;

  static Function get fromJsonFunction => _$TaskDescriptorFromJson;
  factory TaskDescriptor.fromJson(Map<String, dynamic> json) => FromJsonFactory.fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$TaskDescriptorToJson(this);

  String toString() => "$runtimeType - name: $name, measures size: ${measures.length}";
}

/// Any condition on a device ([DeviceDescriptor]) which starts or stops tasks at certain points in time when the condition applies.
/// The condition can either be time-bound, based on data streams, initiated by a user of the platform, or a combination of these.
///
/// See [Trigger.kt](https://github.com/cph-cachet/carp.core-kotlin/blob/develop/carp.protocols.core/src/commonMain/kotlin/dk/cachet/carp/protocols/domain/triggers/Trigger.kt).
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class TriggerDescriptor extends Serializable {
  TriggerDescriptor() : super();

  /// The device role name from which the trigger originates.
  String sourceDeviceRoleName;

  /// Determines whether the trigger needs to be evaluated on a master device ([MasterDeviceDescriptor]).
  bool requiresMasterDevice;

  static Function get fromJsonFunction => _$TriggerDescriptorFromJson;
  factory TriggerDescriptor.fromJson(Map<String, dynamic> json) => FromJsonFactory.fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$TriggerDescriptorToJson(this);

  String toString() => "$runtimeType - sourceDeviceRoleName: $sourceDeviceRoleName, requiresMasterDevice: $requiresMasterDevice";
}

/// Specifies a task which at some point during a [StudyProtocol] gets sent to a specific device.
///
/// See [TriggeredTask.kt](https://github.com/cph-cachet/carp.core-kotlin/blob/develop/carp.protocols.core/src/commonMain/kotlin/dk/cachet/carp/protocols/domain/triggers/TriggeredTask.kt).
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class TriggeredTask extends Serializable {
  TriggeredTask() : super();

  TaskDescriptor task;
  DeviceDescriptor targetDevice;

  static Function get fromJsonFunction => _$TriggeredTaskFromJson;
  factory TriggeredTask.fromJson(Map<String, dynamic> json) => FromJsonFactory.fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$TriggeredTaskToJson(this);

  String toString() => "$runtimeType - task: $task, targetDevice: $targetDevice";
}

/// A [StudyDeploymentStatus] represents the status of a deployment as returned from the CARP web service.
///
/// See [StudyDeploymentStatus.kt](https://github.com/cph-cachet/carp.core-kotlin/blob/develop/carp.deployment.core/src/commonMain/kotlin/dk/cachet/carp/deployment/domain/StudyDeploymentStatus.kt).
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class StudyDeploymentStatus extends DeploymentDomainObject {
  StudyDeploymentStatus(String studyDeploymentId) : super(studyDeploymentId: studyDeploymentId);

  /// The list of all devices part of this study deployment and their status.
  List<DeviceDeploymentStatus> devicesStatus;

  /// The time when the study deployment was ready for the first time (all devices deployed); null otherwise.
  DateTime startTime;

  /// Get the status of this device deployment:
  /// * Invited
  /// * DeployingDevices
  /// * DeploymentReady
  /// * Stopped
  String get status => $type.split('.').last;

  static Function get fromJsonFunction => _$StudyDeploymentStatusFromJson;
  factory StudyDeploymentStatus.fromJson(Map<String, dynamic> json) => FromJsonFactory.fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$StudyDeploymentStatusToJson(this);

  String toString() => "$runtimeType - deploymentId: $studyDeploymentId, status: $status";
}

/// A [DeviceDeploymentStatus] represents the status of a device in a deployment.
///
/// See [DeviceDeploymentStatus.kt](https://github.com/cph-cachet/carp.core-kotlin/blob/develop/carp.deployment.core/src/commonMain/kotlin/dk/cachet/carp/deployment/domain/DeviceDeploymentStatus.kt).
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class DeviceDeploymentStatus extends DeploymentDomainObject {
  DeviceDeploymentStatus();

  /// The description of the device.
  DeviceDescriptor device;

  /// Determines whether the device requires a device deployment by retrieving [MasterDeviceDeployment].
  /// Not all master devices necessarily need deployment; chained master devices do not.
  bool requiresDeployment;

  /// The role names of devices which need to be registered before the deployment information for this device can be obtained.
  List<String> remainingDevicesToRegisterToObtainDeployment;

  /// The role names of devices which need to be registered before this device can be declared as successfully deployed.
  List<String> remainingDevicesToRegisterBeforeDeployment;

  /// Get the status of this device deployment:
  /// * Unregistered
  /// * Registered
  /// * Deployed
  /// * NeedsRedeployment
  String get status => $type.split('.').last;

  static Function get fromJsonFunction => _$DeviceDeploymentStatusFromJson;
  factory DeviceDeploymentStatus.fromJson(Map<String, dynamic> json) => FromJsonFactory.fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$DeviceDeploymentStatusToJson(this);

  String toString() => "$runtimeType - status: $status";
}

/// A [DeviceDescriptor] represents the status of a deployment as returned from the CARP web service.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class DeviceDescriptor extends DeploymentDomainObject {
  DeviceDescriptor() : super();

  /// Is this the master device?
  bool isMasterDevice;

  /// The role name of this device in a specific deployment.
  /// For example, "Patient's phone"
  String roleName;

  /// Sampling configurations for data types available on this device which override the default configuration.
  // TODO: This has not been designed -- see https://github.com/cph-cachet/carp.core-kotlin/blob/develop/carp.protocols.core/src/commonMain/kotlin/dk/cachet/carp/protocols/domain/devices/DeviceDescriptor.kt
  Map<String, dynamic> samplingConfiguration;

  /// Get the type of this device, like `Smartphone`.
  String get deviceType => $type.split('.').last;

  static Function get fromJsonFunction => _$DeviceDescriptorFromJson;
  factory DeviceDescriptor.fromJson(Map<String, dynamic> json) => FromJsonFactory.fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$DeviceDescriptorToJson(this);

  String toString() => "$runtimeType - isMasterDevice: $isMasterDevice, : $roleName, deviceType: $deviceType";
}
