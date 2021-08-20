/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of domain;

/// Contains the entire description and configuration for how a smartphone master
/// device participates in deployment of a study.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class SmartphoneDeployment extends MasterDeviceDeployment {
  late String _studyDeploymentId;

  /// The unique id of this study deployment.
  String get studyDeploymentId => _studyDeploymentId;

  /// The unique id of the user that this deployment collects data from.
  ///
  /// This [userId] may, or may not, be identical to the id of the
  /// user who is logged into an app or uploads data.
  ///
  /// By being able to separate who collects (and potentially uploads) a data
  /// point from who the data point belongs to, allows for one user to collect
  /// data on behalf of another user. For example, a parent on behalf of a child.
  ///
  /// See [DataPoint]. This user id is stored in the
  /// [DataPointHeader] as the [userId].
  String? userId;

  /// The textual [StudyProtocolDescription] containing the title, description
  /// and purpose of this study protocol.
  StudyProtocolDescription? protocolDescription;

  /// The PI responsible for this study.
  StudyProtocolReponsible? get responsible => protocolDescription?.responsible;

  SamplingSchemaType? samplingStrategy;

  SmartphoneDeployment({
    required String studyDeploymentId,
    this.protocolDescription,
    required MasterDeviceDescriptor deviceDescriptor,
    required DeviceRegistration configuration,
    List<DeviceDescriptor> connectedDevices = const [],
    Map<String, DeviceRegistration?> connectedDeviceConfigurations = const {},
    List<TaskDescriptor> tasks = const [],
    Map<String, Trigger> triggers = const {},
    List<TriggeredTask> triggeredTasks = const [],
    DataEndPoint? dataEndPoint,
  }) : super(
          deviceDescriptor: deviceDescriptor,
          configuration: configuration,
          connectedDevices: connectedDevices,
          connectedDeviceConfigurations: connectedDeviceConfigurations,
          tasks: tasks,
          triggers: triggers,
          triggeredTasks: triggeredTasks,
          dataEndPoint: dataEndPoint,
        ) {
    _registerFromJsonFunctions();
    _studyDeploymentId = studyDeploymentId;
  }

  SmartphoneDeployment.fromMasterDeviceDeployment({
    required String studyDeploymentId,
    StudyProtocolDescription? protocolDescription,
    required MasterDeviceDeployment masterDeviceDeployment,
  }) : this(
          studyDeploymentId: studyDeploymentId,
          protocolDescription: protocolDescription,
          deviceDescriptor: masterDeviceDeployment.deviceDescriptor,
          configuration: masterDeviceDeployment.configuration,
          connectedDevices: masterDeviceDeployment.connectedDevices,
          connectedDeviceConfigurations:
              masterDeviceDeployment.connectedDeviceConfigurations,
          tasks: masterDeviceDeployment.tasks,
          triggers: masterDeviceDeployment.triggers,
          triggeredTasks: masterDeviceDeployment.triggeredTasks,
          dataEndPoint: masterDeviceDeployment.dataEndPoint,
        );

  /// Create a [SmartphoneDeployment] based on a [CAMSStudyProtocol].
  /// This method basically makes a 1:1 mapping between a protocol and
  /// a deployment.
  SmartphoneDeployment.fromStudyProtocol({
    required String studyDeploymentId,
    StudyProtocolDescription? protocolDescription,
    required String masterDeviceRoleName,
    DataEndPoint? dataEndPoint,
    required StudyProtocol protocol,
  }) : this(
          studyDeploymentId: studyDeploymentId,
          protocolDescription: protocolDescription,
          deviceDescriptor: Smartphone(roleName: masterDeviceRoleName),
          configuration: DeviceRegistration(),
          connectedDevices: protocol.connectedDevices,
          connectedDeviceConfigurations: {},
          tasks: protocol.tasks.toList(),
          triggers: protocol.triggers,
          triggeredTasks: protocol.triggeredTasks,
          dataEndPoint: dataEndPoint,
        );

  /// Get the list of all mesures in this study deployment.
  List<Measure> get measures {
    final List<Measure> _measures = [];
    tasks.forEach((task) => _measures.addAll(task.measures));
    return _measures;
  }

  /// Adapt the sampling measures of this deployment to the specified [schema].
  void adapt(SamplingSchema schema, {bool restore = true}) {
    samplingStrategy = schema.type;
    schema.adapt(this, restore: restore);
  }

  factory SmartphoneDeployment.fromJson(Map<String, dynamic> json) =>
      _$SmartphoneDeploymentFromJson(json);
  Map<String, dynamic> toJson() => _$SmartphoneDeploymentToJson(this);

  String toString() => '$runtimeType - studyDeploymentId: $studyDeploymentId, '
      'device: ${deviceDescriptor.roleName}, '
      'title: ${protocolDescription?.title}, responsible: ${responsible?.name}';
}
