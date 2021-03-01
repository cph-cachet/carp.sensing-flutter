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
  final StudyProtocol _studyProtocol;
  Set<String> _registeredDevices;
  Map<String, List<DeviceRegistration>> _deviceRegistrationHistory;
  Set<String> _deployedDevices;
  Set<String> _invalidatedDeployedDevices;
  DateTime _startTime;
  bool _isStopped = false;

  String get studyDeploymentId => _studyDeploymentId;
  DateTime get creationDate => _creationDate;
  StudyProtocol get studyProtocol => _studyProtocol;

  /// The set of devices which are currently registered for this study deployment.
  Set<String> get registeredDevices => _registeredDevices;

  /// Per device, a list of all device registrations (included old registrations)
  /// in the order they were registered.
  Map<String, List<DeviceRegistration>> get deviceRegistrationHistory =>
      _deviceRegistrationHistory;

  /// The set of devices which have been deployed correctly.
  Set<String> get deployedDevices => _deployedDevices;
  Set<String> get invalidatedDeployedDevices => _invalidatedDeployedDevices;

  ///The time when the study deployment was ready for the first
  ///time (all devices deployed); null otherwise.
  DateTime get startTime => _startTime;

  /// Determines whether the study deployment has been stopped and no
  /// further modifications are allowed.
  bool get isStopped => _isStopped;

  StudyDeployment(this._studyProtocol) {
    assert(_studyProtocol != null,
        'Cannot create a StudyDeployment without a protocol.');
    _studyDeploymentId = Uuid().v1();
    _creationDate = DateTime.now();
  }

  /// Get the status of this [StudyDeployment].
  StudyDeploymentStatus get status {
    StudyDeploymentStatus status =
        StudyDeploymentStatus(studyDeploymentId: studyDeploymentId);

    // TODO - set the device status
    status.devicesStatus = [];

    // TODO - check that all devices are ready, before setting the overall status
    status.status = StudyDeploymentStatusTypes.DeploymentReady;

    return status;
  }

  /// Register the specified [device] for this deployment using the [registration] options.
  void registerDevice(
      DeviceDescriptor device, DeviceRegistration registration) {
    // TODO: implement registerDevice
    throw UnimplementedError();
  }

  /// Remove the current device registration for the [device] in this deployment.
  /// This will invalidate the deployment of any devices which depend on the this [device].
  void unregisterDevice(DeviceDescriptor device) {
    // TODO: implement unregisterDevice
    throw UnimplementedError();
  }

  /// Get the deployment configuration for the specified [device] in this study deployment.
  MasterDeviceDeployment getDeviceDeploymentFor(MasterDeviceDescriptor device) {
    // TODO: implement getDeviceDeploymentFor
    throw UnimplementedError();
  }

  /// Stop this study deployment. No further changes to this deployment
  /// are allowed and no more data should be collected.
  void stop() => _isStopped = true;
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
  StudyDeploymentStatusTypes _status = StudyDeploymentStatusTypes.Invited;

  /// The CARP study deployment ID.
  String studyDeploymentId;

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
  StudyDeploymentStatusTypes get status {
    // if this object has been created locally, then we know the status
    if ($type == runtimeType) return _status;

    // if this object was create from json deserialization, the $type reflects the status
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

  StudyDeploymentStatus({this.studyDeploymentId}) : super();

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
