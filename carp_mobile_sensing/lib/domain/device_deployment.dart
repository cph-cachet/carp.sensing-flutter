/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of domain;

/// Contains the entire description and configuration for how a CAMS master
/// device participates in running a study.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class CAMSMasterDeviceDeployment extends MasterDeviceDeployment {
  String _studyId;
  String _studyDeploymentId;
  ProtocolOwner _owner;

  /// The unique id of this study. Used in the [DataPointHeader] header.
  String get studyId => _studyId;

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
  String userId;

  /// A technical printer-friendly name for this study.
  /// This name is not localized.
  String name;

  /// The textual [StudyProtocolDescription] containing the title, description
  /// and purpose of this study protocol organized according to language locales.
  StudyProtocolDescription protocolDescription;

  /// The owner of this study.
  ProtocolOwner get owner => _owner;

  SamplingSchemaType samplingStrategy;

  CAMSMasterDeviceDeployment({
    String studyId,
    String studyDeploymentId,
    this.name,
    this.protocolDescription,
    ProtocolOwner owner,
    DataEndPoint dataEndPoint,
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
          dataEndPoint: dataEndPoint,
        ) {
    _registerFromJsonFunctions();

    this._studyId = studyId;
    this._studyDeploymentId = studyDeploymentId;
    this._owner = owner;
  }

  CAMSMasterDeviceDeployment.fromMasterDeviceDeployment({
    String studyId,
    String studyDeploymentId,
    this.name,
    this.protocolDescription,
    ProtocolOwner owner,
    DataEndPoint dataEndPoint,
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
          dataEndPoint: dataEndPoint,
        ) {
    _registerFromJsonFunctions();

    this._studyId = studyId;
    this._studyDeploymentId = studyDeploymentId;
    this._owner = owner;
  }

  /// Get the list of all [Mesure]s in this study protocol.
  List<Measure> get measures {
    List<Measure> _measures = [];
    tasks.forEach((task) => _measures.addAll(task.measures));

    return _measures;
  }

  /// Adapt the sampling [Measure]s of this [StudyProtocol] to the specified
  /// [SamplingSchema].
  void adapt(SamplingSchema schema, {bool restore = true}) {
    assert(schema != null);
    samplingStrategy = schema.type;
    schema.adapt(this, restore: restore);
  }

  factory CAMSMasterDeviceDeployment.fromJson(Map<String, dynamic> json) =>
      _$CAMSMasterDeviceDeploymentFromJson(json);
  Map<String, dynamic> toJson() => _$CAMSMasterDeviceDeploymentToJson(this);

  String toString() => '${super.toString()} - studyId: $studyId, '
      'studyDeploymentId: $studyDeploymentId, '
      'name: $name, owner: $owner}';
}
