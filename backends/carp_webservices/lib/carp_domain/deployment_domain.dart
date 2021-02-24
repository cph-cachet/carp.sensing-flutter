/*
 * Copyright 2020 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of carp_domain;

// -----------------------------------------------------
// Deployment Domain Classes
// See https://github.com/cph-cachet/carp.core-kotlin/tree/develop/carp.deployment.core/src/commonMain/kotlin/dk/cachet/carp/deployment/domain
// -----------------------------------------------------

/// The base class for all [Deployment Domain Classes](https://github.com/cph-cachet/carp.core-kotlin/tree/develop/carp.deployment.core/src/commonMain/kotlin/dk/cachet/carp/deployment/domain).
abstract class DeploymentDomainObject extends Serializable {
  /// The CARP study deployment ID.
  String studyDeploymentId;
  DeploymentDomainObject({this.studyDeploymentId});
  String toString() => '$runtimeType - studyDeploymentId: $studyDeploymentId';
}

/// An [invitation] to participate in an active study deployment using the specified master [devices].
/// Some of the devices which the participant is invited to might already be registered.
/// If the participant wants to use a different device, they will need to unregister the existing device first.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class ActiveParticipationInvitation {
  ActiveParticipationInvitation() : super();

  Participation participation;
  StudyInvitation invitation;
  List<DeviceInvitation> devices;

  /// The CARP study ID.
  String get studyId => invitation?.applicationData;

  /// The CARP study deployment ID.
  String get studyDeploymentId => participation?.studyDeploymentId;

  factory ActiveParticipationInvitation.fromJson(Map<String, dynamic> json) =>
      _$ActiveParticipationInvitationFromJson(json);
  Map<String, dynamic> toJson() => _$ActiveParticipationInvitationToJson(this);

  String toString() =>
      '$runtimeType - participation: $participation, invitation: $invitation, devices size: ${devices.length}';
}

/// Uniquely identifies the participation of an account in a study deployment.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class Participation {
  /// The CARP study deployment ID.
  String studyDeploymentId;

  /// Unique id for this participation.
  String id;

  /// True when the device is already registered in the study deployment; false otherwise.
  /// In case a device is registered, it needs to be unregistered first before a new device can be registered.
  bool isRegistered;

  Participation() : super();

  factory Participation.fromJson(Map<String, dynamic> json) =>
      _$ParticipationFromJson(json);
  Map<String, dynamic> toJson() => _$ParticipationToJson(this);

  String toString() =>
      '${super.toString()}, id: $id, studyDeploymentId: $studyDeploymentId, isRegistered: $isRegistered';
}

/// A description of a study, shared with participants once they are invited to a study.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class StudyInvitation {
  StudyInvitation() : super();

  /// A descriptive name for the study to be shown to participants.
  String name;

  /// A description of the study clarifying to participants what it is about.
  String description;

  /// Application-specific data to be shared with clients when they are invited to a study.
  ///
  /// In CARP this normally contains the study ID.
  String applicationData;

  factory StudyInvitation.fromJson(Map<String, dynamic> json) =>
      _$StudyInvitationFromJson(json);
  Map<String, dynamic> toJson() => _$StudyInvitationToJson(this);

  String toString() =>
      '$runtimeType - name: $name, description: $description, applicationData: $applicationData';
}

/// Holds device invitation details.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class DeviceInvitation {
  DeviceInvitation() : super();

  /// The role name of the device in this invitation.
  String deviceRoleName;

  /// True when the device is already registered in the study deployment,
  /// false otherwise.
  /// In case a device is registered, it needs to be unregistered first
  /// before a new device can be registered.
  bool isRegistered;

  factory DeviceInvitation.fromJson(Map<String, dynamic> json) =>
      _$DeviceInvitationFromJson(json);
  Map<String, dynamic> toJson() => _$DeviceInvitationToJson(this);

  String toString() => '$runtimeType - deviceRoleName: $deviceRoleName';
}

/// The deployment configuration for a master device as read from the CARP
/// web service.
///
/// See [MasterDeviceDeployment.kt](https://github.com/cph-cachet/carp.core-kotlin/blob/develop/carp.deployment.core/src/commonMain/kotlin/dk/cachet/carp/deployment/domain/MasterDeviceDeployment.kt)
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class MasterDeviceDeployment {
  MasterDeviceDeployment() : super();

  /// Configuration for this master device.
  DeviceRegistration configuration;

  /// The devices this device needs to connect to.
  List<DeviceDescriptor> connectedDevices;

  /// Preregistration of connected devices, including configuration such as
  /// connection properties, stored per role name.
  Map<String, DeviceRegistration> connectedDeviceConfigurations;

  /// All tasks which should be able to be executed on this or connected devices.
  List<TaskDescriptor> tasks;
  //List<Map<String, dynamic>> tasks;

  /// All triggers originating from this device and connected devices, stored
  /// per assigned id unique within the study protocol.
  //Map<String, TriggerDescriptor> triggers;
  Map<String, Map<String, dynamic>> triggers;

  /// The specification of tasks triggered and the devices they are sent to.
  //List<TriggeredTask> triggeredTasks;
  List<Map<String, dynamic>> triggeredTasks;

  /// The time when this device deployment was last updated.
  /// This corresponds to the most recent device registration as part of this
  /// device deployment.
  DateTime lastUpdateDate;

  factory MasterDeviceDeployment.fromJson(Map<String, dynamic> json) =>
      _$MasterDeviceDeploymentFromJson(json);
  Map<String, dynamic> toJson() => _$MasterDeviceDeploymentToJson(this);

  String toString() => '$runtimeType - configuration: $configuration';
}

/// Describes a task, which specifies the measures to be collected on a device.
///
/// See [TaskDescriptor.kt](https://github.com/cph-cachet/carp.core-kotlin/blob/develop/carp.protocols.core/src/commonMain/kotlin/dk/cachet/carp/protocols/domain/tasks/TaskDescriptor.kt).
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class TaskDescriptor extends Serializable {
  TaskDescriptor() : super();

  /// A name which uniquely identifies the task.
  String name;

  /// The data which needs to be collected/measured as part of this task.
  List<DataTypeMeasure> measures;

  Function get fromJsonFunction => _$TaskDescriptorFromJson;
  factory TaskDescriptor.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory()
          .fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$TaskDescriptorToJson(this);

  String toString() =>
      '$runtimeType - name: $name, measures size: ${measures.length}';
}

/// A [TaskDescriptor] which contains a definition on how to run tasks,
/// measures, and triggers which differs from the carp.core domain model.
///
/// See [CustomProtocolTask.kt](https://github.com/cph-cachet/carp.core-kotlin/blob/develop/carp.protocols.core/src/commonMain/kotlin/dk/cachet/carp/protocols/domain/tasks/CustomProtocolTask.kt).
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class CustomProtocolTask extends TaskDescriptor {
  CustomProtocolTask() : super();

  ///A definition on how to run a study on a master device, serialized as a string.
  String studyProtocol;

  Function get fromJsonFunction => _$CustomProtocolTaskFromJson;
  factory CustomProtocolTask.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory()
          .fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$CustomProtocolTaskToJson(this);

  String toString() => '${super.toString()}, studyProtocol: $studyProtocol';
}

/// Defines data that needs to be measured/collected from a data stream on a
/// [DeviceDescriptor], as part of a task defined by [TaskDescriptor].
///
/// See [Measure.kt](https://github.com/cph-cachet/carp.core-kotlin/blob/develop/carp.protocols.core/src/commonMain/kotlin/dk/cachet/carp/protocols/domain/tasks/measures/DataTypeMeasure.kt).
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class DataTypeMeasure extends Serializable {
  DataTypeMeasure() : super();

  /// The type of data this measure collects.
  String type;

  Function get fromJsonFunction => _$DataTypeMeasureFromJson;
  factory DataTypeMeasure.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory()
          .fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$DataTypeMeasureToJson(this);

  String toString() => '$runtimeType - type: $type';
}

/// Defines data that needs to be measured/collected from a data stream on a
/// [DeviceDescriptor], as part of a task defined by [TaskDescriptor].
///
/// See [Measure.kt](https://github.com/cph-cachet/carp.core-kotlin/blob/develop/carp.protocols.core/src/commonMain/kotlin/dk/cachet/carp/protocols/domain/tasks/measures/PhoneSensorMeasure.kt).
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class PhoneSensorMeasure extends DataTypeMeasure {
  PhoneSensorMeasure() : super();

  CarpTime duration;

  Function get fromJsonFunction => _$PhoneSensorMeasureFromJson;
  factory PhoneSensorMeasure.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory()
          .fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$PhoneSensorMeasureToJson(this);

  String toString() => '${super.toString()}, duration: $duration';
}

/// Time as specified in carp.core as a value in 'microseconds'.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class CarpTime {
  CarpTime() : super();

  int microseconds;

  factory CarpTime.fromJson(Map<String, dynamic> json) =>
      _$CarpTimeFromJson(json);
  Map<String, dynamic> toJson() => _$CarpTimeToJson(this);

  String toString() => '$runtimeType - microseconds: $microseconds';
}

/// Any condition on a device ([DeviceDescriptor]) which starts or stops tasks
/// at certain points in time when the condition applies.
/// The condition can either be time-bound, based on data streams, initiated
/// by a user of the platform, or a combination of these.
///
/// See [Trigger.kt](https://github.com/cph-cachet/carp.core-kotlin/blob/develop/carp.protocols.core/src/commonMain/kotlin/dk/cachet/carp/protocols/domain/triggers/Trigger.kt).
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class TriggerDescriptor extends Serializable {
  TriggerDescriptor() : super();

  /// The device role name from which the trigger originates.
  String sourceDeviceRoleName;

  /// Determines whether the trigger needs to be evaluated on a master device ([MasterDeviceDescriptor]).
  bool requiresMasterDevice;

  Function get fromJsonFunction => _$TriggerDescriptorFromJson;
  factory TriggerDescriptor.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory()
          .fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$TriggerDescriptorToJson(this);

  String toString() =>
      '$runtimeType - sourceDeviceRoleName: $sourceDeviceRoleName, requiresMasterDevice: $requiresMasterDevice';
}

/// Specifies a task which at some point during a [StudyProtocol] gets sent to a specific device.
///
/// See [TriggeredTask.kt](https://github.com/cph-cachet/carp.core-kotlin/blob/develop/carp.protocols.core/src/commonMain/kotlin/dk/cachet/carp/protocols/domain/triggers/TriggeredTask.kt).
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class TriggeredTask {
  TriggeredTask() : super();

  TaskDescriptor task;
  DeviceDescriptor targetDevice;

  factory TriggeredTask.fromJson(Map<String, dynamic> json) =>
      _$TriggeredTaskFromJson(json);
  Map<String, dynamic> toJson() => _$TriggeredTaskToJson(this);

  String toString() =>
      '$runtimeType - task: $task, targetDevice: $targetDevice';
}

/// A [StudyDeploymentStatus] represents the status of a deployment as returned from the CARP web service.
///
/// See [StudyDeploymentStatus.kt](https://github.com/cph-cachet/carp.core-kotlin/blob/develop/carp.deployment.core/src/commonMain/kotlin/dk/cachet/carp/deployment/domain/StudyDeploymentStatus.kt).
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class StudyDeploymentStatus extends DeploymentDomainObject {
  StudyDeploymentStatus(String studyDeploymentId)
      : super(studyDeploymentId: studyDeploymentId);

  /// The list of all devices part of this study deployment and their status.
  List<DeviceDeploymentStatus> devicesStatus;

  /// The time (milliseconds since epoc) when the study deployment was ready
  /// for the first time (all devices deployed).
  int startTime;

  /// The time when the study deployment was ready (all devices deployed).
  DateTime get startDateTime => DateTime.fromMillisecondsSinceEpoch(startTime);

  /// Get the status of this device deployment:
  /// * Invited
  /// * DeployingDevices
  /// * DeploymentReady
  /// * Stopped
  String get status => $type.split('.').last;

  /// The [DeviceDeploymentStatus] for the master device of this deployment,
  /// which is typically this phone.
  ///
  /// Returns `null` if there is no master device in the list of [devicesStatus].
  DeviceDeploymentStatus get masterDeviceStatus =>
      devicesStatus?.firstWhere((element) => element.device?.isMasterDevice);

  Function get fromJsonFunction => _$StudyDeploymentStatusFromJson;
  factory StudyDeploymentStatus.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory()
          .fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$StudyDeploymentStatusToJson(this);

  String toString() =>
      '$runtimeType - deploymentId: $studyDeploymentId, status: $status';
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

  Function get fromJsonFunction => _$DeviceDeploymentStatusFromJson;
  factory DeviceDeploymentStatus.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory()
          .fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$DeviceDeploymentStatusToJson(this);

  String toString() => '$runtimeType - status: $status';
}

/// Describes any type of electronic device, such as a sensor, video camera,
/// desktop computer, or smartphone that collects data which can be incorporated
/// into the platform after it has been processed by a master device
/// (potentially itself).
///
/// Optionally, a device can present output and receive user input.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class DeviceDescriptor extends DeploymentDomainObject {
  DeviceDescriptor() : super();

  /// Is this the master device?
  bool isMasterDevice;

  /// The role name of this device in a specific deployment.
  /// For example, 'Patient's phone'
  String roleName;

  /// Sampling configurations for data types available on this device which
  /// override the default configuration.
  // TODO: This has not been designed -- see https://github.com/cph-cachet/carp.core-kotlin/blob/develop/carp.protocols.core/src/commonMain/kotlin/dk/cachet/carp/protocols/domain/devices/DeviceDescriptor.kt
  Map<String, dynamic> samplingConfiguration;

  /// Get the type of this device, like `Smartphone`.
  String get deviceType => $type.split('.').last;

  Function get fromJsonFunction => _$DeviceDescriptorFromJson;
  factory DeviceDescriptor.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory()
          .fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$DeviceDescriptorToJson(this);

  String toString() =>
      '$runtimeType - isMasterDevice: $isMasterDevice, roleName: $roleName, deviceType: $deviceType';
}
