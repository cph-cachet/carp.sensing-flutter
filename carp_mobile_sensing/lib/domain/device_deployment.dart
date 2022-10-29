/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of domain;

/// Contains the entire description and configuration for how a smartphone master
/// device participates in the deployment of a study on a smartphone.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class SmartphoneDeployment extends MasterDeviceDeployment {
  late String _studyDeploymentId;
  final List<SmartphoneDeploymentListener> _listeners = [];

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
  ///
  /// This user id is stored in the [DataPointHeader] as the [userId].
  String? userId;

  /// The [StudyDescription] containing the title, description,
  /// purpose, and the responsible researcher for this study.
  StudyDescription? protocolDescription;

  /// The PI responsible for this study.
  StudyResponsible? get responsible => protocolDescription?.responsible;

  /// Specifies where and how to stored or upload the data collected from this
  /// deployment. If `null`, the sensed data is not stored, but may still be
  /// used in the app somehow.
  DataEndPoint? dataEndPoint;

  /// Create a new [SmartphoneDeployment].
  ///
  /// [studyDeploymentId] is a unique id for this deployment. If not specified,
  /// a unique id will be generated.
  ///
  SmartphoneDeployment({
    String? studyDeploymentId,
    required super.deviceDescriptor,
    required super.configuration,
    super.connectedDevices = const [],
    super.connectedDeviceConfigurations = const {},
    super.tasks = const [],
    super.triggers = const {},
    super.triggeredTasks = const [],
    this.protocolDescription,
    this.dataEndPoint,
  }) {
    _studyDeploymentId = studyDeploymentId ?? Uuid().v1();
  }

  /// Create a [SmartphoneDeployment] that combines a [MasterDeviceDeployment] and
  /// a [SmartphoneStudyProtocol].
  SmartphoneDeployment.fromMasterDeviceDeployment({
    String? studyDeploymentId,
    required MasterDeviceDeployment masterDeviceDeployment,
    required SmartphoneStudyProtocol protocol,
  }) : this(
          studyDeploymentId: studyDeploymentId,
          deviceDescriptor: masterDeviceDeployment.deviceDescriptor,
          configuration: masterDeviceDeployment.configuration,
          connectedDevices: masterDeviceDeployment.connectedDevices,
          connectedDeviceConfigurations:
              masterDeviceDeployment.connectedDeviceConfigurations,
          tasks: masterDeviceDeployment.tasks,
          triggers: masterDeviceDeployment.triggers,
          triggeredTasks: masterDeviceDeployment.triggeredTasks,
          protocolDescription: protocol.protocolDescription,
          dataEndPoint: protocol.dataEndPoint,
        );

  /// Create a [SmartphoneDeployment] based on a [SmartphoneStudyProtocol].
  /// This method basically makes a 1:1 mapping between a protocol and
  /// a deployment.
  SmartphoneDeployment.fromSmartphoneStudyProtocol({
    String? studyDeploymentId,
    required String masterDeviceRoleName,
    required SmartphoneStudyProtocol protocol,
  }) : this(
          studyDeploymentId: studyDeploymentId,
          deviceDescriptor: Smartphone(roleName: masterDeviceRoleName),
          configuration: DeviceRegistration(),
          connectedDevices: protocol.connectedDevices,
          connectedDeviceConfigurations: {},
          tasks: protocol.tasks.toList(),
          triggers: protocol.triggers,
          triggeredTasks: protocol.triggeredTasks,
          protocolDescription: protocol.protocolDescription,
          dataEndPoint: protocol.dataEndPoint,
        );

  /// Get the list of all mesures in this study deployment.
  List<Measure> get measures {
    final List<Measure> measures = [];
    for (var task in tasks) {
      measures.addAll(task.measures);
    }
    return measures;
  }

  /// Get the [DeviceDescriptor] based on the [roleName].
  /// This includes both the master device and the connected devices.
  /// Returns null if no device with [roleName] is found.
  DeviceDescriptor? getDeviceFromRoleName(String roleName) {
    if (deviceDescriptor.roleName == roleName) return deviceDescriptor;
    try {
      return connectedDevices
          .firstWhere((device) => device.roleName == roleName);
    } catch (_) {
      return null;
    }
  }

  /// Add a [MeasureListener] to this [Measure].
  void addMeasureListener(SmartphoneDeploymentListener listener) =>
      _listeners.add(listener);

  /// Remove a [MeasureListener] to this [Measure].
  void removeMeasureListener(SmartphoneDeploymentListener listener) =>
      _listeners.remove(listener);

  /// Call this method when this deployment has changed.
  Future<void> hasChanged([dynamic message]) async {
    lastUpdateDate = DateTime.now();
    for (var listener in _listeners) {
      listener.hasChanged(message);
    }
  }

  // /// Adapt the sampling measures of this deployment to the specified [schema].
  // void adapt(SamplingSchema schema, {bool restore = true}) {
  //   samplingStrategy = schema.type;
  //   schema.adapt(this, restore: restore);
  // }

  factory SmartphoneDeployment.fromJson(Map<String, dynamic> json) =>
      _$SmartphoneDeploymentFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$SmartphoneDeploymentToJson(this);

  @override
  String toString() => '$runtimeType - studyDeploymentId: $studyDeploymentId, '
      'device: ${deviceDescriptor.roleName}, '
      'title: ${protocolDescription?.title}, responsible: ${responsible?.name}';
}

/// A Listener that can listen on changes to a [SmartphoneDeployment].
abstract class SmartphoneDeploymentListener {
  /// Called when this [SmartphoneDeploymentListener] has changed.
  void hasChanged([dynamic message]);
}
