/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_core_domain;

/// Contains the entire description and configuration for how a single master
/// device participates in running a study.
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

  /// The specification of tasks triggered and the devices they are sent to.
  List<TriggeredTask> triggeredTasks;

  /// The time when this device deployment was last updated.
  /// This corresponds to the most recent device registration as part of this
  /// device deployment.
  DateTime lastUpdateDate;

  String toString() => '$runtimeType - configuration: $configuration';
}

/// A [DeviceRegistration] configures a [DeviceDescriptor] as part of the
/// deployment of a [StudyProtocol].
class DeviceRegistration {
  /// An ID for the device, used to disambiguate between devices of the same type,
  /// as provided by the device itself.
  /// It is up to specific types of devices to guarantee uniqueness across all
  /// devices of the same type.
  String deviceId;

  DateTime registrationCreationDate;

  DeviceRegistration() : super() {
    registrationCreationDate = DateTime.now();
  }

  String toString() => '$runtimeType - deviceId: $deviceId';
}

/// The status of a [DeviceDeployment].
class DeviceDeploymentStatus {
  /// The status of the deployment
  DeviceDeploymentStatusTypes status;

  /// The description of the device.
  DeviceDescriptor device;

  /// Determines whether the device requires a device deployment by retrieving
  /// [MasterDeviceDeployment].
  /// Not all master devices necessarily need deployment; chained master
  /// devices do not.
  bool requiresDeployment;

  /// Determines whether the device requires a device deployment, and if so,
  /// whether the deployment configuration (to initialize the device environment)
  /// can be obtained.
  /// This requires the specified device and all other master devices it depends
  /// on to be registered.
  bool get canObtainDeviceDeployment =>
      status == DeviceDeploymentStatusTypes.Deployed;

  // get() = this is Deployed || (this is NotDeployed && this.remainingDevicesToRegisterToObtainDeployment.isEmpty())
}

enum DeviceDeploymentStatusTypes {
  /// A device deployment status which indicates the correct deployment has
  /// not been deployed yet.
  NotDeployed,

  /// Device deployment status for when a device has not been registered.
  Unregistered,

  /// Device deployment status for when a device has been registered.
  Registered,

  /// Device deployment status when the device has retrieved its [MasterDeviceDeployment]
  /// and was able to load all the necessary plugins to execute the study.
  Deployed,

  /// Device deployment status when the device has previously been deployed
  /// correctly, but due to changes in device registrations needs to be redeployed.
  NeedsRedeployment,
}
