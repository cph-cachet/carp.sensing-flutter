/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_core;

/// A single instantiation of a [StudyProtocol], taking care of common concerns
/// related to devices when 'running' a study.
///
/// I.e., a [StudyDeployment] is responsible for registering the physical
/// devices described in the [StudyProtocol],
/// enabling a connection between them, tracking device connection issues, and
/// assessing data quality.
class StudyDeployment {
  String _studyDeploymentId;
  DateTime _creationDate;
  final StudyProtocol _protocol;
  final Map<DeviceDescriptor, DeviceRegistration> _registeredDevices = {};
  final Map<DeviceDescriptor, List<DeviceRegistration>>
      _deviceRegistrationHistory = {};
  final Set<DeviceDescriptor> _deployedDevices = {};
  final Set<DeviceDescriptor> _invalidatedDeployedDevices = {};
  DateTime _startTime;
  bool _isStopped = false;
  StudyDeploymentStatus _status;

  String get studyDeploymentId => _studyDeploymentId;
  DateTime get creationDate => _creationDate;
  StudyProtocol get protocol => _protocol;

  /// The set of devices which are currently registered for this study deployment.
  Map<DeviceDescriptor, DeviceRegistration> get registeredDevices =>
      _registeredDevices;

  /// Per device, a list of all device registrations (included old registrations)
  /// in the order they were registered.
  Map<DeviceDescriptor, List<DeviceRegistration>>
      get deviceRegistrationHistory => _deviceRegistrationHistory;

  /// The set of devices which have been deployed correctly.
  Set<DeviceDescriptor> get deployedDevices => _deployedDevices;
  Set<DeviceDescriptor> get invalidatedDeployedDevices =>
      _invalidatedDeployedDevices;

  ///The time when the study deployment was ready for the first
  ///time (all devices deployed); null otherwise.
  DateTime get startTime => _startTime;

  /// Determines whether the study deployment has been stopped and no
  /// further modifications are allowed.
  bool get isStopped => _isStopped;

  StudyDeployment(this._protocol) {
    assert(_protocol != null,
        'Cannot create a StudyDeployment without a protocol.');
    _studyDeploymentId = Uuid().v1();
    _creationDate = DateTime.now();
    _status = StudyDeploymentStatus(studyDeploymentId: _studyDeploymentId);
  }

  /// Get the status of this [StudyDeployment].
  StudyDeploymentStatus get status => _status;

  /// Set the status of this [StudyDeployment].
  // void set status(StudyDeploymentStatus status) => _status = status;
  // {
  //   StudyDeploymentStatus status =
  //       StudyDeploymentStatus(studyDeploymentId: studyDeploymentId);

  //   // TODO - set the device status
  //   status.devicesStatus = [];

  //   // TODO - check that all devices are ready, before setting the overall status

  //   status.status = (isStopped)
  //       ? StudyDeploymentStatusTypes.Stopped
  //       : StudyDeploymentStatusTypes.DeploymentReady;

  //   return status;
  // }

  /// Register the specified [device] for this deployment using the [registration]
  /// options.
  void registerDevice(
    DeviceDescriptor device,
    DeviceRegistration registration,
  ) {
    _status.status = StudyDeploymentStatusTypes.DeployingDevices;
    // Add device to currently registered devices and also store it in registration history.
    _registeredDevices[device] = registration;
    if (_deviceRegistrationHistory[device] == null)
      _deviceRegistrationHistory[device] = [];
    _deviceRegistrationHistory[device].add(registration);
  }

  /// Remove the current device registration for the [device] in this deployment.
  void unregisterDevice(DeviceDescriptor device) {
    _registeredDevices.remove(device);
    _deployedDevices.remove(device);
  }

  /// Get the deployment configuration for the specified master [device] in
  /// this study deployment.
  MasterDeviceDeployment getDeviceDeploymentFor(MasterDeviceDescriptor device) {
    // Verify whether the specified device is part of the protocol of this deployment.
    // assert(_protocol.masterDevices.contains(device),
    //     "The specified master device is not part of the protocol of this deployment.");

    // TODO - Verify whether the specified device is ready to be deployed.
    DeviceRegistration configuration = _registeredDevices[device];

    // Determine which devices this device needs to connect to
    // TODO - retrieve configuration for preregistered devices
    List<DeviceDescriptor> connectedDevices = _protocol.connectedDevices;

    Map<String, DeviceRegistration> deviceRegistrations = {};
    _registeredDevices.forEach((descriptor, registration) =>
        deviceRegistrations[descriptor.roleName] = registration);

    // Get all tasks which might need to be executed on this or connected devices.
    List<TaskDescriptor> tasks = [];
    deviceRegistrations.keys.forEach((deviceRoleName) =>
        tasks.addAll(protocol.getTasksForDeviceRoleName(deviceRoleName)));

    // Get all trigger information for this and connected devices.
    // The trigger IDs assigned are reused to identify them within the protocol
    Map<String, Trigger> usedTriggers = {};
    List<TriggeredTask> triggeredTasks = [];
    int index = 0;
    _protocol.triggers.forEach((trigger) {
      usedTriggers['${index}'] = trigger;
      Set<TriggeredTask> tt = _protocol.getTriggeredTasks(trigger);
      tt.forEach((triggeredTask) {
        triggeredTask.triggerId = index;
        triggeredTasks.add(triggeredTask);
      });
      index++;
    });

    status.status = StudyDeploymentStatusTypes.DeploymentReady;

    return MasterDeviceDeployment(
        deviceDescriptor: device,
        configuration: configuration,
        connectedDevices: connectedDevices,
        connectedDeviceConfigurations: deviceRegistrations,
        tasks: tasks,
        triggers: usedTriggers,
        triggeredTasks: triggeredTasks);
  }

  /// Indicate that the specified [device] was deployed successfully using
  /// the deployment with the specified [deviceDeploymentLastUpdateDate].
  void deviceDeployed(
    MasterDeviceDescriptor device,
    DateTime deviceDeploymentLastUpdateDate,
  ) {
    assert(_protocol.masterDevices.contains(device),
        'The specified master device is not part of the protocol of this deployment.');

    _startTime = deviceDeploymentLastUpdateDate;
  }

  /// Stop this study deployment. No further changes to this deployment
  /// are allowed and no more data should be collected.
  void stop() {
    _isStopped = true;
    status.status = StudyDeploymentStatusTypes.Stopped;
  }
}

enum StudyDeploymentStatusTypes {
  /// Initial study deployment status, indicating the invited participants
  /// have not yet acted on the invitation.
  Invited,

  /// Participants have started registering devices, but remaining master devices still need to be deployed.
  DeployingDevices,

  /// The study deployment is ready to be used.
  DeploymentReady,

  /// The study deployment has been stopped and no more data should be collected.
  Stopped,
}

/// A [StudyDeploymentStatus] represents the status of a deployment as returned from the CARP web service.
///
/// See [StudyDeploymentStatus.kt](https://github.com/cph-cachet/carp.core-kotlin/blob/develop/carp.deployment.core/src/commonMain/kotlin/dk/cachet/carp/deployment/domain/StudyDeploymentStatus.kt).
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class StudyDeploymentStatus extends Serializable {
  StudyDeploymentStatusTypes _status;

  /// The CARP study deployment ID.
  String studyDeploymentId;

  /// The list of all devices part of this study deployment and their status.
  List<DeviceDeploymentStatus> devicesStatus;

  /// The time when the study deployment was ready for the first
  /// time (all devices deployed); null otherwise.
  DateTime startTime;

  /// Get the status of this device deployment:
  /// * Invited
  /// * DeployingDevices
  /// * DeploymentReady
  /// * Stopped
  @JsonKey(ignore: true)
  StudyDeploymentStatusTypes get status {
    // if this object has been created locally, then we know the status
    if (_status != null) return _status;

    // if this object was create from json deserialization,
    // the $type reflects the status
    switch ($type.split('.').last) {
      case 'Invited':
        return StudyDeploymentStatusTypes.Invited;
      case 'DeployingDevices':
        return StudyDeploymentStatusTypes.DeployingDevices;
      case 'DeploymentReady':
        return StudyDeploymentStatusTypes.DeploymentReady;
      case 'Stopped':
        return StudyDeploymentStatusTypes.Stopped;
      default:
        return StudyDeploymentStatusTypes.Invited;
    }
  }

  /// Set the status of this deployment.
  set status(StudyDeploymentStatusTypes status) => _status = status;

  /// The [DeviceDeploymentStatus] for the master device of this deployment,
  /// which is typically this phone.
  ///
  /// Returns `null` if there is no master device in the list of [devicesStatus].
  DeviceDeploymentStatus get masterDeviceStatus =>
      devicesStatus?.firstWhere((element) => element.device?.isMasterDevice);

  StudyDeploymentStatus({this.studyDeploymentId}) : super() {
    _status = StudyDeploymentStatusTypes.Invited;
  }

  Function get fromJsonFunction => _$StudyDeploymentStatusFromJson;
  factory StudyDeploymentStatus.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory()
          .fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$StudyDeploymentStatusToJson(this);
  String get jsonType =>
      'dk.cachet.carp.deployment.domain.StudyDeploymentStatus';

  String toString() =>
      '$runtimeType - deploymentId: $studyDeploymentId, status: ${status.toString().split('.').last}';
}
