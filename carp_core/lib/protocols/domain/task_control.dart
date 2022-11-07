/*
 * Copyright 2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of carp_core_protocols;

/// Specifies that once a condition of the trigger with [triggerId] applies,
/// the task with [taskName] on [destinationDeviceRoleName] should be started or stopped.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class TaskControl {
  /// The id of the [TriggerConfiguration] which describes the condition which when met
  /// sends the task with [taskName] to the device with [destinationDeviceRoleName].
  int triggerId;

  /// The name of the task to send to [destinationDeviceRoleName] when the
  /// trigger condition is met.
  late String taskName;

  /// The role name of the device to which to send the task with [taskName]
  /// when the trigger condition is met.
  String? destinationDeviceRoleName;

  /// What to do with a task once the condition of a trigger is met.
  Control control;

  /// The time the task have been scheduled until.
  /// Mainly used when scheduling a series of tasks for this trigger.
  DateTime? hasBeenScheduledUntil;

  @JsonKey(ignore: true)
  TaskConfiguration? task;

  @JsonKey(ignore: true)
  DeviceConfiguration? targetDevice;

  /// Create a [TaskControl].
  TaskControl(
    this.triggerId, [
    this.control = Control.Start,
    this.task,
    this.targetDevice,
  ]) : super() {
    if (task != null) taskName = task!.name;
    if (targetDevice != null) {
      destinationDeviceRoleName = targetDevice!.roleName;
    }
  }

  factory TaskControl.fromJson(Map<String, dynamic> json) =>
      _$TaskControlFromJson(json);
  Map<String, dynamic> toJson() => _$TaskControlToJson(this);

  @override
  String toString() =>
      '$runtimeType - triggerId: $triggerId, task: $taskName, targetDeviceRoleName: $destinationDeviceRoleName';
}

/// Determines what to do with a task once the condition of a trigger is met.
enum Control { Start, Stop }
