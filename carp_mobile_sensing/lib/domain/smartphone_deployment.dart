/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of domain;

/// Contains the entire description and configuration for how a smartphone
/// device participates in the deployment of a study on a smartphone.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class SmartphoneDeployment extends PrimaryDeviceDeployment
    with SmartphoneProtocolExtension {
  late String _studyDeploymentId;
  // final List<SmartphoneDeploymentListener> _listeners = [];

  /// The unique id of this study deployment.
  String get studyDeploymentId => _studyDeploymentId;

  /// The timestamp (in UTC) when this deployment was deployed on this smartphone.
  /// Returns `null` if not deployed yet.
  DateTime? deployed;

  /// The unique id of the user that this deployment collects data from.
  ///
  /// This [userId] may, or may not, be identical to the id of the
  /// user who is logged into an app or uploads data.
  ///
  /// By being able to separate who collects (and potentially uploads) a data
  /// point from who the data point belongs to, allows for one user to collect
  /// data on behalf of another user. For example, a parent on behalf of a child.
  String? userId;

  /// Create a new [SmartphoneDeployment].
  ///
  /// [studyDeploymentId] is a unique id for this deployment. If not specified,
  /// a unique id will be generated.
  SmartphoneDeployment({
    String? studyDeploymentId,
    required super.deviceConfiguration,
    required super.registration,
    super.connectedDevices,
    super.connectedDeviceRegistrations,
    super.tasks,
    super.triggers,
    super.taskControls,
    super.expectedParticipantData,
    this.userId,
    StudyDescription? protocolDescription,
    DataEndPoint? dataEndPoint,
  }) {
    _studyDeploymentId = studyDeploymentId ?? Uuid().v1();
    _data = SmartphoneApplicationData(
      studyDescription: protocolDescription,
      dataEndPoint: dataEndPoint,
    );
  }

  /// Create a [SmartphoneDeployment] that combines a [PrimaryDeviceDeployment] and
  /// a [SmartphoneStudyProtocol].
  SmartphoneDeployment.fromPrimaryDeviceDeployment({
    String? studyDeploymentId,
    this.userId,
    required PrimaryDeviceDeployment primaryDeviceDeployment,
    required SmartphoneStudyProtocol protocol,
  }) : super(
          deviceConfiguration: primaryDeviceDeployment.deviceConfiguration,
          registration: primaryDeviceDeployment.registration,
          connectedDevices: primaryDeviceDeployment.connectedDevices,
          connectedDeviceRegistrations:
              primaryDeviceDeployment.connectedDeviceRegistrations,
          tasks: primaryDeviceDeployment.tasks,
          triggers: primaryDeviceDeployment.triggers,
          taskControls: primaryDeviceDeployment.taskControls,
          expectedParticipantData:
              primaryDeviceDeployment.expectedParticipantData,
        ) {
    _studyDeploymentId = studyDeploymentId ?? Uuid().v1();
    _data.studyDescription = protocol.studyDescription;
    _data.dataEndPoint = protocol.dataEndPoint;
    _data.applicationData = protocol._data.applicationData;
  }

  /// Create a [SmartphoneDeployment] based on a [SmartphoneStudyProtocol].
  /// This method basically makes a 1:1 mapping between a protocol and
  /// a deployment.
  SmartphoneDeployment.fromSmartphoneStudyProtocol({
    String? studyDeploymentId,
    this.userId,
    required String primaryDeviceRoleName,
    required SmartphoneStudyProtocol protocol,
  }) : super(
          deviceConfiguration: Smartphone(roleName: primaryDeviceRoleName),
          registration: DeviceRegistration(),
          connectedDevices: protocol.connectedDevices ?? {},
          connectedDeviceRegistrations: {},
          tasks: protocol.tasks,
          triggers: protocol.triggers,
          taskControls: protocol.taskControls,
          expectedParticipantData: protocol.expectedParticipantData ?? {},
        ) {
    _studyDeploymentId = studyDeploymentId ?? Uuid().v1();
    _data.studyDescription = protocol.studyDescription;
    _data.dataEndPoint = protocol.dataEndPoint;
    _data.applicationData = protocol._data.applicationData;
  }

  /// Get the list of all measures in this study deployment.
  List<Measure> get measures {
    final List<Measure> measures = [];
    for (var task in tasks) {
      if (task.measures != null) measures.addAll(task.measures!);
    }
    return measures;
  }

  /// Get the [DeviceConfiguration] based on the [roleName].
  /// This includes both the primary device and the connected devices.
  /// Returns null if no device with [roleName] is found.
  DeviceConfiguration? getDeviceFromRoleName(String roleName) {
    if (deviceConfiguration.roleName == roleName) return deviceConfiguration;
    try {
      return connectedDevices
          .firstWhere((device) => device.roleName == roleName);
    } catch (_) {
      return null;
    }
  }

  factory SmartphoneDeployment.fromJson(Map<String, dynamic> json) =>
      _$SmartphoneDeploymentFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$SmartphoneDeploymentToJson(this);

  @override
  String toString() => '$runtimeType - studyDeploymentId: $studyDeploymentId, '
      'device: ${deviceConfiguration.roleName}, '
      'title: ${studyDescription?.title}, responsible: ${responsible?.name}';
}