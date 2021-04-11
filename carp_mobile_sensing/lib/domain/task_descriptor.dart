/*
 * Copyright 2020 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of domain;

/// A [TaskDescriptor] that automatically collects data from the specified measures.
/// Runs without any interaction with the user or UI of the app.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class AutomaticTask extends TaskDescriptor {
  AutomaticTask({String name}) : super(name: name);

  Function get fromJsonFunction => _$AutomaticTaskFromJson;
  factory AutomaticTask.fromJson(Map<String, dynamic> json) => FromJsonFactory()
      .fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$AutomaticTaskToJson(this);
}

// /// A [TaskDescriptor] holds information about each task to be triggered by a [CAMSTrigger] as part of a [StudyProtocol].
// /// Each [TaskDescriptor] holds a list of [Measure]s to be done as part of this task.
// /// A [TaskDescriptor] is hence merely an aggregation of [Measure]s.
// ///
// /// The [TaskDescriptor] class is abstract. Use either [AutomaticTaskDescriptor] or [AppTask] for specific tasks.
// @JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
// class TaskDescriptor extends carp_core_domain.Serializable
//     with carp_core_domain.TaskDescriptor {
//   static int _counter = 0;

//   /// The name of this task. Unique for this [StudyProtocol].
//   String name;

//   /// A list of [Measure]s to be done as part of this task.
//   List<Measure> measures = [];

//   TaskDescriptor({this.name}) : super() {
//     name ??= 'Task #${_counter++}';
//   }

//   Function get fromJsonFunction => _$TaskDescriptorFromJson;
//   factory TaskDescriptor.fromJson(Map<String, dynamic> json) =>
//       FromJsonFactory()
//           .fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
//   Map<String, dynamic> toJson() => _$TaskDescriptorToJson(this);

//   /// Add a [Measure] to this task.
//   void addMeasure(Measure measure) {
//     measures.add(measure);
//   }

//   /// Add a list of [Measure]s to this task.
//   void addMeasures(Iterable<Measure> list) {
//     measures.addAll(list);
//   }

//   /// Remove a [Measure] from this task.
//   void removeMeasure(Measure measure) {
//     measures.remove(measure);
//   }

//   String toString() => '$runtimeType: name: $name';
// }

// /// A [TaskDescriptor] that automatically collects data from the specified measures.
// /// Runs without any interaction with the user or UI of the app.
// @JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
// class AutomaticTaskDescriptor extends TaskDescriptor {
//   AutomaticTaskDescriptor({String name}) : super(name: name);

//   Function get fromJsonFunction => _$AutomaticTaskDescriptorFromJson;
//   factory AutomaticTaskDescriptor.fromJson(Map<String, dynamic> json) =>
//       FromJsonFactory()
//           .fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
//   Map<String, dynamic> toJson() => _$AutomaticTaskDescriptorToJson(this);
// }

// /// Specifies a task which at some point during a [StudyProtocol] gets sent
// /// to a specific device.
// @JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
// class TriggeredTask extends Serializable {
//   TaskDescriptor task;
//   DeviceDescriptor targetDevice;

//   TriggeredTask(this.task, this.targetDevice) : super();

//   Function get fromJsonFunction => _$TriggeredTaskFromJson;
//   factory TriggeredTask.fromJson(Map<String, dynamic> json) => FromJsonFactory()
//       .fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
//   Map<String, dynamic> toJson() => _$TriggeredTaskToJson(this);
// }
