/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_core;

/// A description of how a study is to be executed, defining the type(s) of
/// master device(s) ([AnyMasterDeviceDescriptor]) responsible for aggregating data,
/// the optional devices ([AnyDeviceDescriptor]) connected to them, and
/// the [Trigger]'s which lead to data collection on said devices.
///
/// This is part of the [carp.protocols](https://github.com/cph-cachet/carp.core-kotlin/blob/develop/docs/carp-protocols.md) domain model.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class StudyProtocol extends Serializable {
  /// The owner of this study.
  String ownerId;

  /// A short printer-friendly name for this study.
  String name;

  /// A longer description of this study.
  String description;

  /// The master devices involved in this protocol.
  List<MasterDeviceDescriptor> masterDevices = [];

  /// The devices this device needs to connect to.
  List<DeviceDescriptor> connectedDevices = [];

  /// The set of [Trigger]s which can trigger [TaskDescriptor]s in this study protocol.
  List<Trigger> triggers = [];

  /// The set of tasks which can be triggered as part of this protocol.
  List<TaskDescriptor> tasks = [];

  /// The tasks (and the devices they are triggered to) for the specified [trigger].
  List<TriggeredTask> triggeredTasks = [];

  Map<Trigger, Set<TriggeredTask>> _triggeredTasksMap = {};

  /// Create a new [StudyProtocol].
  StudyProtocol({
    this.ownerId,
    this.name,
    this.description,
  }) : super();

  /// Add a [masterDevice] which is responsible for aggregating and synchronizing
  /// incoming data. Its role name should be unique in the protocol.
  void addMasterDevice(MasterDeviceDescriptor masterDevice) =>
      masterDevices.add(masterDevice);

  /// Add a [device] which is connected to this [masterDevice].
  /// Its role name should be unique in the protocol.
  void addConnectedDevice(DeviceDescriptor device) =>
      connectedDevices.add(device);

  /// Add the [trigger] to this protocol.
  void addTrigger(Trigger trigger) => triggers.add(trigger);

  /// Add a [task] to be sent to a [targetDevice] once a [trigger] within this
  /// protocol is initiated.
  /// In case the [trigger] or [task] is not yet included in this study protocol,
  /// it will be added.
  /// The [targetDevice] needs to be added prior to this call since it needs to
  /// be set up as either a master device or connected device.
  void addTriggeredTask(
    Trigger trigger,
    TaskDescriptor task,
    DeviceDescriptor targetDevice,
  ) {
    // Add trigger and task to ensure they are included in the protocol.
    if (!triggers.contains(trigger)) addTrigger(trigger);
    addTask(task);

    // Add triggered task to both the list and the map
    if (_triggeredTasksMap[trigger] == null) _triggeredTasksMap[trigger] = {};
    TriggeredTask triggeredTask =
        TriggeredTask(task: task, targetDevice: targetDevice);
    _triggeredTasksMap[trigger].add(triggeredTask);
    triggeredTasks.add(triggeredTask);
  }

  /// Gets all the tasks (and the devices they are triggered to) for the
  /// specified [trigger].
  Set<TriggeredTask> getTriggeredTasks(Trigger trigger) {
    assert(triggers.contains(trigger),
        'The passed trigger is not part of this study protocol.');
    return _triggeredTasksMap[trigger];
  }

  /// Gets all the tasks triggered for the specified [device].
  Set<TaskDescriptor> getTasksForDevice(DeviceDescriptor device) {
    assert(connectedDevices.contains(device),
        'The passed device is not part of this study protocol.');

    final Set<TaskDescriptor> deviceTasks = {};
    _triggeredTasksMap.values.forEach((tasks) {
      tasks.forEach((triggered) {
        if (triggered.targetDevice == device) deviceTasks.add(triggered.task);
      });
    });

    return deviceTasks;
  }

  /// Add the [task] to this protocol.
  void addTask(TaskDescriptor task) => tasks.add(task);

  /// Remove the [task] currently present in this configuration
  /// including removing it from any [Trigger]'s which initiate it.
  void removeTask(TaskDescriptor task) {
    // Remove task from triggered tasks
    _triggeredTasksMap.values.forEach((tasks) {
      tasks.forEach((triggeredTask) {
        if (triggeredTask.task == task) {
          tasks.remove(task);
          triggeredTasks.remove(triggeredTask);
        }
      });
    });

    // Remove task itself.
    tasks.remove(task);
  }

  Function get fromJsonFunction => _$StudyProtocolFromJson;
  factory StudyProtocol.fromJson(Map<String, dynamic> json) => FromJsonFactory()
      .fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$StudyProtocolToJson(this);
  String get jsonType => 'dk.cachet.carp.protocols.domain.StudyProtocol';

  String toString() => '$runtimeType - $name';
}
