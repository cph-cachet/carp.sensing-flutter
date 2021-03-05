/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of domain;

/// Contains the entire description and configuration for how a CAMS master
/// device participates in running a study.
class CAMSMasterDeviceDeployment extends MasterDeviceDeployment {
  String _studyId;
  String _studyDeploymentId;
  ProtocolOwner _owner;

  String get studyId => _studyId;
  String get studyDeploymentId => _studyDeploymentId;

  /// A short printer-friendly name for this study.
  String name;

  /// A longer printer-friendly title for this study.
  String title;

  /// A longer description of this study.
  String description;

  /// The purpose of the study. To be used to inform the user about
  /// this study and its purpose.
  String purpose;

  /// The owner of this study.
  ProtocolOwner get owner => _owner;

  CAMSMasterDeviceDeployment({
    String studyId,
    String studyDeploymentId,
    this.name,
    this.title,
    this.description,
    this.purpose,
    ProtocolOwner owner,
    MasterDeviceDescriptor deviceDescriptor,
    DeviceRegistration configuration,
    List<DeviceDescriptor> connectedDevices,
    Map<String, DeviceRegistration> connectedDeviceConfigurations,
    List<TaskDescriptor> tasks,
    Map<String, Trigger> triggers,
    List<TriggeredTask> triggeredTasks,
  }) : super(
          deviceDescriptor: deviceDescriptor,
          configuration: configuration,
          connectedDevices: connectedDevices,
          connectedDeviceConfigurations: connectedDeviceConfigurations,
          tasks: tasks,
          triggers: triggers,
          triggeredTasks: triggeredTasks,
        ) {
    this._studyId = studyId;
    this._studyDeploymentId = studyDeploymentId;
    this._owner = owner;
  }

  CAMSMasterDeviceDeployment.fromMasterDeviceDeployment({
    String studyId,
    String studyDeploymentId,
    this.name,
    this.title,
    this.description,
    this.purpose,
    ProtocolOwner owner,
    MasterDeviceDeployment masterDeviceDeployment,
  }) : super(
          deviceDescriptor: masterDeviceDeployment.deviceDescriptor,
          configuration: masterDeviceDeployment.configuration,
          connectedDevices: masterDeviceDeployment.connectedDevices,
          connectedDeviceConfigurations:
              masterDeviceDeployment.connectedDeviceConfigurations,
          tasks: masterDeviceDeployment.tasks,
          triggers: masterDeviceDeployment.triggers,
          triggeredTasks: masterDeviceDeployment.triggeredTasks,
        ) {
    this._studyId = studyId;
    this._studyDeploymentId = studyDeploymentId;
    this._owner = owner;
  }
}
