/*
 * Copyright 2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_core_deployment;

/// Contains the entire description and configuration for how a single primary
/// device participates in running a study.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class PrimaryDeviceDeployment {
  // The configuration for the primary device this deployment is intended for.
  PrimaryDeviceConfiguration deviceConfiguration;

  /// Registration for this master device.
  DeviceRegistration registration;

  /// The devices this device needs to connect to.
  Set<DeviceConfiguration> connectedDevices;

  /// Preregistration of connected devices, including information such as
  /// connection properties, stored per role name.
  Map<String, DeviceRegistration?> connectedDeviceRegistrations;

  /// All tasks which should be able to be executed on this or connected devices.
  Set<TaskConfiguration> tasks;

  /// All triggers originating from this device and connected devices, stored
  /// per assigned id unique within the study protocol.
  Map<String, TriggerConfiguration> triggers;

  /// The specification of tasks triggered and the devices they are sent to.
  Set<TaskControl> taskControls;

  /// Expected data about participants in the deployment to be input by users.
  Set<ExpectedParticipantData> expectedParticipantData;

  /// Application-specific data to be stored as part of a study deployment.
  ///
  /// This can be used by infrastructures or concrete applications which require
  /// exchanging additional data between the protocols and clients subsystems,
  /// outside of scope or not yet supported by CARP core.
  Map<String, dynamic>? applicationData;

  /// The time when this device deployment was last updated.
  DateTime? lastUpdateDate;

  PrimaryDeviceDeployment({
    required this.deviceConfiguration,
    required this.registration,
    this.connectedDevices = const {},
    this.connectedDeviceRegistrations = const {},
    this.tasks = const {},
    this.triggers = const {},
    this.taskControls = const {},
    this.expectedParticipantData = const {},
  }) {
    lastUpdateDate = DateTime.now();
  }

  // internal map, mapping task name to the task
  Map<String, TaskConfiguration>? _taskMap;

  /// Get the task based on its task name in this deployment.
  TaskConfiguration? getTaskByName(String name) {
    if (_taskMap == null) {
      _taskMap = {};
      for (var task in tasks) {
        _taskMap![task.name] = task;
      }
    }
    return _taskMap![name];
  }

  factory PrimaryDeviceDeployment.fromJson(Map<String, dynamic> json) =>
      _$PrimaryDeviceDeploymentFromJson(json);
  Map<String, dynamic> toJson() => _$PrimaryDeviceDeploymentToJson(this);

  @override
  String toString() => '$runtimeType - device: ${deviceConfiguration.roleName}';
}

/// A [DeviceDeploymentStatus] represents the status of a device in a deployment.
///
/// See [DeviceDeploymentStatus.kt](https://github.com/cph-cachet/carp.core-kotlin/blob/develop/carp.deployment.core/src/commonMain/kotlin/dk/cachet/carp/deployment/domain/DeviceDeploymentStatus.kt).
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class DeviceDeploymentStatus extends Serializable {
  DeviceDeploymentStatusTypes? _status;

  /// The description of the device.
  DeviceConfiguration device;

  /// Determines whether the device can be deployed by retrieving [PrimaryDeviceDeployment].
  /// Not all primary devices necessarily need deployment; chained primary devices do not.
  bool? canBeDeployed = false;

  /// The role names of devices which need to be registered before the deployment
  /// information for this device can be obtained.
  List<String>? remainingDevicesToRegisterToObtainDeployment = [];

  /// The role names of devices which need to be registered before this device
  /// can be declared as successfully deployed.
  List<String>? remainingDevicesToRegisterBeforeDeployment = [];

  /// Get the status of this device deployment:
  /// * Unregistered
  /// * Registered
  /// * Deployed
  /// * NeedsRedeployment
  @JsonKey(ignore: true)
  DeviceDeploymentStatusTypes get status {
    // if this object has been created locally, then we know the status
    if (_status != null) return _status!;

    // if this object was create from json deserialization,
    // the $type reflects the status
    switch ($type!.split('.').last) {
      case 'Unregistered':
        return DeviceDeploymentStatusTypes.Unregistered;
      case 'Registered':
        return DeviceDeploymentStatusTypes.Registered;
      case 'Deployed':
        return DeviceDeploymentStatusTypes.Deployed;
      case 'Running':
        return DeviceDeploymentStatusTypes.Running;
      case 'NeedsRedeployment':
        return DeviceDeploymentStatusTypes.NeedsRedeployment;
      default:
        return DeviceDeploymentStatusTypes.Deployed;
    }
  }

  /// Set the status of this device deployment.
  set status(DeviceDeploymentStatusTypes status) => _status = status;

  DeviceDeploymentStatus({required this.device}) : super() {
    _status = DeviceDeploymentStatusTypes.Unregistered;
  }

  @override
  Function get fromJsonFunction => _$DeviceDeploymentStatusFromJson;
  factory DeviceDeploymentStatus.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as DeviceDeploymentStatus;
  @override
  Map<String, dynamic> toJson() => _$DeviceDeploymentStatusToJson(this);
  @override
  String get jsonType => 'dk.cachet.carp.deployment.domain.$runtimeType';

  @override
  String toString() => '$runtimeType - device: $device, status: $status';
}

/// The types of device deployment status.
enum DeviceDeploymentStatusTypes {
  /// Device deployment status for when a device has not been registered.
  Unregistered,

  /// Device deployment status for when a device has been registered.
  Registered,

  /// Device deployment status when the device has retrieved its
  /// [PrimaryDeviceDeployment] and was able to load all the necessary
  /// plugins to execute the study.
  Deployed,

  /// All primary devices have been successfully deployed and data collection
  /// has started on the time specified by [startedOn].
  Running,

  /// Device deployment status when the device has previously been deployed
  /// correctly, but due to changes in device registrations needs to be redeployed.
  NeedsRedeployment,
}

// /// Holds device invitation details.
// @JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
// class DeviceInvitation {
//   DeviceInvitation() : super();

//   /// The role name of the device in this invitation.
//   late String deviceRoleName;

//   /// True when the device is already registered in the study deployment,
//   /// false otherwise.
//   /// In case a device is registered, it needs to be unregistered first
//   /// before a new device can be registered.
//   late bool isRegistered;

//   factory DeviceInvitation.fromJson(Map<String, dynamic> json) =>
//       _$DeviceInvitationFromJson(json);
//   Map<String, dynamic> toJson() => _$DeviceInvitationToJson(this);

//   @override
//   String toString() => '$runtimeType - deviceRoleName: $deviceRoleName';
// }

/// Primary [device] and its current [registration] assigned to participants as
/// part of a participant group.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class AssignedPrimaryDevice {
  PrimaryDeviceConfiguration device;
  DeviceRegistration? registration;

  AssignedPrimaryDevice({required this.device, this.registration}) : super();

  factory AssignedPrimaryDevice.fromJson(Map<String, dynamic> json) =>
      _$AssignedPrimaryDeviceFromJson(json);
  Map<String, dynamic> toJson() => _$AssignedPrimaryDeviceToJson(this);
}
