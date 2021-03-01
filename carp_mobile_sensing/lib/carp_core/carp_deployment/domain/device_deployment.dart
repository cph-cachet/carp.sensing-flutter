/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_core;

/// Contains the entire description and configuration for how a single master
/// device participates in running a study.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class MasterDeviceDeployment {
  MasterDeviceDeployment() : super();

  // The descriptor for the master device this deployment is intended for.
  MasterDeviceDescriptor deviceDescriptor;

  /// Configuration for this master device.
  DeviceRegistration configuration;

  /// The devices this device needs to connect to.
  List<DeviceDescriptor> connectedDevices;

  /// Preregistration of connected devices, including configuration such as
  /// connection properties, stored per role name.
  Map<String, DeviceRegistration> connectedDeviceConfigurations;

  /// All tasks which should be able to be executed on this or connected devices.
  List<TaskDescriptor> tasks;

  /// All triggers originating from this device and connected devices, stored
  /// per assigned id unique within the study protocol.
  Map<String, Trigger> triggers;
  //   Map<String, Map<String, dynamic>> triggers;

  /// The specification of tasks triggered and the devices they are sent to.
  List<TriggeredTask> triggeredTasks;
  // List<Map<String, dynamic>> triggeredTasks;

  /// The time when this device deployment was last updated.
  /// This corresponds to the most recent device registration as part of this
  /// device deployment.
  DateTime lastUpdateDate;

  factory MasterDeviceDeployment.fromJson(Map<String, dynamic> json) =>
      _$MasterDeviceDeploymentFromJson(json);
  Map<String, dynamic> toJson() => _$MasterDeviceDeploymentToJson(this);

  String toString() => '$runtimeType - configuration: $configuration';
}

/// A [DeviceRegistration] configures a [DeviceDescriptor] as part of the
/// deployment of a [StudyProtocol].
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: true)
class DeviceRegistration extends Serializable {
  /// Create a new [DeviceRegistration]
  ///  * [deviceId] - a unique id for this device.
  ///    If not specified, a unique id will be generated.
  ///  * [registrationCreationDate] - the timestamp in milliseconds when this registration was created.
  ///    If not specified, the time of creation will be used.
  DeviceRegistration([this.deviceId, this.registrationCreationDate]) : super() {
    registrationCreationDate ??= DateTime.now().toUtc();
    deviceId ??= Uuid().v1();
  }

  /// The registration time in zulu time.
  DateTime registrationCreationDate;

  /// An ID for the device, used to disambiguate between devices of the same type,
  /// as provided by the device itself.
  /// It is up to specific types of devices to guarantee uniqueness across all
  /// devices of the same type.
  String deviceId;

  Function get fromJsonFunction => _$DeviceRegistrationFromJson;
  factory DeviceRegistration.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory()
          .fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$DeviceRegistrationToJson(this);
  String get jsonType =>
      'dk.cachet.carp.protocols.domain.devices.DeviceRegistration';

  String toString() =>
      '$runtimeType - deviceId: $deviceId, registrationCreationDate: $registrationCreationDate';
}

/// A [DeviceDeploymentStatus] represents the status of a device in a deployment.
///
/// See [DeviceDeploymentStatus.kt](https://github.com/cph-cachet/carp.core-kotlin/blob/develop/carp.deployment.core/src/commonMain/kotlin/dk/cachet/carp/deployment/domain/DeviceDeploymentStatus.kt).
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class DeviceDeploymentStatus extends Serializable {
  /// The CARP study deployment ID.
  String studyDeploymentId;

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

  DeviceDeploymentStatus() : super();

  Function get fromJsonFunction => _$DeviceDeploymentStatusFromJson;
  factory DeviceDeploymentStatus.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory()
          .fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$DeviceDeploymentStatusToJson(this);
  String get jsonType =>
      'dk.cachet.carp.deployment.domain.DeviceDeploymentStatus';

  String toString() => '$runtimeType - status: $status';
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
