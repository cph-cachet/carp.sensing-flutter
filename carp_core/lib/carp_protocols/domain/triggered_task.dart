/*
 * Copyright 2020 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_core_protocols;

/// Specifies a task which at some point during a [StudyProtocol] gets sent
/// to a specific device.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class TriggeredTask {
  static int _counter = 0;

  /// The id of the [Trigger] which describes the condition which when met
  /// sends the task with [taskName] to the device with [destinationDeviceRoleName].
  int? triggerId;

  /// The name of the task to send to [destinationDeviceRoleName] when the
  /// trigger condition is met.
  String? taskName;

  /// The role name of the device to which to send the task with [taskName]
  /// when the [trigger] condition is met.
  String? targetDeviceRoleName;

  @JsonKey(ignore: true)
  TaskDescriptor? task;

  @JsonKey(ignore: true)
  DeviceDescriptor? targetDevice;

  TriggeredTask({this.triggerId, this.task, this.targetDevice}) : super() {
    triggerId ??= _counter++;
    taskName = task?.name;
    targetDeviceRoleName = targetDevice?.roleName;
  }

  factory TriggeredTask.fromJson(Map<String, dynamic> json) =>
      _$TriggeredTaskFromJson(json);
  Map<String, dynamic> toJson() => _$TriggeredTaskToJson(this);

  String toString() =>
      '$runtimeType - triggerId: $triggerId, task: $taskName, targetDeviceRoleName: $targetDeviceRoleName';
}
