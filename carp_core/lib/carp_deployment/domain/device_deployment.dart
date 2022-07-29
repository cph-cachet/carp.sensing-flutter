/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_core_deployment;

/// Contains the entire description and configuration for how a single master
/// device participates in running a study.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class MasterDeviceDeployment {
  // The descriptor for the master device this deployment is intended for.
  MasterDeviceDescriptor deviceDescriptor;

  /// Configuration for this master device.
  DeviceRegistration configuration;

  /// The devices this device needs to connect to.
  List<DeviceDescriptor> connectedDevices;

  /// Preregistration of connected devices, including configuration such as
  /// connection properties, stored per role name.
  Map<String, DeviceRegistration?> connectedDeviceConfigurations;

  /// All tasks which should be able to be executed on this or connected devices.
  late List<TaskDescriptor> tasks = [];

  /// All triggers originating from this device and connected devices, stored
  /// per assigned id unique within the study protocol.
  Map<String, Trigger> triggers;

  /// The specification of tasks triggered and the devices they are sent to.
  List<TriggeredTask> triggeredTasks;

  /// The time when this device deployment was last updated.
  late DateTime lastUpdateDate;

  MasterDeviceDeployment({
    required this.deviceDescriptor,
    required this.configuration,
    this.connectedDevices = const [],
    this.connectedDeviceConfigurations = const {},
    this.tasks = const [],
    this.triggers = const {},
    this.triggeredTasks = const [],
    // this.dataEndPoint,
  }) {
    lastUpdateDate = DateTime.now();
  }

  // internal map, mapping task name to the task
  Map<String, TaskDescriptor>? _taskMap;

  /// Get the task based on its task name in this deployment.
  TaskDescriptor? getTaskByName(String name) {
    if (_taskMap == null) {
      _taskMap = {};
      for (var task in tasks) {
        _taskMap![task.name] = task;
      }
    }
    return _taskMap![name];
  }

  factory MasterDeviceDeployment.fromJson(Map<String, dynamic> json) =>
      _$MasterDeviceDeploymentFromJson(json);
  Map<String, dynamic> toJson() => _$MasterDeviceDeploymentToJson(this);

  @override
  String toString() => '$runtimeType - device: ${deviceDescriptor.roleName}';
}

/// A [DeviceRegistration] configures a [DeviceDescriptor] as part of the
/// deployment of a [StudyProtocol].
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: true)
class DeviceRegistration extends Serializable {
  /// The registration time in zulu time.
  late DateTime registrationCreationDate;

  /// An ID for the device, used to disambiguate between devices of the same type,
  /// as provided by the device itself.
  /// It is up to specific types of devices to guarantee uniqueness across all
  /// devices of the same type.
  late String deviceId;

  /// Create a new [DeviceRegistration]
  ///  * [deviceId] - a unique id for this device.
  ///    If not specified, a unique id will be generated.
  ///  * [registrationCreationDate] - the timestamp in zulu when this registration was created.
  ///    If not specified, the time of creation will be used.
  DeviceRegistration([
    String? deviceId,
    DateTime? registrationCreationDate,
  ]) : super() {
    this.registrationCreationDate =
        registrationCreationDate ?? DateTime.now().toUtc();
    this.deviceId = deviceId ?? Uuid().v1();
  }

  @override
  Function get fromJsonFunction => _$DeviceRegistrationFromJson;
  factory DeviceRegistration.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as DeviceRegistration;
  @override
  Map<String, dynamic> toJson() => _$DeviceRegistrationToJson(this);
  @override
  String get jsonType =>
      'dk.cachet.carp.protocols.domain.devices.DefaultDeviceRegistration';

  @override
  String toString() =>
      '$runtimeType - deviceId: $deviceId, registrationCreationDate: $registrationCreationDate';
}

/// A [DeviceDeploymentStatus] represents the status of a device in a deployment.
///
/// See [DeviceDeploymentStatus.kt](https://github.com/cph-cachet/carp.core-kotlin/blob/develop/carp.deployment.core/src/commonMain/kotlin/dk/cachet/carp/deployment/domain/DeviceDeploymentStatus.kt).
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class DeviceDeploymentStatus extends Serializable {
  DeviceDeploymentStatusTypes? _status;

  /// The description of the device.
  DeviceDescriptor device;

  /// Determines whether the device requires a device deployment by
  /// retrieving [MasterDeviceDeployment]. Not all master devices necessarily
  /// need deployment; chained master devices do not.
  bool requiresDeployment = false;

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
  /// [MasterDeviceDeployment] and was able to load all the necessary
  /// plugins to execute the study.
  Deployed,

  /// Device deployment status when the device has previously been deployed
  /// correctly, but due to changes in device registrations needs to be redeployed.
  NeedsRedeployment,
}

/// Holds device invitation details.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class DeviceInvitation {
  DeviceInvitation() : super();

  /// The role name of the device in this invitation.
  late String deviceRoleName;

  /// True when the device is already registered in the study deployment,
  /// false otherwise.
  /// In case a device is registered, it needs to be unregistered first
  /// before a new device can be registered.
  late bool isRegistered;

  factory DeviceInvitation.fromJson(Map<String, dynamic> json) =>
      _$DeviceInvitationFromJson(json);
  Map<String, dynamic> toJson() => _$DeviceInvitationToJson(this);

  @override
  String toString() => '$runtimeType - deviceRoleName: $deviceRoleName';
}
